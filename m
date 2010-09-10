Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60373 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751793Ab0IJFP2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Sep 2010 01:15:28 -0400
Date: Fri, 10 Sep 2010 07:15:46 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 09/12] iwlwifi: force scan complete after timeout
Message-ID: <20100910051545.GA2968@redhat.com>
References: <1284040354-31703-1-git-send-email-sgruszka@redhat.com>
 <1284040354-31703-10-git-send-email-sgruszka@redhat.com>
 <E9954878DD1FB34FAE5187FB88C58A3501280FDC94@orsmsx506.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <E9954878DD1FB34FAE5187FB88C58A3501280FDC94@orsmsx506.amr.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 09, 2010 at 08:50:03AM -0700, Guy, Wey-Yi W wrote:
> --- a/drivers/net/wireless/iwlwifi/iwl-core.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-core.c
> @@ -2041,7 +2041,6 @@ void iwl_mac_remove_interface(struct ieee80211_hw *hw,
>  {
>         struct iwl_priv *priv = hw->priv;
>         struct iwl_rxon_context *ctx = iwl_rxon_ctx_from_vif(vif);
> -       bool scan_completed = false;
> 
>         IWL_DEBUG_MAC80211(priv, "enter\n");
> 
> @@ -2050,15 +2049,10 @@ void iwl_mac_remove_interface(struct ieee80211_hw *hw,
>         WARN_ON(ctx->vif != vif);
>         ctx->vif = NULL;
> 
> -       iwl_scan_cancel_timeout(priv, 100);
> +       if (priv->scan_vif == vif)
> +               iwl_scan_cancel_timeout(priv, 100);
>         iwl_set_mode(priv, vif);
> 
> -       if (priv->scan_vif == vif) {
> -               scan_completed = true;
> -               priv->scan_vif = NULL;
> -               priv->scan_request = NULL;
> -       }
> -
[snip]
> Not sure, do we need to check vif match?

I think it is. We should not cancel scan requested by vif0 if vif1 is
removing. Previously we also check vif match before complete scan in
mac.

Stanislaw
