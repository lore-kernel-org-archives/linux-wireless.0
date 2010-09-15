Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:31576 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753639Ab0IOTba (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Sep 2010 15:31:30 -0400
Subject: Re: [PATCH] iwlwifi: fix sparse warning about wrong enum for band
 parameter
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Berg, Johannes" <johannes.berg@intel.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
In-Reply-To: <1284578182-12684-1-git-send-email-linville@tuxdriver.com>
References: <1284578182-12684-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain
Date: Wed, 15 Sep 2010 12:30:42 -0700
Message-Id: <1284579042.25028.17.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

On Wed, 2010-09-15 at 12:16 -0700, John W. Linville wrote:
> drivers/net/wireless/iwlwifi/iwl-scan.c:386:27: warning: mixing different enum types
> drivers/net/wireless/iwlwifi/iwl-scan.c:386:27:     int enum nl80211_band  versus
> drivers/net/wireless/iwlwifi/iwl-scan.c:386:27:     int enum ieee80211_band
> drivers/net/wireless/iwlwifi/iwl-scan.c:435:57: warning: mixing different enum types
> drivers/net/wireless/iwlwifi/iwl-scan.c:435:57:     int enum ieee80211_band  versus
> drivers/net/wireless/iwlwifi/iwl-scan.c:435:57:     int enum nl80211_band
> drivers/net/wireless/iwlwifi/iwl-scan.c:474:53: warning: mixing different enum types
> drivers/net/wireless/iwlwifi/iwl-scan.c:474:53:     int enum ieee80211_band  versus
> drivers/net/wireless/iwlwifi/iwl-scan.c:474:53:     int enum nl80211_band
> drivers/net/wireless/iwlwifi/iwl-scan.c:588:72: warning: mixing different enum types
> drivers/net/wireless/iwlwifi/iwl-scan.c:588:72:     int enum ieee80211_band  versus
> drivers/net/wireless/iwlwifi/iwl-scan.c:588:72:     int enum nl80211_band
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-scan.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
> index 599573f..c54c200 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-scan.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
> @@ -350,7 +350,7 @@ EXPORT_SYMBOL(iwl_init_scan_params);
>  static int __must_check iwl_scan_initiate(struct iwl_priv *priv,
>  					  struct ieee80211_vif *vif,
>  					  bool internal,
> -					  enum nl80211_band band)
> +					  enum ieee80211_band band)
>  {
>  	int ret;
>  
Thank you for fixing this, I also notice this and have the same patch
internally. I will drop my since you already fix it :-)

Wey

