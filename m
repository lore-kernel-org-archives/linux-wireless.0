Return-Path: <SRS0=6Uy3=QL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D499C282C4
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 20:57:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0CA8C20823
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 20:57:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nooOnSNT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727520AbfBDU5T (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Feb 2019 15:57:19 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43053 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725855AbfBDU5T (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Feb 2019 15:57:19 -0500
Received: by mail-wr1-f68.google.com with SMTP id r2so1363992wrv.10
        for <linux-wireless@vger.kernel.org>; Mon, 04 Feb 2019 12:57:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tKhhw23uKVuw/7eHsmgDvdjUoxI9FPdwxBKwhqwmdGg=;
        b=nooOnSNTA23SBy1h4Htid7jk75ai8Nv3cyMmSYl8f44sc55RGsWaCPWmIzBld0Y/jq
         LyALEhab/iOdCovy6G9OLOlPsRPZRj0uuBOJg/CSzv0v9h/CmT1hacmT8f18MlK+0X38
         vX4ZOiD240c9dCToNDyjQZMXe2KRaaBHdimKe7wILzDkicoJKujlYfm9oR0S8EFn+kXJ
         mq9naUR2LQcuu0crS7q82TDxsHnm5+u7gBwEzIvuMrFdw/lD5ajswhKmYdhNrZc7OOrX
         6UVkjl48PpU8+/ghKstaJlTIEgFwcrusNPwr6Wd+gyMCb4UpOBImpaxOkl1odA5fUiUI
         moqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tKhhw23uKVuw/7eHsmgDvdjUoxI9FPdwxBKwhqwmdGg=;
        b=BLnN5imGwoKDBqg8gDfSNipDhVfGrklcun2irR+JgFh+U+GpnUqSxvVkOWSYWaSJBa
         78pBvXHsnFI/GyPN7Fn5/A0wyLBRUwqhVBzQoR9+Aepx7uEColR9ibAOxpj7AXAg73Bs
         q972XRLAK+6vEFjbodXnLmdZ0LAYh+dU/5OUoKqNgGJI0pT+dXdhdmS30DY5sIXOy3Y+
         rz/YKB+ILs9eB32dmerzu5U9+qAxKIHj3CJTbP5IK/YsyiYxlSt6FNEUofpskylGbUht
         jpoK0DUNJaqa/twwQpiybdXlS9g8fXByvAb4nR+XeFkj5T+2ksXu2fCjPU6goSnB8gw8
         Df6Q==
X-Gm-Message-State: AHQUAuYXyvtjWdzdgKuD5dxM6GoPxxMkJqBpVORTOrE9JYIh2uzedtQl
        SHv2JFJol7mzFNCvBGjIm3Ms+N9u
X-Google-Smtp-Source: AHgI3Iaz/cUPjHcx1HxS+TXbjdujUnI7vAs4zpPUCH5UdLhXZ38wkx7PGH+T6RY2/ZvsDGfklKJ4Bg==
X-Received: by 2002:adf:f8cf:: with SMTP id f15mr913279wrq.265.1549313835926;
        Mon, 04 Feb 2019 12:57:15 -0800 (PST)
Received: from debian64.daheim (p4FD09D33.dip0.t-ipconnect.de. [79.208.157.51])
        by smtp.gmail.com with ESMTPSA id c202sm27659380wmd.40.2019.02.04.12.57.14
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 04 Feb 2019 12:57:14 -0800 (PST)
Received: from chuck by debian64.daheim with local (Exim 4.92-RC5)
        (envelope-from <chunkeey@gmail.com>)
        id 1gqlIo-0006DY-53; Mon, 04 Feb 2019 21:57:14 +0100
From:   Christian Lamparter <chunkeey@gmail.com>
To:     linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Cc:     Brian Norris <briannorris@chromium.org>,
        Ben Greear <greearb@candelatech.com>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
Subject: [PATCH v2] ath10k: implement set_base_macaddr to fix rx-bssid mask in multiple APs conf
Date:   Mon,  4 Feb 2019 21:57:14 +0100
Message-Id: <20190204205714.23858-1-chunkeey@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Many integrated QCA9984 WiFis in various IPQ806x platform routers
from various vendors (Netgear R7800, ZyXEL NBG6817, TP-LINK C2600,
etc.) have either blank, bogus or non-unique MAC-addresses in
their calibration data.

As a result, OpenWrt utilizes a discouraged binary calibration data
patching method that allows to modify the device's MAC-addresses right
at the source. This is because the ath10k' firmware extracts the MAC
address from the supplied radio/calibration data and issues a response
to the ath10k linux driver. Which was designed to take the main MAC in
ath10k_wmi_event_ready().

Part of the "setting an alternate MAC" issue was already tackled by a
patch from Brian Norris:
commit 9d5804662ce1
("ath10k: retrieve MAC address from system firmware if provided")
by allowing the option to specify an alternate MAC-address with the
established device_get_mac_address() function which extracts the right
address from DeviceTree/fwnode mac-address or local-mac-address
properties and saves it for later.

However, Ben Greear noted that the Qualcomm's ath10k firmware is liable
to not properly calculate its rx-bssid mask in this case. This can cause
issues in the popluar "multiple AP with a single ath10k instance"
configurations.

To improve MAC address handling, Felix Fietkau suggested to call
pdev_set_base_macaddr_cmdid before bringing up the first vif and
use the first vif MAC address there. Which is in ath10k_core_start().

This patch implement Felix Fietkau's request to
"call pdev_set_base_macaddr_cmdid before bringing up the first vif".
The pdev_set_base_macaddr_cmdid is already declared for all devices
and version. The driver just needed the support code for this
function.

Tested on:
QCA9880/CUS223, firmwares: 10.2.4.13-2, 10.2.4.70.44, 10.2.4-1.0-00041
QCA9887/MR33 firmware:10.2.4-1.0-00033
QCA4019/RT-AC58U firmware: 10.4-3.4-00104, 10.4-3.5.3-00057
QCA9984/R7800 firmware: Candela Technologies (CT) Firmware

BugLink: https://lists.openwrt.org/pipermail/openwrt-devel/2018-November/014595.html
Fixes: 9d5804662ce1 ("ath10k: retrieve MAC address from system firmware if provided")
Cc: Brian Norris <briannorris@chromium.org>
Cc: Ben Greear <greearb@candelatech.com>
Cc: Felix Fietkau <nbd@nbd.name>
Cc: Mathias Kresin <dev@kresin.me>
Signed-off-by: Christian Lamparter <chunkeey@gmail.com>

---

Changed from v1:
	- removed support for obsolete, untested firmwares
	- removed unsupported TLV ops
	- don't error-out on unsupported platforms
---
 drivers/net/wireless/ath/ath10k/core.c    |  7 +++++++
 drivers/net/wireless/ath/ath10k/wmi-ops.h | 18 ++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.c     | 21 +++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h     |  4 ++++
 4 files changed, 50 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 399b501f3c3c..dd980af04ed6 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -2649,6 +2649,13 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode,
 		goto err_hif_stop;
 	}
 
+	status = ath10k_wmi_pdev_set_base_macaddr(ar, ar->mac_addr);
+	if (status && status != -EOPNOTSUPP) {
+		ath10k_err(ar,
+			   "failed to set base mac address: %d\n", status);
+		goto err_hif_stop;
+	}
+
 	/* Some firmware revisions do not properly set up hardware rx filter
 	 * registers.
 	 *
diff --git a/drivers/net/wireless/ath/ath10k/wmi-ops.h b/drivers/net/wireless/ath/ath10k/wmi-ops.h
index 04663076d27a..4f8c7e402e6f 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-ops.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-ops.h
@@ -66,6 +66,8 @@ struct wmi_ops {
 
 	struct sk_buff *(*gen_pdev_suspend)(struct ath10k *ar, u32 suspend_opt);
 	struct sk_buff *(*gen_pdev_resume)(struct ath10k *ar);
+	struct sk_buff *(*gen_pdev_set_base_macaddr)(struct ath10k *ar,
+						     const u8 macaddr[ETH_ALEN]);
 	struct sk_buff *(*gen_pdev_set_rd)(struct ath10k *ar, u16 rd, u16 rd2g,
 					   u16 rd5g, u16 ctl2g, u16 ctl5g,
 					   enum wmi_dfs_region dfs_reg);
@@ -506,6 +508,22 @@ ath10k_wmi_pdev_set_regdomain(struct ath10k *ar, u16 rd, u16 rd2g, u16 rd5g,
 				   ar->wmi.cmd->pdev_set_regdomain_cmdid);
 }
 
+static inline int
+ath10k_wmi_pdev_set_base_macaddr(struct ath10k *ar, const u8 macaddr[ETH_ALEN])
+{
+	struct sk_buff *skb;
+
+	if (!ar->wmi.ops->gen_pdev_set_base_macaddr)
+		return -EOPNOTSUPP;
+
+	skb = ar->wmi.ops->gen_pdev_set_base_macaddr(ar, macaddr);
+	if (IS_ERR(skb))
+		return PTR_ERR(skb);
+
+	return ath10k_wmi_cmd_send(ar, skb,
+				   ar->wmi.cmd->pdev_set_base_macaddr_cmdid);
+}
+
 static inline int
 ath10k_wmi_pdev_suspend_target(struct ath10k *ar, u32 suspend_opt)
 {
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 8e236d158ca6..1b9b9f10ad5e 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -6239,6 +6239,25 @@ int ath10k_wmi_connect(struct ath10k *ar)
 	return 0;
 }
 
+static struct sk_buff *
+ath10k_wmi_op_gen_pdev_set_base_macaddr(struct ath10k *ar,
+					const u8 macaddr[ETH_ALEN])
+{
+	struct wmi_pdev_set_base_macaddr_cmd *cmd;
+	struct sk_buff *skb;
+
+	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd));
+	if (!skb)
+		return ERR_PTR(-ENOMEM);
+
+	cmd = (struct wmi_pdev_set_base_macaddr_cmd *)skb->data;
+	ether_addr_copy(cmd->mac_addr.addr, macaddr);
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI,
+		   "wmi pdev basemac %pM\n", macaddr);
+	return skb;
+}
+
 static struct sk_buff *
 ath10k_wmi_op_gen_pdev_set_rd(struct ath10k *ar, u16 rd, u16 rd2g, u16 rd5g,
 			      u16 ctl2g, u16 ctl5g,
@@ -9115,6 +9134,7 @@ static const struct wmi_ops wmi_10_2_4_ops = {
 	.gen_peer_create = ath10k_wmi_op_gen_peer_create,
 	.gen_peer_delete = ath10k_wmi_op_gen_peer_delete,
 	.gen_peer_flush = ath10k_wmi_op_gen_peer_flush,
+	.gen_pdev_set_base_macaddr = ath10k_wmi_op_gen_pdev_set_base_macaddr,
 	.gen_peer_set_param = ath10k_wmi_op_gen_peer_set_param,
 	.gen_set_psmode = ath10k_wmi_op_gen_set_psmode,
 	.gen_set_sta_ps = ath10k_wmi_op_gen_set_sta_ps,
@@ -9166,6 +9186,7 @@ static const struct wmi_ops wmi_10_4_ops = {
 
 	.gen_pdev_suspend = ath10k_wmi_op_gen_pdev_suspend,
 	.gen_pdev_resume = ath10k_wmi_op_gen_pdev_resume,
+	.gen_pdev_set_base_macaddr = ath10k_wmi_op_gen_pdev_set_base_macaddr,
 	.gen_pdev_set_rd = ath10k_wmi_10x_op_gen_pdev_set_rd,
 	.gen_pdev_set_param = ath10k_wmi_op_gen_pdev_set_param,
 	.gen_init = ath10k_wmi_10_4_op_gen_init,
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 2034ccc7cc72..151abcb5ec35 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -4083,6 +4083,10 @@ struct wmi_pdev_set_param_cmd {
 	__le32 param_value;
 } __packed;
 
+struct wmi_pdev_set_base_macaddr_cmd {
+	struct wmi_mac_addr mac_addr;
+} __packed;
+
 /* valid period is 1 ~ 60000ms, unit in millisecond */
 #define WMI_PDEV_PARAM_CAL_PERIOD_MAX 60000
 
-- 
2.20.1

