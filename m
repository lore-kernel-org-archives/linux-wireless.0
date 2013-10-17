Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50273 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756035Ab3JQNfk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 09:35:40 -0400
Date: Thu, 17 Oct 2013 15:32:13 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Pedro Francisco <pedrogfrancisco@gmail.com>
Cc: Tino Keitel <tino.keitel@tikei.de>,
	ML linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Power saving features for iwl4965
Message-ID: <20131017133210.GB1723@redhat.com> (sfid-20131017_153555_591250_5867438B)
References: <CAJZjf_zOF=qGEE=pWDRe0YDpAYophm93cVM8pfuL0sTRGq56EA@mail.gmail.com>
 <20130614131829.GA5125@redhat.com>
 <20130625142514.GA1938@redhat.com>
 <CAJZjf_z=+QW_Y3yuz6nJ+muVA_6bGRut8EQ7fCopDqqj2Fn9Yw@mail.gmail.com>
 <20130716102743.GA8321@redhat.com>
 <CAJZjf_y9fnkHLp4YPdYY2sVo4r4+hKJcZAebJmjVKCBh-0EUtA@mail.gmail.com>
 <20130731120848.GA31732@redhat.com>
 <CAJZjf_zA+GyL9Wu3rKaNpU6Sn6_zO+Ng6T2S4Y=Y4rJjzA6RiQ@mail.gmail.com>
 <CAJZjf_x3xwMijn5Jjc0qAaFdzq-4sH-gtm+hv5jKVpFCSBu0=Q@mail.gmail.com>
 <20131017090654.GA21496@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ibTvN161/egqYuK8"
In-Reply-To: <20131017090654.GA21496@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 17, 2013 at 11:06:55AM +0200, Stanislaw Gruszka wrote:
> Sorry for late answer. I have two more patches, which perhaps make
> powersave stop crashing on 3945. Please test them (note that I only
> compile tested, be carefull :-)

First patch has a bug. I'm attaching improved version.

Stanislaw

--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-iwlegacy-poke-device-when-waiting-for-hcmd.patch"

>From dae9f167853f266d5efe688f965968725375e2ae Mon Sep 17 00:00:00 2001
From: Stanislaw Gruszka <sgruszka@redhat.com>
Date: Thu, 17 Oct 2013 15:30:07 +0200
Subject: [PATCH] iwlegacy poke device when waiting for hcmd

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/common.c | 29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index b03e22e..3d8dae3c 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -254,8 +254,6 @@ il_get_cmd_string(u8 cmd)
 }
 EXPORT_SYMBOL(il_get_cmd_string);
 
-#define HOST_COMPLETE_TIMEOUT (HZ / 2)
-
 static void
 il_generic_cmd_callback(struct il_priv *il, struct il_device_cmd *cmd,
 			struct il_rx_pkt *pkt)
@@ -305,11 +303,15 @@ il_send_cmd_async(struct il_priv *il, struct il_host_cmd *cmd)
 	return 0;
 }
 
+#define HOST_COMPLETE_TIMEOUT (HZ / 2)
+#define COMMAND_POKE_TIMEOUT  (HZ / 10)
+
 int
 il_send_cmd_sync(struct il_priv *il, struct il_host_cmd *cmd)
 {
-	int cmd_idx;
-	int ret;
+	unsigned long flags;
+	int cmd_idx, ret;
+	int timeout = HOST_COMPLETE_TIMEOUT;
 
 	lockdep_assert_held(&il->mutex);
 
@@ -333,9 +335,22 @@ il_send_cmd_sync(struct il_priv *il, struct il_host_cmd *cmd)
 		goto out;
 	}
 
-	ret = wait_event_timeout(il->wait_command_queue,
-				 !test_bit(S_HCMD_ACTIVE, &il->status),
-				 HOST_COMPLETE_TIMEOUT);
+	while (timeout > 0) {
+		ret = wait_event_timeout(il->wait_command_queue,
+					 !test_bit(S_HCMD_ACTIVE, &il->status),
+					 COMMAND_POKE_TIMEOUT);
+		if (ret)
+			break;
+
+		/* Poke the device, it may have lost the command. */
+		spin_lock_irqsave(&il->reg_lock, flags);
+		_il_grab_nic_access(il);
+		_il_release_nic_access(il);
+		spin_unlock_irqrestore(&il->reg_lock, flags);
+
+		timeout -= COMMAND_POKE_TIMEOUT;
+	}
+
 	if (!ret) {
 		if (test_bit(S_HCMD_ACTIVE, &il->status)) {
 			IL_ERR("Error sending %s: time out after %dms.\n",
-- 
1.8.3.1


--ibTvN161/egqYuK8--
