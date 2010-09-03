Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:24294 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753846Ab0ICOYL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Sep 2010 10:24:11 -0400
Subject: Re: [PATCH 02/13] iwlwifi: unify scan start checks
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Berg, Johannes" <johannes.berg@intel.com>
In-Reply-To: <1283515056-11523-3-git-send-email-sgruszka@redhat.com>
References: <1283515056-11523-1-git-send-email-sgruszka@redhat.com>
	 <1283515056-11523-3-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain
Date: Fri, 03 Sep 2010 07:23:33 -0700
Message-Id: <1283523813.5211.11.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Fri, 2010-09-03 at 04:57 -0700, Stanislaw Gruszka wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Rather than duplicating all the checks and even
> in case of errors accepting the scan request
> from mac80211, we can push the checks to the
> caller and in all error cases reject the scan
> request right away (rather than accepting and
> then saying it was aborted).
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-3945.h     |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |   85 ++++--------------
>  drivers/net/wireless/iwlwifi/iwl-agn.h      |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-core.h     |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-scan.c     |  127 ++++++++++++++++-----------
>  drivers/net/wireless/iwlwifi/iwl3945-base.c |   74 ++--------------
>  6 files changed, 107 insertions(+), 185 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
> index bb2aeeb..98509c5 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-3945.h
> +++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
> @@ -295,7 +295,7 @@ extern const struct iwl_channel_info *iwl3945_get_channel_info(
>  extern int iwl3945_rs_next_rate(struct iwl_priv *priv, int rate);
> 
>  /* scanning */
> -void iwl3945_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif);
> +int iwl3945_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif);
> 
>  /* Requires full declaration of iwl_priv before including */
>  #include "iwl-io.h"
> diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
> index 51a8d7e..5a2540e 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
> @@ -1154,7 +1154,7 @@ static int iwl_get_channels_for_scan(struct iwl_priv *priv,
>         return added;
>  }
> 
> -void iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
> +int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
>  {
>         struct iwl_host_cmd cmd = {
>                 .id = REPLY_SCAN_CMD,
> @@ -1174,57 +1174,20 @@ void iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
>         int  chan_mod;
>         u8 active_chains;
>         u8 scan_tx_antennas = priv->hw_params.valid_tx_ant;
> +       int ret;
> +
> +       lockdep_assert_held(&priv->mutex);
> 
>         if (vif)
>                 ctx = iwl_rxon_ctx_from_vif(vif);
> 
> -       cancel_delayed_work(&priv->scan_check);
> -
> -       if (!iwl_is_ready(priv)) {
> -               IWL_WARN(priv, "request scan called when driver not ready.\n");
> -               goto done;
> -       }
> -
> -       /* Make sure the scan wasn't canceled before this queued work
> -        * was given the chance to run... */
> -       if (!test_bit(STATUS_SCANNING, &priv->status))
> -               goto done;
> -
> -       /* This should never be called or scheduled if there is currently
> -        * a scan active in the hardware. */
> -       if (test_bit(STATUS_SCAN_HW, &priv->status)) {
> -               IWL_DEBUG_INFO(priv, "Multiple concurrent scan requests in parallel. "
> -                              "Ignoring second request.\n");
> -               goto done;
> -       }
> -
> -       if (test_bit(STATUS_EXIT_PENDING, &priv->status)) {
> -               IWL_DEBUG_SCAN(priv, "Aborting scan due to device shutdown\n");
> -               goto done;
> -       }
> -
> -       if (test_bit(STATUS_SCAN_ABORTING, &priv->status)) {
> -               IWL_DEBUG_HC(priv, "Scan request while abort pending.  Queuing.\n");
> -               goto done;
> -       }
> -
> -       if (iwl_is_rfkill(priv)) {
> -               IWL_DEBUG_HC(priv, "Aborting scan due to RF Kill activation\n");
> -               goto done;
> -       }
> -
> -       if (!test_bit(STATUS_READY, &priv->status)) {
> -               IWL_DEBUG_HC(priv, "Scan request while uninitialized.  Queuing.\n");
> -               goto done;
> -       }
> -
>         if (!priv->scan_cmd) {
>                 priv->scan_cmd = kmalloc(sizeof(struct iwl_scan_cmd) +
>                                          IWL_MAX_SCAN_SIZE, GFP_KERNEL);
>                 if (!priv->scan_cmd) {
>                         IWL_DEBUG_SCAN(priv,
>                                        "fail to allocate memory for scan\n");
> -                       goto done;
> +                       return -ENOMEM;
>                 }
>         }
>         scan = priv->scan_cmd;
> @@ -1331,8 +1294,8 @@ void iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
>                                                 IWL_GOOD_CRC_TH_NEVER;
>                 break;
>         default:
> -               IWL_WARN(priv, "Invalid scan band count\n");
> -               goto done;
> +               IWL_WARN(priv, "Invalid scan band\n");
> +               return -EIO;
>         }
> 
>         band = priv->scan_band;
> @@ -1412,7 +1375,7 @@ void iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
>         }
>         if (scan->channel_count == 0) {
>                 IWL_DEBUG_SCAN(priv, "channel count %d\n", scan->channel_count);
> -               goto done;
> +               return -EIO;
>         }
> 
>         cmd.len += le16_to_cpu(scan->tx_cmd.len) +
> @@ -1422,28 +1385,20 @@ void iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
> 
>         set_bit(STATUS_SCAN_HW, &priv->status);
> 
> -       if (priv->cfg->ops->hcmd->set_pan_params &&
> -           priv->cfg->ops->hcmd->set_pan_params(priv))
> -               goto done;
> +       if (priv->cfg->ops->hcmd->set_pan_params) {
> +               ret = priv->cfg->ops->hcmd->set_pan_params(priv);
> +               if (ret)
> +                       return ret;
> +       }
STATUS_SCAN_HW bit still set here

Wey




