Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:57112 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140Ab0IHXgO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Sep 2010 19:36:14 -0400
Received: by ywh1 with SMTP id 1so355788ywh.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Sep 2010 16:36:13 -0700 (PDT)
From: Steve deRosier <steve@cozybit.com>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: johannes@sipsolutions.net, javier@cozybit.com,
	Mattia Barbon <mbarbon@cpan.org>,
	Steve deRosier <steve@cozybit.com>
Subject: [PATCH 1/3] libertas_tf: display debugging output only when debugging is enabled.
Date: Wed,  8 Sep 2010 16:35:56 -0700
Message-Id: <1283988958-44928-1-git-send-email-steve@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mattia Barbon <mbarbon@cpan.org>

Signed-off-by: Mattia Barbon <mbarbon@cpan.org>
Signed-off-by: Steve deRosier <steve@cozybit.com>
---
 drivers/net/wireless/libertas_tf/cmd.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/libertas_tf/cmd.c b/drivers/net/wireless/libertas_tf/cmd.c
index 8c15e35..1bca11b 100644
--- a/drivers/net/wireless/libertas_tf/cmd.c
+++ b/drivers/net/wireless/libertas_tf/cmd.c
@@ -741,10 +741,12 @@ int lbtf_process_rx_command(struct lbtf_private *priv)
 	respcmd = le16_to_cpu(resp->command);
 	result = le16_to_cpu(resp->result);
 
+#ifdef CONFIG_LIBERTAS_THINFIRM_DEBUG
 	if (net_ratelimit())
 		pr_info("libertastf: cmd response 0x%04x, seq %d, size %d\n",
 			respcmd, le16_to_cpu(resp->seqnum),
 			le16_to_cpu(resp->size));
+#endif
 
 	if (resp->seqnum != priv->cur_cmd->cmdbuf->seqnum) {
 		spin_unlock_irqrestore(&priv->driver_lock, flags);
-- 
1.7.0

