Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:38726 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbbFBTKw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2015 15:10:52 -0400
Received: by igblz2 with SMTP id lz2so18900771igb.1
        for <linux-wireless@vger.kernel.org>; Tue, 02 Jun 2015 12:10:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1433270224-10013-1-git-send-email-chaitanya.mgit@gmail.com>
References: <1433270224-10013-1-git-send-email-chaitanya.mgit@gmail.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Wed, 3 Jun 2015 00:40:31 +0530
Message-ID: <CABPxzYKpD12OTgU_57eO6Xui5NhMV-BE37jHmYtkkWGQ2dAzfA@mail.gmail.com> (sfid-20150602_211055_093076_FE4BE8A1)
Subject: Re: [PATCH V2] mac80211: Minstrel HT: Handle all SMPS states of the
 peer STA.
To: Felix Fietkau <nbd@openwrt.org>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Chaitanya Tata <chaitanya.mgit@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 3, 2015 at 12:07 AM, Chaitanya T K <chaitanya.mgit@gmail.com> wrote:
> From: Chaitanya Tata <chaitanya.mgit@gmail.com>
>
> In case of Dynamic SMPS enable RTS/CTS for all rates.
> In case of Static SMPS mark the Nss > 1 rates as not supported.
>
> Signed-off-by: Chaitanya T K <chaitanya.mgit@gmail.com>
> ---
> V2: Fix the Indent and Sign off missing.
> ---
>  net/mac80211/rc80211_minstrel_ht.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
>
> diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
> index 7430a1d..0889c22 100644
> --- a/net/mac80211/rc80211_minstrel_ht.c
> +++ b/net/mac80211/rc80211_minstrel_ht.c
> @@ -1176,9 +1176,16 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
>
>                 nss = minstrel_mcs_groups[i].streams;
>
> -               /* Mark MCS > 7 as unsupported if STA is in static SMPS mode */
> -               if (sta->smps_mode == IEEE80211_SMPS_STATIC && nss > 1)
> -                       continue;
> +               /* Handle STA's SMPS State, if Nss > 1.
> +               * a. Use RTS_CTS, if STA is in Dynamic SMPS Mode
> +               * b. Mark Nss > 1 as unsupported, if STA is in static SMPS mode
> +               */
> +               if (nss > 1) {
> +                       if (sta->smps_mode == IEEE80211_SMPS_DYNAMIC)
> +                               gflags |= IEEE80211_TX_RC_USE_RTS_CTS;

Just noticed that the minstrel_mcs_groups is a const struct, so this wont work.

So may be we can move this check to set_rate we can populate rate_table
and also have access to "sta" info?

> +                       else if (sta->smps_mode == IEEE80211_SMPS_STATIC)
> +                               continue;
> +               }
>
>                 /* HT rate */
>                 if (gflags & IEEE80211_TX_RC_MCS) {
> --
> 1.9.1
>



-- 
Thanks,
Regards,
Chaitanya T K.
