Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11214 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752783Ab3JQJJD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 05:09:03 -0400
Date: Thu, 17 Oct 2013 11:06:55 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Pedro Francisco <pedrogfrancisco@gmail.com>
Cc: Tino Keitel <tino.keitel@tikei.de>,
	ML linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Power saving features for iwl4965
Message-ID: <20131017090654.GA21496@redhat.com> (sfid-20131017_110909_465339_C4273EE8)
References: <20130611161924.GB1696@redhat.com>
 <CAJZjf_zOF=qGEE=pWDRe0YDpAYophm93cVM8pfuL0sTRGq56EA@mail.gmail.com>
 <20130614131829.GA5125@redhat.com>
 <20130625142514.GA1938@redhat.com>
 <CAJZjf_z=+QW_Y3yuz6nJ+muVA_6bGRut8EQ7fCopDqqj2Fn9Yw@mail.gmail.com>
 <20130716102743.GA8321@redhat.com>
 <CAJZjf_y9fnkHLp4YPdYY2sVo4r4+hKJcZAebJmjVKCBh-0EUtA@mail.gmail.com>
 <20130731120848.GA31732@redhat.com>
 <CAJZjf_zA+GyL9Wu3rKaNpU6Sn6_zO+Ng6T2S4Y=Y4rJjzA6RiQ@mail.gmail.com>
 <CAJZjf_x3xwMijn5Jjc0qAaFdzq-4sH-gtm+hv5jKVpFCSBu0=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="envbJBWh7q8WU6mo"
In-Reply-To: <CAJZjf_x3xwMijn5Jjc0qAaFdzq-4sH-gtm+hv5jKVpFCSBu0=Q@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Aug 04, 2013 at 03:53:14PM +0100, Pedro Francisco wrote:
> On Sun, Aug 4, 2013 at 3:24 PM, Pedro Francisco
> <pedrogfrancisco@gmail.com> wrote:
> > On Wed, Jul 31, 2013 at 1:08 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> >> On Wed, Jul 17, 2013 at 12:48:30PM +0100, Pedro Francisco wrote:
> >>> On Tue, Jul 16, 2013 at 11:27 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> >>> >> I seem only to be able to trigger it with disable_hw_scan=0, I need
> >>> >> further testing with disable_hw_scan=1 (I use disable_hw_scan=0
> >>> >> because it prevents me from getting disconnected from eduroam Cisco
> >>> >> APs -- haven't tested disable_hw_scan=0 since the VOIP-friendly SW
> >>> >> scanning patch, however).
> >>> >>
> >>> >> Do you want the log anyway? (modprobe iwl3945 debug=0x47ffffff
> >>> >> disable_hw_scan=0 and runtime PCI powersave also enabled -- I don't
> >>> >> know if it matters).
> >>> >
> >>> > As this is not causing troubles with default disable_hw_scan option,
> >>> > I'll post that patch.
> >>>
> >>> My mistake, I can trigger error conditions _independently_ of
> >>> disable_hw_scan option being enabled or disabled, as long as powersave
> >>> is enabled.
> >>>
> >>> I'll send you a private email with the logs.
> >>
> >> I think I found bug which couse this firmware crash. We have only 5
> >> queues so updating write_ptr for txq[5] can cause random value write
> >> to HBUS_TARG_WRPTR register. I also added spin_lock to do not abuse
> >> writes we do in tx skb.
> >>
> >> Please test attached patch (with powersave on :-)
> >
> > Still not working :( I tested for two nights, first one was fine,
> > second was not (the only difference was I had kernel parameter
> > `slub_debug` on the second night, but my guess it shouldn't affect
> > anything?).
> >
> > Snippet of log follows, full logs I'll send privately (beware,
> > unzipped it's 423MB).

Sorry for late answer. I have two more patches, which perhaps make
powersave stop crashing on 3945. Please test them (note that I only
compile tested, be carefull :-)

Thanks
Stanislaw


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-iwlegacy-poke-device-when-waiting-for-hcmd.patch"

>From c9da2966ce58ed1446367a0b14b0953ebc3fbfbe Mon Sep 17 00:00:00 2001
From: Stanislaw Gruszka <sgruszka@redhat.com>
Date: Thu, 17 Oct 2013 10:48:44 +0200
Subject: [PATCH 1/2] iwlegacy poke device when waiting for hcmd

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/common.c |   27 ++++++++++++++++++++-------
 1 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index b03e22e..7ada864 100644
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
 
@@ -333,9 +335,20 @@ il_send_cmd_sync(struct il_priv *il, struct il_host_cmd *cmd)
 		goto out;
 	}
 
-	ret = wait_event_timeout(il->wait_command_queue,
-				 !test_bit(S_HCMD_ACTIVE, &il->status),
-				 HOST_COMPLETE_TIMEOUT);
+	while (timeout) {
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
+	}
+
 	if (!ret) {
 		if (test_bit(S_HCMD_ACTIVE, &il->status)) {
 			IL_ERR("Error sending %s: time out after %dms.\n",
-- 
1.7.1


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0002-iwlegacy-merge-and-fix-reclaim-for-3945.patch"

>From 05b86620fcec5f18293b0df2a4dddbe34ae24125 Mon Sep 17 00:00:00 2001
From: Stanislaw Gruszka <sgruszka@redhat.com>
Date: Thu, 17 Oct 2013 11:03:21 +0200
Subject: [PATCH 2/2] iwlegacy: merge and fix reclaim for 3945

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945-mac.c |    9 +--------
 drivers/net/wireless/iwlegacy/4965-mac.c |   12 +-----------
 drivers/net/wireless/iwlegacy/common.h   |   14 ++++++++++++++
 3 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index dea3b50..d7c8dd3 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -1248,14 +1248,7 @@ il3945_rx_handle(struct il_priv *il)
 		len = le32_to_cpu(pkt->len_n_flags) & IL_RX_FRAME_SIZE_MSK;
 		len += sizeof(u32);	/* account for status word */
 
-		/* Reclaim a command buffer only if this packet is a response
-		 *   to a (driver-originated) command.
-		 * If the packet (e.g. Rx frame) originated from uCode,
-		 *   there is no command buffer to reclaim.
-		 * Ucode should set SEQ_RX_FRAME bit if ucode-originated,
-		 *   but apparently a few don't get set; catch them here. */
-		reclaim = !(pkt->hdr.sequence & SEQ_RX_FRAME) &&
-		    pkt->hdr.cmd != N_STATS && pkt->hdr.cmd != C_TX;
+		reclaim = il_need_reclaim(il, pkt);
 
 		/* Based on type of command response or notification,
 		 *   handle those that need handling via function in
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 86812b9..97cfaa9 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -4274,17 +4274,7 @@ il4965_rx_handle(struct il_priv *il)
 		len = le32_to_cpu(pkt->len_n_flags) & IL_RX_FRAME_SIZE_MSK;
 		len += sizeof(u32);	/* account for status word */
 
-		/* Reclaim a command buffer only if this packet is a response
-		 *   to a (driver-originated) command.
-		 * If the packet (e.g. Rx frame) originated from uCode,
-		 *   there is no command buffer to reclaim.
-		 * Ucode should set SEQ_RX_FRAME bit if ucode-originated,
-		 *   but apparently a few don't get set; catch them here. */
-		reclaim = !(pkt->hdr.sequence & SEQ_RX_FRAME) &&
-		    (pkt->hdr.cmd != N_RX_PHY) && (pkt->hdr.cmd != N_RX) &&
-		    (pkt->hdr.cmd != N_RX_MPDU) &&
-		    (pkt->hdr.cmd != N_COMPRESSED_BA) &&
-		    (pkt->hdr.cmd != N_STATS) && (pkt->hdr.cmd != C_TX);
+		reclaim = il_need_reclaim(il, pkt);
 
 		/* Based on type of command response or notification,
 		 *   handle those that need handling via function in
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index 83f8ed8..eccd6a4 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -1978,6 +1978,20 @@ extern void il_wr_prph(struct il_priv *il, u32 addr, u32 val);
 extern u32 il_read_targ_mem(struct il_priv *il, u32 addr);
 extern void il_write_targ_mem(struct il_priv *il, u32 addr, u32 val);
 
+static inline bool il_need_reclaim(struct il_priv *il, struct il_rx_pkt *pkt)
+{
+	/* Reclaim a command buffer only if this packet is a response
+	 * to a (driver-originated) command. If the packet (e.g. Rx frame)
+	 * originated from uCode, there is no command buffer to reclaim.
+	 * Ucode should set SEQ_RX_FRAME bit if ucode-originated, but
+	 * apparently a few don't get set; catch them here.
+	 */
+	return !(pkt->hdr.sequence & SEQ_RX_FRAME) &&
+	       pkt->hdr.cmd != N_STATS && pkt->hdr.cmd != C_TX &&
+	       pkt->hdr.cmd != N_RX_PHY && pkt->hdr.cmd != N_RX &&
+	       pkt->hdr.cmd != N_RX_MPDU && pkt->hdr.cmd != N_COMPRESSED_BA;
+}
+
 static inline void
 _il_write8(struct il_priv *il, u32 ofs, u8 val)
 {
-- 
1.7.1


--envbJBWh7q8WU6mo--
