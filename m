Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47309 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385AbbBZI4S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Feb 2015 03:56:18 -0500
Date: Thu, 26 Feb 2015 11:56:05 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: wey-yi.w.guy@intel.com
Cc: linux-wireless@vger.kernel.org
Subject: re: iwlwifi: split the drivers for agn and legacy devices 3945/4965
Message-ID: <20150226085605.GA5923@mwanda> (sfid-20150226_095624_340438_BA069864)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Wey-Yi Guy,

The patch be663ab67077: "iwlwifi: split the drivers for agn and
legacy devices 3945/4965" from Feb 21, 2011, leads to the following
static checker warning:

	drivers/net/wireless/iwlegacy/4965-mac.c:6390 il4965_init_drv()
	error: potential NULL dereference 'il->ieee_rates'.

Also:

	drivers/net/wireless/iwlegacy/3945-mac.c:3541 il3945_init_drv()
	error: potential NULL dereference 'il->ieee_rates'.

The il_init_geos() function is the only place where we set
"->ieee_rates" to non-NULL.  There are two callers and they both rely
on il_init_geos() to set it to non-NULL otherwise they crash.  However,
there is a return in il_init_geos() which does not set ->ieee_rates so
if we ever hit that path then the kernel will Oops.  This makes the
static checkers complain.

drivers/net/wireless/iwlegacy/common.c
  3431  int
  3432  il_init_geos(struct il_priv *il)
  3433  {
  3434          struct il_channel_info *ch;
  3435          struct ieee80211_supported_band *sband;
  3436          struct ieee80211_channel *channels;
  3437          struct ieee80211_channel *geo_ch;
  3438          struct ieee80211_rate *rates;
  3439          int i = 0;
  3440          s8 max_tx_power = 0;
  3441  
  3442          if (il->bands[IEEE80211_BAND_2GHZ].n_bitrates ||
  3443              il->bands[IEEE80211_BAND_5GHZ].n_bitrates) {
  3444                  D_INFO("Geography modes already initialized.\n");
  3445                  set_bit(S_GEO_CONFIGURED, &il->status);
  3446                  return 0;
                        ^^^^^^^^
We have not set ->ieee_rates here.  If we ever hit this return then the
kernel will Oops.

  3447          }
  3448  

Here is one caller, the other is the same.

drivers/net/wireless/iwlegacy/4965-mac.c
  6362          il->ieee_channels = NULL;
  6363          il->ieee_rates = NULL;
                ^^^^^^^^^^^^^^^^^^^^^
We set il->ieee_rates to NULL.

  6364          il->band = IEEE80211_BAND_2GHZ;
  6365  
  6366          il->iw_mode = NL80211_IFTYPE_STATION;
  6367          il->current_ht_config.smps = IEEE80211_SMPS_STATIC;
  6368          il->missed_beacon_threshold = IL_MISSED_BEACON_THRESHOLD_DEF;
  6369  
  6370          /* initialize force reset */
  6371          il->force_reset.reset_duration = IL_DELAY_NEXT_FORCE_FW_RELOAD;
  6372  
  6373          /* Choose which receivers/antennas to use */
  6374          if (il->ops->set_rxon_chain)
  6375                  il->ops->set_rxon_chain(il);
  6376  
  6377          il_init_scan_params(il);
  6378  
  6379          ret = il_init_channel_map(il);
  6380          if (ret) {
  6381                  IL_ERR("initializing regulatory failed: %d\n", ret);
  6382                  goto err;
  6383          }
  6384  
  6385          ret = il_init_geos(il);
                      ^^^^^^^^^^^^^^^^
Assume we hit the problematic return.

  6386          if (ret) {
  6387                  IL_ERR("initializing geos failed: %d\n", ret);
  6388                  goto err_free_channel_map;
  6389          }
  6390          il4965_init_hw_rates(il, il->ieee_rates);
                                         ^^^^^^^^^^^^^^
This will lead to a NULL dereference inside the il4965_init_hw_rates()
function.

  6391  
  6392          return 0;

regards,
dan carpenter
