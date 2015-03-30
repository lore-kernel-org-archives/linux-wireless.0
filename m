Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:27788 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858AbbC3OOZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 10:14:25 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [RFC 0/5] cfg80211 / mac80211: add support for Neighbor Awareness Networking
Date: Mon, 30 Mar 2015 17:14:15 +0300
Message-Id: <1427724860-1992-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150330_161429_248261_2D221C3C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series add supports for a new WiFi feature called
Neighbor Awareness Networking a.k.a. NAN.
It is built from the following layers:
 * Time synchronization
 * Discovery Engine (DE)

Time synchronization (MAC Layer):
---------------------------------

NAN allows service discovery within a group of devices: a
cluster. At least one device in the cluster is sending
beacons to keep all the other devices synchronized and to
allow new devices to find and join the cluster. This device
is called "master".
Since sending beacons costs power, the spec allows each
device to set a number which will reflect if it wants to be
master or not. This number is called "master preference" and
can change while NAN is active.

At specific times (16ms every 512ms on each supported band),
a NAN device must stay awake on channel to exchange
information with the other devices in the cluster. This
period of time is called Discovery Window (DW).

Clusters can merge based on rules defined by the spec. The
cluster survivability to disappearing nodes is also ensured
by the spec.

Discovery Engine (DE):
----------------------

The DE can send frames in the DW, this makes sure that all
the devices in the cluster are awake and on channel.
The DE contains NAN functions that can be:
 * publish
 * subscribe
 * follow-up

Each one of these has specific parameters. For example, a
NAN device can actively subscribe to a service. In this case
it will send frames to say it is looking for a service.
A device can also subsribe without sending any frames, this
is called "passive subscribe".
A device can publish a service and send a frame to advertise
the service only if it is requested by an active subscriber.
This is called "solicited publish". A device can also
publish a service and send frames to advertise the service
regardless of the presence or absence of subscribers for
this specific service. This is called "unsolicited publish".
A device can send follow-up frames which allow to get more
info about a specific service.

One of the main goals of NAN is to provide a low power
mechanism for service discovery. Hence, most devices
implementing NAN are expected to offload the layers
described above into the device. This means that cfg80211
/ mac80211 won't do much besides being a pass through for
the configuration. This still means that we need to add a
new vif type and add quite a bit of code to do just that.

Emmanuel Grumbach (5):
  cfg80211: add start / stop NAN commands
  mac80211: add boilerplate code for start / stop NAN
  cfg80211: add add_nan_func / rm_nan_func
  cfg80211: allow the user space to change the NAN master preference
  cfg80211: provide a function to report a match for NAN

 include/net/cfg80211.h       | 108 +++++++++-
 include/net/mac80211.h       |   6 +
 include/uapi/linux/nl80211.h | 198 +++++++++++++++++
 net/mac80211/cfg.c           |  38 ++++
 net/mac80211/chan.c          |   6 +
 net/mac80211/driver-ops.h    |  29 ++-
 net/mac80211/iface.c         |  12 +-
 net/mac80211/main.c          |   4 +
 net/mac80211/offchannel.c    |   3 +-
 net/mac80211/trace.h         |  48 +++++
 net/mac80211/util.c          |   4 +-
 net/wireless/chan.c          |   2 +
 net/wireless/core.c          |  35 +++
 net/wireless/core.h          |   3 +
 net/wireless/mlme.c          |   1 +
 net/wireless/nl80211.c       | 497 ++++++++++++++++++++++++++++++++++++++++++-
 net/wireless/rdev-ops.h      |  57 +++++
 net/wireless/trace.h         |  77 +++++++
 net/wireless/util.c          |   9 +-
 19 files changed, 1126 insertions(+), 11 deletions(-)

-- 
1.9.1

