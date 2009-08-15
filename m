Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:53011 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750824AbZHOFqr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Aug 2009 01:46:47 -0400
Message-ID: <4A864BB1.8020307@redfish-solutions.com>
Date: Fri, 14 Aug 2009 22:46:25 -0700
From: "Philip A. Prindeville" <philipp@redfish-solutions.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Pavel Roskin <proski@gnu.org>
Subject: [PATCH] Don't build PCMCIA modules when PCMCIA isn't present
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Philip A Prindeville <philipp@redfish-solutions.com>

If you're building for a platform that has (for example) no PCMCIA/
Cardbus, then having a single knob to turn to disable this is a
major win.  Especially if more devices get add later that are
PCMCIA-based.

Tested.

Signed-off-by: Philip A Prindeville <philipp@redfish-solutions.com>
---
 config.mk |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/config.mk b/config.mk
index 0c3ea98..a24b7bd 100644
--- a/config.mk
+++ b/config.mk
@@ -191,7 +191,9 @@ CONFIG_B43=m
 CONFIG_B43_HWRNG=y
 CONFIG_B43_PCI_AUTOSELECT=y
 CONFIG_B43_PCICORE_AUTOSELECT=y
+ifneq ($(CONFIG_PCMCIA),)
 CONFIG_B43_PCMCIA=y
+endif
 CONFIG_B43_PIO=y
 CONFIG_B43_LEDS=y
 CONFIG_B43_RFKILL=y
@@ -242,8 +244,10 @@ CONFIG_SSB_BLOCKIO=y
 CONFIG_SSB_PCIHOST_POSSIBLE=y
 CONFIG_SSB_PCIHOST=y
 CONFIG_SSB_B43_PCI_BRIDGE=y
+ifneq ($(CONFIG_PCMCIA),)
 CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
 CONFIG_SSB_PCMCIAHOST=y
+endif
 # CONFIG_SSB_DEBUG=y
 CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
 CONFIG_SSB_DRIVER_PCICORE=y
@@ -258,7 +262,9 @@ CONFIG_B44_PCI=y
 CONFIG_RTL8180=m
 
 CONFIG_ADM8211=m
+ifneq ($(CONFIG_PCMCIA),)
 CONFIG_PCMCIA_ATMEL=m
+endif
 
 CONFIG_RT2X00_LIB_PCI=m
 CONFIG_RT2400PCI=m

