Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46157 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab3A2LxC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2013 06:53:02 -0500
Message-ID: <1359460403.8108.17.camel@jlt4.sipsolutions.net> (sfid-20130129_125306_967380_81B0C468)
Subject: Re: [PATCHv4] mac80211: mesh power save basics
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>,
	Mike Krinkin <krinkin.m.u@gmail.com>,
	Max Filippov <jcmvbkbc@gmail.com>
Date: Tue, 29 Jan 2013 12:53:23 +0100
In-Reply-To: <1358767080-21758-1-git-send-email-marco@cozybit.com> (sfid-20130121_121831_158137_E5D23643)
References: <1358767080-21758-1-git-send-email-marco@cozybit.com>
	 (sfid-20130121_121831_158137_E5D23643)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-01-21 at 12:18 +0100, Marco Porsch wrote:
[long changelog]

I think the changelog is pretty much unreadable. Can you boil it down,
or maybe start with a "tl;dr" version? All the little technical details
are also less important (like debugfs files, who cares).


> @@ -656,6 +684,13 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
>  	sta_info_flush(sdata);
>  	mesh_path_flush_by_iface(sdata);
>  
> +	atomic_set(&ifmsh->ps.num_sta_ps, 0); /* not reset by sta_info_flush */
> +	atomic_set(&ifmsh->num_mpsp, 0);

This comment tells me that you have bugs elsewhere, in particular in
mesh housekeeping. In fact, looking there, I see nothing that causes a
sleeping station to be accounted for correctly when it expires.


> +static void mps_set_sta_peer_pm(struct sta_info *sta,
> +				struct ieee80211_hdr *hdr)

> +void ieee80211_mpsp_trigger_process(struct ieee80211_hdr *hdr,
> +				    struct sta_info *sta, bool tx, bool acked)

I wonder if these functions should get the QoS CTL field instead of the
header, as otherwise nothing really verifies that they're passed QoS
frames to start with. Yes, that's the case today, but it's not obvious
that this is really a requirement.
 
johannes

