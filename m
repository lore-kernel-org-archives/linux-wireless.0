Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hs-out-0708.google.com ([64.233.178.240]:31620 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753942AbYBDVW3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2008 16:22:29 -0500
Received: by hs-out-2122.google.com with SMTP id 54so2006963hsz.5
        for <linux-wireless@vger.kernel.org>; Mon, 04 Feb 2008 13:22:28 -0800 (PST)
To: linux-wireless@vger.kernel.org
From: Luis Carlos Cobo <luisca@cozybit.com>
Date: Mon, 4 Feb 2008 10:48:57 -0800
Subject: [PATCH 00/13] o11s: mesh interface support for mac80211
Message-ID: <47a78212.15588c0a.27b2.61d2@mx.google.com> (sfid-20080204_212233_169667_739F231D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series of patches provides support for (pre) IEEE 802.11s mesh interfaces.
Current features include mesh discovery, peer link establishment and on-demand
HWMP path discovery, using hop count as the metric.

The code has been tested in a 12-node testbed and has proved to be stable and
functional. We would like to get it integrated as soon as possible so it can get
more widespread testing and (hopefully) contributions. Unfortunately we have run
out of funds for this project (we are looking for sponsors!) so work on the
project from our side might slow down. At the very least, we are commited to
fixing bugs and tracking changes introduced by newer versions of the 11s draft.

The only supported driver right now is zd1211rw, but changes in the driver for
mesh functionality are minimal (for the zd1211rw driver most changes were just
to provide missing functionality such as beaconing support), so we expect a wide
array of devices to be supported soon.

We would appreciate any comments or advice useful toward integration of this
code. Specific areas where we would like to get some feedback are:

- Possible integration between mesh peer link and sta_info structures. Their
  purpose is similar and it will make it easier to implement mesh rate control
  and airtime link metric.

- Beaconing support: the current beacon model is appropriate for the zd1211rw
  driver but might not be for others.

- set_mesh_cfg command to set mesh ID and use of broadcast mesh ID when none is
  set: Johannes suggested the mesh ID should be specified when creating the mesh
  interface [1]. However we feel that a "mesh configuration" or "mesh network"
  object analogous to the "association" object he talks about would be more
  appropriate. Such an association object has not yet been implemented. We
  would appreciate some advice on how to implement our mesh network object so
  that it follows the spirit of mac80211.

- Scan support: we were waiting for scan to be moved to cfg80211 to avoid
  messing unnecessarily with wext, is there any effort in this direction?

[1]: http://www.spinics.net/lists/linux-wireless/msg07745.html

For more information, please visit: http://o11s.org/devel

Enjoy,

Luis Carlos Cobo


