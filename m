Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3382 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056Ab2EGKvz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 06:51:55 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "Rob Landley" <rob@landley.net>
cc: linux-doc@vger.kernel.org, "Arend van Spriel" <arend@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	"Gustavo Padovan" <gustavo@padovan.org>,
	linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [PATCH] Documentation: CodingStyle: add alignment rule for
 breaking statements
Date: Mon, 7 May 2012 12:51:32 +0200
Message-ID: <1336387892-3730-1-git-send-email-arend@broadcom.com> (sfid-20120507_125201_844516_8C44E4E3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The coding style document does cover breaking lines that are hitting
the 80 column boundary. However, how to format the portions is not
in the document. The submitted patches mostly align them on the same
column so that seems the consensus on it and in recent thread [1] this
lead to push-back on patches by David Miller. As the script checkpatch
already validate patches against this alignment rule it seems time to
add the rule to the coding style so people can not use the argument
that it is not there.

[1] http://article.gmane.org/gmane.linux.bluez.kernel/24759

Cc: David S. Miller <davem@davemloft.net>
Cc: Gustavo Padovan <gustavo@padovan.org>
Cc: linux-bluetooth@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 Documentation/CodingStyle |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
index c58b236..bfb9008 100644
--- a/Documentation/CodingStyle
+++ b/Documentation/CodingStyle
@@ -87,6 +87,18 @@ are placed substantially to the right. The same applies to function headers
 with a long argument list. However, never break user-visible strings such as
 printk messages, because that breaks the ability to grep for them.
 
+When breaking statements you should align the sensible chunks to the same
+column. This may involve adding a couple of spaces behind the tabs of the
+next line(s), eg.:
+
+static inline const struct device *chunk_device(struct device *parent,
+						bool sensible_device_chunks)
+{
+	if (parent)
+		if (somewhat_lengthy_global_logical_condition &&
+		    sensible_device_chunks)
+			perform_the_jobs(parent);
+}
 
 		Chapter 3: Placing Braces and Spaces
 
-- 
1.7.9.5


