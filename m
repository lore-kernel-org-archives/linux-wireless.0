Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61176 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655Ab1LUXHw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 18:07:52 -0500
Received: by ggdk6 with SMTP id k6so5912033ggd.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Dec 2011 15:07:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1324453642-1920-2-git-send-email-bzhao@marvell.com>
References: <1324453642-1920-1-git-send-email-bzhao@marvell.com> <1324453642-1920-2-git-send-email-bzhao@marvell.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 22 Dec 2011 10:07:30 +1100
Message-ID: <CAGRGNgVEnn23UbnEUFXiKhu=6j4VJi560Y6AkyRP978gTtzGnA@mail.gmail.com> (sfid-20111222_000755_453044_23F4F401)
Subject: Re: [PATCH 2/3] mwifiex: use IEEE80211_HT_PARAM_CHA_SEC_* macros
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Frank Huang <frankh@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bing and Amitkumar,

Quick question:

On Wed, Dec 21, 2011 at 18:47, Bing Zhao <bzhao@marvell.com> wrote:
> From: Amitkumar Karwar <akarwar@marvell.com>
>
> Replace driver specific macros with the corresponding
> IEEE80211_HT_PARAM_CHA_SEC_* macros defined in ieee80211.h.
> Also, rename 'adapter->chan_offset' to 'adapter->sec_chan_offset'
> for consistency.
>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> Signed-off-by: Bing Zhao <bzhao@marvell.com>
> ---
> diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
> index 64bf640..0723f61 100644
> --- a/drivers/net/wireless/mwifiex/cfg80211.c
> +++ b/drivers/net/wireless/mwifiex/cfg80211.c
> +static u8
> +mwifiex_cfg80211_channel_type_to_sec_chan_offset(enum nl80211_channel_type
> +                                                channel_type)
>  {
>        switch (channel_type) {
>        case NL80211_CHAN_NO_HT:
>        case NL80211_CHAN_HT20:
> -               return NO_SEC_CHANNEL;
> +               return IEEE80211_HT_PARAM_CHA_SEC_NONE;
>        case NL80211_CHAN_HT40PLUS:
> -               return SEC_CHANNEL_ABOVE;
> +               return IEEE80211_HT_PARAM_CHA_SEC_ABOVE;
>        case NL80211_CHAN_HT40MINUS:
> -               return SEC_CHANNEL_BELOW;
> +               return IEEE80211_HT_PARAM_CHA_SEC_BELOW;
>        default:
> -               return NO_SEC_CHANNEL;
> +               return IEEE80211_HT_PARAM_CHA_SEC_NONE;
>        }
>  }

Is there a function in mac80211 to do this for you?

> @@ -51,20 +51,20 @@ mwifiex_cfg80211_channel_type_to_mwifiex_channels(enum nl80211_channel_type
>  static enum nl80211_channel_type
>  mwifiex_channels_to_cfg80211_channel_type(int channel_type)
>  {
>        switch (channel_type) {
> -       case NO_SEC_CHANNEL:
> +       case IEEE80211_HT_PARAM_CHA_SEC_NONE:
>                return NL80211_CHAN_HT20;
> -       case SEC_CHANNEL_ABOVE:
> +       case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
>                return NL80211_CHAN_HT40PLUS;
> -       case SEC_CHANNEL_BELOW:
> +       case IEEE80211_HT_PARAM_CHA_SEC_BELOW:
>                return NL80211_CHAN_HT40MINUS;
>        default:
>                return NL80211_CHAN_HT20;

Same again.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
