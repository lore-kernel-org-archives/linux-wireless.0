Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54730 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755544Ab2JSNYe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Oct 2012 09:24:34 -0400
Message-ID: <1350653106.10678.1.camel@jlt4.sipsolutions.net> (sfid-20121019_152439_296197_25F87CD5)
Subject: Re: [PATCH] mac80211: make powersave independent of interface type
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, bob@cozybit.com,
	devel@lists.open80211s.org
Date: Fri, 19 Oct 2012 15:25:06 +0200
In-Reply-To: <1349897990-9589-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
References: <1349897990-9589-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-10-10 at 12:39 -0700, Marco Porsch wrote:
> This patch prepares mac80211 for a later implementation of mesh or ad-hoc
> powersave clients.
> The structures related to powersave (buffer, TIM map, counters) are moved
> from the AP-specific interface structure to a generic structure that can
> be embedded into any interface type.
> The functions related to powersave are prepared to allow easy extension
> with different interface types. For example with:
> 
> + } else if (sta->sdata->vif.type == NL80211_IFTYPE_MESH_POINT) {
> +			ps = &sdata->u.mesh.ps;
> 
> Some references to the AP's beacon structure are removed where they were
> obviously not used.
> 
> The patch compiles without warning and has been briefly tested as AP
> interface with one client in PS mode.

Applied.

johannes

