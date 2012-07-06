Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:42738 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752943Ab2GFT72 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 15:59:28 -0400
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Ilan Elias <ilane@ti.com>, linux-wireless@vger.kernel.org,
	linux-nfc@lists.01.org, Eric Lapuyade <eric.lapuyade@intel.com>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 13/33] NFC: Error management documentation
Date: Fri,  6 Jul 2012 22:09:33 +0200
Message-Id: <1341605393-32056-14-git-send-email-sameo@linux.intel.com> (sfid-20120706_220535_723415_D70A55F6)
In-Reply-To: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
References: <1341605393-32056-1-git-send-email-sameo@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eric Lapuyade <eric.lapuyade@intel.com>

Signed-off-by: Eric Lapuyade <eric.lapuyade@intel.com>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 Documentation/nfc/nfc-hci.txt |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/Documentation/nfc/nfc-hci.txt b/Documentation/nfc/nfc-hci.txt
index 320f933..89a339c 100644
--- a/Documentation/nfc/nfc-hci.txt
+++ b/Documentation/nfc/nfc-hci.txt
@@ -178,3 +178,36 @@ ANY_GET_PARAMETER to the reader A gate to get information on the target
 that was discovered).
 
 Typically, such an event will be propagated to NFC Core from MSGRXWQ context.
+
+Error management
+----------------
+
+Errors that occur synchronously with the execution of an NFC Core request are
+simply returned as the execution result of the request. These are easy.
+
+Errors that occur asynchronously (e.g. in a background protocol handling thread)
+must be reported such that upper layers don't stay ignorant that something
+went wrong below and know that expected events will probably never happen.
+Handling of these errors is done as follows:
+
+- driver (pn544) fails to deliver an incoming frame: it stores the error such
+that any subsequent call to the driver will result in this error. Then it calls
+the standard nfc_shdlc_recv_frame() with a NULL argument to report the problem
+above. shdlc stores a EREMOTEIO sticky status, which will trigger SMW to
+report above in turn.
+
+- SMW is basically a background thread to handle incoming and outgoing shdlc
+frames. This thread will also check the shdlc sticky status and report to HCI
+when it discovers it is not able to run anymore because of an unrecoverable
+error that happened within shdlc or below. If the problem occurs during shdlc
+connection, the error is reported through the connect completion.
+
+- HCI: if an internal HCI error happens (frame is lost), or HCI is reported an
+error from a lower layer, HCI will either complete the currently executing
+command with that error, or notify NFC Core directly if no command is executing.
+
+- NFC Core: when NFC Core is notified of an error from below and polling is
+active, it will send a tag discovered event with an empty tag list to the user
+space to let it know that the poll operation will never be able to detect a tag.
+If polling is not active and the error was sticky, lower levels will return it
+at next invocation.
-- 
1.7.10

