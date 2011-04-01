Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35233 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244Ab1DAIVG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 04:21:06 -0400
Subject: Re: [PATCH] nl80211: report mesh capabilities
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, javier@cozybit.com
In-Reply-To: <1301622549-16788-1-git-send-email-thomas@cozybit.com>
References: <1301472903.3935.3.camel@jlt3.sipsolutions.net>
	 <1301622549-16788-1-git-send-email-thomas@cozybit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Apr 2011 10:23:00 +0200
Message-ID: <1301646180.3832.7.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-03-31 at 18:49 -0700, Thomas Pedersen wrote:
> NL80211_CMD_GET_WIPHY now returns a flag NL80211_SUPPORT_MESH_AUTH if
> the wiphy's mesh implementation supports routing of mesh auth frames to
> userspace.  This is useful for forward compatibility between old kernels
> and new userspace tools.

Patch looks good, but you should check whether mesh auth is supported in
join_mesh when it is requested, and refuse otherwise, so that we force
drivers to correctly advertise it.


> Thanks for your comments, I've tried to implement the necessary changes below.
> wiphy->flags now gets a WIPHY_FLAG_MESH_AUTH flag in case the mesh
> implementation supports routing of mesh auth frames to userspace. If you know
> of a better place to put this (rdev maybe?), please let me know. Also, it would
> be nice if all you have is the ifindex; not having to send a command to
> nl80211, parse the response, then get the wiphy index so you can request
> capabilities from the stack. I'd like to be able to get capabilities directly
> from an interface, should this happen in CMD_GET_MESH_CONFIG,
> CMD_GET_INTERFACE, or maybe somewhere else?

iw can't do this because it overloads the command line, but in nl80211
you can always use an ifindex instead of a wiphy index to identify a
device.

johannes

