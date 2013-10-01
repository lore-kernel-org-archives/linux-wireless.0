Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59742 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab3JALx4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Oct 2013 07:53:56 -0400
Message-ID: <1380628433.14430.38.camel@jlt4.sipsolutions.net> (sfid-20131001_135400_120006_0788E261)
Subject: Re: [PATCH] iw: use nl80211 for phy_lookup function
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Lopez <jlopex@cozybit.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 01 Oct 2013 13:53:53 +0200
In-Reply-To: <1380534243-4766-1-git-send-email-jlopex@cozybit.com> (sfid-20130930_114417_359295_7C4C8D96)
References: <1380534243-4766-1-git-send-email-jlopex@cozybit.com>
	 (sfid-20130930_114417_359295_7C4C8D96)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-09-30 at 11:44 +0200, Javier Lopez wrote:
> Original implementation uses sysfs to get dev index from
> dev name. Due the changes on netns and sysfs iw is broken
> if using multiple network namespaces. iw works properly
> if using it from the main namespace, but it won't work if
> using from the new namespace.
> 
> Kernel commit 3ff195b0, "sysfs: Implement sysfs tagged
> directory support" patch, added a filtering mechanism
> to sysfs, allowing sysfs directories to look different
> depending on the context where they are being observed.
> 
> When an interface is moved to another namespace, the
> interface dissapears from sysfs structure. In order
> to recover access to the directory a solution is to
> remount sysfs from the correct context. This will force
> the user to remount sysfs before using iw from a
> different namespace.
> 
> To avoid this issue we can use nl80211 (using
> NL80211_CMD_GET_WIPHY command) this returns the list of
> phys, then process the list, find the device and return
> the device index.

This seems a bit workaround-ish/hack-ish to me. Why would a remount be
necessary? Can't sysfs look at the process tags when determining the
access? Should we maybe do something in our sysfs code in the kernel for
this?

johannes

