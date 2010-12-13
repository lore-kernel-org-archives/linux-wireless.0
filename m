Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33612 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376Ab0LMKEJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 05:04:09 -0500
Subject: Re: [PATCH 1/2] mac80211: Let userspace enable and configure
 vendor specific path selection.
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Steve Derosier <steve@cozybit.com>, devel@lists.open80211s.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <1292022251-12616-2-git-send-email-javier@cozybit.com>
References: <1292022251-12616-1-git-send-email-javier@cozybit.com>
	 <1292022251-12616-2-git-send-email-javier@cozybit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Dec 2010 11:04:03 +0100
Message-ID: <1292234643.3539.6.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-12-10 at 15:04 -0800, Javier Cardona wrote:

> +++ b/include/net/cfg80211.h
> @@ -643,6 +643,12 @@ struct mesh_config {
>  	u16 dot11MeshHWMPpreqMinInterval;
>  	u16 dot11MeshHWMPnetDiameterTraversalTime;
>  	u8  dot11MeshHWMPRootMode;
> +	u8  vendor_path_sel_enabled;
> +	u8  vendor_metric_enabled;
> +	struct {
> +		u8  *data;

const -- and I really wouldn't do a substruct for this.

> +		u8  length;
> +	} vendor_ie;
>  };

Should these really be part of mesh_config, rather than mesh_setup? I
may accept a need to change beacon IEs, but I don't think it makes any
sense to change the path selection at mesh runtime since changing it
will change the mesh network the node belongs to per mesh_matches_local.

> @@ -522,6 +528,10 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
>  	ieee80211_mesh_root_setup(ifmsh);
>  	ieee80211_queue_work(&local->hw, &sdata->work);
>  	sdata->vif.bss_conf.beacon_int = MESH_DEFAULT_BEACON_INTERVAL;
> +	sdata->u.mesh.mesh_pp_id = ifmsh->mshcfg.vendor_path_sel_enabled ?
> +		MESH_PATH_PROTOCOL_VENDOR : MESH_PATH_PROTOCOL_HWMP;
> +	sdata->u.mesh.mesh_pm_id = ifmsh->mshcfg.vendor_metric_enabled ?
> +		MESH_PATH_METRIC_VENDOR : MESH_PATH_METRIC_AIRTIME;

In fact, it looks like you only honour changes to them in start_mesh().

> +++ b/net/mac80211/mesh.h
> @@ -44,6 +44,30 @@ enum mesh_path_flags {
>  };
>  
>  /**
> + * enum - mesh path selection protocol identifier
> + *
> + * @MESH_PATH_PROTOCOL_HWMP: the default path selection protocol
> + * @MESH_PATH_PROTOCOL_VENDOR: a vendor specific protocol that will be
> + * specified in a vendor specific information element
> + */
> +enum {
> +	MESH_PATH_PROTOCOL_HWMP = 0,
> +	MESH_PATH_PROTOCOL_VENDOR = 255,
> +};

> +/**
> + * enum - mesh path selection metric identifier
> + *
> + * @MESH_PATH_METRIC_AIRTIME: the default path selection metric
> + * @MESH_PATH_METRIC_VENDOR: a vendor specific metric that will be
> + * specified in a vendor specific information element
> + */
> +enum {
> +	MESH_PATH_METRIC_AIRTIME = 0,
> +	MESH_PATH_METRIC_VENDOR = 255,
> +};

Should these get an IEEE80211 prefix and move to
include/linux/ieee80211.h?

johannes

