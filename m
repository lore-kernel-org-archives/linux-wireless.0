Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52914 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757761Ab3APV47 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2013 16:56:59 -0500
Message-ID: <1358373443.15012.7.camel@jlt4.sipsolutions.net> (sfid-20130116_225706_926358_6D141F7D)
Subject: Re: [PATCHv2 0/6] mesh power save - basics
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Date: Wed, 16 Jan 2013 22:57:23 +0100
In-Reply-To: <1357571093-12868-1-git-send-email-marco@cozybit.com> (sfid-20130107_160502_996138_4CD53EC2)
References: <1357571093-12868-1-git-send-email-marco@cozybit.com>
	 (sfid-20130107_160502_996138_4CD53EC2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-01-07 at 16:04 +0100, Marco Porsch wrote:
> Commits #5 and #6 cover the basic subset of functions, that each mesh node
> must support to communicate in the presence of power saving nodes.
> The current patchset does not implement any actual power savings yet (no
> hardware configuration, no doze state).
> 
> Mesh powersave is different from client mode powersave in the sense that
> 1) there is not just a singular power mode towards the access point, but a
>    link-specific power mode towards each peer instead
> 2) peers also maintain a power mode towards us (the local STA)
> 3) each node has to buffer frames towards power saving neighbors
> 
> changes since PATCHv1:
> - explicitly clear QoS control field in mps_qos_null_get
> - beautify FILL_IN_MESH_PARAM_IF_SET macro
> 
> Marco Porsch (6):
>   nl80211: add range checks to mesh parameters
>   mac80211: update mesh peer link counter during userspace peering
>   mac80211: move add_tim to subfunction
>   {cfg,nl,mac}80211: set beacon interval and DTIM period on mesh join
>   {cfg,nl}80211: mesh power mode primitives and userspace access

I applied patches 1-5, comments on 6 following shortly.

johannes

