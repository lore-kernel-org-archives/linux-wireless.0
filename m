Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.platinumzone24.at ([88.198.159.93]:41552 "EHLO
	mail.platinumzone24.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815Ab1A3TKu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 14:10:50 -0500
Message-ID: <4D45B7B2.40001@davizone.at>
Date: Sun, 30 Jan 2011 20:10:42 +0100
From: David Gnedt <david.gnedt@davizone.at>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, Kalle Valo <kvalo@adurom.com>,
	Grazvydas Ignotas <notasas@gmail.com>,
	Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Subject: [PATCH 00/18] wl1251: feature ports / monitor mode / packet injection
References: <4D45A583.3060605@davizone.at>
In-Reply-To: <4D45A583.3060605@davizone.at>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patch 01-03 fix some bugs.
Patch 04-09 contain some feature ports from Maemo Fremantle and wl1271.
Patch 10-18 implement (mainly) monitor mode and packet injection.

Sorry for the partly broken patches, I thought I configured my client the
right way. I tried to stop the mails at my mailserver, but it was mostly
already too late.

David Gnedt (18):
  wl1251: fix queue stopping/waking for TX path
  wl1251: fix 4-byte TX buffer alignment
  wl1251: fix scan behaviour while not associated
  wl1251: add sysfs interface for bluetooth coexistence mode
    configuration
  wl1251: retry power save entry
  wl1251: enable beacon early termination while in power-saving mode
  wl1251: implement connection quality monitoring
  wl1251: implement hardware ARP filtering
  wl1251: enable adhoc mode
  wl1251: split RX and TX data path initialisation
  wl1251: configure hardware en-/decryption for monitor mode
  wl1251: set rate index and preamble flag on received packets
  wl1251: rework configure_filter() callback
  wl1251: implement multicast address filtering
  wl1251: disable power saving in monitor mode
  wl1251: fix channel switching in monitor mode
  wl1251: enable tx path in monitor mode if necessary for packet
    injection
  wl1251: disable retry and ACK policy for injected packets

 drivers/net/wireless/wl1251/acx.c    |  150 ++++++++++++++--
 drivers/net/wireless/wl1251/acx.h    |  106 ++++++++++-
 drivers/net/wireless/wl1251/boot.c   |    3 +-
 drivers/net/wireless/wl1251/cmd.c    |   58 ++++--
 drivers/net/wireless/wl1251/cmd.h    |    8 +-
 drivers/net/wireless/wl1251/event.c  |   62 ++++++
 drivers/net/wireless/wl1251/event.h  |    7 +
 drivers/net/wireless/wl1251/init.c   |   19 +-
 drivers/net/wireless/wl1251/main.c   |  348 ++++++++++++++++++++++++++++------
 drivers/net/wireless/wl1251/ps.c     |   11 +
 drivers/net/wireless/wl1251/rx.c     |   48 +++++-
 drivers/net/wireless/wl1251/tx.c     |  101 ++++++----
 drivers/net/wireless/wl1251/wl1251.h |   26 ++-
 13 files changed, 795 insertions(+), 152 deletions(-)


