Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:20336 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756151Ab0CJDyP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Mar 2010 22:54:15 -0500
Subject: [PATCH 2/2] compat-wireless: disable wl12xx if crc7 is not available
To: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
From: Pavel Roskin <proski@gnu.org>
Date: Tue, 09 Mar 2010 22:54:14 -0500
Message-ID: <20100310035414.28564.10870.stgit@mj.roinet.com>
In-Reply-To: <20100310035408.28564.65912.stgit@mj.roinet.com>
References: <20100310035408.28564.65912.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 config.mk |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/config.mk b/config.mk
index e5be3fd..990eac6 100644
--- a/config.mk
+++ b/config.mk
@@ -447,9 +447,11 @@ CONFIG_P54_LEDS=y
 CONFIG_ATH_COMMON=m
 # CONFIG_ATH_DEBUG=y
 
+ifneq ($(CONFIG_CRC7),)
 CONFIG_WL12XX=y
 CONFIG_WL1251=m
 CONFIG_WL1271=m
+endif
 
 ifdef CONFIG_COMPAT_KERNEL_27
 CONFIG_LIBERTAS=n
