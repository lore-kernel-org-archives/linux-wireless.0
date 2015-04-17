Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:17029 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbbDQHGi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Apr 2015 03:06:38 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: implement more versatile set_bitrate_mask
References: <1428672772-9275-1-git-send-email-michal.kazior@tieto.com>
Date: Fri, 17 Apr 2015 10:06:28 +0300
In-Reply-To: <1428672772-9275-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 10 Apr 2015 13:32:52 +0000")
Message-ID: <87618v44jv.fsf@kamboji.qca.qualcomm.com> (sfid-20150417_090655_837889_0A5F34FA)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Until now only a single fixed tx rate or nss was
> allowed to be set.
>
> The patch attempts to improve this by allowing
> most bitrate masks. The limitation is VHT MCS
> rates cannot be expressed separately using
> existing firmware interfaces and only the
> following VHT MCS ranges are supported: none, 0-7,
> 0-8, and 0-9.
>
> This keeps the old behaviour when requesting
> single tx rate or single nss. The new bitrate mask
> logic is only applied to other cases that would
> return -EINVAL until now.
>
> Depending on firmware revisions some combinations
> may crash firmware so use with care, please.
>
> This depends on "ath10k: don't use reassoc flag".
> Without it key cache would effectively be
> invalidated upon bitrate change leading to
> communication being no longer possible.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

To reduce support questions from the users it would be nice to give few
good examples how to use this with iw. And also it makes it easier to
test the patch. If you could send something I can add it to the commit
log.

> +static u16
> +ath10k_peer_assoc_h_vht_limit(u16 tx_mcs_set,
> +			      const u16 vht_mcs_limit[NL80211_VHT_NSS_MAX])
> +{
> +	int idx_limit;
> +	int nss;
> +	u16 mcs_map;
> +	u16 mcs;
> +
> +	for (nss = 0; nss < NL80211_VHT_NSS_MAX; nss++) {
> +		mcs_map = ath10k_mac_get_max_vht_mcs_map(tx_mcs_set, nss) &
> +			  vht_mcs_limit[nss];
> +
> +		if (mcs_map)
> +			idx_limit = fls(mcs_map) - 1;
> +		else
> +			idx_limit = -1;
> +
> +		switch (idx_limit) {
> +		case 0: /* fall through */
> +		case 1: /* fall through */
> +		case 2: /* fall through */
> +		case 3: /* fall through */
> +		case 4: /* fall through */
> +		case 5: /* fall through */
> +		case 6: /* fall through */
> +		default:
> +			/* see ath10k_mac_can_set_bitrate_mask() */
> +			WARN_ON(1);
> +			/* fall through */
> +		case -1:
> +			mcs = IEEE80211_VHT_MCS_NOT_SUPPORTED; break;
> +		case 7:
> +			mcs = IEEE80211_VHT_MCS_SUPPORT_0_7; break;
> +		case 8:
> +			mcs = IEEE80211_VHT_MCS_SUPPORT_0_8; break;
> +		case 9:
> +			mcs = IEEE80211_VHT_MCS_SUPPORT_0_9; break;
> +		}

I moved the breaks into their own lines, I think that just easier to
read. This is the diff:

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index ace273f7ec73..069f399e4c25 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2277,13 +2277,17 @@ ath10k_peer_assoc_h_vht_limit(u16 tx_mcs_set,
                        WARN_ON(1);
                        /* fall through */
                case -1:
-                       mcs = IEEE80211_VHT_MCS_NOT_SUPPORTED; break;
+                       mcs = IEEE80211_VHT_MCS_NOT_SUPPORTED;
+                       break;
                case 7:
-                       mcs = IEEE80211_VHT_MCS_SUPPORT_0_7; break;
+                       mcs = IEEE80211_VHT_MCS_SUPPORT_0_7;
+                       break;
                case 8:
-                       mcs = IEEE80211_VHT_MCS_SUPPORT_0_8; break;
+                       mcs = IEEE80211_VHT_MCS_SUPPORT_0_8;
+                       break;
                case 9:
-                       mcs = IEEE80211_VHT_MCS_SUPPORT_0_9; break;
+                       mcs = IEEE80211_VHT_MCS_SUPPORT_0_9;
+                       break;
                }
 
                tx_mcs_set &= ~(0x3 << (nss * 2));

-- 
Kalle Valo
