Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42084 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792AbbIQOd0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2015 10:33:26 -0400
From: andrei.otcheretianski@intel.com
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Subject: [RFC 0/7] cfg80211 / mac80211: add support for Neighbor Awareness Networking
Date: Thu, 17 Sep 2015 17:32:24 +0300
Message-Id: <1442500351-8780-1-git-send-email-andrei.otcheretianski@intel.com> (sfid-20150917_163353_272009_C86445FD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

RFC Disclaimer:
---------------

This set of patches is supposed to provide a basic NAN skeleton
for mac80211/cfg80211 implementation and define nl80211 API.
We're still working on our driver implementation, so don't expect these
patches to be merged until we're ready with that; we'll repost these
changes at that time.
If anyone is working on their own driver implementation for upstream,
then please review and use these API definitions. If that driver is ready
before ours, feel free to repost these patches for inclusion with the
driver changes.
There are still some opens in current implementation. For example,
all further availability related stuff is missing, since it is still
not clear how it is supposed to be used.
Of course, comments and discussions are welcome :)
---------------

This patch series add support for a new WiFi feature called
Neighbor Awareness Networking a.k.a. NAN.
It is built from the following layers:
 * Time synchronization
 * Discovery Engine (DE)

Time synchronization (MAC Layer):
---------------------

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

Andrei Otcheretianski (2):
  [RFC] mac80211: Implement add_nan_func and rm_nan_func
  [RFC] mac80211: implement nan_change_conf

Emmanuel Grumbach (5):
  [RFC] cfg80211: add start / stop NAN commands
  [RFC] mac80211: add boilerplate code for start / stop NAN
  [RFC] cfg80211: add add_nan_func / rm_nan_func
  [RFC] cfg80211: allow the user space to change current NAN
    configuration
  [RFC] cfg80211: provide a function to report a match for NAN

 include/net/cfg80211.h       | 138 ++++++++++-
 include/net/mac80211.h       |  26 ++-
 include/uapi/linux/nl80211.h | 208 +++++++++++++++++
 net/mac80211/cfg.c           |  86 +++++++
 net/mac80211/chan.c          |   6 +
 net/mac80211/driver-ops.h    |  81 ++++++-
 net/mac80211/iface.c         |  12 +-
 net/mac80211/main.c          |   4 +
 net/mac80211/offchannel.c    |   3 +-
 net/mac80211/rx.c            |   3 +
 net/mac80211/trace.h         | 137 +++++++++++
 net/mac80211/util.c          |   4 +-
 net/wireless/chan.c          |   2 +
 net/wireless/core.c          |  36 +++
 net/wireless/core.h          |   3 +
 net/wireless/mlme.c          |   1 +
 net/wireless/nl80211.c       | 534 ++++++++++++++++++++++++++++++++++++++++++-
 net/wireless/rdev-ops.h      |  59 +++++
 net/wireless/trace.h         |  89 ++++++++
 net/wireless/util.c          |   9 +-
 20 files changed, 1429 insertions(+), 12 deletions(-)

-- 
1.8.3

