Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56658 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752078Ab1IVRFQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 13:05:16 -0400
Subject: Re: [PATCH] libertas: scan behaviour consistency improvements
From: Dan Williams <dcbw@redhat.com>
To: Daniel Drake <dsd@laptop.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	libertas-dev@lists.infradead.org
Date: Thu, 22 Sep 2011 12:05:12 -0500
In-Reply-To: <20110921174359.DD2B39D401D@zog.reactivated.net>
References: <20110921174359.DD2B39D401D@zog.reactivated.net>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1316711112.3698.15.camel@dcbw.foobar.com> (sfid-20110922_190520_105218_547DB058)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-09-21 at 18:43 +0100, Daniel Drake wrote:
> When scanning for the broadcast SSID, there is no need to add the
> SSID TLV (restoring the behaviour of the driver behaviour in the wext
> days, confirmed in Marvell specifications).

I reviewed the specs for v9 and v10 and this is correct.

> If bssid is unspecified, the current scan code will usually fire off an
> active scan probing for the specific requested SSID. However, if a scan
> is ongoing (or has just finished), those scan results will be used
> instead (even if that scan is totally different, e.g. a passive scan on
> channel 4 for a different SSID). Fix this inconsistency by always
> firing off a scan when associating without a bssid.

> Signed-off-by: Daniel Drake <dsd@laptop.org>

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
>  drivers/net/wireless/libertas/cfg.c |   33 +++++++++++++++++----------------
>  drivers/net/wireless/libertas/dev.h |    1 -
>  2 files changed, 17 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
> index b456a53..93e5dea 100644
> --- a/drivers/net/wireless/libertas/cfg.c
> +++ b/drivers/net/wireless/libertas/cfg.c
> @@ -691,7 +691,7 @@ static void lbs_scan_worker(struct work_struct *work)
>  	tlv = scan_cmd->tlvbuffer;
>  
>  	/* add SSID TLV */
> -	if (priv->scan_req->n_ssids)
> +	if (priv->scan_req->n_ssids && priv->scan_req->ssids[0].ssid_len > 0)
>  		tlv += lbs_add_ssid_tlv(tlv,
>  					priv->scan_req->ssids[0].ssid,
>  					priv->scan_req->ssids[0].ssid_len);
> @@ -732,7 +732,6 @@ static void lbs_scan_worker(struct work_struct *work)
>  			cfg80211_scan_done(priv->scan_req, false);
>  
>  		priv->scan_req = NULL;
> -		priv->last_scan = jiffies;
>  	}
>  
>  	/* Restart network */
> @@ -1295,24 +1294,26 @@ static int lbs_cfg_connect(struct wiphy *wiphy, struct net_device *dev,
>  	lbs_deb_enter(LBS_DEB_CFG80211);
>  
>  	if (!sme->bssid) {
> -		/* Run a scan if one isn't in-progress already and if the last
> -		 * scan was done more than 2 seconds ago.
> -		 */
> -		if (priv->scan_req == NULL &&
> -		    time_after(jiffies, priv->last_scan + (2 * HZ))) {
> -			struct cfg80211_scan_request *creq;
> +		struct cfg80211_scan_request *creq;
>  
> -			creq = _new_connect_scan_req(wiphy, sme);
> -			if (!creq) {
> -				ret = -EINVAL;
> -				goto done;
> -			}
> +		/*
> +		 * Scan for the requested network after waiting for existing
> +		 * scans to finish.
> +		 */
> +		lbs_deb_assoc("assoc: waiting for existing scans\n");
> +		wait_event_interruptible_timeout(priv->scan_q,
> +						 (priv->scan_req == NULL),
> +						 (15 * HZ));
>  
> -			lbs_deb_assoc("assoc: scanning for compatible AP\n");
> -			_internal_start_scan(priv, true, creq);
> +		creq = _new_connect_scan_req(wiphy, sme);
> +		if (!creq) {
> +			ret = -EINVAL;
> +			goto done;
>  		}
>  
> -		/* Wait for any in-progress scan to complete */
> +		lbs_deb_assoc("assoc: scanning for compatible AP\n");
> +		_internal_start_scan(priv, true, creq);
> +
>  		lbs_deb_assoc("assoc: waiting for scan to complete\n");
>  		wait_event_interruptible_timeout(priv->scan_q,
>  						 (priv->scan_req == NULL),
> diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
> index adb3490..5ac4d17 100644
> --- a/drivers/net/wireless/libertas/dev.h
> +++ b/drivers/net/wireless/libertas/dev.h
> @@ -167,7 +167,6 @@ struct lbs_private {
>  	wait_queue_head_t scan_q;
>  	/* Whether the scan was initiated internally and not by cfg80211 */
>  	bool internal_scan;
> -	unsigned long last_scan;
>  };
>  
>  extern struct cmd_confirm_sleep confirm_sleep;


