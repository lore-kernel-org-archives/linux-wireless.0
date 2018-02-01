Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:37336 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754559AbeBABE1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Jan 2018 20:04:27 -0500
Received: by mail-pg0-f66.google.com with SMTP id z17so11541933pgc.4
        for <linux-wireless@vger.kernel.org>; Wed, 31 Jan 2018 17:04:27 -0800 (PST)
From: Denis Kenzior <denkenz@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Denis Kenzior <denkenz@gmail.com>
Subject: [RFC v4 0/6] EAPoL over NL80211
Date: Wed, 31 Jan 2018 19:04:14 -0600
Message-Id: <20180201010420.6102-1-denkenz@gmail.com> (sfid-20180201_020431_965728_8614E9A2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset adds support for running 802.11 authentication mechanisms (e.g.
802.1X, 4-Way Handshake, etc) over NL80211 instead of putting them onto the
network device.  This has the advantage of fixing several long-standing race
conditions that result from userspace operating on multiple transports in order
to manage a 802.11 connection (e.g. NL80211 and wireless netdev, wlan0, etc).

For example, userspace would sometimes see 4-Way handshake packets before
NL80211 signaled that the connection has been established.  Leading to ugly
hacks or having the STA wait for retransmissions from the AP.

This also provides a way to mitigate a particularly nasty race condition where
the encryption key could be set prior to the 4-way handshake packet 4/4 being
sent.  This would result in the packet being sent encrypted and discarded by
the peer.  The mitigation strategy for this race is for userspace to explicitly
tell the kernel that a particular EAPoL packet should not be encrypted.

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
netlink via the NL80211_CMD_CONTROL_PORT_FRAME notification.
NL80211_ATTR_CONTROL_PORT_ETHERTYPE and NL80211_ATTR_MAC are included to
specify the control port frame protocol and source address respectively.  If
the control port frame was received unencrypted then
NL80211_ATTR_CONTROL_PORT_NO_ENCRYPT flag is also included.  NL80211_ATTR_FRAME
attribute contains the raw control port frame with all transport layer headers
stripped (e.g. this would be the raw EAPoL frame).

Userspace can reply to control port frames either via legacy methods (by sending
frames to the network device) or via NL80211_CMD_CONTROL_PORT_FRAME request.
Userspace would included NL80211_ATTR_FRAME with the raw control port frame as
well as NL80211_Attr_MAC and NL80211_ATTR_CONTROL_PORT_ETHERTYPE attributes to
specify the destination address and protocol respectively.  This allows
Pre-Authentication (protocol 0x88c7) frames to be sent via this mechanism as
well.  Finally, NL80211_ATTR_CONTROL_PORT_NO_ENCRYPT flag can be included to
tell the driver to send the frame unencrypted, e.g. for 4-Way handshake 4/4
frames.

The proposed patchset has been tested in a mac80211_hwsim based environment with
hostapd and iwd.

ChangeLog

v4

- Reordered the patches to make sure that: when CONTROL_PORT_OVER_NL80211 is
provided by userspace, nl80211 checks that both EXT_FEATURE bit is set and
the tx_control_port is present in rdev ops.
- Fixed up various issues Johannes found in his review

v3

- Added ETH_P_PREAUTH to if_ether.h
- Moved NL80211 feature bit from wiphy features to ext features
- Addressed various comments from Johannes

v2

- Added WIPHY_FLAG_CONTROL_PORT_OVER_NL80211 flag.  This is a capability flag
used by the drivers, e.g. that the driver supports control port over nl80211
capability.  This capability is now checked when CONTROL_PORT_OVER_NL80211 is
requested.

- mac80211 rx path now forwards Pre-Authentication frames over NL80211 as well,
if requested.  Tweaked the signature of cfg80211_rx_control_port.

- TX path reworked completely.  tx_control_port method has been introduced to
cfg80211_ops.  An implementation of tx_control_port for mac80211 was added.

Denis Kenzior (6):
  uapi: Add 802.11 Preauthentication to if_ether
  nl80211: Add CMD_CONTROL_PORT_FRAME API
  nl80211: Implement TX of control port frames
  nl80211: Add CONTROL_PORT_OVER_NL80211 attribute
  mac80211: Add support for tx_control_port
  mac80211: Send control port frames over nl80211

 include/net/cfg80211.h        |  34 +++++++++++
 include/uapi/linux/if_ether.h |   1 +
 include/uapi/linux/nl80211.h  |  30 +++++++++-
 net/mac80211/cfg.c            |   3 +
 net/mac80211/ieee80211_i.h    |   4 ++
 net/mac80211/main.c           |   2 +
 net/mac80211/mlme.c           |   2 +
 net/mac80211/rx.c             |  33 +++++++++--
 net/mac80211/tx.c             |  46 +++++++++++++++
 net/wireless/nl80211.c        | 134 +++++++++++++++++++++++++++++++++++++++++-
 net/wireless/rdev-ops.h       |  15 +++++
 net/wireless/trace.h          |  47 +++++++++++++++
 12 files changed, 344 insertions(+), 7 deletions(-)

-- 
2.13.5
