Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:35163 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932206AbdL1R6h (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Dec 2017 12:58:37 -0500
Received: by mail-io0-f195.google.com with SMTP id 14so32530063iou.2
        for <linux-wireless@vger.kernel.org>; Thu, 28 Dec 2017 09:58:37 -0800 (PST)
From: Denis Kenzior <denkenz@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Denis Kenzior <denkenz@gmail.com>
Subject: [RFC 0/4] EAPoL over NL80211
Date: Thu, 28 Dec 2017 11:58:28 -0600
Message-Id: <20171228175832.3253-1-denkenz@gmail.com> (sfid-20171228_185852_022852_F81E95C1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset adds support for running 802.11 authentication mechanisms (e.g.
802.1X, 4-Way Handshake, etc) over NL80211 instead of putting them onto the
network device.  This has the advantage of fixing several long-standing race
conditions that result from userspace operating on multiple transports in order
to manage a 802.11 connection (e.g. NL80211 and wireless netdev, wlan0, etc)

For example, userspace would sometimes see 4-Way handshake packets before
NL80211 signaled that the connection has been established.  Leading to ugly
hacks or having the STA wait for retransmissions from the AP.

To make this possible this patchset introduces a new NL80211 command and several
new attributes.  A userspace that is capable of processing EAPoL packets over
NL80211 includes a new NL80211_ATTR_CONTROL_PORT_OVER_NL80211 attribute in its
NL80211_CMD_ASSOCIATE or NL80211_CMD_CONNECT requests being sent to the kernel.
The previously added NL80211_ATTR_SOCKET_OWNER attribute must also be included.
The latter is used by the kernel to send NL80211_CMD_CONTROL_PORT_FRAME
notifications back to userspace via a netlink unicast.  If the
NL80211_ATTR_CONTROL_PORT_OVER_NL80211 attribute is not specified, then legacy
behavior is kept and control port packets continue to flow over the network
interface.

If control port over nl80211 transport is requested, then control port packets
are intercepted just prior to being handed to the network device and sent over
netlink via the NL80211_CMD_CONTROL_PORT_FRAME notification.  NL80211_ATTR_CONTROL_PORT_ETHERTYPE and NL80211_ATTR_MAC are included to specify the control port
frame protocol and source address respectively.  If the control port frame was
received unencrypted then NL80211_ATTR_CONTROL_PORT_NO_ENCRYPT flag is also
included.  NL80211_ATTR_FRAME attribute contains the raw control port frame with
all transport layer headers stripped (e.g. this would be the raw EAPoL frame).

Userspace can reply to control port frames either via legacy methods (by sending
frames to the network device) or via NL80211_CMD_CONTROL_PORT_FRAME request.
Userspace would included NL80211_ATTR_FRAME with the raw control port frame.

Open Questions
==============

1. It is not clear whether all drivers provide information as to whether the
control port frame was sent encrypted or not.  Do they?

2. It has been previously suggested that CMD_FRAME infrastructure is used to
accomplish control port over nl80211 transport.  However, it did not seem to be
a good fit as the relevant code paths assume that only management frames are
to be sent via this mechanism.  Thoughts?

3. I'm not sure that the TX implementation is the right way to go.  It has been
suggested before that userspace should be able to specify whether a given
control port frame should be encrypted or not.  The current implementation would
still try to honor the global CONTROL_PORT_NO_ENCRYPT flag but I didn't find a
good way to specify this for individual frames.  Ideas?

4. It would be nice to extend this functionaly for Pre-Authentiation frames
(protocol 0x88c7) as well so that userspace does not have to deal with these
using a different transport.

The proposed patchset has been tested in a mac80211_hwsim based environment with
hostapd and iwd.

Denis Kenzior (4):
  nl80211: Add CONTROL_PORT_OVER_NL80211 attribute
  nl80211: Add CMD_CONTROL_PORT_FRAME API
  mac80211: Send control port frames over nl80211
  nl80211: Implement TX of control port frames

 include/net/cfg80211.h       |  18 ++++++
 include/uapi/linux/nl80211.h |  29 ++++++++-
 net/mac80211/cfg.c           |   2 +
 net/mac80211/ieee80211_i.h   |   1 +
 net/mac80211/mlme.c          |   2 +
 net/mac80211/rx.c            |  32 +++++++++-
 net/wireless/nl80211.c       | 139 ++++++++++++++++++++++++++++++++++++++++++-
 net/wireless/trace.h         |  15 +++++
 8 files changed, 233 insertions(+), 5 deletions(-)

-- 
2.13.5
