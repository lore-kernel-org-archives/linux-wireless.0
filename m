Return-Path: <SRS0=TNca=MO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5676C004D2
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 09:26:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8ECB020878
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 09:26:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="2m7fLpnn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8ECB020878
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbeJBQIa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Oct 2018 12:08:30 -0400
Received: from mail-cys01nam02on0082.outbound.protection.outlook.com ([104.47.37.82]:22848
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726317AbeJBQI3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Oct 2018 12:08:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z4vbOPmahAPB4BB6YqJed3+aGFtO+9yHdBIl+Git34A=;
 b=2m7fLpnnTPZSQL0EZSV9NYrRAlEs60tNr+ZN9xmGMKBPYd+BnS3yYVelnpBaxLAa0TyPuBehAd1QZ7qjQW5gMkB9qN7CIBUxeQg8rPDJfgGok/DuEVhD7AwkjghtUtP7qxoGDxG165cFyp3nEoD0p3NdEin3JRbqPghwX5Bazk4=
Received: from BL0PR05MB4595.namprd05.prod.outlook.com (20.177.144.212) by
 BL0PR05MB4849.namprd05.prod.outlook.com (52.132.15.31) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1207.17; Tue, 2 Oct 2018 09:26:00 +0000
Received: from BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::58a1:7de3:62b:f06a]) by BL0PR05MB4595.namprd05.prod.outlook.com
 ([fe80::58a1:7de3:62b:f06a%3]) with mapi id 15.20.1185.024; Tue, 2 Oct 2018
 09:26:00 +0000
From:   Sergey Matyukevich OS <sergey.matyukevich.os@quantenna.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     Igor Mitsyanko OS <igor.mitsyanko.os@quantenna.com>,
        Sergey Matyukevich OS <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 05/13] qtnfmac: cleanup and unify command error handling
Thread-Topic: [PATCH 05/13] qtnfmac: cleanup and unify command error handling
Thread-Index: AQHUWjHuTZzjrV0VEkGcpNp0bvyXNA==
Date:   Tue, 2 Oct 2018 09:26:00 +0000
Message-ID: <20181002092542.18966-6-sergey.matyukevich.os@quantenna.com>
References: <20181002092542.18966-1-sergey.matyukevich.os@quantenna.com>
In-Reply-To: <20181002092542.18966-1-sergey.matyukevich.os@quantenna.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5PR06CA0023.eurprd06.prod.outlook.com
 (2603:10a6:206:2::36) To BL0PR05MB4595.namprd05.prod.outlook.com
 (2603:10b6:208:5f::20)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BL0PR05MB4849;6:QMIQWT3pEEqv3CLzOFGIlWakZ3buZTwELINKqKIC95quCbShrpTxS8stQn3zbHmO5D9wRROFo4oHTxmVr945laBZ8GXv9KulFhJdmWLuRCd4MPI3s3fJ7JI8VblBBLPG4CAyAIfmg+2iWiRSysmNxprdtCJitFkXT64iD0ZikUhkp7LteRQFWZcOE2sWpI4CfwsxZXYUqBnekj4K2n0wK5rQd6lbMfuo9y5iMOtfj/v/Ok9e9+lbzuhi5DjvaRNPmR6WiqrSosejnYbTc8DipA7HN3N6Sw34pjLOmf6Mpo6enCbpJqaGwAtPFeiN6Aoo1g/Qn36rErwcurAJSumcTI71o4oPKY1c+52y//nfD3MPTn+excLJDmPBarglGpzz29kEcuWTKMunxhHQHrpwjofl6pCJgSv1CkvyOW8IDyr5/W1mzjPoOLaQxr12TzVekfs0MBJizB0Edkl0Ese9IA==;5:mvs2Syq4AwG0Fghvsqx/jf1IQplMViB83m/oB6b8lsUwAeo+ZUcV9o6COPppAgzudB1gotSn9hm3/t4tX5Sk1e1kf0J7GG0CwzQeIoRwQPTevyM/cjYvLZ5cXWpmhYrvXvQNb3rEAsTrTu87Ut1jCsa00EakqErQ3gbIvH02NqU=;7:DFJR6CZbi7ad4TVst23KUYczgsDlHlm+7DeLuwhcVmUKdio/oFwIMPna7klGZJAwx93CtqyeWPHAHXecqkhMI9iDrnIIRkYbXo0E8D40bSeJ4nEFFK2aMKuPJj9hT7rIYeQ8enwIOOJD1qkoQEiNv3zSjst1RShifJWzbYIwBnsBVPqkPS5+eqBrjl2bjVkJV8qVewbJo4xXMT7d+njiN4cEYPMKr5PNwTDwzVGG5AkBwoKWbKbNXE46qLjwpAAJ
x-ms-office365-filtering-correlation-id: 7903c605-e04f-4058-d636-08d6284910cd
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534165)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BL0PR05MB4849;
x-ms-traffictypediagnostic: BL0PR05MB4849:
x-microsoft-antispam-prvs: <BL0PR05MB48497629987733C09003B08CA3E80@BL0PR05MB4849.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(21532816269658)(269456686620040);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(3231355)(944501410)(52105095)(3002001)(93006095)(93001095)(10201501046)(149066)(150057)(6041310)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123562045)(20161123564045)(20161123560045)(20161123558120)(201708071742011)(7699051)(76991041);SRVR:BL0PR05MB4849;BCL:0;PCL:0;RULEID:;SRVR:BL0PR05MB4849;
x-forefront-prvs: 0813C68E65
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(376002)(39840400004)(136003)(396003)(366004)(199004)(189003)(11346002)(106356001)(14454004)(446003)(66066001)(486006)(5660300001)(5024004)(14444005)(6916009)(54906003)(478600001)(2616005)(476003)(256004)(68736007)(105586002)(26005)(186003)(305945005)(103116003)(8936002)(102836004)(8676002)(81156014)(81166006)(316002)(6346003)(2906002)(7736002)(2351001)(25786009)(4326008)(36756003)(5640700003)(107886003)(86362001)(53936002)(6436002)(6486002)(16200700003)(99286004)(53946003)(6512007)(97736004)(6506007)(52116002)(386003)(4744004)(71200400001)(76176011)(2501003)(71190400001)(5250100002)(1076002)(3846002)(6116002)(2900100001)(579004)(569006);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR05MB4849;H:BL0PR05MB4595.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-microsoft-antispam-message-info: R/HI84rU8RjE9mnIsuMGgJbz3zosqSF2fVYzKZqx2qeJBYJRBcrPwpOFN/e7wIK/IZeV5tmZwqSRgm5o2Boi0WOryn2X8lnbxTBZiO3Mt9gRvKae+kuaGl6m6lpBw9+GW4Q9jWm3xjpUcI8g4PCvzyeGpV9Sglt+ZKhyGLJXT5vEA6rysGDeXtHjFhggbSLi7Tune3b6FtpnIVwBc5DPkUmx0eldn9hzeKDwtOHQ51zgKvMo87snd8fQzlhsQ0tsgDgSBkjYqTdjIHxvJ707OL/Mh+rCCrxsoP6C7VH+I6TZ23jg852lKg3sIAoMtj4Ddg3we/AvG7dosRhdsJ1v5Gqfoig2daqcy1VZ1nmIikE=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7903c605-e04f-4058-d636-08d6284910cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Oct 2018 09:26:00.5947
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR05MB4849
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Unify command error handling using qtnf_cmd_resp_result_decode
function. Do not duplicate error messages in command handlers
and cfg80211 callbacks: report 'cmd exec fail' only on control
path internal failure. Remove redundant 'unlikely' macros.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c |  64 ++-
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 518 +++++-------------=
----
 2 files changed, 149 insertions(+), 433 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/ne=
t/wireless/quantenna/qtnfmac/cfg80211.c
index c4961e16d91a..4631277092bf 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -141,8 +141,8 @@ qtnf_change_virtual_intf(struct wiphy *wiphy,
=20
 	ret =3D qtnf_cmd_send_change_intf_type(vif, type, mac_addr);
 	if (ret) {
-		pr_err("VIF%u.%u: failed to change VIF type: %d\n",
-		       vif->mac->macid, vif->vifid, ret);
+		pr_err("VIF%u.%u: failed to change type to %d\n",
+		       vif->mac->macid, vif->vifid, type);
 		return ret;
 	}
=20
@@ -228,18 +228,22 @@ static struct wireless_dev *qtnf_add_virtual_intf(str=
uct wiphy *wiphy,
 	if (params)
 		mac_addr =3D params->macaddr;
=20
-	if (qtnf_cmd_send_add_intf(vif, type, mac_addr)) {
-		pr_err("VIF%u.%u: failed to add VIF\n", mac->macid, vif->vifid);
+	ret =3D qtnf_cmd_send_add_intf(vif, type, mac_addr);
+	if (ret) {
+		pr_err("VIF%u.%u: failed to add VIF %pM\n",
+		       mac->macid, vif->vifid, mac_addr);
 		goto err_cmd;
 	}
=20
 	if (!is_valid_ether_addr(vif->mac_addr)) {
 		pr_err("VIF%u.%u: FW reported bad MAC: %pM\n",
 		       mac->macid, vif->vifid, vif->mac_addr);
+		ret =3D -EINVAL;
 		goto err_mac;
 	}
=20
-	if (qtnf_core_net_attach(mac, vif, name, name_assign_t)) {
+	ret =3D qtnf_core_net_attach(mac, vif, name, name_assign_t);
+	if (ret) {
 		pr_err("VIF%u.%u: failed to attach netdev\n", mac->macid,
 		       vif->vifid);
 		goto err_net;
@@ -255,7 +259,7 @@ static struct wireless_dev *qtnf_add_virtual_intf(struc=
t wiphy *wiphy,
 err_cmd:
 	vif->wdev.iftype =3D NL80211_IFTYPE_UNSPECIFIED;
=20
-	return ERR_PTR(-EFAULT);
+	return ERR_PTR(ret);
 }
=20
 static int qtnf_mgmt_set_appie(struct qtnf_vif *vif,
@@ -334,12 +338,11 @@ static int qtnf_stop_ap(struct wiphy *wiphy, struct n=
et_device *dev)
 	qtnf_scan_done(vif->mac, true);
=20
 	ret =3D qtnf_cmd_send_stop_ap(vif);
-	if (ret) {
+	if (ret)
 		pr_err("VIF%u.%u: failed to stop AP operation in FW\n",
 		       vif->mac->macid, vif->vifid);
=20
-		netif_carrier_off(vif->netdev);
-	}
+	netif_carrier_off(vif->netdev);
=20
 	return ret;
 }
@@ -589,6 +592,7 @@ qtnf_del_station(struct wiphy *wiphy, struct net_device=
 *dev,
 	if (ret)
 		pr_err("VIF%u.%u: failed to delete STA %pM\n",
 		       vif->mac->macid, vif->vifid, params->mac);
+
 	return ret;
 }
=20
@@ -596,21 +600,25 @@ static int
 qtnf_scan(struct wiphy *wiphy, struct cfg80211_scan_request *request)
 {
 	struct qtnf_wmac *mac =3D wiphy_priv(wiphy);
+	int ret;
=20
 	cancel_delayed_work_sync(&mac->scan_timeout);
=20
 	mac->scan_req =3D request;
=20
-	if (qtnf_cmd_send_scan(mac)) {
+	ret =3D qtnf_cmd_send_scan(mac);
+	if (ret) {
 		pr_err("MAC%u: failed to start scan\n", mac->macid);
 		mac->scan_req =3D NULL;
-		return -EFAULT;
+		goto out;
 	}
=20
+	pr_debug("MAC%u: scan started\n", mac->macid);
 	queue_delayed_work(mac->bus->workqueue, &mac->scan_timeout,
 			   QTNF_SCAN_TIMEOUT_SEC * HZ);
=20
-	return 0;
+out:
+	return ret;
 }
=20
 static int
@@ -630,12 +638,13 @@ qtnf_connect(struct wiphy *wiphy, struct net_device *=
dev,
=20
 	ret =3D qtnf_cmd_send_connect(vif, sme);
 	if (ret) {
-		pr_err("VIF%u.%u: failed to connect\n", vif->mac->macid,
-		       vif->vifid);
-		return ret;
+		pr_err("VIF%u.%u: failed to connect\n",
+		       vif->mac->macid, vif->vifid);
+		goto out;
 	}
=20
-	return 0;
+out:
+	return ret;
 }
=20
 static int
@@ -661,8 +670,8 @@ qtnf_disconnect(struct wiphy *wiphy, struct net_device =
*dev,
=20
 	ret =3D qtnf_cmd_send_disconnect(vif, reason_code);
 	if (ret)
-		pr_err("VIF%u.%u: failed to disconnect\n", mac->macid,
-		       vif->vifid);
+		pr_err("VIF%u.%u: failed to disconnect\n",
+		       mac->macid, vif->vifid);
=20
 	if (vif->wdev.current_bss) {
 		netif_carrier_off(vif->netdev);
@@ -740,7 +749,6 @@ qtnf_dump_survey(struct wiphy *wiphy, struct net_device=
 *dev,
 	default:
 		pr_debug("failed to get chan(%d) stats from card\n",
 			 chan->hw_value);
-		ret =3D -EINVAL;
 		break;
 	}
=20
@@ -763,6 +771,7 @@ qtnf_get_channel(struct wiphy *wiphy, struct wireless_d=
ev *wdev,
 	ret =3D qtnf_cmd_get_channel(vif, chandef);
 	if (ret) {
 		pr_err("%s: failed to get channel: %d\n", ndev->name, ret);
+		ret =3D -ENODATA;
 		goto out;
 	}
=20
@@ -772,6 +781,7 @@ qtnf_get_channel(struct wiphy *wiphy, struct wireless_d=
ev *wdev,
 		       chandef->center_freq1, chandef->center_freq2,
 		       chandef->width);
 		ret =3D -ENODATA;
+		goto out;
 	}
=20
 out:
@@ -841,10 +851,8 @@ static int qtnf_set_power_mgmt(struct wiphy *wiphy, st=
ruct net_device *dev,
=20
 	ret =3D qtnf_cmd_send_pm_set(vif, enabled ? QLINK_PM_AUTO_STANDBY :
 				   QLINK_PM_OFF, timeout);
-	if (ret) {
+	if (ret)
 		pr_err("%s: failed to set PM mode ret=3D%d\n", dev->name, ret);
-		return ret;
-	}
=20
 	return ret;
 }
@@ -964,9 +972,16 @@ static void qtnf_cfg80211_reg_notifier(struct wiphy *w=
iphy_in,
=20
 	ret =3D qtnf_cmd_reg_notify(bus, req);
 	if (ret) {
-		if (ret !=3D -EOPNOTSUPP && ret !=3D -EALREADY)
+		if (ret =3D=3D -EOPNOTSUPP) {
+			pr_warn("reg update not supported\n");
+		} else if (ret =3D=3D -EALREADY) {
+			pr_info("regulatory domain is already set to %c%c",
+				req->alpha2[0], req->alpha2[1]);
+		} else {
 			pr_err("failed to update reg domain to %c%c\n",
 			       req->alpha2[0], req->alpha2[1]);
+		}
+
 		return;
 	}
=20
@@ -1139,7 +1154,8 @@ void qtnf_netdev_updown(struct net_device *ndev, bool=
 up)
 	struct qtnf_vif *vif =3D qtnf_netdev_get_priv(ndev);
=20
 	if (qtnf_cmd_send_updown_intf(vif, up))
-		pr_err("failed to send up/down command to FW\n");
+		pr_err("failed to send %s command to VIF%u.%u\n",
+		       up ? "UP" : "DOWN", vif->mac->macid, vif->vifid);
 }
=20
 void qtnf_virtual_intf_cleanup(struct net_device *ndev)
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/ne=
t/wireless/quantenna/qtnfmac/commands.c
index ae9e77300533..63d93cf3ace0 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -80,7 +80,6 @@ static int qtnf_cmd_resp_result_decode(enum qlink_cmd_res=
ult qcode)
 static int qtnf_cmd_send_with_reply(struct qtnf_bus *bus,
 				    struct sk_buff *cmd_skb,
 				    struct sk_buff **response_skb,
-				    u16 *result_code,
 				    size_t const_resp_size,
 				    size_t *var_resp_size)
 {
@@ -88,7 +87,8 @@ static int qtnf_cmd_send_with_reply(struct qtnf_bus *bus,
 	const struct qlink_resp *resp;
 	struct sk_buff *resp_skb =3D NULL;
 	u16 cmd_id;
-	u8 mac_id, vif_id;
+	u8 mac_id;
+	u8 vif_id;
 	int ret;
=20
 	cmd =3D (struct qlink_cmd *)cmd_skb->data;
@@ -97,8 +97,11 @@ static int qtnf_cmd_send_with_reply(struct qtnf_bus *bus=
,
 	vif_id =3D cmd->vifid;
 	cmd->mhdr.len =3D cpu_to_le16(cmd_skb->len);
=20
-	if (unlikely(bus->fw_state !=3D QTNF_FW_STATE_ACTIVE &&
-		     le16_to_cpu(cmd->cmd_id) !=3D QLINK_CMD_FW_INIT)) {
+	pr_debug("VIF%u.%u cmd=3D0x%.4X\n", mac_id, vif_id,
+		 le16_to_cpu(cmd->cmd_id));
+
+	if (bus->fw_state !=3D QTNF_FW_STATE_ACTIVE &&
+	    le16_to_cpu(cmd->cmd_id) !=3D QLINK_CMD_FW_INIT) {
 		pr_warn("VIF%u.%u: drop cmd 0x%.4X in fw state %d\n",
 			mac_id, vif_id, le16_to_cpu(cmd->cmd_id),
 			bus->fw_state);
@@ -106,24 +109,16 @@ static int qtnf_cmd_send_with_reply(struct qtnf_bus *=
bus,
 		return -ENODEV;
 	}
=20
-	pr_debug("VIF%u.%u cmd=3D0x%.4X\n", mac_id, vif_id,
-		 le16_to_cpu(cmd->cmd_id));
-
 	ret =3D qtnf_trans_send_cmd_with_resp(bus, cmd_skb, &resp_skb);
-
-	if (unlikely(ret))
+	if (ret)
 		goto out;
=20
 	resp =3D (const struct qlink_resp *)resp_skb->data;
 	ret =3D qtnf_cmd_check_reply_header(resp, cmd_id, mac_id, vif_id,
 					  const_resp_size);
-
-	if (unlikely(ret))
+	if (ret)
 		goto out;
=20
-	if (likely(result_code))
-		*result_code =3D le16_to_cpu(resp->result);
-
 	/* Return length of variable part of response */
 	if (response_skb && var_resp_size)
 		*var_resp_size =3D le16_to_cpu(resp->mhdr.len) - const_resp_size;
@@ -134,14 +129,18 @@ static int qtnf_cmd_send_with_reply(struct qtnf_bus *=
bus,
 	else
 		consume_skb(resp_skb);
=20
+	if (!ret && resp)
+		return qtnf_cmd_resp_result_decode(le16_to_cpu(resp->result));
+
+	pr_warn("VIF%u.%u: cmd 0x%.4X failed: %d\n",
+		mac_id, vif_id, le16_to_cpu(cmd->cmd_id), ret);
+
 	return ret;
 }
=20
-static inline int qtnf_cmd_send(struct qtnf_bus *bus,
-				struct sk_buff *cmd_skb,
-				u16 *result_code)
+static inline int qtnf_cmd_send(struct qtnf_bus *bus, struct sk_buff *cmd_=
skb)
 {
-	return qtnf_cmd_send_with_reply(bus, cmd_skb, NULL, result_code,
+	return qtnf_cmd_send_with_reply(bus, cmd_skb, NULL,
 					sizeof(struct qlink_resp), NULL);
 }
=20
@@ -228,7 +227,6 @@ int qtnf_cmd_send_start_ap(struct qtnf_vif *vif,
 	struct sk_buff *cmd_skb;
 	struct qlink_cmd_start_ap *cmd;
 	struct qlink_auth_encr *aen;
-	u16 res_code =3D QLINK_CMD_RESULT_OK;
 	int ret;
 	int i;
=20
@@ -329,30 +327,21 @@ int qtnf_cmd_send_start_ap(struct qtnf_vif *vif,
 	}
=20
 	qtnf_bus_lock(vif->mac->bus);
-
-	ret =3D qtnf_cmd_send(vif->mac->bus, cmd_skb, &res_code);
-
-	if (unlikely(ret))
-		goto out;
-
-	if (unlikely(res_code !=3D QLINK_CMD_RESULT_OK)) {
-		pr_err("VIF%u.%u: CMD failed: %u\n", vif->mac->macid,
-		       vif->vifid, res_code);
-		ret =3D -EFAULT;
+	ret =3D qtnf_cmd_send(vif->mac->bus, cmd_skb);
+	if (ret)
 		goto out;
-	}
=20
 	netif_carrier_on(vif->netdev);
=20
 out:
 	qtnf_bus_unlock(vif->mac->bus);
+
 	return ret;
 }
=20
 int qtnf_cmd_send_stop_ap(struct qtnf_vif *vif)
 {
 	struct sk_buff *cmd_skb;
-	u16 res_code =3D QLINK_CMD_RESULT_OK;
 	int ret;
=20
 	cmd_skb =3D qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
@@ -362,23 +351,13 @@ int qtnf_cmd_send_stop_ap(struct qtnf_vif *vif)
 		return -ENOMEM;
=20
 	qtnf_bus_lock(vif->mac->bus);
-
-	ret =3D qtnf_cmd_send(vif->mac->bus, cmd_skb, &res_code);
-
-	if (unlikely(ret))
-		goto out;
-
-	if (unlikely(res_code !=3D QLINK_CMD_RESULT_OK)) {
-		pr_err("VIF%u.%u: CMD failed: %u\n", vif->mac->macid,
-		       vif->vifid, res_code);
-		ret =3D -EFAULT;
+	ret =3D qtnf_cmd_send(vif->mac->bus, cmd_skb);
+	if (ret)
 		goto out;
-	}
-
-	netif_carrier_off(vif->netdev);
=20
 out:
 	qtnf_bus_unlock(vif->mac->bus);
+
 	return ret;
 }
=20
@@ -386,7 +365,6 @@ int qtnf_cmd_send_register_mgmt(struct qtnf_vif *vif, u=
16 frame_type, bool reg)
 {
 	struct sk_buff *cmd_skb;
 	struct qlink_cmd_mgmt_frame_register *cmd;
-	u16 res_code =3D QLINK_CMD_RESULT_OK;
 	int ret;
=20
 	cmd_skb =3D qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
@@ -401,20 +379,13 @@ int qtnf_cmd_send_register_mgmt(struct qtnf_vif *vif,=
 u16 frame_type, bool reg)
 	cmd->frame_type =3D cpu_to_le16(frame_type);
 	cmd->do_register =3D reg;
=20
-	ret =3D qtnf_cmd_send(vif->mac->bus, cmd_skb, &res_code);
-
-	if (unlikely(ret))
-		goto out;
-
-	if (unlikely(res_code !=3D QLINK_CMD_RESULT_OK)) {
-		pr_err("VIF%u.%u: CMD failed: %u\n", vif->mac->macid,
-		       vif->vifid, res_code);
-		ret =3D -EFAULT;
+	ret =3D qtnf_cmd_send(vif->mac->bus, cmd_skb);
+	if (ret)
 		goto out;
-	}
=20
 out:
 	qtnf_bus_unlock(vif->mac->bus);
+
 	return ret;
 }
=20
@@ -423,7 +394,6 @@ int qtnf_cmd_send_mgmt_frame(struct qtnf_vif *vif, u32 =
cookie, u16 flags,
 {
 	struct sk_buff *cmd_skb;
 	struct qlink_cmd_mgmt_frame_tx *cmd;
-	u16 res_code =3D QLINK_CMD_RESULT_OK;
 	int ret;
=20
 	if (sizeof(*cmd) + len > QTNF_MAX_CMD_BUF_SIZE) {
@@ -448,20 +418,13 @@ int qtnf_cmd_send_mgmt_frame(struct qtnf_vif *vif, u3=
2 cookie, u16 flags,
 	if (len && buf)
 		qtnf_cmd_skb_put_buffer(cmd_skb, buf, len);
=20
-	ret =3D qtnf_cmd_send(vif->mac->bus, cmd_skb, &res_code);
-
-	if (unlikely(ret))
+	ret =3D qtnf_cmd_send(vif->mac->bus, cmd_skb);
+	if (ret)
 		goto out;
=20
-	if (unlikely(res_code !=3D QLINK_CMD_RESULT_OK)) {
-		pr_err("VIF%u.%u: CMD failed: %u\n", vif->mac->macid,
-		       vif->vifid, res_code);
-		ret =3D -EFAULT;
-		goto out;
-	}
-
 out:
 	qtnf_bus_unlock(vif->mac->bus);
+
 	return ret;
 }
=20
@@ -469,7 +432,6 @@ int qtnf_cmd_send_mgmt_set_appie(struct qtnf_vif *vif, =
u8 frame_type,
 				 const u8 *buf, size_t len)
 {
 	struct sk_buff *cmd_skb;
-	u16 res_code =3D QLINK_CMD_RESULT_OK;
 	int ret;
=20
 	if (len > QTNF_MAX_CMD_BUF_SIZE) {
@@ -487,21 +449,13 @@ int qtnf_cmd_send_mgmt_set_appie(struct qtnf_vif *vif=
, u8 frame_type,
 	qtnf_cmd_tlv_ie_set_add(cmd_skb, frame_type, buf, len);
=20
 	qtnf_bus_lock(vif->mac->bus);
-
-	ret =3D qtnf_cmd_send(vif->mac->bus, cmd_skb, &res_code);
-
-	if (unlikely(ret))
+	ret =3D qtnf_cmd_send(vif->mac->bus, cmd_skb);
+	if (ret)
 		goto out;
=20
-	if (unlikely(res_code !=3D QLINK_CMD_RESULT_OK)) {
-		pr_err("VIF%u.%u frame %u: CMD failed: %u\n", vif->mac->macid,
-		       vif->vifid, frame_type, res_code);
-		ret =3D -EFAULT;
-		goto out;
-	}
-
 out:
 	qtnf_bus_unlock(vif->mac->bus);
+
 	return ret;
 }
=20
@@ -730,7 +684,6 @@ int qtnf_cmd_get_sta_info(struct qtnf_vif *vif, const u=
8 *sta_mac,
 	struct qlink_cmd_get_sta_info *cmd;
 	const struct qlink_resp_get_sta_info *resp;
 	size_t var_resp_len;
-	u16 res_code =3D QLINK_CMD_RESULT_OK;
 	int ret =3D 0;
=20
 	cmd_skb =3D qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
@@ -745,31 +698,13 @@ int qtnf_cmd_get_sta_info(struct qtnf_vif *vif, const=
 u8 *sta_mac,
 	ether_addr_copy(cmd->sta_addr, sta_mac);
=20
 	ret =3D qtnf_cmd_send_with_reply(vif->mac->bus, cmd_skb, &resp_skb,
-				       &res_code, sizeof(*resp),
-				       &var_resp_len);
-
-	if (unlikely(ret))
-		goto out;
-
-	if (unlikely(res_code !=3D QLINK_CMD_RESULT_OK)) {
-		switch (res_code) {
-		case QLINK_CMD_RESULT_ENOTFOUND:
-			pr_warn("VIF%u.%u: %pM STA not found\n",
-				vif->mac->macid, vif->vifid, sta_mac);
-			ret =3D -ENOENT;
-			break;
-		default:
-			pr_err("VIF%u.%u: can't get info for %pM: %u\n",
-			       vif->mac->macid, vif->vifid, sta_mac, res_code);
-			ret =3D -EFAULT;
-			break;
-		}
+				       sizeof(*resp), &var_resp_len);
+	if (ret)
 		goto out;
-	}
=20
 	resp =3D (const struct qlink_resp_get_sta_info *)resp_skb->data;
=20
-	if (unlikely(!ether_addr_equal(sta_mac, resp->sta_addr))) {
+	if (!ether_addr_equal(sta_mac, resp->sta_addr)) {
 		pr_err("VIF%u.%u: wrong mac in reply: %pM !=3D %pM\n",
 		       vif->mac->macid, vif->vifid, resp->sta_addr, sta_mac);
 		ret =3D -EINVAL;
@@ -795,7 +730,6 @@ static int qtnf_cmd_send_add_change_intf(struct qtnf_vi=
f *vif,
 	struct sk_buff *cmd_skb, *resp_skb =3D NULL;
 	struct qlink_cmd_manage_intf *cmd;
 	const struct qlink_resp_manage_intf *resp;
-	u16 res_code =3D QLINK_CMD_RESULT_OK;
 	int ret =3D 0;
=20
 	cmd_skb =3D qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
@@ -828,17 +762,9 @@ static int qtnf_cmd_send_add_change_intf(struct qtnf_v=
if *vif,
 		eth_zero_addr(cmd->intf_info.mac_addr);
=20
 	ret =3D qtnf_cmd_send_with_reply(vif->mac->bus, cmd_skb, &resp_skb,
-				       &res_code, sizeof(*resp), NULL);
-
-	if (unlikely(ret))
-		goto out;
-
-	ret =3D qtnf_cmd_resp_result_decode(res_code);
-	if (ret) {
-		pr_err("VIF%u.%u: CMD %d failed: %u\n", vif->mac->macid,
-		       vif->vifid, cmd_type, res_code);
+				       sizeof(*resp), NULL);
+	if (ret)
 		goto out;
-	}
=20
 	resp =3D (const struct qlink_resp_manage_intf *)resp_skb->data;
 	ether_addr_copy(vif->mac_addr, resp->intf_info.mac_addr);
@@ -868,7 +794,6 @@ int qtnf_cmd_send_del_intf(struct qtnf_vif *vif)
 {
 	struct sk_buff *cmd_skb;
 	struct qlink_cmd_manage_intf *cmd;
-	u16 res_code =3D QLINK_CMD_RESULT_OK;
 	int ret =3D 0;
=20
 	cmd_skb =3D qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
@@ -897,17 +822,9 @@ int qtnf_cmd_send_del_intf(struct qtnf_vif *vif)
=20
 	eth_zero_addr(cmd->intf_info.mac_addr);
=20
-	ret =3D qtnf_cmd_send(vif->mac->bus, cmd_skb, &res_code);
-
-	if (unlikely(ret))
-		goto out;
-
-	if (unlikely(res_code !=3D QLINK_CMD_RESULT_OK)) {
-		pr_err("VIF%u.%u: CMD failed: %u\n", vif->mac->macid,
-		       vif->vifid, res_code);
-		ret =3D -EFAULT;
+	ret =3D qtnf_cmd_send(vif->mac->bus, cmd_skb);
+	if (ret)
 		goto out;
-	}
=20
 out:
 	qtnf_bus_unlock(vif->mac->bus);
@@ -1732,7 +1649,6 @@ int qtnf_cmd_get_mac_info(struct qtnf_wmac *mac)
 	struct sk_buff *cmd_skb, *resp_skb =3D NULL;
 	const struct qlink_resp_get_mac_info *resp;
 	size_t var_data_len;
-	u16 res_code =3D QLINK_CMD_RESULT_OK;
 	int ret =3D 0;
=20
 	cmd_skb =3D qtnf_cmd_alloc_new_cmdskb(mac->macid, QLINK_VIFID_RSVD,
@@ -1742,18 +1658,11 @@ int qtnf_cmd_get_mac_info(struct qtnf_wmac *mac)
 		return -ENOMEM;
=20
 	qtnf_bus_lock(mac->bus);
-
-	ret =3D qtnf_cmd_send_with_reply(mac->bus, cmd_skb, &resp_skb, &res_code,
+	ret =3D qtnf_cmd_send_with_reply(mac->bus, cmd_skb, &resp_skb,
 				       sizeof(*resp), &var_data_len);
-	if (unlikely(ret))
+	if (ret)
 		goto out;
=20
-	if (unlikely(res_code !=3D QLINK_CMD_RESULT_OK)) {
-		pr_err("MAC%u: CMD failed: %u\n", mac->macid, res_code);
-		ret =3D -EFAULT;
-		goto out;
-	}
-
 	resp =3D (const struct qlink_resp_get_mac_info *)resp_skb->data;
 	qtnf_cmd_resp_proc_mac_info(mac, resp);
 	ret =3D qtnf_parse_variable_mac_info(mac, resp->var_info, var_data_len);
@@ -1769,7 +1678,6 @@ int qtnf_cmd_get_hw_info(struct qtnf_bus *bus)
 {
 	struct sk_buff *cmd_skb, *resp_skb =3D NULL;
 	const struct qlink_resp_get_hw_info *resp;
-	u16 res_code =3D QLINK_CMD_RESULT_OK;
 	int ret =3D 0;
 	size_t info_len;
=20
@@ -1780,18 +1688,10 @@ int qtnf_cmd_get_hw_info(struct qtnf_bus *bus)
 		return -ENOMEM;
=20
 	qtnf_bus_lock(bus);
-
-	ret =3D qtnf_cmd_send_with_reply(bus, cmd_skb, &resp_skb, &res_code,
+	ret =3D qtnf_cmd_send_with_reply(bus, cmd_skb, &resp_skb,
 				       sizeof(*resp), &info_len);
-
-	if (unlikely(ret))
-		goto out;
-
-	if (unlikely(res_code !=3D QLINK_CMD_RESULT_OK)) {
-		pr_err("cmd exec failed: 0x%.4X\n", res_code);
-		ret =3D -EFAULT;
+	if (ret)
 		goto out;
-	}
=20
 	resp =3D (const struct qlink_resp_get_hw_info *)resp_skb->data;
 	ret =3D qtnf_cmd_resp_proc_hw_info(bus, resp, info_len);
@@ -1810,7 +1710,6 @@ int qtnf_cmd_band_info_get(struct qtnf_wmac *mac,
 	size_t info_len;
 	struct qlink_cmd_band_info_get *cmd;
 	struct qlink_resp_band_info_get *resp;
-	u16 res_code =3D QLINK_CMD_RESULT_OK;
 	int ret =3D 0;
 	u8 qband;
=20
@@ -1838,18 +1737,10 @@ int qtnf_cmd_band_info_get(struct qtnf_wmac *mac,
 	cmd->band =3D qband;
=20
 	qtnf_bus_lock(mac->bus);
-
-	ret =3D qtnf_cmd_send_with_reply(mac->bus, cmd_skb, &resp_skb, &res_code,
+	ret =3D qtnf_cmd_send_with_reply(mac->bus, cmd_skb, &resp_skb,
 				       sizeof(*resp), &info_len);
-
-	if (unlikely(ret))
-		goto out;
-
-	if (unlikely(res_code !=3D QLINK_CMD_RESULT_OK)) {
-		pr_err("MAC%u: CMD failed: %u\n", mac->macid, res_code);
-		ret =3D -EFAULT;
+	if (ret)
 		goto out;
-	}
=20
 	resp =3D (struct qlink_resp_band_info_get *)resp_skb->data;
 	if (resp->band !=3D qband) {
@@ -1873,7 +1764,6 @@ int qtnf_cmd_send_get_phy_params(struct qtnf_wmac *ma=
c)
 	struct sk_buff *cmd_skb, *resp_skb =3D NULL;
 	size_t response_size;
 	struct qlink_resp_phy_params *resp;
-	u16 res_code =3D QLINK_CMD_RESULT_OK;
 	int ret =3D 0;
=20
 	cmd_skb =3D qtnf_cmd_alloc_new_cmdskb(mac->macid, 0,
@@ -1883,18 +1773,10 @@ int qtnf_cmd_send_get_phy_params(struct qtnf_wmac *=
mac)
 		return -ENOMEM;
=20
 	qtnf_bus_lock(mac->bus);
-
-	ret =3D qtnf_cmd_send_with_reply(mac->bus, cmd_skb, &resp_skb, &res_code,
+	ret =3D qtnf_cmd_send_with_reply(mac->bus, cmd_skb, &resp_skb,
 				       sizeof(*resp), &response_size);
-
-	if (unlikely(ret))
-		goto out;
-
-	if (unlikely(res_code !=3D QLINK_CMD_RESULT_OK)) {
-		pr_err("MAC%u: CMD failed: %u\n", mac->macid, res_code);
-		ret =3D -EFAULT;
+	if (ret)
 		goto out;
-	}
=20
 	resp =3D (struct qlink_resp_phy_params *)resp_skb->data;
 	ret =3D qtnf_cmd_resp_proc_phy_params(mac, resp->info, response_size);
@@ -1910,7 +1792,6 @@ int qtnf_cmd_send_update_phy_params(struct qtnf_wmac =
*mac, u32 changed)
 {
 	struct wiphy *wiphy =3D priv_to_wiphy(mac);
 	struct sk_buff *cmd_skb;
-	u16 res_code =3D QLINK_CMD_RESULT_OK;
 	int ret =3D 0;
=20
 	cmd_skb =3D qtnf_cmd_alloc_new_cmdskb(mac->macid, 0,
@@ -1931,26 +1812,19 @@ int qtnf_cmd_send_update_phy_params(struct qtnf_wma=
c *mac, u32 changed)
 		qtnf_cmd_skb_put_tlv_u8(cmd_skb, QTN_TLV_ID_COVERAGE_CLASS,
 					wiphy->coverage_class);
=20
-	ret =3D qtnf_cmd_send(mac->bus, cmd_skb, &res_code);
-
-	if (unlikely(ret))
-		goto out;
-
-	if (unlikely(res_code !=3D QLINK_CMD_RESULT_OK)) {
-		pr_err("MAC%u: CMD failed: %u\n", mac->macid, res_code);
-		ret =3D -EFAULT;
+	ret =3D qtnf_cmd_send(mac->bus, cmd_skb);
+	if (ret)
 		goto out;
-	}
=20
 out:
 	qtnf_bus_unlock(mac->bus);
+
 	return ret;
 }
=20
 int qtnf_cmd_send_init_fw(struct qtnf_bus *bus)
 {
 	struct sk_buff *cmd_skb;
-	u16 res_code =3D QLINK_CMD_RESULT_OK;
 	int ret =3D 0;
=20
 	cmd_skb =3D qtnf_cmd_alloc_new_cmdskb(QLINK_MACID_RSVD, QLINK_VIFID_RSVD,
@@ -1960,20 +1834,13 @@ int qtnf_cmd_send_init_fw(struct qtnf_bus *bus)
 		return -ENOMEM;
=20
 	qtnf_bus_lock(bus);
-
-	ret =3D qtnf_cmd_send(bus, cmd_skb, &res_code);
-
-	if (unlikely(ret))
-		goto out;
-
-	if (unlikely(res_code !=3D QLINK_CMD_RESULT_OK)) {
-		pr_err("cmd exec failed: 0x%.4X\n", res_code);
-		ret =3D -EFAULT;
+	ret =3D qtnf_cmd_send(bus, cmd_skb);
+	if (ret)
 		goto out;
-	}
=20
 out:
 	qtnf_bus_unlock(bus);
+
 	return ret;
 }
=20
@@ -1988,9 +1855,7 @@ void qtnf_cmd_send_deinit_fw(struct qtnf_bus *bus)
 		return;
=20
 	qtnf_bus_lock(bus);
-
-	qtnf_cmd_send(bus, cmd_skb, NULL);
-
+	qtnf_cmd_send(bus, cmd_skb);
 	qtnf_bus_unlock(bus);
 }
=20
@@ -1999,7 +1864,6 @@ int qtnf_cmd_send_add_key(struct qtnf_vif *vif, u8 ke=
y_index, bool pairwise,
 {
 	struct sk_buff *cmd_skb;
 	struct qlink_cmd_add_key *cmd;
-	u16 res_code =3D QLINK_CMD_RESULT_OK;
 	int ret =3D 0;
=20
 	cmd_skb =3D qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
@@ -2031,19 +1895,13 @@ int qtnf_cmd_send_add_key(struct qtnf_vif *vif, u8 =
key_index, bool pairwise,
 					 params->seq,
 					 params->seq_len);
=20
-	ret =3D qtnf_cmd_send(vif->mac->bus, cmd_skb, &res_code);
-	if (unlikely(ret))
-		goto out;
-
-	if (unlikely(res_code !=3D QLINK_CMD_RESULT_OK)) {
-		pr_err("VIF%u.%u: CMD failed: %u\n",
-		       vif->mac->macid, vif->vifid, res_code);
-		ret =3D -EFAULT;
+	ret =3D qtnf_cmd_send(vif->mac->bus, cmd_skb);
+	if (ret)
 		goto out;
-	}
=20
 out:
 	qtnf_bus_unlock(vif->mac->bus);
+
 	return ret;
 }
=20
@@ -2052,7 +1910,6 @@ int qtnf_cmd_send_del_key(struct qtnf_vif *vif, u8 ke=
y_index, bool pairwise,
 {
 	struct sk_buff *cmd_skb;
 	struct qlink_cmd_del_key *cmd;
-	u16 res_code =3D QLINK_CMD_RESULT_OK;
 	int ret =3D 0;
=20
 	cmd_skb =3D qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
@@ -2072,19 +1929,14 @@ int qtnf_cmd_send_del_key(struct qtnf_vif *vif, u8 =
key_index, bool pairwise,
=20
 	cmd->key_index =3D key_index;
 	cmd->pairwise =3D pairwise;
-	ret =3D qtnf_cmd_send(vif->mac->bus, cmd_skb, &res_code);
-	if (unlikely(ret))
-		goto out;
=20
-	if (unlikely(res_code !=3D QLINK_CMD_RESULT_OK)) {
-		pr_err("VIF%u.%u: CMD failed: %u\n",
-		       vif->mac->macid, vif->vifid, res_code);
-		ret =3D -EFAULT;
+	ret =3D qtnf_cmd_send(vif->mac->bus, cmd_skb);
+	if (ret)
 		goto out;
-	}
=20
 out:
 	qtnf_bus_unlock(vif->mac->bus);
+
 	return ret;
 }
=20
@@ -2093,7 +1945,6 @@ int qtnf_cmd_send_set_default_key(struct qtnf_vif *vi=
f, u8 key_index,
 {
 	struct sk_buff *cmd_skb;
 	struct qlink_cmd_set_def_key *cmd;
-	u16 res_code =3D QLINK_CMD_RESULT_OK;
 	int ret =3D 0;
=20
 	cmd_skb =3D qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
@@ -2108,19 +1959,14 @@ int qtnf_cmd_send_set_default_key(struct qtnf_vif *=
vif, u8 key_index,
 	cmd->key_index =3D key_index;
 	cmd->unicast =3D unicast;
 	cmd->multicast =3D multicast;
-	ret =3D qtnf_cmd_send(vif->mac->bus, cmd_skb, &res_code);
-	if (unlikely(ret))
-		goto out;
=20
-	if (unlikely(res_code !=3D QLINK_CMD_RESULT_OK)) {
-		pr_err("VIF%u.%u: CMD failed: %u\n", vif->mac->macid,
-		       vif->vifid, res_code);
-		ret =3D -EFAULT;
+	ret =3D qtnf_cmd_send(vif->mac->bus, cmd_skb);
+	if (ret)
 		goto out;
-	}
=20
 out:
 	qtnf_bus_unlock(vif->mac->bus);
+
 	return ret;
 }
=20
@@ -2128,7 +1974,6 @@ int qtnf_cmd_send_set_default_mgmt_key(struct qtnf_vi=
f *vif, u8 key_index)
 {
 	struct sk_buff *cmd_skb;
 	struct qlink_cmd_set_def_mgmt_key *cmd;
-	u16 res_code =3D QLINK_CMD_RESULT_OK;
 	int ret =3D 0;
=20
 	cmd_skb =3D qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
@@ -2141,19 +1986,14 @@ int qtnf_cmd_send_set_default_mgmt_key(struct qtnf_=
vif *vif, u8 key_index)
=20
 	cmd =3D (struct qlink_cmd_set_def_mgmt_key *)cmd_skb->data;
 	cmd->key_index =3D key_index;
-	ret =3D qtnf_cmd_send(vif->mac->bus, cmd_skb, &res_code);
-	if (unlikely(ret))
-		goto out;
=20
-	if (unlikely(res_code !=3D QLINK_CMD_RESULT_OK)) {
-		pr_err("VIF%u.%u: CMD failed: %u\n", vif->mac->macid,
-		       vif->vifid, res_code);
-		ret =3D -EFAULT;
+	ret =3D qtnf_cmd_send(vif->mac->bus, cmd_skb);
+	if (ret)
 		goto out;
-	}
=20
 out:
 	qtnf_bus_unlock(vif->mac->bus);
+
 	return ret;
 }
=20
@@ -2183,7 +2023,6 @@ int qtnf_cmd_send_change_sta(struct qtnf_vif *vif, co=
nst u8 *mac,
 {
 	struct sk_buff *cmd_skb;
 	struct qlink_cmd_change_sta *cmd;
-	u16 res_code =3D QLINK_CMD_RESULT_OK;
 	int ret =3D 0;
=20
 	cmd_skb =3D qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
@@ -2214,19 +2053,13 @@ int qtnf_cmd_send_change_sta(struct qtnf_vif *vif, =
const u8 *mac,
 		goto out;
 	}
=20
-	ret =3D qtnf_cmd_send(vif->mac->bus, cmd_skb, &res_code);
-	if (unlikely(ret))
+	ret =3D qtnf_cmd_send(vif->mac->bus, cmd_skb);
+	if (ret)
 		goto out;
=20
-	if (unlikely(res_code !=3D QLINK_CMD_RESULT_OK)) {
-		pr_err("VIF%u.%u: CMD failed: %u\n", vif->mac->macid,
-		       vif->vifid, res_code);
-		ret =3D -EFAULT;
-		goto out;
-	}
-
 out:
 	qtnf_bus_unlock(vif->mac->bus);
+
 	return ret;
 }
=20
@@ -2235,7 +2068,6 @@ int qtnf_cmd_send_del_sta(struct qtnf_vif *vif,
 {
 	struct sk_buff *cmd_skb;
 	struct qlink_cmd_del_sta *cmd;
-	u16 res_code =3D QLINK_CMD_RESULT_OK;
 	int ret =3D 0;
=20
 	cmd_skb =3D qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
@@ -2256,19 +2088,13 @@ int qtnf_cmd_send_del_sta(struct qtnf_vif *vif,
 	cmd->subtype =3D params->subtype;
 	cmd->reason_code =3D cpu_to_le16(params->reason_code);
=20
-	ret =3D qtnf_cmd_send(vif->mac->bus, cmd_skb, &res_code);
-	if (unlikely(ret))
-		goto out;
-
-	if (unlikely(res_code !=3D QLINK_CMD_RESULT_OK)) {
-		pr_err("VIF%u.%u: CMD failed: %u\n", vif->mac->macid,
-		       vif->vifid, res_code);
-		ret =3D -EFAULT;
+	ret =3D qtnf_cmd_send(vif->mac->bus, cmd_skb);
+	if (ret)
 		goto out;
-	}
=20
 out:
 	qtnf_bus_unlock(vif->mac->bus);
+
 	return ret;
 }
=20
@@ -2312,7 +2138,6 @@ static void qtnf_cmd_randmac_tlv_add(struct sk_buff *=
cmd_skb,
 int qtnf_cmd_send_scan(struct qtnf_wmac *mac)
 {
 	struct sk_buff *cmd_skb;
-	u16 res_code =3D QLINK_CMD_RESULT_OK;
 	struct ieee80211_channel *sc;
 	struct cfg80211_scan_request *scan_req =3D mac->scan_req;
 	int n_channels;
@@ -2370,20 +2195,13 @@ int qtnf_cmd_send_scan(struct qtnf_wmac *mac)
 					 scan_req->mac_addr_mask);
 	}
=20
-	ret =3D qtnf_cmd_send(mac->bus, cmd_skb, &res_code);
-
-	if (unlikely(ret))
+	ret =3D qtnf_cmd_send(mac->bus, cmd_skb);
+	if (ret)
 		goto out;
=20
-	pr_debug("MAC%u: scan started\n", mac->macid);
-
-	if (unlikely(res_code !=3D QLINK_CMD_RESULT_OK)) {
-		pr_err("MAC%u: CMD failed: %u\n", mac->macid, res_code);
-		ret =3D -EFAULT;
-		goto out;
-	}
 out:
 	qtnf_bus_unlock(mac->bus);
+
 	return ret;
 }
=20
@@ -2393,7 +2211,6 @@ int qtnf_cmd_send_connect(struct qtnf_vif *vif,
 	struct sk_buff *cmd_skb;
 	struct qlink_cmd_connect *cmd;
 	struct qlink_auth_encr *aen;
-	u16 res_code =3D QLINK_CMD_RESULT_OK;
 	int ret;
 	int i;
 	u32 connect_flags =3D 0;
@@ -2474,20 +2291,13 @@ int qtnf_cmd_send_connect(struct qtnf_vif *vif,
 		qtnf_cmd_channel_tlv_add(cmd_skb, sme->channel);
=20
 	qtnf_bus_lock(vif->mac->bus);
-
-	ret =3D qtnf_cmd_send(vif->mac->bus, cmd_skb, &res_code);
-
-	if (unlikely(ret))
+	ret =3D qtnf_cmd_send(vif->mac->bus, cmd_skb);
+	if (ret)
 		goto out;
=20
-	if (unlikely(res_code !=3D QLINK_CMD_RESULT_OK)) {
-		pr_err("VIF%u.%u: CMD failed: %u\n", vif->mac->macid,
-		       vif->vifid, res_code);
-		ret =3D -EFAULT;
-		goto out;
-	}
 out:
 	qtnf_bus_unlock(vif->mac->bus);
+
 	return ret;
 }
=20
@@ -2495,7 +2305,6 @@ int qtnf_cmd_send_disconnect(struct qtnf_vif *vif, u1=
6 reason_code)
 {
 	struct sk_buff *cmd_skb;
 	struct qlink_cmd_disconnect *cmd;
-	u16 res_code =3D QLINK_CMD_RESULT_OK;
 	int ret;
=20
 	cmd_skb =3D qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
@@ -2509,19 +2318,13 @@ int qtnf_cmd_send_disconnect(struct qtnf_vif *vif, =
u16 reason_code)
 	cmd =3D (struct qlink_cmd_disconnect *)cmd_skb->data;
 	cmd->reason =3D cpu_to_le16(reason_code);
=20
-	ret =3D qtnf_cmd_send(vif->mac->bus, cmd_skb, &res_code);
-
-	if (unlikely(ret))
+	ret =3D qtnf_cmd_send(vif->mac->bus, cmd_skb);
+	if (ret)
 		goto out;
=20
-	if (unlikely(res_code !=3D QLINK_CMD_RESULT_OK)) {
-		pr_err("VIF%u.%u: CMD failed: %u\n", vif->mac->macid,
-		       vif->vifid, res_code);
-		ret =3D -EFAULT;
-		goto out;
-	}
 out:
 	qtnf_bus_unlock(vif->mac->bus);
+
 	return ret;
 }
=20
@@ -2529,7 +2332,6 @@ int qtnf_cmd_send_updown_intf(struct qtnf_vif *vif, b=
ool up)
 {
 	struct sk_buff *cmd_skb;
 	struct qlink_cmd_updown *cmd;
-	u16 res_code =3D QLINK_CMD_RESULT_OK;
 	int ret;
=20
 	cmd_skb =3D qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
@@ -2542,20 +2344,13 @@ int qtnf_cmd_send_updown_intf(struct qtnf_vif *vif,=
 bool up)
 	cmd->if_up =3D !!up;
=20
 	qtnf_bus_lock(vif->mac->bus);
-
-	ret =3D qtnf_cmd_send(vif->mac->bus, cmd_skb, &res_code);
-
-	if (unlikely(ret))
+	ret =3D qtnf_cmd_send(vif->mac->bus, cmd_skb);
+	if (ret)
 		goto out;
=20
-	if (unlikely(res_code !=3D QLINK_CMD_RESULT_OK)) {
-		pr_err("VIF%u.%u: CMD failed: %u\n", vif->mac->macid,
-		       vif->vifid, res_code);
-		ret =3D -EFAULT;
-		goto out;
-	}
 out:
 	qtnf_bus_unlock(vif->mac->bus);
+
 	return ret;
 }
=20
@@ -2563,7 +2358,6 @@ int qtnf_cmd_reg_notify(struct qtnf_bus *bus, struct =
regulatory_request *req)
 {
 	struct sk_buff *cmd_skb;
 	int ret;
-	u16 res_code;
 	struct qlink_cmd_reg_notify *cmd;
=20
 	cmd_skb =3D qtnf_cmd_alloc_new_cmdskb(QLINK_MACID_RSVD, QLINK_VIFID_RSVD,
@@ -2604,29 +2398,10 @@ int qtnf_cmd_reg_notify(struct qtnf_bus *bus, struc=
t regulatory_request *req)
 	}
=20
 	qtnf_bus_lock(bus);
-
-	ret =3D qtnf_cmd_send(bus, cmd_skb, &res_code);
+	ret =3D qtnf_cmd_send(bus, cmd_skb);
 	if (ret)
 		goto out;
=20
-	switch (res_code) {
-	case QLINK_CMD_RESULT_ENOTSUPP:
-		pr_warn("reg update not supported\n");
-		ret =3D -EOPNOTSUPP;
-		break;
-	case QLINK_CMD_RESULT_EALREADY:
-		pr_info("regulatory domain is already set to %c%c",
-			req->alpha2[0], req->alpha2[1]);
-		ret =3D -EALREADY;
-		break;
-	case QLINK_CMD_RESULT_OK:
-		ret =3D 0;
-		break;
-	default:
-		ret =3D -EFAULT;
-		break;
-	}
-
 out:
 	qtnf_bus_unlock(bus);
=20
@@ -2640,7 +2415,6 @@ int qtnf_cmd_get_chan_stats(struct qtnf_wmac *mac, u1=
6 channel,
 	struct qlink_cmd_get_chan_stats *cmd;
 	struct qlink_resp_get_chan_stats *resp;
 	size_t var_data_len;
-	u16 res_code =3D QLINK_CMD_RESULT_OK;
 	int ret =3D 0;
=20
 	cmd_skb =3D qtnf_cmd_alloc_new_cmdskb(mac->macid, QLINK_VIFID_RSVD,
@@ -2654,25 +2428,10 @@ int qtnf_cmd_get_chan_stats(struct qtnf_wmac *mac, =
u16 channel,
 	cmd =3D (struct qlink_cmd_get_chan_stats *)cmd_skb->data;
 	cmd->channel =3D cpu_to_le16(channel);
=20
-	ret =3D qtnf_cmd_send_with_reply(mac->bus, cmd_skb, &resp_skb, &res_code,
+	ret =3D qtnf_cmd_send_with_reply(mac->bus, cmd_skb, &resp_skb,
 				       sizeof(*resp), &var_data_len);
-	if (unlikely(ret)) {
-		qtnf_bus_unlock(mac->bus);
-		return ret;
-	}
-
-	if (unlikely(res_code !=3D QLINK_CMD_RESULT_OK)) {
-		switch (res_code) {
-		case QLINK_CMD_RESULT_ENOTFOUND:
-			ret =3D -ENOENT;
-			break;
-		default:
-			pr_err("cmd exec failed: 0x%.4X\n", res_code);
-			ret =3D -EFAULT;
-			break;
-		}
+	if (ret)
 		goto out;
-	}
=20
 	resp =3D (struct qlink_resp_get_chan_stats *)resp_skb->data;
 	ret =3D qtnf_cmd_resp_proc_chan_stat_info(stats, resp->info,
@@ -2681,6 +2440,7 @@ int qtnf_cmd_get_chan_stats(struct qtnf_wmac *mac, u1=
6 channel,
 out:
 	qtnf_bus_unlock(mac->bus);
 	consume_skb(resp_skb);
+
 	return ret;
 }
=20
@@ -2690,7 +2450,6 @@ int qtnf_cmd_send_chan_switch(struct qtnf_vif *vif,
 	struct qtnf_wmac *mac =3D vif->mac;
 	struct qlink_cmd_chan_switch *cmd;
 	struct sk_buff *cmd_skb;
-	u16 res_code =3D QLINK_CMD_RESULT_OK;
 	int ret;
=20
 	cmd_skb =3D qtnf_cmd_alloc_new_cmdskb(mac->macid, vif->vifid,
@@ -2707,32 +2466,13 @@ int qtnf_cmd_send_chan_switch(struct qtnf_vif *vif,
 	cmd->block_tx =3D params->block_tx;
 	cmd->beacon_count =3D params->count;
=20
-	ret =3D qtnf_cmd_send(mac->bus, cmd_skb, &res_code);
-
-	if (unlikely(ret))
+	ret =3D qtnf_cmd_send(mac->bus, cmd_skb);
+	if (ret)
 		goto out;
=20
-	switch (res_code) {
-	case QLINK_CMD_RESULT_OK:
-		ret =3D 0;
-		break;
-	case QLINK_CMD_RESULT_ENOTFOUND:
-		ret =3D -ENOENT;
-		break;
-	case QLINK_CMD_RESULT_ENOTSUPP:
-		ret =3D -EOPNOTSUPP;
-		break;
-	case QLINK_CMD_RESULT_EALREADY:
-		ret =3D -EALREADY;
-		break;
-	case QLINK_CMD_RESULT_INVALID:
-	default:
-		ret =3D -EFAULT;
-		break;
-	}
-
 out:
 	qtnf_bus_unlock(mac->bus);
+
 	return ret;
 }
=20
@@ -2742,7 +2482,6 @@ int qtnf_cmd_get_channel(struct qtnf_vif *vif, struct=
 cfg80211_chan_def *chdef)
 	const struct qlink_resp_channel_get *resp;
 	struct sk_buff *cmd_skb;
 	struct sk_buff *resp_skb =3D NULL;
-	u16 res_code =3D QLINK_CMD_RESULT_OK;
 	int ret;
=20
 	cmd_skb =3D qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
@@ -2752,25 +2491,18 @@ int qtnf_cmd_get_channel(struct qtnf_vif *vif, stru=
ct cfg80211_chan_def *chdef)
 		return -ENOMEM;
=20
 	qtnf_bus_lock(bus);
-
-	ret =3D qtnf_cmd_send_with_reply(bus, cmd_skb, &resp_skb, &res_code,
+	ret =3D qtnf_cmd_send_with_reply(bus, cmd_skb, &resp_skb,
 				       sizeof(*resp), NULL);
-
-	qtnf_bus_unlock(bus);
-
-	if (unlikely(ret))
-		goto out;
-
-	if (unlikely(res_code !=3D QLINK_CMD_RESULT_OK)) {
-		ret =3D -ENODATA;
+	if (ret)
 		goto out;
-	}
=20
 	resp =3D (const struct qlink_resp_channel_get *)resp_skb->data;
 	qlink_chandef_q2cfg(priv_to_wiphy(vif->mac), &resp->chan, chdef);
=20
 out:
+	qtnf_bus_unlock(bus);
 	consume_skb(resp_skb);
+
 	return ret;
 }
=20
@@ -2782,7 +2514,6 @@ int qtnf_cmd_start_cac(const struct qtnf_vif *vif,
 	struct sk_buff *cmd_skb;
 	struct qlink_cmd_start_cac *cmd;
 	int ret;
-	u16 res_code;
=20
 	cmd_skb =3D qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
 					    QLINK_CMD_START_CAC,
@@ -2795,19 +2526,12 @@ int qtnf_cmd_start_cac(const struct qtnf_vif *vif,
 	qlink_chandef_cfg2q(chdef, &cmd->chan);
=20
 	qtnf_bus_lock(bus);
-	ret =3D qtnf_cmd_send(bus, cmd_skb, &res_code);
-	qtnf_bus_unlock(bus);
-
+	ret =3D qtnf_cmd_send(bus, cmd_skb);
 	if (ret)
-		return ret;
+		goto out;
=20
-	switch (res_code) {
-	case QLINK_CMD_RESULT_OK:
-		break;
-	default:
-		ret =3D -EOPNOTSUPP;
-		break;
-	}
+out:
+	qtnf_bus_unlock(bus);
=20
 	return ret;
 }
@@ -2819,7 +2543,6 @@ int qtnf_cmd_set_mac_acl(const struct qtnf_vif *vif,
 	struct sk_buff *cmd_skb;
 	struct qlink_tlv_hdr *tlv;
 	size_t acl_size =3D qtnf_cmd_acl_data_size(params);
-	u16 res_code;
 	int ret;
=20
 	cmd_skb =3D qtnf_cmd_alloc_new_cmdskb(vif->mac->macid, vif->vifid,
@@ -2834,22 +2557,12 @@ int qtnf_cmd_set_mac_acl(const struct qtnf_vif *vif=
,
 	qlink_acl_data_cfg2q(params, (struct qlink_acl_data *)tlv->val);
=20
 	qtnf_bus_lock(bus);
-	ret =3D qtnf_cmd_send(bus, cmd_skb, &res_code);
-	qtnf_bus_unlock(bus);
-
-	if (unlikely(ret))
-		return ret;
+	ret =3D qtnf_cmd_send(bus, cmd_skb);
+	if (ret)
+		goto out;
=20
-	switch (res_code) {
-	case QLINK_CMD_RESULT_OK:
-		break;
-	case QLINK_CMD_RESULT_INVALID:
-		ret =3D -EINVAL;
-		break;
-	default:
-		ret =3D -EOPNOTSUPP;
-		break;
-	}
+out:
+	qtnf_bus_unlock(bus);
=20
 	return ret;
 }
@@ -2858,7 +2571,6 @@ int qtnf_cmd_send_pm_set(const struct qtnf_vif *vif, =
u8 pm_mode, int timeout)
 {
 	struct qtnf_bus *bus =3D vif->mac->bus;
 	struct sk_buff *cmd_skb;
-	u16 res_code =3D QLINK_CMD_RESULT_OK;
 	struct qlink_cmd_pm_set *cmd;
 	int ret =3D 0;
=20
@@ -2873,18 +2585,13 @@ int qtnf_cmd_send_pm_set(const struct qtnf_vif *vif=
, u8 pm_mode, int timeout)
=20
 	qtnf_bus_lock(bus);
=20
-	ret =3D qtnf_cmd_send(bus, cmd_skb, &res_code);
-
-	if (unlikely(ret))
+	ret =3D qtnf_cmd_send(bus, cmd_skb);
+	if (ret)
 		goto out;
=20
-	if (unlikely(res_code !=3D QLINK_CMD_RESULT_OK)) {
-		pr_err("cmd exec failed: 0x%.4X\n", res_code);
-		ret =3D -EFAULT;
-	}
-
 out:
 	qtnf_bus_unlock(bus);
+
 	return ret;
 }
=20
@@ -2893,7 +2600,6 @@ int qtnf_cmd_send_wowlan_set(const struct qtnf_vif *v=
if,
 {
 	struct qtnf_bus *bus =3D vif->mac->bus;
 	struct sk_buff *cmd_skb;
-	u16 res_code =3D QLINK_CMD_RESULT_OK;
 	struct qlink_cmd_wowlan_set *cmd;
 	u32 triggers =3D 0;
 	int count =3D 0;
@@ -2929,16 +2635,10 @@ int qtnf_cmd_send_wowlan_set(const struct qtnf_vif =
*vif,
=20
 	cmd->triggers =3D cpu_to_le32(triggers);
=20
-	ret =3D qtnf_cmd_send(bus, cmd_skb, &res_code);
-
-	if (unlikely(ret))
+	ret =3D qtnf_cmd_send(bus, cmd_skb);
+	if (ret)
 		goto out;
=20
-	if (unlikely(res_code !=3D QLINK_CMD_RESULT_OK)) {
-		pr_err("cmd exec failed: 0x%.4X\n", res_code);
-		ret =3D -EFAULT;
-	}
-
 out:
 	qtnf_bus_unlock(bus);
 	return ret;
--=20
2.11.0

