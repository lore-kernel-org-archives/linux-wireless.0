Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:30957 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756962Ab1LNPig (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 10:38:36 -0500
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 4/8] NFC: Atomic socket allocation
Date: Wed, 14 Dec 2011 16:43:08 +0100
Message-Id: <1323877392-20567-5-git-send-email-sameo@linux.intel.com> (sfid-20111214_163838_393881_19A07E3B)
In-Reply-To: <1323877392-20567-1-git-send-email-sameo@linux.intel.com>
References: <1323877392-20567-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rawsock_create() is called with preemption disabled, so we should not
sleep.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 net/nfc/rawsock.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/nfc/rawsock.c b/net/nfc/rawsock.c
index 11ac0a1..2e2f8c6 100644
--- a/net/nfc/rawsock.c
+++ b/net/nfc/rawsock.c
@@ -310,7 +310,7 @@ static int rawsock_create(struct net *net, struct socket *sock,
 
 	sock->ops = &rawsock_ops;
 
-	sk = sk_alloc(net, PF_NFC, GFP_KERNEL, nfc_proto->proto);
+	sk = sk_alloc(net, PF_NFC, GFP_ATOMIC, nfc_proto->proto);
 	if (!sk)
 		return -ENOMEM;
 
-- 
1.7.7.3

