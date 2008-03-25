Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:29806 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757733AbYCYQmF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2008 12:42:05 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [PATCH][RESEND] wireless: convert !X & Y to !(X & Y) in iwl4965_is_fat_tx_allowed()
Date: Tue, 25 Mar 2008 09:30:58 -0700
Message-ID: <D936D925018D154694D8A362EEB08920040370C5@orsmsx416.amr.corp.intel.com> (sfid-20080325_164212_513904_EF6A5EC1)
In-Reply-To: <47E9226C.7090403@tiscali.nl>
References: <47E9226C.7090403@tiscali.nl>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Roel Kluin" <12o3l@tiscali.nl>, "Zhu, Yi" <yi.zhu@intel.com>
Cc: <linux-wireless@vger.kernel.org>,
	"lkml" <linux-kernel@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, March 25, 2008 9:04 AM, Roel Kluin  wrote:

> from include/linux/ieee80211.h:274:
> #define IEEE80211_HT_CAP_SUP_WIDTH              0x0002 ---
> ! has a higher priority than &
> 
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> ---
> diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c
> b/drivers/net/wireless/iwlwifi/iwl-4965.c
> index d727de8..6576757 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-4965.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
> @@ -4589,7 +4589,7 @@ static u8
> iwl4965_is_fat_tx_allowed(struct iwl4965_priv *priv,
> 
> 	if (sta_ht_inf) {
> 		if ((!sta_ht_inf->ht_supported) ||
> -		   (!sta_ht_inf->cap & IEEE80211_HT_CAP_SUP_WIDTH))
> +		   (!(sta_ht_inf->cap & IEEE80211_HT_CAP_SUP_WIDTH)))
return 0;
> 	}

This patch has already been acked and merged into wireless-testing, and
afaik already pushed further upstream.

Reinette
