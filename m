Return-Path: <SRS0=Ta2d=QQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57ACBC282C4
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 07:12:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0399D20863
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 07:12:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="utA5B3OB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbfBIHMn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 9 Feb 2019 02:12:43 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:9344 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726821AbfBIHMn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Feb 2019 02:12:43 -0500
X-IronPort-AV: E=Sophos;i="5.56,564,1539673200"; 
   d="scan'208";a="26492091"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 09 Feb 2019 00:12:41 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.105) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Sat, 9 Feb 2019 00:12:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6TWwqPocbDn7agZSpw+ZnBmewIz+ikyF6aw5JczLWeI=;
 b=utA5B3OBUdlUKg1jhjJhbNEOHaEIti8ZWjX4+EJPs9USNlp5ID6i4RpG1Yc0dsfTlgDI8n1A2uDTauu1zwzdbs14Vz5/IyxCKRiVTJHDzOrPWKOAA31XQf2YLaO12R4MFucn9hsE9r8UTOWI9ZcjsM3egVaOREoSUNwpP9l43SY=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3128.namprd11.prod.outlook.com (20.177.227.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.21; Sat, 9 Feb 2019 07:12:38 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::cc6d:bc31:d5b:a27d%5]) with mapi id 15.20.1601.016; Sat, 9 Feb 2019
 07:12:38 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>, <kvalo@codeaurora.org>,
        <johannes@sipsolutions.net>, <Adham.Abozaeid@microchip.com>,
        <Venkateswara.Kaja@microchip.com>, <Nicolas.Ferre@microchip.com>,
        <Claudiu.Beznea@microchip.com>, <Ajay.Kathat@microchip.com>
Subject: [PATCH 09/16] wilc1000: add wilc_netdev.c
Thread-Topic: [PATCH 09/16] wilc1000: add wilc_netdev.c
Thread-Index: AQHUwEbWN15VYlDNakeOtF1lWN8lSQ==
Date:   Sat, 9 Feb 2019 07:12:38 +0000
Message-ID: <1549696298-9795-10-git-send-email-ajay.kathat@microchip.com>
References: <1549696298-9795-1-git-send-email-ajay.kathat@microchip.com>
In-Reply-To: <1549696298-9795-1-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR0101CA0021.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:21::31) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.7.4
x-originating-ip: [183.82.17.42]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3128;6:dXp83NtDclP42N5CP5NJkSMGQaFfXOiP0CQtguS+ctvwlGT7XqLUv39WptEws1KuvYRNqpF0vWKXoMElal38leKeuaHXCjReROrySSlUCo+URt+28KowSkWzT5ri06rtzaOcxwuhpxkVo+/qH+JKXZYrhP15ro3bemZdeunPHLH93pMHWYDaYuNuD6QMlxn6f4BDZ9iyWCNtdyeaTn6DQ3yKnnPLfFt2HV+jxMzy1NQW5a5xqsPp2MdVn514MuVQyAt+7oJEJjH7fwJc9uEISP9KREhBmI9Fsn9kARbO5BJ8/v134CwcYkjbn5h4EXgb/SNoRZps92FPLgp7o1LH6Pe6Ddq5ZGY2EPjFFz24Esj+mac3qEkzW+5zbxVBCC6+rosYFKz3vl8laUFmjtEKrRICbaPQqGJ3H+Jq0TZ0yuh868EaISF9wOzuIHV93QPeh74p5I3fvnv2OvM+nrIzKg==;5:Ae8svppzGn9oDGELLbs+Y0LaXJEAze9NGmWqT4fSs4wC2QIZqe9/WfKJUqyi5XgJh7dgAvu/CUfXrbRoTsvyWweqd+NjssaIozosu69K0mY9bfpvIed9rBFmzGKZJlrBMes6ElADT+j5htOsxYc+7rF6gx0Fcwwh/vTtId9rDgWyLkiEJLZG2UklWNc8TLvp2goSOCJMcRJtzC+JOm5n6A==;7:8rjfwcqsxRz7pLtK1lNvDk6BGXX1VaYpMw0vCF+Ur15ElqqUxtadsWfA1TPrj8u1TMOGRp0OECCE/vHviGKuea3LXYDxR0SkkfldKghNPGczebkateDFsOPWDsijDpbdZJ22skXRjla5fsx5sxzNMQ==
x-ms-office365-filtering-correlation-id: 3a3f6546-8644-4479-b98a-08d68e5df929
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3128;
x-ms-traffictypediagnostic: BYAPR11MB3128:
x-microsoft-antispam-prvs: <BYAPR11MB3128C707EF5D5143B8990138E36A0@BYAPR11MB3128.namprd11.prod.outlook.com>
x-forefront-prvs: 09435FCA72
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(366004)(39860400002)(376002)(396003)(136003)(199004)(189003)(4326008)(53946003)(8936002)(50226002)(476003)(52116002)(2616005)(2501003)(76176011)(305945005)(53936002)(6486002)(7736002)(66066001)(11346002)(2351001)(26005)(68736007)(6916009)(36756003)(6506007)(386003)(99286004)(6436002)(105586002)(102836004)(5640700003)(6512007)(8676002)(81156014)(81166006)(186003)(106356001)(446003)(97736004)(107886003)(478600001)(14444005)(256004)(30864003)(71200400001)(78486014)(25786009)(316002)(54906003)(72206003)(486006)(14454004)(2906002)(86362001)(3846002)(6116002)(71190400001)(579004)(559001);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3128;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 0NBoC52FRGe+w8XT6iB8SF6F98hmzXrs3nTQo3kbo6TtSYIEN5nL+R9999nQr21QQdQll3umyjJyqk4VdYI9OY9+/RYoRFD85IPw3hw1rmmurNg/w5Sqz2QVggv2Y1TF6bhuFQ/5tGFDEX4TgciPgC6MqULZm6eHYMUB2/yovq31eUm0JpRPfCnzMggkiq74tZvAUVhzcV7Ga6VAEOsgFtGyjtuRSFmqyNDue5+VaIKmOa7ClI4guSJXMtfrImwTkGw00ZI4TVw0HwugK1UbVcDCA+yRdX5iPKgDrHPyS/pDKXSYueP+D5GaUBzwNWWmXEw3cD9fb6NuLK1JGOEPWA8hIXD8g7HnUbHVdVcMw9fBi70iTvFpq9kBWox/uIxnTmwJOa/WGNWiQkC3qpdO8b5iSqpHy1dM50YUJruUSs8=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a3f6546-8644-4479-b98a-08d68e5df929
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2019 07:12:35.3427
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3128
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

Moved '/driver/staging/wilc1000/wilc_netdev.c' to
'drivers/net/wireless/microchip/wilc1000/'.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 .../net/wireless/microchip/wilc1000/wilc_netdev.c  | 1079 ++++++++++++++++=
++++
 1 file changed, 1079 insertions(+)
 create mode 100644 drivers/net/wireless/microchip/wilc1000/wilc_netdev.c

diff --git a/drivers/net/wireless/microchip/wilc1000/wilc_netdev.c b/driver=
s/net/wireless/microchip/wilc1000/wilc_netdev.c
new file mode 100644
index 0000000..1787154
--- /dev/null
+++ b/drivers/net/wireless/microchip/wilc1000/wilc_netdev.c
@@ -0,0 +1,1079 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2012 - 2018 Microchip Technology Inc., and its subsidiari=
es.
+ * All rights reserved.
+ */
+
+#include <linux/irq.h>
+#include <linux/kthread.h>
+#include <linux/firmware.h>
+#include <linux/netdevice.h>
+#include <linux/inetdevice.h>
+
+#include "wilc_wfi_cfgoperations.h"
+
+#define WILC_MULTICAST_TABLE_SIZE	8
+
+static irqreturn_t isr_uh_routine(int irq, void *user_data)
+{
+	struct net_device *dev =3D user_data;
+	struct wilc_vif *vif =3D netdev_priv(dev);
+	struct wilc *wilc =3D vif->wilc;
+
+	if (wilc->close) {
+		netdev_err(dev, "Can't handle UH interrupt\n");
+		return IRQ_HANDLED;
+	}
+	return IRQ_WAKE_THREAD;
+}
+
+static irqreturn_t isr_bh_routine(int irq, void *userdata)
+{
+	struct net_device *dev =3D userdata;
+	struct wilc_vif *vif =3D netdev_priv(userdata);
+	struct wilc *wilc =3D vif->wilc;
+
+	if (wilc->close) {
+		netdev_err(dev, "Can't handle BH interrupt\n");
+		return IRQ_HANDLED;
+	}
+
+	wilc_handle_isr(wilc);
+
+	return IRQ_HANDLED;
+}
+
+static int init_irq(struct net_device *dev)
+{
+	int ret =3D 0;
+	struct wilc_vif *vif =3D netdev_priv(dev);
+	struct wilc *wl =3D vif->wilc;
+
+	ret =3D gpiod_direction_input(wl->gpio_irq);
+	if (ret) {
+		netdev_err(dev, "could not obtain gpio for WILC_INTR\n");
+		return ret;
+	}
+
+	wl->dev_irq_num =3D gpiod_to_irq(wl->gpio_irq);
+
+	ret =3D request_threaded_irq(wl->dev_irq_num, isr_uh_routine,
+				   isr_bh_routine,
+				   IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+				   "WILC_IRQ", dev);
+	if (ret < 0)
+		netdev_err(dev, "Failed to request IRQ\n");
+	else
+		netdev_dbg(dev, "IRQ request succeeded IRQ-NUM=3D %d\n",
+			   wl->dev_irq_num);
+
+	return ret;
+}
+
+static void deinit_irq(struct net_device *dev)
+{
+	struct wilc_vif *vif =3D netdev_priv(dev);
+	struct wilc *wilc =3D vif->wilc;
+
+	/* Deinitialize IRQ */
+	if (wilc->dev_irq_num)
+		free_irq(wilc->dev_irq_num, wilc);
+}
+
+void wilc_mac_indicate(struct wilc *wilc)
+{
+	s8 status;
+
+	wilc_wlan_cfg_get_val(wilc, WID_STATUS, &status, 1);
+	if (wilc->mac_status =3D=3D WILC_MAC_STATUS_INIT) {
+		wilc->mac_status =3D status;
+		complete(&wilc->sync_event);
+	} else {
+		wilc->mac_status =3D status;
+	}
+}
+
+static struct net_device *get_if_handler(struct wilc *wilc, u8 *mac_header=
)
+{
+	u8 *bssid, *bssid1;
+	int i =3D 0;
+
+	bssid =3D mac_header + 10;
+	bssid1 =3D mac_header + 4;
+
+	for (i =3D 0; i < wilc->vif_num; i++) {
+		if (wilc->vif[i]->mode =3D=3D WILC_STATION_MODE)
+			if (ether_addr_equal_unaligned(bssid,
+						       wilc->vif[i]->bssid))
+				return wilc->vif[i]->ndev;
+		if (wilc->vif[i]->mode =3D=3D WILC_AP_MODE)
+			if (ether_addr_equal_unaligned(bssid1,
+						       wilc->vif[i]->bssid))
+				return wilc->vif[i]->ndev;
+	}
+
+	return NULL;
+}
+
+void wilc_wlan_set_bssid(struct net_device *wilc_netdev, u8 *bssid, u8 mod=
e)
+{
+	struct wilc_vif *vif =3D netdev_priv(wilc_netdev);
+
+	if (bssid)
+		ether_addr_copy(vif->bssid, bssid);
+	else
+		eth_zero_addr(vif->bssid);
+
+	vif->mode =3D mode;
+}
+
+int wilc_wlan_get_num_conn_ifcs(struct wilc *wilc)
+{
+	u8 i =3D 0;
+	u8 ret_val =3D 0;
+
+	for (i =3D 0; i < wilc->vif_num; i++)
+		if (!is_zero_ether_addr(wilc->vif[i]->bssid))
+			ret_val++;
+
+	return ret_val;
+}
+
+static int wilc_txq_task(void *vp)
+{
+	int ret;
+	u32 txq_count;
+	struct net_device *dev =3D vp;
+	struct wilc_vif *vif =3D netdev_priv(dev);
+	struct wilc *wl =3D vif->wilc;
+
+	complete(&wl->txq_thread_started);
+	while (1) {
+		wait_for_completion(&wl->txq_event);
+
+		if (wl->close) {
+			complete(&wl->txq_thread_started);
+
+			while (!kthread_should_stop())
+				schedule();
+			break;
+		}
+		do {
+			ret =3D wilc_wlan_handle_txq(dev, &txq_count);
+			if (txq_count < FLOW_CONTROL_LOWER_THRESHOLD) {
+				if (wl->vif[0]->mac_opened &&
+				    netif_queue_stopped(wl->vif[0]->ndev))
+					netif_wake_queue(wl->vif[0]->ndev);
+				if (wl->vif[1]->mac_opened &&
+				    netif_queue_stopped(wl->vif[1]->ndev))
+					netif_wake_queue(wl->vif[1]->ndev);
+			}
+		} while (ret =3D=3D -ENOBUFS && !wl->close);
+	}
+	return 0;
+}
+
+static int wilc_wlan_get_firmware(struct net_device *dev)
+{
+	struct wilc_vif *vif =3D netdev_priv(dev);
+	struct wilc *wilc =3D vif->wilc;
+	int chip_id, ret =3D 0;
+	const struct firmware *wilc_firmware;
+	char *firmware;
+
+	chip_id =3D wilc_get_chipid(wilc, false);
+
+	if (chip_id < 0x1003a0)
+		firmware =3D FIRMWARE_1002;
+	else
+		firmware =3D FIRMWARE_1003;
+
+	netdev_info(dev, "loading firmware %s\n", firmware);
+
+	if (request_firmware(&wilc_firmware, firmware, wilc->dev) !=3D 0) {
+		netdev_err(dev, "%s - firmware not available\n", firmware);
+		ret =3D -1;
+		goto fail;
+	}
+	wilc->firmware =3D wilc_firmware;
+
+fail:
+
+	return ret;
+}
+
+static int wilc_start_firmware(struct net_device *dev)
+{
+	struct wilc_vif *vif =3D netdev_priv(dev);
+	struct wilc *wilc =3D vif->wilc;
+	int ret =3D 0;
+
+	ret =3D wilc_wlan_start(wilc);
+	if (ret < 0)
+		return ret;
+
+	if (!wait_for_completion_timeout(&wilc->sync_event,
+					 msecs_to_jiffies(5000)))
+		return -ETIME;
+
+	return 0;
+}
+
+static int wilc1000_firmware_download(struct net_device *dev)
+{
+	struct wilc_vif *vif =3D netdev_priv(dev);
+	struct wilc *wilc =3D vif->wilc;
+	int ret =3D 0;
+
+	if (!wilc->firmware) {
+		netdev_err(dev, "Firmware buffer is NULL\n");
+		return -ENOBUFS;
+	}
+
+	ret =3D wilc_wlan_firmware_download(wilc, wilc->firmware->data,
+					  wilc->firmware->size);
+	if (ret < 0)
+		return ret;
+
+	release_firmware(wilc->firmware);
+	wilc->firmware =3D NULL;
+
+	netdev_dbg(dev, "Download Succeeded\n");
+
+	return 0;
+}
+
+static int wilc_init_fw_config(struct net_device *dev, struct wilc_vif *vi=
f)
+{
+	struct wilc_priv *priv;
+	struct host_if_drv *hif_drv;
+	u8 b;
+	u16 hw;
+	u32 w;
+
+	netdev_dbg(dev, "Start configuring Firmware\n");
+	priv =3D wiphy_priv(dev->ieee80211_ptr->wiphy);
+	hif_drv =3D (struct host_if_drv *)priv->hif_drv;
+	netdev_dbg(dev, "Host =3D %p\n", hif_drv);
+
+	w =3D vif->iftype;
+	cpu_to_le32s(&w);
+	if (!wilc_wlan_cfg_set(vif, 1, WID_SET_OPERATION_MODE, (u8 *)&w, 4,
+			       0, 0))
+		goto fail;
+
+	b =3D WILC_FW_BSS_TYPE_INFRA;
+	if (!wilc_wlan_cfg_set(vif, 0, WID_BSS_TYPE, &b, 1, 0, 0))
+		goto fail;
+
+	b =3D WILC_FW_TX_RATE_AUTO;
+	if (!wilc_wlan_cfg_set(vif, 0, WID_CURRENT_TX_RATE, &b, 1, 0, 0))
+		goto fail;
+
+	b =3D WILC_FW_OPER_MODE_G_MIXED_11B_2;
+	if (!wilc_wlan_cfg_set(vif, 0, WID_11G_OPERATING_MODE, &b, 1, 0, 0))
+		goto fail;
+
+	b =3D WILC_FW_PREAMBLE_SHORT;
+	if (!wilc_wlan_cfg_set(vif, 0, WID_PREAMBLE, &b, 1, 0, 0))
+		goto fail;
+
+	b =3D WILC_FW_11N_PROT_AUTO;
+	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_PROT_MECH, &b, 1, 0, 0))
+		goto fail;
+
+	b =3D WILC_FW_ACTIVE_SCAN;
+	if (!wilc_wlan_cfg_set(vif, 0, WID_SCAN_TYPE, &b, 1, 0, 0))
+		goto fail;
+
+	b =3D WILC_FW_SITE_SURVEY_OFF;
+	if (!wilc_wlan_cfg_set(vif, 0, WID_SITE_SURVEY, &b, 1, 0, 0))
+		goto fail;
+
+	hw =3D 0xffff;
+	cpu_to_le16s(&hw);
+	if (!wilc_wlan_cfg_set(vif, 0, WID_RTS_THRESHOLD, (u8 *)&hw, 2, 0, 0))
+		goto fail;
+
+	hw =3D 2346;
+	cpu_to_le16s(&hw);
+	if (!wilc_wlan_cfg_set(vif, 0, WID_FRAG_THRESHOLD, (u8 *)&hw, 2, 0, 0))
+		goto fail;
+
+	b =3D 0;
+	if (!wilc_wlan_cfg_set(vif, 0, WID_BCAST_SSID, &b, 1, 0, 0))
+		goto fail;
+
+	b =3D 1;
+	if (!wilc_wlan_cfg_set(vif, 0, WID_QOS_ENABLE, &b, 1, 0, 0))
+		goto fail;
+
+	b =3D WILC_FW_NO_POWERSAVE;
+	if (!wilc_wlan_cfg_set(vif, 0, WID_POWER_MANAGEMENT, &b, 1, 0, 0))
+		goto fail;
+
+	b =3D WILC_FW_SEC_NO;
+	if (!wilc_wlan_cfg_set(vif, 0, WID_11I_MODE, &b, 1, 0, 0))
+		goto fail;
+
+	b =3D WILC_FW_AUTH_OPEN_SYSTEM;
+	if (!wilc_wlan_cfg_set(vif, 0, WID_AUTH_TYPE, &b, 1, 0, 0))
+		goto fail;
+
+	b =3D 3;
+	if (!wilc_wlan_cfg_set(vif, 0, WID_LISTEN_INTERVAL, &b, 1, 0, 0))
+		goto fail;
+
+	b =3D 3;
+	if (!wilc_wlan_cfg_set(vif, 0, WID_DTIM_PERIOD, &b, 1, 0, 0))
+		goto fail;
+
+	b =3D WILC_FW_ACK_POLICY_NORMAL;
+	if (!wilc_wlan_cfg_set(vif, 0, WID_ACK_POLICY, &b, 1, 0, 0))
+		goto fail;
+
+	b =3D 0;
+	if (!wilc_wlan_cfg_set(vif, 0, WID_USER_CONTROL_ON_TX_POWER, &b, 1,
+			       0, 0))
+		goto fail;
+
+	b =3D 48;
+	if (!wilc_wlan_cfg_set(vif, 0, WID_TX_POWER_LEVEL_11A, &b, 1, 0, 0))
+		goto fail;
+
+	b =3D 28;
+	if (!wilc_wlan_cfg_set(vif, 0, WID_TX_POWER_LEVEL_11B, &b, 1, 0, 0))
+		goto fail;
+
+	hw =3D 100;
+	cpu_to_le16s(&hw);
+	if (!wilc_wlan_cfg_set(vif, 0, WID_BEACON_INTERVAL, (u8 *)&hw, 2, 0, 0))
+		goto fail;
+
+	b =3D WILC_FW_REKEY_POLICY_DISABLE;
+	if (!wilc_wlan_cfg_set(vif, 0, WID_REKEY_POLICY, &b, 1, 0, 0))
+		goto fail;
+
+	w =3D 84600;
+	cpu_to_le32s(&w);
+	if (!wilc_wlan_cfg_set(vif, 0, WID_REKEY_PERIOD, (u8 *)&w, 4, 0, 0))
+		goto fail;
+
+	w =3D 500;
+	cpu_to_le32s(&w);
+	if (!wilc_wlan_cfg_set(vif, 0, WID_REKEY_PACKET_COUNT, (u8 *)&w, 4, 0,
+			       0))
+		goto fail;
+
+	b =3D 1;
+	if (!wilc_wlan_cfg_set(vif, 0, WID_SHORT_SLOT_ALLOWED, &b, 1, 0,
+			       0))
+		goto fail;
+
+	b =3D WILC_FW_ERP_PROT_SELF_CTS;
+	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_ERP_PROT_TYPE, &b, 1, 0, 0))
+		goto fail;
+
+	b =3D 1;
+	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_ENABLE, &b, 1, 0, 0))
+		goto fail;
+
+	b =3D WILC_FW_11N_OP_MODE_HT_MIXED;
+	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_OPERATING_MODE, &b, 1, 0, 0))
+		goto fail;
+
+	b =3D 1;
+	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_TXOP_PROT_DISABLE, &b, 1, 0, 0))
+		goto fail;
+
+	b =3D WILC_FW_OBBS_NONHT_DETECT_PROTECT_REPORT;
+	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_OBSS_NONHT_DETECTION, &b, 1,
+			       0, 0))
+		goto fail;
+
+	b =3D WILC_FW_HT_PROT_RTS_CTS_NONHT;
+	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_HT_PROT_TYPE, &b, 1, 0, 0))
+		goto fail;
+
+	b =3D 0;
+	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_RIFS_PROT_ENABLE, &b, 1, 0,
+			       0))
+		goto fail;
+
+	b =3D 7;
+	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_CURRENT_TX_MCS, &b, 1, 0, 0))
+		goto fail;
+
+	b =3D 1;
+	if (!wilc_wlan_cfg_set(vif, 0, WID_11N_IMMEDIATE_BA_ENABLED, &b, 1,
+			       1, 1))
+		goto fail;
+
+	return 0;
+
+fail:
+	return -1;
+}
+
+static void wlan_deinit_locks(struct net_device *dev)
+{
+	struct wilc_vif *vif =3D netdev_priv(dev);
+	struct wilc *wilc =3D vif->wilc;
+
+	mutex_destroy(&wilc->hif_cs);
+	mutex_destroy(&wilc->rxq_cs);
+	mutex_destroy(&wilc->cfg_cmd_lock);
+	mutex_destroy(&wilc->txq_add_to_head_cs);
+}
+
+static void wlan_deinitialize_threads(struct net_device *dev)
+{
+	struct wilc_vif *vif =3D netdev_priv(dev);
+	struct wilc *wl =3D vif->wilc;
+
+	wl->close =3D 1;
+
+	complete(&wl->txq_event);
+
+	if (wl->txq_thread) {
+		kthread_stop(wl->txq_thread);
+		wl->txq_thread =3D NULL;
+	}
+}
+
+static void wilc_wlan_deinitialize(struct net_device *dev)
+{
+	struct wilc_vif *vif =3D netdev_priv(dev);
+	struct wilc *wl =3D vif->wilc;
+
+	if (!wl) {
+		netdev_err(dev, "wl is NULL\n");
+		return;
+	}
+
+	if (wl->initialized) {
+		netdev_info(dev, "Deinitializing wilc1000...\n");
+
+		if (!wl->dev_irq_num &&
+		    wl->hif_func->disable_interrupt) {
+			mutex_lock(&wl->hif_cs);
+			wl->hif_func->disable_interrupt(wl);
+			mutex_unlock(&wl->hif_cs);
+		}
+		complete(&wl->txq_event);
+
+		wlan_deinitialize_threads(dev);
+		deinit_irq(dev);
+
+		wilc_wlan_stop(wl);
+		wilc_wlan_cleanup(dev);
+		wlan_deinit_locks(dev);
+
+		wl->initialized =3D false;
+
+		netdev_dbg(dev, "wilc1000 deinitialization Done\n");
+	} else {
+		netdev_dbg(dev, "wilc1000 is not initialized\n");
+	}
+}
+
+static void wlan_init_locks(struct net_device *dev)
+{
+	struct wilc_vif *vif =3D netdev_priv(dev);
+	struct wilc *wl =3D vif->wilc;
+
+	mutex_init(&wl->hif_cs);
+	mutex_init(&wl->rxq_cs);
+	mutex_init(&wl->cfg_cmd_lock);
+
+	spin_lock_init(&wl->txq_spinlock);
+	mutex_init(&wl->txq_add_to_head_cs);
+
+	init_completion(&wl->txq_event);
+
+	init_completion(&wl->cfg_event);
+	init_completion(&wl->sync_event);
+	init_completion(&wl->txq_thread_started);
+}
+
+static int wlan_initialize_threads(struct net_device *dev)
+{
+	struct wilc_vif *vif =3D netdev_priv(dev);
+	struct wilc *wilc =3D vif->wilc;
+
+	wilc->txq_thread =3D kthread_run(wilc_txq_task, (void *)dev,
+				       "K_TXQ_TASK");
+	if (IS_ERR(wilc->txq_thread)) {
+		netdev_err(dev, "couldn't create TXQ thread\n");
+		wilc->close =3D 0;
+		return PTR_ERR(wilc->txq_thread);
+	}
+	wait_for_completion(&wilc->txq_thread_started);
+
+	return 0;
+}
+
+static int wilc_wlan_initialize(struct net_device *dev, struct wilc_vif *v=
if)
+{
+	int ret =3D 0;
+	struct wilc *wl =3D vif->wilc;
+
+	if (!wl->initialized) {
+		wl->mac_status =3D WILC_MAC_STATUS_INIT;
+		wl->close =3D 0;
+
+		wlan_init_locks(dev);
+
+		ret =3D wilc_wlan_init(dev);
+		if (ret < 0) {
+			ret =3D -EIO;
+			goto fail_locks;
+		}
+
+		if (wl->gpio_irq && init_irq(dev)) {
+			ret =3D -EIO;
+			goto fail_locks;
+		}
+
+		ret =3D wlan_initialize_threads(dev);
+		if (ret < 0) {
+			ret =3D -EIO;
+			goto fail_wilc_wlan;
+		}
+
+		if (!wl->dev_irq_num &&
+		    wl->hif_func->enable_interrupt &&
+		    wl->hif_func->enable_interrupt(wl)) {
+			ret =3D -EIO;
+			goto fail_irq_init;
+		}
+
+		if (wilc_wlan_get_firmware(dev)) {
+			ret =3D -EIO;
+			goto fail_irq_enable;
+		}
+
+		ret =3D wilc1000_firmware_download(dev);
+		if (ret < 0) {
+			ret =3D -EIO;
+			goto fail_irq_enable;
+		}
+
+		ret =3D wilc_start_firmware(dev);
+		if (ret < 0) {
+			ret =3D -EIO;
+			goto fail_irq_enable;
+		}
+
+		if (wilc_wlan_cfg_get(vif, 1, WID_FIRMWARE_VERSION, 1, 0)) {
+			int size;
+			char firmware_ver[20];
+
+			size =3D wilc_wlan_cfg_get_val(wl, WID_FIRMWARE_VERSION,
+						     firmware_ver,
+						     sizeof(firmware_ver));
+			firmware_ver[size] =3D '\0';
+			netdev_dbg(dev, "Firmware Ver =3D %s\n", firmware_ver);
+		}
+		ret =3D wilc_init_fw_config(dev, vif);
+
+		if (ret < 0) {
+			netdev_err(dev, "Failed to configure firmware\n");
+			ret =3D -EIO;
+			goto fail_fw_start;
+		}
+
+		wl->initialized =3D true;
+		return 0;
+
+fail_fw_start:
+		wilc_wlan_stop(wl);
+
+fail_irq_enable:
+		if (!wl->dev_irq_num &&
+		    wl->hif_func->disable_interrupt)
+			wl->hif_func->disable_interrupt(wl);
+fail_irq_init:
+		if (wl->dev_irq_num)
+			deinit_irq(dev);
+
+		wlan_deinitialize_threads(dev);
+fail_wilc_wlan:
+		wilc_wlan_cleanup(dev);
+fail_locks:
+		wlan_deinit_locks(dev);
+		netdev_err(dev, "WLAN initialization FAILED\n");
+	} else {
+		netdev_dbg(dev, "wilc1000 already initialized\n");
+	}
+	return ret;
+}
+
+static int mac_init_fn(struct net_device *ndev)
+{
+	netif_start_queue(ndev);
+	netif_stop_queue(ndev);
+
+	return 0;
+}
+
+static int wilc_mac_open(struct net_device *ndev)
+{
+	struct wilc_vif *vif =3D netdev_priv(ndev);
+	struct wilc *wl =3D vif->wilc;
+	struct wilc_priv *priv =3D wdev_priv(vif->ndev->ieee80211_ptr);
+	unsigned char mac_add[ETH_ALEN] =3D {0};
+	int ret =3D 0;
+	int i =3D 0;
+
+	if (!wl || !wl->dev) {
+		netdev_err(ndev, "device not ready\n");
+		return -ENODEV;
+	}
+
+	netdev_dbg(ndev, "MAC OPEN[%p]\n", ndev);
+
+	ret =3D wilc_init_host_int(ndev);
+	if (ret < 0)
+		return ret;
+
+	ret =3D wilc_wlan_initialize(ndev, vif);
+	if (ret < 0) {
+		wilc_deinit_host_int(ndev);
+		return ret;
+	}
+
+	for (i =3D 0; i < wl->vif_num; i++) {
+		if (ndev =3D=3D wl->vif[i]->ndev) {
+			wilc_set_wfi_drv_handler(vif, wilc_get_vif_idx(vif),
+						 vif->iftype, vif->ifc_id);
+			wilc_set_operation_mode(vif, vif->iftype);
+			break;
+		}
+	}
+
+	wilc_get_mac_address(vif, mac_add);
+	netdev_dbg(ndev, "Mac address: %pM\n", mac_add);
+	memcpy(wl->vif[i]->src_addr, mac_add, ETH_ALEN);
+	memcpy(ndev->dev_addr, wl->vif[i]->src_addr, ETH_ALEN);
+
+	if (!is_valid_ether_addr(ndev->dev_addr)) {
+		netdev_err(ndev, "Wrong MAC address\n");
+		wilc_deinit_host_int(ndev);
+		wilc_wlan_deinitialize(ndev);
+		return -EINVAL;
+	}
+
+	wilc_mgmt_frame_register(vif->ndev->ieee80211_ptr->wiphy,
+				 vif->ndev->ieee80211_ptr,
+				 vif->frame_reg[0].type,
+				 vif->frame_reg[0].reg);
+	wilc_mgmt_frame_register(vif->ndev->ieee80211_ptr->wiphy,
+				 vif->ndev->ieee80211_ptr,
+				 vif->frame_reg[1].type,
+				 vif->frame_reg[1].reg);
+	netif_wake_queue(ndev);
+	wl->open_ifcs++;
+	priv->p2p.local_random =3D 0x01;
+	vif->mac_opened =3D 1;
+	return 0;
+}
+
+static struct net_device_stats *mac_stats(struct net_device *dev)
+{
+	struct wilc_vif *vif =3D netdev_priv(dev);
+
+	return &vif->netstats;
+}
+
+static void wilc_set_multicast_list(struct net_device *dev)
+{
+	struct netdev_hw_addr *ha;
+	struct wilc_vif *vif =3D netdev_priv(dev);
+	int i;
+	u8 *mc_list;
+	u8 *cur_mc;
+
+	if (dev->flags & IFF_PROMISC)
+		return;
+
+	if (dev->flags & IFF_ALLMULTI ||
+	    dev->mc.count > WILC_MULTICAST_TABLE_SIZE) {
+		wilc_setup_multicast_filter(vif, 0, 0, NULL);
+		return;
+	}
+
+	if (dev->mc.count =3D=3D 0) {
+		wilc_setup_multicast_filter(vif, 1, 0, NULL);
+		return;
+	}
+
+	mc_list =3D kmalloc_array(dev->mc.count, ETH_ALEN, GFP_KERNEL);
+	if (!mc_list)
+		return;
+
+	cur_mc =3D mc_list;
+	i =3D 0;
+	netdev_for_each_mc_addr(ha, dev) {
+		memcpy(cur_mc, ha->addr, ETH_ALEN);
+		netdev_dbg(dev, "Entry[%d]: %pM\n", i, cur_mc);
+		i++;
+		cur_mc +=3D ETH_ALEN;
+	}
+
+	if (wilc_setup_multicast_filter(vif, 1, dev->mc.count, mc_list))
+		kfree(mc_list);
+}
+
+static void wilc_tx_complete(void *priv, int status)
+{
+	struct tx_complete_data *pv_data =3D priv;
+
+	dev_kfree_skb(pv_data->skb);
+	kfree(pv_data);
+}
+
+netdev_tx_t wilc_mac_xmit(struct sk_buff *skb, struct net_device *ndev)
+{
+	struct wilc_vif *vif =3D netdev_priv(ndev);
+	struct wilc *wilc =3D vif->wilc;
+	struct tx_complete_data *tx_data =3D NULL;
+	int queue_count;
+
+	if (skb->dev !=3D ndev) {
+		netdev_err(ndev, "Packet not destined to this device\n");
+		return 0;
+	}
+
+	tx_data =3D kmalloc(sizeof(*tx_data), GFP_ATOMIC);
+	if (!tx_data) {
+		dev_kfree_skb(skb);
+		netif_wake_queue(ndev);
+		return 0;
+	}
+
+	tx_data->buff =3D skb->data;
+	tx_data->size =3D skb->len;
+	tx_data->skb  =3D skb;
+
+	vif->netstats.tx_packets++;
+	vif->netstats.tx_bytes +=3D tx_data->size;
+	tx_data->bssid =3D wilc->vif[vif->idx]->bssid;
+	queue_count =3D wilc_wlan_txq_add_net_pkt(ndev, (void *)tx_data,
+						tx_data->buff, tx_data->size,
+						wilc_tx_complete);
+
+	if (queue_count > FLOW_CONTROL_UPPER_THRESHOLD) {
+		if (wilc->vif[0]->mac_opened)
+			netif_stop_queue(wilc->vif[0]->ndev);
+		if (wilc->vif[1]->mac_opened)
+			netif_stop_queue(wilc->vif[1]->ndev);
+	}
+
+	return 0;
+}
+
+static int wilc_mac_close(struct net_device *ndev)
+{
+	struct wilc_vif *vif =3D netdev_priv(ndev);
+	struct wilc *wl =3D vif->wilc;
+
+	netdev_dbg(ndev, "Mac close\n");
+
+	if (wl->open_ifcs > 0)
+		wl->open_ifcs--;
+	else
+		return 0;
+
+	if (vif->ndev) {
+		netif_stop_queue(vif->ndev);
+
+		wilc_deinit_host_int(vif->ndev);
+	}
+
+	if (wl->open_ifcs =3D=3D 0) {
+		netdev_dbg(ndev, "Deinitializing wilc1000\n");
+		wl->close =3D 1;
+		wilc_wlan_deinitialize(ndev);
+	}
+
+	vif->mac_opened =3D 0;
+
+	return 0;
+}
+
+void wilc_frmw_to_host(struct wilc *wilc, u8 *buff, u32 size,
+		       u32 pkt_offset)
+{
+	unsigned int frame_len =3D 0;
+	int stats;
+	unsigned char *buff_to_send =3D NULL;
+	struct sk_buff *skb;
+	struct net_device *wilc_netdev;
+	struct wilc_vif *vif;
+
+	if (!wilc)
+		return;
+
+	wilc_netdev =3D get_if_handler(wilc, buff);
+	if (!wilc_netdev)
+		return;
+
+	buff +=3D pkt_offset;
+	vif =3D netdev_priv(wilc_netdev);
+
+	if (size > 0) {
+		frame_len =3D size;
+		buff_to_send =3D buff;
+
+		skb =3D dev_alloc_skb(frame_len);
+		if (!skb)
+			return;
+
+		skb->dev =3D wilc_netdev;
+
+		skb_put_data(skb, buff_to_send, frame_len);
+
+		skb->protocol =3D eth_type_trans(skb, wilc_netdev);
+		vif->netstats.rx_packets++;
+		vif->netstats.rx_bytes +=3D frame_len;
+		skb->ip_summed =3D CHECKSUM_UNNECESSARY;
+		stats =3D netif_rx(skb);
+		netdev_dbg(wilc_netdev, "netif_rx ret value is: %d\n", stats);
+	}
+}
+
+void wilc_wfi_mgmt_rx(struct wilc *wilc, u8 *buff, u32 size)
+{
+	int i =3D 0;
+	struct wilc_vif *vif;
+
+	for (i =3D 0; i < wilc->vif_num; i++) {
+		vif =3D netdev_priv(wilc->vif[i]->ndev);
+		if (vif->monitor_flag) {
+			wilc_wfi_monitor_rx(wilc->monitor_dev, buff, size);
+			return;
+		}
+	}
+
+	vif =3D netdev_priv(wilc->vif[1]->ndev);
+	if ((buff[0] =3D=3D vif->frame_reg[0].type && vif->frame_reg[0].reg) ||
+	    (buff[0] =3D=3D vif->frame_reg[1].type && vif->frame_reg[1].reg))
+		wilc_wfi_p2p_rx(wilc->vif[1]->ndev, buff, size);
+}
+
+static const struct net_device_ops wilc_netdev_ops =3D {
+	.ndo_init =3D mac_init_fn,
+	.ndo_open =3D wilc_mac_open,
+	.ndo_stop =3D wilc_mac_close,
+	.ndo_start_xmit =3D wilc_mac_xmit,
+	.ndo_get_stats =3D mac_stats,
+	.ndo_set_rx_mode  =3D wilc_set_multicast_list,
+};
+
+static int dev_state_ev_handler(struct notifier_block *this,
+				unsigned long event, void *ptr)
+{
+	struct in_ifaddr *dev_iface =3D ptr;
+	struct wilc_priv *priv;
+	struct host_if_drv *hif_drv;
+	struct net_device *dev;
+	struct wilc_vif *vif;
+
+	if (!dev_iface || !dev_iface->ifa_dev || !dev_iface->ifa_dev->dev)
+		return NOTIFY_DONE;
+
+	dev  =3D (struct net_device *)dev_iface->ifa_dev->dev;
+	if (dev->netdev_ops !=3D &wilc_netdev_ops)
+		return NOTIFY_DONE;
+
+	if (!dev->ieee80211_ptr || !dev->ieee80211_ptr->wiphy)
+		return NOTIFY_DONE;
+
+	priv =3D wiphy_priv(dev->ieee80211_ptr->wiphy);
+	if (!priv)
+		return NOTIFY_DONE;
+
+	hif_drv =3D (struct host_if_drv *)priv->hif_drv;
+	vif =3D netdev_priv(dev);
+	if (!vif || !hif_drv)
+		return NOTIFY_DONE;
+
+	switch (event) {
+	case NETDEV_UP:
+		if (vif->iftype =3D=3D WILC_STATION_MODE ||
+		    vif->iftype =3D=3D WILC_CLIENT_MODE) {
+			hif_drv->ifc_up =3D 1;
+			vif->obtaining_ip =3D false;
+			del_timer(&vif->during_ip_timer);
+		}
+
+		if (vif->wilc->enable_ps)
+			wilc_set_power_mgmt(vif, 1, 0);
+
+		break;
+
+	case NETDEV_DOWN:
+		if (vif->iftype =3D=3D WILC_STATION_MODE ||
+		    vif->iftype =3D=3D WILC_CLIENT_MODE) {
+			hif_drv->ifc_up =3D 0;
+			vif->obtaining_ip =3D false;
+			wilc_set_power_mgmt(vif, 0, 0);
+		}
+
+		wilc_resolve_disconnect_aberration(vif);
+
+		break;
+
+	default:
+		break;
+	}
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block g_dev_notifier =3D {
+	.notifier_call =3D dev_state_ev_handler
+};
+
+void wilc_netdev_cleanup(struct wilc *wilc)
+{
+	int i;
+
+	if (!wilc)
+		return;
+
+	if (wilc->vif[0]->ndev || wilc->vif[1]->ndev)
+		unregister_inetaddr_notifier(&g_dev_notifier);
+
+	if (wilc->firmware) {
+		release_firmware(wilc->firmware);
+		wilc->firmware =3D NULL;
+	}
+
+	for (i =3D 0; i < WILC_NUM_CONCURRENT_IFC; i++) {
+		if (wilc->vif[i] && wilc->vif[i]->ndev) {
+			unregister_netdev(wilc->vif[i]->ndev);
+			wilc_free_wiphy(wilc->vif[i]->ndev);
+			free_netdev(wilc->vif[i]->ndev);
+		}
+	}
+
+	wilc_wfi_deinit_mon_interface(wilc);
+	flush_workqueue(wilc->hif_workqueue);
+	destroy_workqueue(wilc->hif_workqueue);
+	wilc_wlan_cfg_deinit(wilc);
+	kfree(wilc->bus_data);
+	kfree(wilc);
+}
+EXPORT_SYMBOL_GPL(wilc_netdev_cleanup);
+
+int wilc_netdev_init(struct wilc **wilc, struct device *dev, int io_type,
+		     const struct wilc_hif_func *ops)
+{
+	int i, ret;
+	struct wilc_vif *vif;
+	struct net_device *ndev;
+	struct wilc *wl;
+
+	wl =3D kzalloc(sizeof(*wl), GFP_KERNEL);
+	if (!wl)
+		return -ENOMEM;
+
+	ret =3D wilc_wlan_cfg_init(wl);
+	if (ret)
+		goto free_wl;
+
+	*wilc =3D wl;
+	wl->io_type =3D io_type;
+	wl->hif_func =3D ops;
+	wl->enable_ps =3D true;
+	wl->chip_ps_state =3D WILC_CHIP_WAKEDUP;
+	INIT_LIST_HEAD(&wl->txq_head.list);
+	INIT_LIST_HEAD(&wl->rxq_head.list);
+
+	wl->hif_workqueue =3D create_singlethread_workqueue("WILC_wq");
+	if (!wl->hif_workqueue) {
+		ret =3D -ENOMEM;
+		goto free_cfg;
+	}
+
+	register_inetaddr_notifier(&g_dev_notifier);
+
+	for (i =3D 0; i < WILC_NUM_CONCURRENT_IFC; i++) {
+		struct wireless_dev *wdev;
+
+		ndev =3D alloc_etherdev(sizeof(struct wilc_vif));
+		if (!ndev) {
+			ret =3D -ENOMEM;
+			goto free_ndev;
+		}
+
+		vif =3D netdev_priv(ndev);
+		memset(vif, 0, sizeof(struct wilc_vif));
+
+		if (i =3D=3D 0) {
+			strcpy(ndev->name, "wlan%d");
+			vif->ifc_id =3D 1;
+		} else {
+			strcpy(ndev->name, "p2p%d");
+			vif->ifc_id =3D 0;
+		}
+		vif->wilc =3D *wilc;
+		vif->ndev =3D ndev;
+		wl->vif[i] =3D vif;
+		wl->vif_num =3D i + 1;
+		vif->idx =3D i;
+
+		ndev->netdev_ops =3D &wilc_netdev_ops;
+
+		wdev =3D wilc_create_wiphy(ndev, dev);
+		if (!wdev) {
+			netdev_err(ndev, "Can't register WILC Wiphy\n");
+			ret =3D -ENOMEM;
+			goto free_ndev;
+		}
+
+		SET_NETDEV_DEV(ndev, dev);
+
+		vif->ndev->ieee80211_ptr =3D wdev;
+		vif->ndev->ml_priv =3D vif;
+		wdev->netdev =3D vif->ndev;
+		vif->netstats.rx_packets =3D 0;
+		vif->netstats.tx_packets =3D 0;
+		vif->netstats.rx_bytes =3D 0;
+		vif->netstats.tx_bytes =3D 0;
+
+		ret =3D register_netdev(ndev);
+		if (ret)
+			goto free_ndev;
+
+		vif->iftype =3D WILC_STATION_MODE;
+		vif->mac_opened =3D 0;
+	}
+
+	return 0;
+
+free_ndev:
+	for (; i >=3D 0; i--) {
+		if (wl->vif[i]) {
+			if (wl->vif[i]->iftype =3D=3D WILC_STATION_MODE)
+				unregister_netdev(wl->vif[i]->ndev);
+
+			if (wl->vif[i]->ndev) {
+				wilc_free_wiphy(wl->vif[i]->ndev);
+				free_netdev(wl->vif[i]->ndev);
+			}
+		}
+	}
+	unregister_inetaddr_notifier(&g_dev_notifier);
+	destroy_workqueue(wl->hif_workqueue);
+free_cfg:
+	wilc_wlan_cfg_deinit(wl);
+free_wl:
+	kfree(wl);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(wilc_netdev_init);
+
+MODULE_LICENSE("GPL");
--=20
2.7.4

