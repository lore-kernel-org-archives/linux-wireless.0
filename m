Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:33781 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753011AbdFOSZb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Jun 2017 14:25:31 -0400
From: Mark Greer <mgreer@animalcreek.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
        Mark Greer <mgreer@animalcreek.com>
Subject: [PATCH 11/23] adapter: Do not poll when there is an active tag
Date: Thu, 15 Jun 2017 11:25:04 -0700
Message-Id: <20170615182516.4508-12-mgreer@animalcreek.com> (sfid-20170615_202545_304365_5DDF34D4)
In-Reply-To: <20170615182516.4508-1-mgreer@animalcreek.com>
References: <20170615182516.4508-1-mgreer@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When there is an active tag and a request to start polling is
received by neard, it will discard the currently registered tag
and requests that the kernel start another poll.  The kernel receives
this request and returns EBUSY because there is already an active tag.
neard receives this failure and reports it to the poll requestor.
At this point, the tag is active but neard no longer has any knowledge
of it.  Fix this by returning EBUSY when there is an active tag and
a new poll request is received.

Signed-off-by: Mark Greer <mgreer@animalcreek.com>
---
 src/adapter.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/adapter.c b/src/adapter.c
index eb1a407..9e3e75e 100644
--- a/src/adapter.c
+++ b/src/adapter.c
@@ -358,6 +358,9 @@ static DBusMessage *start_poll_loop(DBusConnection *conn,
 		return __near_error_failed(msg, ENODEV);
 	}
 
+	if (g_hash_table_size(adapter->tags) > 0)
+		return __near_error_failed(msg, EBUSY);
+
 	dbus_message_get_args(msg, NULL, DBUS_TYPE_STRING, &dbus_mode,
 							DBUS_TYPE_INVALID);
 
-- 
2.13.0
