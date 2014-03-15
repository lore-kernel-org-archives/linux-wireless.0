Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56221 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaCOEjc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Mar 2014 00:39:32 -0400
Received: by mail-pb0-f46.google.com with SMTP id rq2so3439992pbb.19
        for <linux-wireless@vger.kernel.org>; Fri, 14 Mar 2014 21:39:31 -0700 (PDT)
From: "Zhao\, Gang" <gamerh2o@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wlan-ng: fixup staging driver for removal of ieee80211_dsss_chan_to_freq
References: <1394730975-20389-1-git-send-email-linville@tuxdriver.com>
Date: Sat, 15 Mar 2014 12:39:14 +0800
In-Reply-To: <1394730975-20389-1-git-send-email-linville@tuxdriver.com> (John
	W. Linville's message of "Thu, 13 Mar 2014 13:16:15 -0400")
Message-ID: <87wqfw6pot.fsf@will.lan> (sfid-20140315_053935_642446_D507480C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-03-14 at 01:16:15 +0800, John W. Linville wrote:
> Commit 3ebe8e257307a87c33460aa7d2b75dadd374ed9c ("ieee80211: remove
> function ieee80211_{dsss_chan_to_freq, freq_to_dsss_chan}") removed
> ieee80211_dsss_chan_to_freq, but it neglected to account for this
> staging driver...

Hi, John.

I have submited a similar patch to staging/staging-next tree, and it was
applied in that tree on Feb 18, the commit is 4e5e9d7c66f04 on that
tree. But my patch add a variable to deal with 80 characters
problem. I'm not sure if your patch is applied to wireless-next, then
there could be a conflict in future time.

I separated the wireless tree patches and staging tree patch to
different maintainers when doing that change. If I knew the staging driver
change can happen on wireless tree, I should have combined them in one place.

>
> Cc: Zhao, Gang <gamerh2o@gmail.com>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  drivers/staging/wlan-ng/cfg80211.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/wlan-ng/cfg80211.c b/drivers/staging/wlan-ng/cfg80211.c
> index a7d24c95191d..7dd2b95416e8 100644
> --- a/drivers/staging/wlan-ng/cfg80211.c
> +++ b/drivers/staging/wlan-ng/cfg80211.c
> @@ -416,7 +416,7 @@ static int prism2_scan(struct wiphy *wiphy,
>  		memcpy(&ie_buf[2], &(msg2.ssid.data.data), msg2.ssid.data.len);
>  		bss = cfg80211_inform_bss(wiphy,
>  			ieee80211_get_channel(wiphy,
> -			      ieee80211_dsss_chan_to_freq(msg2.dschannel.data)),
> +			      ieee80211_channel_to_frequency(msg2.dschannel.data, IEEE80211_BAND_2GHZ)),
>  			(const u8 *) &(msg2.bssid.data.data),
>  			msg2.timestamp.data, msg2.capinfo.data,
>  			msg2.beaconperiod.data,
