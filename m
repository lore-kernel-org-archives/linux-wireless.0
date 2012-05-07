Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:25800 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756116Ab2EGKdA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 06:33:00 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	H Hartley Sweeten <hartleys@visionengravers.com>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Samuel Ortiz <sameo@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 17/20] NFC: The NFC genl family structure should not be exposed globally
Date: Mon,  7 May 2012 12:31:28 +0200
Message-Id: <1336386691-24840-18-git-send-email-sameo@linux.intel.com> (sfid-20120507_123304_832319_D4F3508B)
In-Reply-To: <1336386691-24840-1-git-send-email-sameo@linux.intel.com>
References: <1336386691-24840-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: H Hartley Sweeten <hartleys@visionengravers.com>

The variable 'nfc_genl_family' is only referenced in this file and
should be marked static to prevent it from being exposed globally.

Quites the sparse warning:

warning: symbol 'nfc_genl_family' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Cc: Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/netlink.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index 747c6b3..23b75c1 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -33,7 +33,7 @@ static struct genl_multicast_group nfc_genl_event_mcgrp = {
 	.name = NFC_GENL_MCAST_EVENT_NAME,
 };
 
-struct genl_family nfc_genl_family = {
+static struct genl_family nfc_genl_family = {
 	.id = GENL_ID_GENERATE,
 	.hdrsize = 0,
 	.name = NFC_GENL_NAME,
-- 
1.7.9.1

