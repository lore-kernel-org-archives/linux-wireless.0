Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-3.exch022.serverdata.net ([206.225.164.186]:45530
	"EHLO HUB022-nj-3.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751724Ab2INISd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2012 04:18:33 -0400
Message-ID: <5052E852.8030804@posedge.com> (sfid-20120914_101843_565218_E87F70A9)
Date: Fri, 14 Sep 2012 13:48:26 +0530
From: Mahesh Palivela <maheshp@posedge.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [RFC v3] cfg80211: VHT regulatory
References: <504DBBAC.7040300@posedge.com> <CAB=NE6UfQdM6HrVGw3Dn-NBxQupwA3kJD27kv3c9DjLY8DVm1Q@mail.gmail.com>
In-Reply-To: <CAB=NE6UfQdM6HrVGw3Dn-NBxQupwA3kJD27kv3c9DjLY8DVm1Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/14/2012 02:11 AM, Luis R. Rodriguez wrote:
> On Mon, Sep 10, 2012 at 3:06 AM, Mahesh Palivela <maheshp@posedge.com> wrote:
>> VHT (11ac) regulatory new design. VHT channel center freq, bandwidth and
>> primary channel are used to decide if that channel config is permitted in
>> current regulatory domain.
>
> Please include me on cfg80211 regulatory changes in the future. My
> review below. But in short I am not in agreement with this approach
> for a few reasons explained below. I removed all hunks from my reply
> for which I had no comments for.
>

Stanislaw felt flags based approach is not scalable, so is this new 
approach.

>> + *
>> + * @chan_width1: channel bandwidth
>
> Comment here is chan_width1 but you have only chan_width
>

Removed 1.

>> +       freq_range = &reg_rule->freq_range;
>> +
>> +       if (freq_range->max_bandwidth_khz < bw_khz)
>> +               return false;
>
> Do you really need the above two lines ? The reg_does_bw_fit() should
> have figured this out no?
>

This is still required. what if the rule says max allowed BW is 40 MHz 
and our desired is 80 MHz.

>> +
>> +       /* find left and right arms of center freq */
>> +       left_end_freq = center_freq - (bw_khz/2);
>> +       right_end_freq = center_freq + (bw_khz/2);
>> +
>> +       /* left_end_freq and right_end_freq are edge of left and right
>> +        * channels. Get center freq of left and right channels
>> +        * by adding 10MHz to left_end_freq and subtracting 10 MHZ from
>> +        * right_end_freq.
>> +        */
>> +       left_end_freq += MHZ_TO_KHZ(10);
>> +       right_end_freq -= MHZ_TO_KHZ(10);
>
> Note: you are starting your left_end_freq here at the very first IEEE
> channel from the left of the regulatory rule.
>

Not really. what if centre_freq is chan 46, BW is 80 MHz then chan 38 
will be left_end. Plus 10 Mhz will give chan 40.

>> +       /* find out all possible secondary channels */
>> +       while (left_end_freq < right_end_freq) {
>
> Should this be <= ? Otherwise the last 20 MHz IEEE channel would not
> be checked, no ?
>

Agree. will change that..

>> +               chan = ieee80211_get_channel(wiphy, left_end_freq);
>> +               if (chan == NULL ||
>> +                   chan->flags & IEEE80211_CHAN_DISABLED) {
>> +                       return false;
>> +               }
>> +               left_end_freq -= MHZ_TO_KHZ(20);
>
>  From what I read here you are sweeping left to right for all 20 MHz
> channels and you are allowing for the VHT channel of bw_khz bandwidth
> only if all 20 MHz IEEE channels in between are allowed. Is that
> correct?
>

Yes Luis.

>> +       }
>> +
>> +       return true;
>> +}
>> +
>> +bool reg_chan_use_permitted(struct wiphy *wiphy,
>> +                           struct ieee80211_channel_config *chan_config,
>> +                           const struct ieee80211_regdomain *regd)
>> +{
>> +       u32 desired_bw_khz = MHZ_TO_KHZ(20);
>> +       bool ret;
>> +
>> +       /* get chan BW from config */
>>
>> +       switch (chan_config->chan_width) {
>> +       case IEEE80211_CHAN_WIDTH_20MHZ_NOHT:
>> +       case IEEE80211_CHAN_WIDTH_20MHZ:
>> +               desired_bw_khz = MHZ_TO_KHZ(20);
>> +               break;
>> +
>> +       case IEEE80211_CHAN_WIDTH_40MHZ:
>> +               desired_bw_khz = MHZ_TO_KHZ(40);
>> +               break;
>> +
>> +       case IEEE80211_CHAN_WIDTH_80MHZ:
>> +       case IEEE80211_CHAN_WIDTH_80P80MHZ:
>> +               desired_bw_khz = MHZ_TO_KHZ(80);
>> +               break;
>> +
>> +       case IEEE80211_CHAN_WIDTH_160MHZ:
>> +               desired_bw_khz = MHZ_TO_KHZ(160);
>> +               break;
>> +       default:
>> +               REG_DBG_PRINT("Invalid channel width %d\n",
>> +                             chan_config->chan_width);
>> +               return false;
>> +       }
>> +
>> +       ret = reg_fits_reg_rule_sec_chans(wiphy,
>> +                                         chan_config->center_freq1,
>> +                                         desired_bw_khz,
>> +                                         regd);
>> +
>>
>> +       if (ret == false)
>> +               return ret;
>> +
>> +       if (chan_config->chan_width == IEEE80211_CHAN_WIDTH_80P80MHZ) {
>> +               ret = reg_fits_reg_rule_sec_chans(wiphy,
>> +                                                 chan_config->center_freq2,
>> +                                                 desired_bw_khz,
>> +                                                 regd);
>>
>> +       }
>
> And for the special case of 80 MHz + 80 MHz split channels (ie, not
> contiguous) you then spin off the check for each segment of 80 MHz
> channels.
>
> But no code here uses it. Based on the previous threads on this VHT
> regulatory topic I get the impression your goal is to end up using
> this code to determine whether or not a non-HT, HT or VHT channel is
> allowed for and based on feedback it seems that the objective is to
> use this code eventually to do dynamic run time checks of whether or
> not we're allowed to use this channel configuration setup. If so then
> I have a few comments for that.

Yes. That's the objective. we are not calling these functions anywhere 
yet. Once this proposal is accepted then I want to spread further. But I 
am confused now....

>
> Although VHT complicates the regulatory checks, to the extent you
> check for valid 20 MHz IEEE channels in between a VHT wide channel,
> the IEEE spec actually only allows in practice certain VHT
> arrangements. I've asked for shiny diagrams that have this laid out
> clearly and simple but unfortunately we do not have one, but such
> simple static arrangements are apparently specified on the spec, its
> not clear to me where exactly though... Technically then if we wanted
> to keep a static cached early check of allowed channels maps for VHT
> we should be able to have a bitmap representation of the allowed IEEE
> VHT channel configurations and upon initialization / regulatory change
> update this bitmap to determine if we're allowed to use the new
> arrangement. The approach you use is also fine and while it does allow
> for flexibility to do add more technologies one should consider the
> penalty incurred at doing these computations at run time. The run time
> impact is no issue if its done just once but consider changing
> channels and how often we can do this. Consider a device now with one
> radio but two virtual devices and each one doing their own set of
> scans and two different types of HT / VHT configurations. This means
> the code you just wrote will become a real hot path -- used for
> anything  that has to do with any channel change. The purpose of the
> flags are to remove that run time penalty, so if we can take into
> consideration more the nature of how we VHT channels are allowed and
> how IEEE decided to simplify the arrangements for VHT then likely
> keeping flags may make sense then. That is, not all VHT arrangements
> are possible, only a subset, and it seems fairly trivial and
> reasonable to me to do this upon regulatory change only once rather
> than at every channel change.
>
> And as for the question: "What about the future? Will we see 320 MHz
> wide channels in 2020? :)"
>
> I'm told through a shiny crystal ball: let's not expect 320 MHz channels.
>
> So I'd rather keep this simple and also due to the fact that VHT
> channels are static just try to use a bitmap for them and check for it
> at regulatory change.
>

I agree Luis. Limiting the flags to a subset is fine with me. Hope no 
more disagreements.

>    Luis
>
