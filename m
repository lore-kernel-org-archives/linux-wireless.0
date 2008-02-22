Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.189]:15991 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbYBVHRP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2008 02:17:15 -0500
Received: by rv-out-0910.google.com with SMTP id k20so203984rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 21 Feb 2008 23:17:13 -0800 (PST)
To: linux-wireless@vger.kernel.org
From: Luis Carlos Cobo <luisca@cozybit.com>
Date: Thu, 21 Feb 2008 20:05:04 -0800
Subject: [PATCH 00/13 v2] o11s: mesh interface support for mac80211
Message-ID: <47be76f9.03b48c0a.025f.54f4@mx.google.com> (sfid-20080222_071727_691746_9DC8AC76)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series of patches provides support for (pre) IEEE 802.11s mesh interfaces.
Current features include mesh discovery, peer link establishment and on-demand
HWMP path discovery.

This is the second round of patches incorporating the comments from Johannes
Berg and others. The main changes with the first set of patches are:

 - We are now using airtime link metric, instead of hop count.

 - Mesh peer link table has been discarded, integrating the necessary attributes
   directly on struct sta_info.

 - We no longer use directly rtnetlink for mesh peer link and mesh paths
   operation, and use nl80211 instead.

 - We now support mesh network in scan. The part interacting with wext is a bit
   ugly but works well. I just read the mail from Johannes with a different
   approach and will consider it.

The pid rate control algorithm has been modified to provide an estimated
transmission error, probability, necessary for the airtime link metric, and a to
call mesh_peer_link_broken() if it detects a sta is no longer reachable.

I would like to point out that it looks like we can get duplicate sta_entries,
or more entries than the maximum allowed, if stas are added at the same time
through normal network behavior and manual operation through nl80211. Please
correct me if I am wrong or if it is just that no interface type is supposed to
allow both kinds of additions.

The code has been tested in a 12-node testbed and has proved to be stable and
functional. The only supported driver right now is zd1211rw, but changes in the
driver for mesh functionality are minimal (for the zd1211rw driver most changes
were just to provide missing functionality such as beaconing support), so we
expect a wide array of devices to be supported soon.

The patches are to be applied on top of wireless-2.6/everything HEAD. Even
though I am sure there will be some issues, it would be great if we could
integrate this as soon as possible to make it easier for other people to
collaborate and to make my life a bit easier :-)

For more information, please visit: http://o11s.org/devel

Enjoy,

Luis Carlos Cobo


