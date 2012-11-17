Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56436 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882Ab2KQJOL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Nov 2012 04:14:11 -0500
Message-ID: <1353143685.9543.22.camel@jlt4.sipsolutions.net> (sfid-20121117_101419_856334_C539CC8F)
Subject: Re: [RFC 06/14] mac80211: track neighbor STA power modes
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Cc: javier@cozybit.com, linux-wireless@vger.kernel.org,
	Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>,
	Mike Krinkin <krinkin.m.u@gmail.com>,
	Max Filippov <jcmvbkbc@gmail.com>
Date: Sat, 17 Nov 2012 10:14:45 +0100
In-Reply-To: <1353134886-13256-7-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1353134886-13256-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
	 <1353134886-13256-7-git-send-email-marco.porsch@etit.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-11-16 at 22:47 -0800, Marco Porsch wrote:

> +/**
> + * ieee80211_has_qos_pm - check Power Save Level in QoS control
> + * @qc - QoS control bytes in little-endian byteorder
> + */
> +static inline int ieee80211_has_qos_pm(__le16 qc)

bool

> +/**
> + * ieee80211_set_peer_ps_mode - track the neighbor mesh STA's peer-specific
> + * power mode towards the local STA

not valid kernel-doc.

> +void ieee80211_set_nonpeer_ps_mode(struct sta_info *sta,
> +				   struct ieee80211_hdr *hdr)
> +{
> +	enum nl80211_mesh_power_mode pm;
> +	static const char *modes[] = {
> +		[NL80211_MESH_POWER_ACTIVE] = "active",
> +		[NL80211_MESH_POWER_DEEP_SLEEP] = "deep sleep",
> +	};

> +	mps_dbg(sta->sdata, "STA %pM sets non-peer mode to %s\n",
> +		sta->sta.addr, modes[pm]);

This will cause warnings if debug is disabled, can't you just print the
numeric value? It's for your own debugging -- hardly seems necessary to
have the strings.

Same in the other function.

And now that I've seen you haven't even compiled the code with the debug
Kconfig turned off, I'll have to ask you to do that.

johannes

