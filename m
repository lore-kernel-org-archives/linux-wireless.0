Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:58254 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754464Ab1LVAQG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 19:16:06 -0500
Received: by obcwo16 with SMTP id wo16so3635865obc.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Dec 2011 16:16:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <477F20668A386D41ADCC57781B1F704308185E3EED@SC-VEXCH1.marvell.com>
References: <1324453642-1920-1-git-send-email-bzhao@marvell.com>
 <1324453642-1920-2-git-send-email-bzhao@marvell.com> <CAGRGNgVEnn23UbnEUFXiKhu=6j4VJi560Y6AkyRP978gTtzGnA@mail.gmail.com>
 <477F20668A386D41ADCC57781B1F704308185E3EED@SC-VEXCH1.marvell.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 22 Dec 2011 11:15:45 +1100
Message-ID: <CAGRGNgXRSeaxeUKGdrJc_UoySkyEJqTP+NoKo+j52afv0BC4yw@mail.gmail.com> (sfid-20111222_011620_104350_3C74DC42)
Subject: Re: [PATCH 2/3] mwifiex: use IEEE80211_HT_PARAM_CHA_SEC_* macros
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bing,

On Thu, Dec 22, 2011 at 11:06, Bing Zhao <bzhao@marvell.com> wrote:
> Hi Julian,
>
> Thanks for your comment.
>
>> Subject: Re: [PATCH 2/3] mwifiex: use IEEE80211_HT_PARAM_CHA_SEC_* macros
>>
>> Hi Bing and Amitkumar,
>>
>> Quick question:
>>
>> On Wed, Dec 21, 2011 at 18:47, Bing Zhao <bzhao@marvell.com> wrote:
>> > From: Amitkumar Karwar <akarwar@marvell.com>
>> >
>> > Replace driver specific macros with the corresponding
>> > IEEE80211_HT_PARAM_CHA_SEC_* macros defined in ieee80211.h.
>> > Also, rename 'adapter->chan_offset' to 'adapter->sec_chan_offset'
>> > for consistency.
>> >
>> > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
>> > Signed-off-by: Bing Zhao <bzhao@marvell.com>
>> > ---
>> > diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
>> > index 64bf640..0723f61 100644
>> > --- a/drivers/net/wireless/mwifiex/cfg80211.c
>> > +++ b/drivers/net/wireless/mwifiex/cfg80211.c
>> > +static u8
>> > +mwifiex_cfg80211_channel_type_to_sec_chan_offset(enum nl80211_channel_type
>> > +                                                channel_type)
>> >  {
>> >        switch (channel_type) {
>> >        case NL80211_CHAN_NO_HT:
>> >        case NL80211_CHAN_HT20:
>> > -               return NO_SEC_CHANNEL;
>> > +               return IEEE80211_HT_PARAM_CHA_SEC_NONE;
>> >        case NL80211_CHAN_HT40PLUS:
>> > -               return SEC_CHANNEL_ABOVE;
>> > +               return IEEE80211_HT_PARAM_CHA_SEC_ABOVE;
>> >        case NL80211_CHAN_HT40MINUS:
>> > -               return SEC_CHANNEL_BELOW;
>> > +               return IEEE80211_HT_PARAM_CHA_SEC_BELOW;
>> >        default:
>> > -               return NO_SEC_CHANNEL;
>> > +               return IEEE80211_HT_PARAM_CHA_SEC_NONE;
>> >        }
>> >  }
>>
>> Is there a function in mac80211 to do this for you?
>
> The mac80211.h does define inline functions like this:
>
> static inline bool
> conf_is_ht40_minus(struct ieee80211_conf *conf)
> {
>        return conf->channel_type == NL80211_CHAN_HT40MINUS;
> }

Ah, that makes things a little more tricky =)

> But they take 'struct ieee80211_conf *conf', instead of 'enum nl80211_channel_type', as the parameters. If I make use of them I will have to construct a redundant 'struct ieee80211_conf' variable in mwifiex driver and add "if (ht40_minus), else if (ht40_plus), else()" logic to get the return values of IEEE80211_HT_PARAM_CHA_SEC_ type.

That would not be a good solution.

My point about this was that there may be other drivers who would want
to use the IEEE80211_HT_PARAM_CHA_SEC_ values so maybe someone (not
necessarily you) should create a common function in mac80211 to switch
between these values, rather than having a function in mwiflex to do
something that isn't driver specific.

>> > @@ -51,20 +51,20 @@ mwifiex_cfg80211_channel_type_to_mwifiex_channels(enum nl80211_channel_type
>> >  static enum nl80211_channel_type
>> >  mwifiex_channels_to_cfg80211_channel_type(int channel_type)
>> >  {
>> >        switch (channel_type) {
>> > -       case NO_SEC_CHANNEL:
>> > +       case IEEE80211_HT_PARAM_CHA_SEC_NONE:
>> >                return NL80211_CHAN_HT20;
>> > -       case SEC_CHANNEL_ABOVE:
>> > +       case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
>> >                return NL80211_CHAN_HT40PLUS;
>> > -       case SEC_CHANNEL_BELOW:
>> > +       case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
>> >                return NL80211_CHAN_HT40MINUS;
>> >        default:
>> >                return NL80211_CHAN_HT20;
>>
>> Same again.
>
> The macro replacement in this function is temporary. This entire function has been removed in 3/3 in the same patch series.

I didn't read patch 3 that closely so I must have missed that change.
I asked about this for the same reason as above.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
