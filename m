Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41557 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400Ab2DSTvJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 15:51:09 -0400
Received: by pbcun15 with SMTP id un15so171148pbc.19
        for <linux-wireless@vger.kernel.org>; Thu, 19 Apr 2012 12:51:09 -0700 (PDT)
From: Stanislav Yakovlev <stas.yakovlev@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, stable@kernel.org,
	Stanislav Yakovlev <stas.yakovlev@gmail.com>
Subject: [PATCH] net/wireless: ipw2200: Fix race condition in the command completion acknowledge
Date: Thu, 19 Apr 2012 15:55:09 -0400
Message-Id: <1334865310-4662-1-git-send-email-stas.yakovlev@gmail.com> (sfid-20120419_215114_586779_A74B1115)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Driver incorrectly validates command completion: instead of waiting
for a command to be acknowledged it continues execution.  Most of the
time driver gets acknowledge of the command completion in a tasklet
before it executes the next one. But sometimes it sends the next
command before it gets acknowledge for the previous one. In such a
case one of the following error messages appear in the log:

Failed to send SYSTEM_CONFIG: Already sending a command.
Failed to send ASSOCIATE: Already sending a command.
Failed to send TX_POWER: Already sending a command.

After that you need to reload the driver to get it working again.

This bug occurs during roammaping (reported by Sam Varshavchik)
https://bugzilla.redhat.com/show_bug.cgi?id=738508
and machine booting (reported by Tom Gundersen and Mads Kiilerich)
https://bugs.archlinux.org/task/28097
https://bugzilla.redhat.com/show_bug.cgi?id=802106

This patch doesn't fix the delay issue during firmware load.
But at least device now works as usual after boot.

Cc: stable@kernel.org
Signed-off-by: Stanislav Yakovlev <stas.yakovlev@gmail.com>
---
 drivers/net/wireless/ipw2x00/ipw2200.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
index 4130802..8cbafa5 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -2192,6 +2192,7 @@ static int __ipw_send_cmd(struct ipw_priv *priv, struct host_cmd *cmd)
 {
 	int rc = 0;
 	unsigned long flags;
+	unsigned long now, end;
 
 	spin_lock_irqsave(&priv->lock, flags);
 	if (priv->status & STATUS_HCMD_ACTIVE) {
@@ -2233,10 +2234,20 @@ static int __ipw_send_cmd(struct ipw_priv *priv, struct host_cmd *cmd)
 	}
 	spin_unlock_irqrestore(&priv->lock, flags);
 
+	now = jiffies;
+	end = now + HOST_COMPLETE_TIMEOUT;
+again:
 	rc = wait_event_interruptible_timeout(priv->wait_command_queue,
 					      !(priv->
 						status & STATUS_HCMD_ACTIVE),
-					      HOST_COMPLETE_TIMEOUT);
+					      end - now);
+	if (rc < 0) {
+		now = jiffies;
+		if (time_before(now, end))
+			goto again;
+		rc = 0;
+	}
+
 	if (rc == 0) {
 		spin_lock_irqsave(&priv->lock, flags);
 		if (priv->status & STATUS_HCMD_ACTIVE) {
-- 
1.7.2.5

