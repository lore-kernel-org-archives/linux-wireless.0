Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:53302 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752476Ab2FKPut (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 11:50:49 -0400
Message-ID: <4FD613CB.4040900@xenotime.net> (sfid-20120611_175052_686586_A2731842)
Date: Mon, 11 Jun 2012 08:50:35 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
MIME-Version: 1.0
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
CC: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	javier@cozybit.com, linville@tuxdriver.com,
	devel@lists.open80211s.org
Subject: Re: [PATCH] {nl,cfg,mac}80211: add missing kernel-doc for mesh configuration
 structure
References: <1339387150-7345-1-git-send-email-yeohchunyeow@gmail.com>
In-Reply-To: <1339387150-7345-1-git-send-email-yeohchunyeow@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/10/2012 08:59 PM, Chun-Yeow Yeoh wrote:

> Add the missing kernel-doc for mesh configuration parameters as pointed
> out by Johannes Berg.
> 
> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>


Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

> ---
>  include/net/cfg80211.h |   59 +++++++++++++++++++++++++++++++++++++++--------
>  1 files changed, 49 insertions(+), 10 deletions(-)
> 
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 7319f25..a129ee2 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -790,26 +790,69 @@ struct bss_parameters {
>  	int ht_opmode;
>  };
>  
> -/*
> +/**
>   * struct mesh_config - 802.11s mesh configuration
>   *
>   * These parameters can be changed while the mesh is active.
> + *
> + * @dot11MeshRetryTimeout: the initial retry timeout in millisecond units used
> + *	by the Mesh Peering Open message
> + * @dot11MeshConfirmTimeout: the initial retry timeout in millisecond units
> + *	used by the Mesh Peering Open message
> + * @dot11MeshHoldingTimeout: the confirm timeout in millisecond units used by
> + *	the mesh peering management to close a mesh peering
> + * @dot11MeshMaxPeerLinks: the maximum number of peer links allowed on this
> + *	mesh interface
> + * @dot11MeshMaxRetries: the maximum number of peer link open retries that can
> + *	be sent to establish a new peer link instance in a mesh
> + * @dot11MeshTTL: the value of TTL field set at a source mesh STA
> + * @element_ttl: the value of TTL field set at a mesh STA for path selection
> + *	elements
> + * @auto_open_plinks: whether we should automatically open peer links when we
> + *	detect compatible mesh peers
> + * @dot11MeshNbrOffsetMaxNeighbor: the maximum number of neighbors to
> + *	synchronize to for 11s default synchronization method
> + * @dot11MeshHWMPmaxPREQretries: the number of action frames containing a PREQ
> + *	that an originator mesh STA can send to a particular path target
> + * @path_refresh_time: how frequently to refresh mesh paths in milliseconds
> + * @min_discovery_timeout: the minimum length of time to wait until giving up on
> + *	a path discovery in milliseconds
> + * @dot11MeshHWMPactivePathTimeout: the time (in TUs) for which mesh STAs
> + *	receiving a PREQ shall consider the forwarding information from the
> + *	root to be valid. (TU = time unit)
> + * @dot11MeshHWMPpreqMinInterval: the minimum interval of time (in TUs) during
> + *	which a mesh STA can send only one action frame containing a PREQ
> + *	element
> + * @dot11MeshHWMPperrMinInterval: the minimum interval of time (in TUs) during
> + *	which a mesh STA can send only one Action frame containing a PERR
> + *	element
> + * @dot11MeshHWMPnetDiameterTraversalTime: the interval of time (in TUs) that
> + *	it takes for an HWMP information element to propagate across the mesh
> + * @dot11MeshHWMPRootMode: the configuration of a mesh STA as root mesh STA
> + * @dot11MeshHWMPRannInterval: the interval of time (in TUs) between root
> + *	announcements are transmitted
> + * @dot11MeshGateAnnouncementProtocol: whether to advertise that this mesh
> + *	station has access to a broader network beyond the MBSS. (This is
> + *	missnamed in draft 12.0: dot11MeshGateAnnouncementProtocol set to true
> + *	only means that the station will announce others it's a mesh gate, but
> + *	not necessarily using the gate announcement protocol. Still keeping the
> + *	same nomenclature to be in sync with the spec)
> + * @dot11MeshForwarding: whether the Mesh STA is forwarding or non-forwarding
> + *	entity (default is TRUE - forwarding entity)
> + * @rssi_threshold: the threshold for average signal strength of candidate
> + *	station to establish a peer link
> + * @ht_opmode: mesh HT protection mode
>   */
>  struct mesh_config {
> -	/* Timeouts in ms */
> -	/* Mesh plink management parameters */
>  	u16 dot11MeshRetryTimeout;
>  	u16 dot11MeshConfirmTimeout;
>  	u16 dot11MeshHoldingTimeout;
>  	u16 dot11MeshMaxPeerLinks;
>  	u8  dot11MeshMaxRetries;
>  	u8  dot11MeshTTL;
> -	/* ttl used in path selection information elements */
>  	u8  element_ttl;
>  	bool auto_open_plinks;
> -	/* neighbor offset synchronization */
>  	u32 dot11MeshNbrOffsetMaxNeighbor;
> -	/* HWMP parameters */
>  	u8  dot11MeshHWMPmaxPREQretries;
>  	u32 path_refresh_time;
>  	u16 min_discovery_timeout;
> @@ -819,10 +862,6 @@ struct mesh_config {
>  	u16 dot11MeshHWMPnetDiameterTraversalTime;
>  	u8  dot11MeshHWMPRootMode;
>  	u16 dot11MeshHWMPRannInterval;
> -	/* This is missnamed in draft 12.0: dot11MeshGateAnnouncementProtocol
> -	 * set to true only means that the station will announce others it's a
> -	 * mesh gate, but not necessarily using the gate announcement protocol.
> -	 * Still keeping the same nomenclature to be in sync with the spec. */
>  	bool  dot11MeshGateAnnouncementProtocol;
>  	bool dot11MeshForwarding;
>  	s32 rssi_threshold;



-- 
~Randy
