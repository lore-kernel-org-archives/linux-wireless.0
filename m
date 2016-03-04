Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:59496 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758550AbcCDIen (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2016 03:34:43 -0500
Message-ID: <1457078876.28365.124.camel@coelho.fi> (sfid-20160304_093451_889631_E1CD9A8D)
From: Luca Coelho <luca@coelho.fi>
To: Jouni Malinen <jouni@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 04 Mar 2016 10:07:56 +0200
In-Reply-To: <1456517569-27235-1-git-send-email-jouni@qca.qualcomm.com>
References: <1456517569-27235-1-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH v2 1/3] cfg80211: Allow a scan request for a specific
 BSSID
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Looks good.  A couple of small comments.

On Fri, 2016-02-26 at 22:12 +0200, Jouni Malinen wrote:
> This allows scans for a specific BSSID to be optimized by the user space
> application by requesting the driver to set the Probe Request frame
> BSSID field (Address 3) to the specified BSSID instead of the wildcard
> BSSID. This prevents other APs from replying which reduces airtime need
> and latency in getting the response from the target AP through.
> 
> This is an optimization and as such, it is acceptable for some of the
> drivers not to support the mechanism. If not supported, the wildcard
> BSSID will be used and more responses may be received.

Receiving more responses than what we asked for is always possible,
because we don't filter out other things we may receive at the same
time.  It's like requesting for a specific SSID, it just means that the
SSID will be used in the probe requests, but it doesn't guarantee that
other results will not be returned.


> Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
> ---
> 
> Notes:
>     v2: Updated two forgotten rdev_scan() callers
> 
>  include/net/cfg80211.h       | 2 ++
>  include/uapi/linux/nl80211.h | 4 +++-
>  net/wireless/nl80211.c       | 6 ++++++
>  net/wireless/scan.c          | 2 ++
>  net/wireless/sme.c           | 2 ++
>  5 files changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 9e1b24c..14c0c43 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -1455,6 +1455,7 @@ struct cfg80211_ssid {
>   * @mac_addr_mask: MAC address mask used with randomisation, bits that
>   *	are 0 in the mask should be randomised, bits that are 1 should
>   *	be taken from the @mac_addr
> + * @bssid: BSSID to scan for (most commonly, the wildcard BSSID)
>   */
>  struct cfg80211_scan_request {
>  	struct cfg80211_ssid *ssids;
> @@ -1471,6 +1472,7 @@ struct cfg80211_scan_request {
>  
>  	u8 mac_addr[ETH_ALEN] __aligned(2);
>  	u8 mac_addr_mask[ETH_ALEN] __aligned(2);
> +	u8 bssid[ETH_ALEN] __aligned(2);
>  
>  	/* internal */
>  	struct wiphy *wiphy;
> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
> index 5a30a75..23bf066 100644
> --- a/include/uapi/linux/nl80211.h
> +++ b/include/uapi/linux/nl80211.h
> @@ -322,7 +322,9 @@
>   * @NL80211_CMD_GET_SCAN: get scan results
>   * @NL80211_CMD_TRIGGER_SCAN: trigger a new scan with the given parameters
>   *	%NL80211_ATTR_TX_NO_CCK_RATE is used to decide whether to send the
> - *	probe requests at CCK rate or not.
> + *	probe requests at CCK rate or not. %NL80211_ATTR_MAC can be used to
> + *	specify a BSSID to scan for; if not included, the wildcard BSSID will
> + *	be used.

Maybe you could be explicit here about the possibility of receiving
more results than requested?

--
Cheers,
Luca.
