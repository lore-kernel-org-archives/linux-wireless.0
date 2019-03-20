Return-Path: <SRS0=2I9a=RX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCE69C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 10:05:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 751112184E
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 10:05:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="YiXdNn6m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727620AbfCTKFj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Mar 2019 06:05:39 -0400
Received: from mail-eopbgr720083.outbound.protection.outlook.com ([40.107.72.83]:25002
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727586AbfCTKFj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Mar 2019 06:05:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gE5tzCkhfFzszOpbOsyEJrAA6KwTfRcOQDYpWQR85hY=;
 b=YiXdNn6mYYMTAi9RQos2xT0FQOrpFgE0yyxTPXS4G9JzY6xFb3+FG6RKaISXB+0KZo6kicwBiNtMiWeiYYLm9I2WZvUTrbQR3Jj0+yYRZH1cakN2TNBXKWqAEF9tlo1N30NaxJ1S0Nge1YP6mqV5cYmlyB+VKQqdbApw7Z+FGGk=
Received: from DM6PR05MB6347.namprd05.prod.outlook.com (20.178.224.142) by
 DM6PR05MB4810.namprd05.prod.outlook.com (20.176.111.219) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.14; Wed, 20 Mar 2019 10:05:19 +0000
Received: from DM6PR05MB6347.namprd05.prod.outlook.com
 ([fe80::c57d:be14:6100:bd58]) by DM6PR05MB6347.namprd05.prod.outlook.com
 ([fe80::c57d:be14:6100:bd58%3]) with mapi id 15.20.1709.015; Wed, 20 Mar 2019
 10:05:19 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com (52.135.117.74) by
 SN6PR05MB5661.namprd05.prod.outlook.com (52.135.111.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1709.15; Wed, 20 Mar 2019 10:04:09 +0000
Received: from SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e]) by SN6PR05MB4928.namprd05.prod.outlook.com
 ([fe80::ecfd:3a22:dcb3:3b9e%4]) with mapi id 15.20.1709.015; Wed, 20 Mar 2019
 10:04:09 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 13/14] qtnfmac: send EAPOL frames via control path
Thread-Topic: [PATCH 13/14] qtnfmac: send EAPOL frames via control path
Thread-Index: AQHU3wRCAzNEfthIYEeWfINpvOMT2g==
Date:   Wed, 20 Mar 2019 10:04:09 +0000
Message-ID: <20190320100340.14168-14-sergey.matyukevich.os@quantenna.com>
References: <20190320100340.14168-1-sergey.matyukevich.os@quantenna.com>
In-Reply-To: <20190320100340.14168-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR05CA0106.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::47) To SN6PR05MB4928.namprd05.prod.outlook.com
 (2603:10b6:805:9d::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.11.0
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6e85b8dd-2b1e-437c-3ca4-08d6ad1b64f3
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600127)(711020)(4605104)(2017052603328)(7153060)(7193020);SRVR:SN6PR05MB5661;
x-ms-traffictypediagnostic: SN6PR05MB5661:|DM6PR05MB4810:
x-moderation-data: 3/20/2019 10:05:18 AM
x-microsoft-antispam-prvs: <DM6PR05MB4810CAC4B01BE123F7A8B2FAA3410@DM6PR05MB4810.namprd05.prod.outlook.com>
x-forefront-prvs: 098291215C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(376002)(39850400004)(136003)(396003)(346002)(189003)(199004)(103116003)(54906003)(68736007)(305945005)(7736002)(478600001)(14454004)(25786009)(316002)(5640700003)(6512007)(5660300002)(106356001)(2906002)(2351001)(6486002)(30864003)(6436002)(6916009)(105586002)(6116002)(3846002)(1076003)(476003)(2616005)(11346002)(446003)(486006)(186003)(71200400001)(97736004)(71190400001)(256004)(386003)(99286004)(6506007)(52116002)(102836004)(26005)(76176011)(2501003)(5024004)(14444005)(81156014)(8676002)(81166006)(50226002)(8936002)(66066001)(36756003)(436003)(86362001)(53936002)(107886003)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR05MB4810;H:DM6PR05MB6347.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 0MiMqx+N7Kwc+NyufADdU6zae6WrY/T7x4C/mCDLyHRoPtRKv7WM4LQRYULJRuMTQSV3cswHekv70W5T6C4AMZioIHiBLly3uLA+FPywiRx2H58DS2SRXTUPoOz+bZHyHeodeYwoLVd+f+zYgk8/yIwkhDNJZ2NC7BJ/Hbt4/bijc27+sH4bl1xHcce4jUkWSoJm57C7TU1/mFS6vR7iI6ccbxmDhaithlxQ65FcFYB6JcWievzjdHMFS/+L1BQVo/iniLwwQzkxT5blS48s3kZ04zErb4jSUnAIdahdUxlHlpOpdRXLBC5a5safiHSWgp7nYN9ezBIm7g1YJRRc1RzsVdhWQoY9rVIOw6Wvg/MTKvxbGUh9Okan9gq+gZ60TV9dqceXSsxddbKngMXBgt86VYz5e3NMIVWWn5K0Nbs=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e85b8dd-2b1e-437c-3ca4-08d6ad1b64f3
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2019 10:05:19.7995
 (UTC)
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR05MB4810
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

Use control path to send EAPOL frames to make sure they are
sent with higher priority with aggregation disabled.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/bus.h       |  1 +
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c  | 17 +++++---
 drivers/net/wireless/quantenna/qtnfmac/commands.c  | 10 ++---
 drivers/net/wireless/quantenna/qtnfmac/commands.h  |  4 +-
 drivers/net/wireless/quantenna/qtnfmac/core.c      | 45 ++++++++++++++++++=
++--
 drivers/net/wireless/quantenna/qtnfmac/core.h      |  3 ++
 drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c |  1 +
 .../wireless/quantenna/qtnfmac/pcie/pcie_priv.h    |  1 +
 .../wireless/quantenna/qtnfmac/pcie/topaz_pcie.c   |  8 ++++
 drivers/net/wireless/quantenna/qtnfmac/qlink.h     | 24 +++++++-----
 10 files changed, 89 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/bus.h b/drivers/net/wir=
eless/quantenna/qtnfmac/bus.h
index dc1bd32d4827..7cea08f71838 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/bus.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/bus.h
@@ -49,6 +49,7 @@ struct qtnf_bus {
 	struct napi_struct mux_napi;
 	struct net_device mux_dev;
 	struct workqueue_struct *workqueue;
+	struct workqueue_struct *hprio_workqueue;
 	struct work_struct fw_work;
 	struct work_struct event_work;
 	struct mutex bus_lock; /* lock during command/event processing */
diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/ne=
t/wireless/quantenna/qtnfmac/cfg80211.c
index 95572555ed6a..c78500bcaa2d 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -144,6 +144,7 @@ int qtnf_del_virtual_intf(struct wiphy *wiphy, struct w=
ireless_dev *wdev)
 {
 	struct net_device *netdev =3D  wdev->netdev;
 	struct qtnf_vif *vif;
+	struct sk_buff *skb;
=20
 	if (WARN_ON(!netdev))
 		return -EFAULT;
@@ -157,6 +158,11 @@ int qtnf_del_virtual_intf(struct wiphy *wiphy, struct =
wireless_dev *wdev)
 	if (netif_carrier_ok(netdev))
 		netif_carrier_off(netdev);
=20
+	while ((skb =3D skb_dequeue(&vif->high_pri_tx_queue)))
+		dev_kfree_skb_any(skb);
+
+	cancel_work_sync(&vif->high_pri_tx_work);
+
 	if (netdev->reg_state =3D=3D NETREG_REGISTERED)
 		unregister_netdevice(netdev);
=20
@@ -424,13 +430,13 @@ qtnf_mgmt_tx(struct wiphy *wiphy, struct wireless_dev=
 *wdev,
 	*cookie =3D short_cookie;
=20
 	if (params->offchan)
-		flags |=3D QLINK_MGMT_FRAME_TX_FLAG_OFFCHAN;
+		flags |=3D QLINK_FRAME_TX_FLAG_OFFCHAN;
=20
 	if (params->no_cck)
-		flags |=3D QLINK_MGMT_FRAME_TX_FLAG_NO_CCK;
+		flags |=3D QLINK_FRAME_TX_FLAG_NO_CCK;
=20
 	if (params->dont_wait_for_ack)
-		flags |=3D QLINK_MGMT_FRAME_TX_FLAG_ACK_NOWAIT;
+		flags |=3D QLINK_FRAME_TX_FLAG_ACK_NOWAIT;
=20
 	/* If channel is not specified, pass "freq =3D 0" to tell device
 	 * firmware to use current channel.
@@ -445,9 +451,8 @@ qtnf_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *=
wdev,
 		 le16_to_cpu(mgmt_frame->frame_control), mgmt_frame->da,
 		 params->len, short_cookie, flags);
=20
-	return qtnf_cmd_send_mgmt_frame(vif, short_cookie, flags,
-					freq,
-					params->buf, params->len);
+	return qtnf_cmd_send_frame(vif, short_cookie, flags,
+				   freq, params->buf, params->len);
 }
=20
 static int
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/ne=
t/wireless/quantenna/qtnfmac/commands.c
index a04321305ebc..62edddb8551e 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -381,11 +381,11 @@ int qtnf_cmd_send_register_mgmt(struct qtnf_vif *vif,=
 u16 frame_type, bool reg)
 	return ret;
 }
=20
-int qtnf_cmd_send_mgmt_frame(struct qtnf_vif *vif, u32 cookie, u16 flags,
-			     u16 freq, const u8 *buf, size_t len)
+int qtnf_cmd_send_frame(struct qtnf_vif *vif, u32 cookie, u16 flags,
+			u16 freq, const u8 *buf, size_t len)
 {
 	struct sk_buff *cmd_skb;
-	struct qlink_cmd_mgmt_frame_tx *cmd;
+	struct qlink_cmd_frame_tx *cmd;
 	int ret;
=20
 	if (sizeof(*cmd) + len > QTNF_MAX_CMD_BUF_SIZE) {
@@ -395,14 +395,14 @@ int qtnf_cmd_send_mgmt_frame(struct qtnf_vif *vif, u3=
2 cookie, u16 flags,
 	}
=20
 	cmd_skb =3D qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
-					    QLINK_CMD_SEND_MGMT_FRAME,
+					    QLINK_CMD_SEND_FRAME,
 					    sizeof(*cmd));
 	if (!cmd_skb)
 		return -ENOMEM;
=20
 	qtnf_bus_lock(vif->mac->bus);
=20
-	cmd =3D (struct qlink_cmd_mgmt_frame_tx *)cmd_skb->data;
+	cmd =3D (struct qlink_cmd_frame_tx *)cmd_skb->data;
 	cmd->cookie =3D cpu_to_le32(cookie);
 	cmd->freq =3D cpu_to_le16(freq);
 	cmd->flags =3D cpu_to_le16(flags);
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.h b/drivers/ne=
t/wireless/quantenna/qtnfmac/commands.h
index 050f9a49d16c..6406365287fc 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.h
@@ -27,8 +27,8 @@ int qtnf_cmd_send_start_ap(struct qtnf_vif *vif,
 			   const struct cfg80211_ap_settings *s);
 int qtnf_cmd_send_stop_ap(struct qtnf_vif *vif);
 int qtnf_cmd_send_register_mgmt(struct qtnf_vif *vif, u16 frame_type, bool=
 reg);
-int qtnf_cmd_send_mgmt_frame(struct qtnf_vif *vif, u32 cookie, u16 flags,
-			     u16 freq, const u8 *buf, size_t len);
+int qtnf_cmd_send_frame(struct qtnf_vif *vif, u32 cookie, u16 flags,
+			u16 freq, const u8 *buf, size_t len);
 int qtnf_cmd_send_mgmt_set_appie(struct qtnf_vif *vif, u8 frame_type,
 				 const u8 *buf, size_t len);
 int qtnf_cmd_get_sta_info(struct qtnf_vif *vif, const u8 *sta_mac,
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.c b/drivers/net/wi=
reless/quantenna/qtnfmac/core.c
index eed12e4dec65..54ea86ae4959 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.c
@@ -368,6 +368,23 @@ static void qtnf_mac_scan_timeout(struct work_struct *=
work)
 	qtnf_mac_scan_finish(mac, true);
 }
=20
+static void qtnf_vif_send_data_high_pri(struct work_struct *work)
+{
+	struct qtnf_vif *vif =3D
+		container_of(work, struct qtnf_vif, high_pri_tx_work);
+	struct sk_buff *skb;
+
+	if (!vif->netdev ||
+	    vif->wdev.iftype =3D=3D NL80211_IFTYPE_UNSPECIFIED)
+		return;
+
+	while ((skb =3D skb_dequeue(&vif->high_pri_tx_queue))) {
+		qtnf_cmd_send_frame(vif, 0, QLINK_FRAME_TX_FLAG_8023,
+				    0, skb->data, skb->len);
+		dev_kfree_skb_any(skb);
+	}
+}
+
 static struct qtnf_wmac *qtnf_core_mac_alloc(struct qtnf_bus *bus,
 					     unsigned int macid)
 {
@@ -395,7 +412,8 @@ static struct qtnf_wmac *qtnf_core_mac_alloc(struct qtn=
f_bus *bus,
 		vif->mac =3D mac;
 		vif->vifid =3D i;
 		qtnf_sta_list_init(&vif->sta_list);
-
+		INIT_WORK(&vif->high_pri_tx_work, qtnf_vif_send_data_high_pri);
+		skb_queue_head_init(&vif->high_pri_tx_queue);
 		vif->stats64 =3D netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
 		if (!vif->stats64)
 			pr_warn("VIF%u.%u: per cpu stats allocation failed\n",
@@ -598,6 +616,13 @@ int qtnf_core_attach(struct qtnf_bus *bus)
 		goto error;
 	}
=20
+	bus->hprio_workqueue =3D alloc_workqueue("QTNF_HPRI", WQ_HIGHPRI, 0);
+	if (!bus->hprio_workqueue) {
+		pr_err("failed to alloc high prio workqueue\n");
+		ret =3D -ENOMEM;
+		goto error;
+	}
+
 	INIT_WORK(&bus->event_work, qtnf_event_work_handler);
=20
 	ret =3D qtnf_cmd_send_init_fw(bus);
@@ -607,7 +632,6 @@ int qtnf_core_attach(struct qtnf_bus *bus)
 	}
=20
 	bus->fw_state =3D QTNF_FW_STATE_ACTIVE;
-
 	ret =3D qtnf_cmd_get_hw_info(bus);
 	if (ret) {
 		pr_err("failed to get HW info: %d\n", ret);
@@ -642,7 +666,6 @@ int qtnf_core_attach(struct qtnf_bus *bus)
=20
 error:
 	qtnf_core_detach(bus);
-
 	return ret;
 }
 EXPORT_SYMBOL_GPL(qtnf_core_attach);
@@ -664,6 +687,13 @@ void qtnf_core_detach(struct qtnf_bus *bus)
 	if (bus->workqueue) {
 		flush_workqueue(bus->workqueue);
 		destroy_workqueue(bus->workqueue);
+		bus->workqueue =3D NULL;
+	}
+
+	if (bus->hprio_workqueue) {
+		flush_workqueue(bus->hprio_workqueue);
+		destroy_workqueue(bus->hprio_workqueue);
+		bus->hprio_workqueue =3D NULL;
 	}
=20
 	qtnf_trans_free(bus);
@@ -800,6 +830,15 @@ void qtnf_update_tx_stats(struct net_device *ndev, con=
st struct sk_buff *skb)
 }
 EXPORT_SYMBOL_GPL(qtnf_update_tx_stats);
=20
+void qtnf_packet_send_hi_pri(struct sk_buff *skb)
+{
+	struct qtnf_vif *vif =3D qtnf_netdev_get_priv(skb->dev);
+
+	skb_queue_tail(&vif->high_pri_tx_queue, skb);
+	queue_work(vif->mac->bus->hprio_workqueue, &vif->high_pri_tx_work);
+}
+EXPORT_SYMBOL_GPL(qtnf_packet_send_hi_pri);
+
 MODULE_AUTHOR("Quantenna Communications");
 MODULE_DESCRIPTION("Quantenna 802.11 wireless LAN FullMAC driver.");
 MODULE_LICENSE("GPL");
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.h b/drivers/net/wi=
reless/quantenna/qtnfmac/core.h
index 1b983ec9afcc..af8372dfb927 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.h
@@ -63,6 +63,8 @@ struct qtnf_vif {
 	struct qtnf_wmac *mac;
=20
 	struct work_struct reset_work;
+	struct work_struct high_pri_tx_work;
+	struct sk_buff_head high_pri_tx_queue;
 	struct qtnf_sta_list sta_list;
 	unsigned long cons_tx_timeout_cnt;
 	int generation;
@@ -149,6 +151,7 @@ void qtnf_virtual_intf_cleanup(struct net_device *ndev)=
;
=20
 void qtnf_netdev_updown(struct net_device *ndev, bool up);
 void qtnf_scan_done(struct qtnf_wmac *mac, bool aborted);
+void qtnf_packet_send_hi_pri(struct sk_buff *skb);
=20
 static inline struct qtnf_vif *qtnf_netdev_get_priv(struct net_device *dev=
)
 {
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c b/drivers/n=
et/wireless/quantenna/qtnfmac/pcie/pcie.c
index 56fc6d49c121..069fe61aa477 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
@@ -358,6 +358,7 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, const =
struct pci_device_id *id)
 	pcie_priv->pcie_irq_count =3D 0;
 	pcie_priv->tx_reclaim_done =3D 0;
 	pcie_priv->tx_reclaim_req =3D 0;
+	pcie_priv->tx_eapol =3D 0;
=20
 	pcie_priv->workqueue =3D create_singlethread_workqueue("QTNF_PCIE");
 	if (!pcie_priv->workqueue) {
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie_priv.h b/driv=
ers/net/wireless/quantenna/qtnfmac/pcie/pcie_priv.h
index b21de4f52a9d..5e8b9cb68419 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie_priv.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie_priv.h
@@ -62,6 +62,7 @@ struct qtnf_pcie_bus_priv {
 	u32 tx_done_count;
 	u32 tx_reclaim_done;
 	u32 tx_reclaim_req;
+	u32 tx_eapol;
=20
 	u8 msi_enabled;
 	u8 tx_stopped;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c b/dri=
vers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c
index d9b83ea6281c..9a4380ed7f1b 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/topaz_pcie.c
@@ -498,6 +498,13 @@ static int qtnf_pcie_data_tx(struct qtnf_bus *bus, str=
uct sk_buff *skb)
 	int len;
 	int i;
=20
+	if (unlikely(skb->protocol =3D=3D htons(ETH_P_PAE))) {
+		qtnf_packet_send_hi_pri(skb);
+		qtnf_update_tx_stats(skb->dev, skb);
+		priv->tx_eapol++;
+		return NETDEV_TX_OK;
+	}
+
 	spin_lock_irqsave(&priv->tx_lock, flags);
=20
 	if (!qtnf_tx_queue_ready(ts)) {
@@ -761,6 +768,7 @@ static int qtnf_dbg_pkt_stats(struct seq_file *s, void =
*data)
 	seq_printf(s, "tx_done_count(%u)\n", priv->tx_done_count);
 	seq_printf(s, "tx_reclaim_done(%u)\n", priv->tx_reclaim_done);
 	seq_printf(s, "tx_reclaim_req(%u)\n", priv->tx_reclaim_req);
+	seq_printf(s, "tx_eapol(%u)\n", priv->tx_eapol);
=20
 	seq_printf(s, "tx_bd_r_index(%u)\n", priv->tx_bd_r_index);
 	seq_printf(s, "tx_done_index(%u)\n", tx_done_index);
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/w=
ireless/quantenna/qtnfmac/qlink.h
index f6d30069ef3a..2fe71adc221a 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -206,6 +206,8 @@ struct qlink_sta_info_state {
  * execution status (one of &enum qlink_cmd_result). Reply message
  * may also contain data payload specific to the command type.
  *
+ * @QLINK_CMD_SEND_FRAME: send specified frame over the air; firmware will
+ *	encapsulate 802.3 packet into 802.11 frame automatically.
  * @QLINK_CMD_BAND_INFO_GET: for the specified MAC and specified band, get
  *	the band's description including number of operational channels and
  *	info on each channel, HT/VHT capabilities, supported rates etc.
@@ -220,7 +222,7 @@ enum qlink_cmd_type {
 	QLINK_CMD_FW_INIT		=3D 0x0001,
 	QLINK_CMD_FW_DEINIT		=3D 0x0002,
 	QLINK_CMD_REGISTER_MGMT		=3D 0x0003,
-	QLINK_CMD_SEND_MGMT_FRAME	=3D 0x0004,
+	QLINK_CMD_SEND_FRAME		=3D 0x0004,
 	QLINK_CMD_MGMT_SET_APPIE	=3D 0x0005,
 	QLINK_CMD_PHY_PARAMS_GET	=3D 0x0011,
 	QLINK_CMD_PHY_PARAMS_SET	=3D 0x0012,
@@ -321,22 +323,26 @@ struct qlink_cmd_mgmt_frame_register {
 	u8 do_register;
 } __packed;
=20
-enum qlink_mgmt_frame_tx_flags {
-	QLINK_MGMT_FRAME_TX_FLAG_NONE		=3D 0,
-	QLINK_MGMT_FRAME_TX_FLAG_OFFCHAN	=3D BIT(0),
-	QLINK_MGMT_FRAME_TX_FLAG_NO_CCK		=3D BIT(1),
-	QLINK_MGMT_FRAME_TX_FLAG_ACK_NOWAIT	=3D BIT(2),
+/**
+ * @QLINK_FRAME_TX_FLAG_8023: frame has a 802.3 header; if not set, frame
+ *	is a 802.11 encapsulated.
+ */
+enum qlink_frame_tx_flags {
+	QLINK_FRAME_TX_FLAG_OFFCHAN	=3D BIT(0),
+	QLINK_FRAME_TX_FLAG_NO_CCK	=3D BIT(1),
+	QLINK_FRAME_TX_FLAG_ACK_NOWAIT	=3D BIT(2),
+	QLINK_FRAME_TX_FLAG_8023	=3D BIT(3),
 };
=20
 /**
- * struct qlink_cmd_mgmt_frame_tx - data for QLINK_CMD_SEND_MGMT_FRAME com=
mand
+ * struct qlink_cmd_frame_tx - data for QLINK_CMD_SEND_FRAME command
  *
  * @cookie: opaque request identifier.
  * @freq: Frequency to use for frame transmission.
- * @flags: Transmission flags, one of &enum qlink_mgmt_frame_tx_flags.
+ * @flags: Transmission flags, one of &enum qlink_frame_tx_flags.
  * @frame_data: frame to transmit.
  */
-struct qlink_cmd_mgmt_frame_tx {
+struct qlink_cmd_frame_tx {
 	struct qlink_cmd chdr;
 	__le32 cookie;
 	__le16 freq;
--=20
2.11.0

