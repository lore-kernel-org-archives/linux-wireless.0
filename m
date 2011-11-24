Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39585 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab1KXSXU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Nov 2011 13:23:20 -0500
Subject: Re: [RFC v2 2/8] mac80211: mesh power mode indication in QoS frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Mike Krinkin <krinkin.m.u@gmail.com>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
In-Reply-To: <1321886416-12597-3-git-send-email-ivan.bezyazychnyy@gmail.com> (sfid-20111121_154146_911104_5CCCA53C)
References: <1321886416-12597-1-git-send-email-ivan.bezyazychnyy@gmail.com>
	 <1321886416-12597-3-git-send-email-ivan.bezyazychnyy@gmail.com>
	 (sfid-20111121_154146_911104_5CCCA53C)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Nov 2011 19:23:17 +0100
Message-ID: <1322158997.5366.29.camel@jlt3.sipsolutions.net> (sfid-20111124_192323_584042_6345F03F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-11-21 at 18:40 +0400, Ivan Bezyazychnyy wrote:

> +static enum nl80211_mesh_power_mode
> +ieee80211s_get_ps_mode(struct ieee80211_sub_if_data *sdata,
> +			struct ieee80211_hdr *hdr)
> +{
> +	enum nl80211_mesh_power_mode pm = NL80211_MESH_POWER_ACTIVE;
> +	struct mesh_path *mpath;
> +
> +	if (is_multicast_ether_addr(hdr->addr1)) {
> +		pm = (enum nl80211_mesh_power_mode)
> +				sdata->u.mesh.mshcfg.power_mode;

I mean here.

> +	} else {
> +		rcu_read_lock();
> +		mpath = mesh_path_lookup(hdr->addr3, sdata);
> +		if (mpath) {
> +			pm = mpath->next_hop->local_ps_mode;
> +		}

No need for braces.

> +static void ieee80211_set_mesh_ps_fields(struct ieee80211_sub_if_data *sdata,
> +					struct ieee80211_hdr *hdr)
> +{
> +	if (ieee80211_vif_is_mesh(&sdata->vif) &&
> +	    (ieee80211_is_data_qos(hdr->frame_control)
> +	     || ieee80211_is_qos_nullfunc(hdr->frame_control))) {
> +		enum nl80211_mesh_power_mode
> +				pm = ieee80211s_get_ps_mode(sdata, hdr);
> +		if (pm != NL80211_MESH_POWER_ACTIVE) {
> +			__le16 *qc = (__le16 *) ieee80211_get_qos_ctl(hdr);
> +			hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_PM);
> +			if (pm == NL80211_MESH_POWER_DEEP_SLEEP) {
> +				*qc |= cpu_to_le16(
> +					IEEE80211_QOS_CTL_MESH_PS_LEVEL);
> +			}
> +		}
> +	}
> +}

I'm sure you can write this in a more readable way, e.g. by returning
from the function if the conditions aren't met etc.

johannes

