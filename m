Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:35016 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755321Ab0JVPXz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Oct 2010 11:23:55 -0400
Subject: Re: [PATCH 1/7] iwlwifi: warn when send tx power settings during
 scan
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1287759870-5758-1-git-send-email-sgruszka@redhat.com>
References: <1287759870-5758-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain
Date: Fri, 22 Oct 2010 08:23:05 -0700
Message-Id: <1287760985.8143.0.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

On Fri, 2010-10-22 at 08:04 -0700, Stanislaw Gruszka wrote:
> Add WARN_ONCE when scanning is pending. Use STATUS_SCAN_HW bit since we
> can have scan canceled or completed but STATUS_SCANNING bit still set.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-3945.c    |    4 ++++
>  drivers/net/wireless/iwlwifi/iwl-4965.c    |   10 +++-------
>  drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    4 ++++
>  3 files changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
> index 176e525..93db6a0 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-3945.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
> @@ -1451,6 +1451,10 @@ static int iwl3945_send_tx_power(struct iwl_priv *priv)
>  	};
>  	u16 chan;
>  
> +	if (WARN_ONCE(test_bit(STATUS_SCAN_HW, &priv->status),
> +		      "TX Power requested while scanning!\n"))
> +		return -EIO;
> +
>  	chan = le16_to_cpu(priv->contexts[IWL_RXON_CTX_BSS].active.channel);
>  
>  	txpower.band = (priv->band == IEEE80211_BAND_5GHZ) ? 0 : 1;
> diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
> index b207e3e..924f335 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-4965.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
> @@ -1377,13 +1377,9 @@ static int iwl4965_send_tx_power(struct iwl_priv *priv)
>  	u8 ctrl_chan_high = 0;
>  	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
>  
> -	if (test_bit(STATUS_SCANNING, &priv->status)) {
> -		/* If this gets hit a lot, switch it to a BUG() and catch
> -		 * the stack trace to find out who is calling this during
> -		 * a scan. */
> -		IWL_WARN(priv, "TX Power requested while scanning!\n");
> -		return -EAGAIN;
> -	}
> +	if (WARN_ONCE(test_bit(STATUS_SCAN_HW, &priv->status),
> +		      "TX Power requested while scanning!\n"))
> +		return -EIO;

what reason we want to return -EIO instead of -EAGAIN?

Wey



