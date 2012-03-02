Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33846 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757385Ab2CBSQZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2012 13:16:25 -0500
Received: by iagz16 with SMTP id z16so2602210iag.19
        for <linux-wireless@vger.kernel.org>; Fri, 02 Mar 2012 10:16:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1330711566.8542.23.camel@jlt3.sipsolutions.net>
References: <1330645207-13964-1-git-send-email-javier@cozybit.com>
 <1330645207-13964-3-git-send-email-javier@cozybit.com> <1330674633.3367.3.camel@jlt3.sipsolutions.net>
 <CAPjQAd9CfNiLjqQh_ONaF89o7qQpuZrhRnysNP_wDXrAe+tYgA@mail.gmail.com> <1330711566.8542.23.camel@jlt3.sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Fri, 2 Mar 2012 10:16:04 -0800
Message-ID: <CAPjQAd8x8iq2uSOF5FGLH0HvogUVwNvyiemf2LTrPjrGv8eb-Q@mail.gmail.com> (sfid-20120302_191629_000739_BF6377E1)
Subject: Re: [PATCHv2 3/3] mac80211_hwsim: Implement ieee80211_ops:tx_last_beacon
To: Johannes Berg <johannes@sipsolutions.net>
Cc: devel@lists.open80211s.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 2, 2012 at 10:06 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2012-03-02 at 09:51 -0800, Javier Cardona wrote:
>> On Thu, Mar 1, 2012 at 11:50 PM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > On Thu, 2012-03-01 at 15:40 -0800, Javier Cardona wrote:
>> >> Without this you won't see probe responses in an IBSS/hwsim network,
>> >> which is convenient for testing.
>> >>
>> >> Signed-off-by: Javier Cardona <javier@cozybit.com>
>> >> ---
>> >>  drivers/net/wireless/mac80211_hwsim.c |    9 +++++++++
>> >>  1 files changed, 9 insertions(+), 0 deletions(-)
>> >>
>> >> diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
>> >> index deed95f..e4b6ca6 100644
>> >> --- a/drivers/net/wireless/mac80211_hwsim.c
>> >> +++ b/drivers/net/wireless/mac80211_hwsim.c
>> >> @@ -47,6 +47,8 @@ static bool fake_hw_scan;
>> >>  module_param(fake_hw_scan, bool, 0444);
>> >>  MODULE_PARM_DESC(fake_hw_scan, "Install fake (no-op) hw-scan handler");
>> >>
>> >> +static struct ieee80211_hw *txed_last_beacon;
>> >
>> > That's definitely not right.
>>
>> I am using that module global to save the last hw that transmitted a
>> beacon.  The pointer is only tested for equality, never dereferenced.
>> And even if a read access happens during a non-atomic write, there are
>> no adverse consquences other than mac80211_hwsim_tx_last_beacon()
>> returning the wrong value.  Would you rather see it protected with a
>> mutex?
>
> No, no, it's just the logic.
>
>> >> +static int mac80211_hwsim_tx_last_beacon(struct ieee80211_hw *hw)
>> >> +{
>> >> +     return (hw == txed_last_beacon);
>> >> +}
>> >
>> > And this is mostly a fancy way of saying "return 1" -- there's no beacon
>> > backoff protocol in here, so why not just hardcode "return 1"?
>>
>> This only returns true if 'hw' is the last hw that transmitted a
>> beacon.  Worked for me, as I was seeing 0's and 1's.
>
> Yeah, but it's nowhere near how IBSS works. You're doing this across
> different channels, no matter whether it's even in IBSS mode, and
> there's no backoff (all of them will TX anyway)

I thought that function was called only in IBSS mode, but still, you
are right.  There are many things i did not consider.

>> My (maybe flawed) thinking was: I need this function to return true to
>> test my previous patch.  Hardcoding a 1 would do it me, but someone
>> might complain that makes no sense.  So I tried to simulate a behavior
>> that's closer to reality.  In my IBSS/hwsim network I now see one
>> probe response at a time even though there are multiple phy's.
>
> It's so far from reality that I don't think we should do it :-)
>
>> What would you want me to do with this patch?  I'm not particulary
>> attached to it...
>
> I don't really care -- do you want to return 1 or just leave this patch
> out?

Hmmm, I think I'll leave it out.  If anyone is using hwsim to test
IBSS they'll probably know how to code this better.

Thanks for your help!

Javier
