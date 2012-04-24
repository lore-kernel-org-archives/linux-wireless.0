Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:63306 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754186Ab2DXNQu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Apr 2012 09:16:50 -0400
From: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>
To: linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [RFCv2 0/6] Draft Software/Virtual AMP80211
Date: Tue, 24 Apr 2012 16:17:34 +0300
Message-Id: <1335273460-12682-1-git-send-email-Andrei.Emeltchenko.news@gmail.com> (sfid-20120424_151656_263496_E844E5D8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Emeltchenko <andrei.emeltchenko@intel.com>

RFC for Software / Virtual _DRAFT_ implementation of Bluetooth High Speed
by using wireless driver. Currently it can be used for testing Bluetooth
A2MP protocol.

Changes:
	RFCv2: Process basic HCI commands and basic data traffic; added skeleton
	for Netlink comms, took comments from reviewers.
	RFCv1: Initial release.

TODO:
	Change names from vamp to <softamp|bt_softamp|etc>

Main ideas:
 - Use existing wireless infrastructure nl80211, mac80211.
 - Use virtual interface of type NL80211_IFTYPE_BLUETOOTH_AMP. Then all
drivers supporting virtual interface should work.

After modifying iw it will be enabled by adding new virtual interface.

# iw phy <physical device> interface add vamp type vamp
# iw dev
phy#0
	Interface vamp
		ifindex 6
		type Virtual AMP
...
# hciconfig 
hci1:	Type: AMP  Bus: VIRTUAL
	BD Address: 00:00:00:00:00:00  ACL MTU: 0:0  SCO MTU: 0:0
	DOWN 
	RX bytes:0 acl:0 sco:0 events:0 errors:0
	TX bytes:0 acl:0 sco:0 commands:0 errors:0
...

Andrei Emeltchenko (6):
  mac80211: softamp: Adds Bluetooth Software AMP
  mac80211: softamp: Adds build config option
  hwsim: Adds support for BT SOFTAMP for testing
  mac80211: softamp: Handle assoc request
  mac80211: softamp: Netlink interface to softamp
  mac80211: softamp: Handle data traffic

 drivers/net/wireless/mac80211_hwsim.c |    3 +-
 include/linux/ieee80211.h             |   13 +
 include/linux/nl80211.h               |    1 +
 net/mac80211/Kconfig                  |    9 +
 net/mac80211/Makefile                 |    2 +
 net/mac80211/ieee80211_i.h            |    5 +
 net/mac80211/iface.c                  |    9 +
 net/mac80211/rx.c                     |    4 +
 net/mac80211/sta_info.h               |    4 +
 net/mac80211/util.c                   |    1 +
 net/mac80211/virtual_amp.c            |  675 +++++++++++++++++++++++++++++++++
 net/mac80211/virtual_amp.h            |   96 +++++
 12 files changed, 821 insertions(+), 1 deletion(-)
 create mode 100644 net/mac80211/virtual_amp.c
 create mode 100644 net/mac80211/virtual_amp.h

-- 
1.7.9.5

