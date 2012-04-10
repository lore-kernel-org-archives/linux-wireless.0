Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:46978 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754688Ab2DJMLN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2012 08:11:13 -0400
From: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>
To: linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [RFCv1] Draft Software/Virtual AMP80211
Date: Tue, 10 Apr 2012 15:11:48 +0300
Message-Id: <1334059909-20513-1-git-send-email-Andrei.Emeltchenko.news@gmail.com> (sfid-20120410_141119_714069_FCEFE186)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Emeltchenko <andrei.emeltchenko@intel.com>

RFC for Software / Virtual _DRAFT_ implementation of Bluetooth High Speed
by using wireless driver.

Currently it can be used for testing Bluetooth A2MP protocol.

Please comment is this right way of implementing things like: using virtual
interface to enable AMP. Shall I use module instead? Shall I put files to
mac80211 or use other location? Is name "vamp" OK? Other variants are:
softamp, soft_amp, soft_amp80211, etc.

Main ideas:
 - Use existing wireless infrastructure nl80211, mac80211.
 - Use virtual interface of type NL80211_IFTYPE_VIRTUAL_AMP80211. Then all
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


Andrei Emeltchenko (1):
  mac80211: Adds Software / Virtual AMP 80211

 drivers/net/wireless/mac80211_hwsim.c |    3 +-
 include/linux/nl80211.h               |    1 +
 net/mac80211/Kconfig                  |    8 ++
 net/mac80211/Makefile                 |    2 +
 net/mac80211/ieee80211_i.h            |    4 +
 net/mac80211/iface.c                  |   25 ++++
 net/mac80211/util.c                   |    1 +
 net/mac80211/virtual_amp.c            |  205 +++++++++++++++++++++++++++++++++
 net/mac80211/virtual_amp.h            |   29 +++++
 9 files changed, 277 insertions(+), 1 deletions(-)
 create mode 100644 net/mac80211/virtual_amp.c
 create mode 100644 net/mac80211/virtual_amp.h

-- 
1.7.9.1

