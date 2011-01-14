Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:34561 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923Ab1ANSGF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Jan 2011 13:06:05 -0500
Message-ID: <4D309086.7070703@openwrt.org>
Date: Fri, 14 Jan 2011 19:05:58 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: greearb@candelatech.com
CC: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [ath9k-devel] [RFC 1/2] ath9k: Fix up hardware mode and beacons
 with multiple vifs.
References: <1295026029-21130-1-git-send-email-greearb@candelatech.com>
In-Reply-To: <1295026029-21130-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-01-14 6:27 PM, greearb@candelatech.com wrote:
> From: Ben Greear<greearb@candelatech.com>
>
> When using a mixture of AP and Station interfaces,
> the hardware mode was using the type of the
> last VIF registered.  Instead, we should keep track
> of the number of different types of vifs and set the
> mode accordingly.
>
> In addtion, use the vif type instead of hardware opmode
> when dealing with beacons.
>
> Attempt to move some of the common setup code into smaller
> methods so we can re-use it when changing vif mode as
> well as adding/deleting vifs.
>
> This needs review.
>
> Signed-off-by: Ben Greear<greearb@candelatech.com>
> ---
> :100644 100644 3108699... a2da259... M	drivers/net/wireless/ath/ath9k/ath9k.h
> :100644 100644 385ba03... 8de591e... M	drivers/net/wireless/ath/ath9k/beacon.c
> :100644 100644 0452580... 1a65e53... M	drivers/net/wireless/ath/ath9k/main.c
> :100644 100644 ea2f67c... 9a2b4a8... M	drivers/net/wireless/ath/ath9k/recv.c
>   drivers/net/wireless/ath/ath9k/ath9k.h  |   10 +-
>   drivers/net/wireless/ath/ath9k/beacon.c |   14 +-
>   drivers/net/wireless/ath/ath9k/main.c   |  263 ++++++++++++++++++++++---------
>   drivers/net/wireless/ath/ath9k/recv.c   |   17 ++-
>   4 files changed, 214 insertions(+), 90 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
> index 3108699..a2da259 100644
> --- a/drivers/net/wireless/ath/ath9k/ath9k.h
> +++ b/drivers/net/wireless/ath/ath9k/ath9k.h
> @@ -607,10 +607,15 @@ struct ath_softc {
>   	u32 sc_flags; /* SC_OP_* */
>   	u16 ps_flags; /* PS_* */
>   	u16 curtxpow;
> -	u8 nbcnvifs;
> -	u16 nvifs;
>   	bool ps_enabled;
>   	bool ps_idle;
> +	short nbcnvifs;
> +	short nvifs;
> +	short naps; /* number of APs */
> +	short nmeshes;
> +	short nstations;
> +	short nwds;
> +	short nadhocs;
>   	unsigned long ps_usecount;
>
>   	struct ath_config config;
Do we really need all those counters? Wouldn't it be better to iterate 
over active interfaces instead?

> diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
> index ea2f67c..9a2b4a8 100644
> --- a/drivers/net/wireless/ath/ath9k/recv.c
> +++ b/drivers/net/wireless/ath/ath9k/recv.c
> @@ -589,8 +589,14 @@ static void ath_rx_ps_beacon(struct ath_softc *sc, struct sk_buff *skb)
>   		return;
>
>   	mgmt = (struct ieee80211_mgmt *)skb->data;
> -	if (memcmp(common->curbssid, mgmt->bssid, ETH_ALEN) != 0)
> +	if (memcmp(common->curbssid, mgmt->bssid, ETH_ALEN) != 0) {
> +		/* TODO:  This doesn't work well if you have stations
> +		 * associated to two different APs because curbssid
> +		 * is just the last AP that any of the stations associated
> +		 * with.
> +		 */
>   		return; /* not from our current AP */
> +	}
>
>   	sc->ps_flags&= ~PS_WAIT_FOR_BEACON;
>
> @@ -980,13 +986,20 @@ static void ath9k_process_rssi(struct ath_common *common,
>   	int last_rssi;
>   	__le16 fc;
>
> +	/* TODO:  Maybe need to accept this if we have STA vifs active?? */
>   	if (ah->opmode != NL80211_IFTYPE_STATION)
>   		return;
>
>   	fc = hdr->frame_control;
>   	if (!ieee80211_is_beacon(fc) ||
> -	    compare_ether_addr(hdr->addr3, common->curbssid))
> +	    compare_ether_addr(hdr->addr3, common->curbssid)) {
> +		/* TODO:  This doesn't work well if you have stations
> +		 * associated to two different APs because curbssid
> +		 * is just the last AP that any of the stations associated
> +		 * with.
> +		 */
>   		return;
> +	}
>
>   	if (rx_stats->rs_rssi != ATH9K_RSSI_BAD&&  !rx_stats->rs_moreaggr)
>   		ATH_RSSI_LPF(aphy->last_rssi, rx_stats->rs_rssi);
Checking for the STA opmode is correct, this code should not be used for 
STA+AP. For the multi-STA case, it may make sense to process the RSSI 
average per vif and using the minimum for ANI.

- Felix
