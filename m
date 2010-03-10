Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:20336 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756151Ab0CJDyJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Mar 2010 22:54:09 -0500
Subject: [PATCH 1/2] compat-wireless: disable rt2800 if crc_ccitt is not
 available
To: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
From: Pavel Roskin <proski@gnu.org>
Date: Tue, 09 Mar 2010 22:54:08 -0500
Message-ID: <20100310035408.28564.65912.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 config.mk |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/config.mk b/config.mk
index 5565e12..e5be3fd 100644
--- a/config.mk
+++ b/config.mk
@@ -281,8 +281,10 @@ CONFIG_ADM8211=m
 CONFIG_RT2X00_LIB_PCI=m
 CONFIG_RT2400PCI=m
 CONFIG_RT2500PCI=m
+ifneq ($(CONFIG_CRC_CCITT),)
 CONFIG_RT2800PCI=m
 CONFIG_RT2800PCI_PCI=y
+endif
 NEED_RT2X00=y
 
 # Two rt2x00 drivers require firmware: rt61pci and rt73usb. They depend on
@@ -358,7 +360,9 @@ endif
 
 # RT2500USB does not require firmware
 CONFIG_RT2500USB=m
+ifneq ($(CONFIG_CRC_CCITT),)
 CONFIG_RT2800USB=m
+endif
 CONFIG_RT2X00_LIB_USB=m
 NEED_RT2X00=y
 # RT73USB requires firmware
