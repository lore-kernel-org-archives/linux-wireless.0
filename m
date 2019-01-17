Return-Path: <SRS0=z7UY=PZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D62D2C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 13:21:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CFBA20851
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jan 2019 13:21:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="ZeLaY8Vp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727363AbfAQNVb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 17 Jan 2019 08:21:31 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:38976 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfAQNVb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Jan 2019 08:21:31 -0500
X-IronPort-AV: E=Sophos;i="5.56,489,1539673200"; 
   d="scan'208";a="25605801"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 17 Jan 2019 06:21:30 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.108) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Thu, 17 Jan 2019 06:21:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s+DcS9JT1aWvO219j+R8tBTjywF4RIFoQ7U+NtX+omA=;
 b=ZeLaY8Vply+jYJmfvqCxEBDbOxSmTUcw8pmbkWZaIfuA8XeII7945QMx3zaMAgDteu2IWrrLEQtVnkvPpdjW+Qppi5rKMBW24iG9owseQ6Cz9Ubdr3XDR18aq/l658+ZBL1U8gHKE/mMzlTEcZyxo+u225RvVOcGamRnHjinUrI=
Received: from BYAPR11MB2567.namprd11.prod.outlook.com (52.135.226.160) by
 BYAPR11MB3464.namprd11.prod.outlook.com (20.177.187.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1537.26; Thu, 17 Jan 2019 13:21:27 +0000
Received: from BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::c110:8559:a438:491d]) by BYAPR11MB2567.namprd11.prod.outlook.com
 ([fe80::c110:8559:a438:491d%3]) with mapi id 15.20.1516.019; Thu, 17 Jan 2019
 13:21:27 +0000
From:   <Ajay.Kathat@microchip.com>
To:     <linux-wireless@vger.kernel.org>
CC:     <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <Adham.Abozaeid@microchip.com>, <johannes@sipsolutions.net>,
        <Ajay.Kathat@microchip.com>
Subject: [PATCH 07/13] staging: wilc1000: use struct to pack join parameters
 for FW
Thread-Topic: [PATCH 07/13] staging: wilc1000: use struct to pack join
 parameters for FW
Thread-Index: AQHUrmeN2CgOqqUMEEO02nCWXd/5rA==
Date:   Thu, 17 Jan 2019 13:21:27 +0000
Message-ID: <1547731250-18518-8-git-send-email-ajay.kathat@microchip.com>
References: <1547731250-18518-1-git-send-email-ajay.kathat@microchip.com>
In-Reply-To: <1547731250-18518-1-git-send-email-ajay.kathat@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR01CA0138.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:35::32) To BYAPR11MB2567.namprd11.prod.outlook.com
 (2603:10b6:a02:c5::32)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Ajay.Kathat@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.7.4
x-originating-ip: [49.205.218.18]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR11MB3464;6:KbVGNFA3l2lLZsuVlAOcj7VpoU+D3I1G+HsYMMBhLTwVhgLScXYjI4ZK2mJZ3TAGxF8W9C34b2hcE9EEkKFQRgvsKU8UgiTJaGQyqRpcHFz3FguMsGaEbSBnPJWUzGj8hi/GwjfMj0MSCZcYvVGpGMS15UcHTIKbX6GuJgKl8yH9nbniOdQRveEFlkw4SIbFA1gckVUl5QNWaQ/YT2Rwdmuf/fWFfSUEQ1s2vccamUq3WYGggPlygpVWdPHETedp9htQHA1PFN/E0o5Z/91ALl8s98mS3Daulu7TIG3K4nx8i43Y2r9d6jScgI8vdAcLroI+bFaknh0ISjmLFUOfRl64UzHC1NbInUHJmdQKzwBWo3zpsBqeW3/5Rae9HGmnys0DQHSWa8aX25SYMZy5rVDjXwtpq4k9GjC0WHgXINxdAkHMnalZnlr2Cvo85ZhQaIxIqE/nBkr+DUJPgAai4A==;5:p2hq7rXpKFJlKskfSz0CplUYwlIBEqR2+N/8ilUR3xVoxSBgX/tARGm2lZ/WFwrV0mazQ91FzU8GPYUVA4gd9oNfvYf1Wvvl6EjSjYsErgVU7F29bwvIXf102wHCFq0l4Di9B64Vgju8cF/9Ibq7UVSvw7GMLbJYPETRVvv08lXzORkwYgGDI2gQ+KJN9LRwocvPRch9a5hALEod8x6FaQ==;7:FjHVrgpTlp1Wz08mKA8xoaXuE+RxLrdhKCMhFfwhUARZTEaFm9/wYy87Ze36UhjUkmVOvzcymwxREZ7LFrgks+c4fziGlyc62QjSO99EpQHKZbp2gvsFrHyrTN+FeCMcWa1frUPERzI4HypeSsMC7A==
x-ms-office365-filtering-correlation-id: e0e1e52a-c171-4e37-3039-08d67c7eaf75
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600109)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR11MB3464;
x-ms-traffictypediagnostic: BYAPR11MB3464:
x-microsoft-antispam-prvs: <BYAPR11MB3464723728F8A74E5D74FE1FE3830@BYAPR11MB3464.namprd11.prod.outlook.com>
x-forefront-prvs: 0920602B08
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(366004)(136003)(39860400002)(376002)(396003)(199004)(189003)(14454004)(68736007)(81166006)(81156014)(5660300001)(8936002)(2906002)(53946003)(106356001)(8676002)(26005)(305945005)(7736002)(6486002)(6436002)(5640700003)(36756003)(86362001)(99286004)(478600001)(6916009)(30864003)(50226002)(72206003)(45080400002)(78486014)(76176011)(2501003)(66066001)(4326008)(97736004)(486006)(25786009)(6506007)(476003)(102836004)(14444005)(256004)(386003)(53936002)(2616005)(54906003)(6512007)(71190400001)(71200400001)(105586002)(107886003)(3846002)(52116002)(186003)(2351001)(6116002)(316002)(11346002)(446003);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR11MB3464;H:BYAPR11MB2567.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 4fPgocGUn+eVWICy5GP/r+bweqE72o3L0gJMwf8bB/o2VpRzfXl9q8KuUxnvcDkjXItwUJZRhgxQiaLxgAij5P5E9FXEhpBcccVmxYn/kVZt9x1yOVzKbMD8PBjzFp4PQhd+VOGPjfu9qsVghKswyVbXPRzpMTwWP7G7jPHC3MyX9jg9iNco+b6cS2g0i3y6qZNOc7AFrCtOvzl/2rZTqq0NiNJkshJqEF0lZdEukHCZm4zlHFJkq8AP4zyN9C4EW4UFuQNiY6pfiwRztdYhPjJJJiTF/culzMUqXdDWaA7c0VMI0IkNM2pXrc1+kWRIhwtM9u79wddk4667T9mefmo15Kz2XDVTZzv+S2qETrPArl+Lz2DG7a3NH6baXaQhthjDidATnei7BmldtZN7s5DqeZZ4X3gFoKZ9175/gsE=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e0e1e52a-c171-4e37-3039-08d67c7eaf75
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2019 13:21:24.8324
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3464
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Ajay Singh <ajay.kathat@microchip.com>

Refactor code to use struct to construct the join parameters. Avoid use
of extra buffer before sending to FW instead directly pass the struct
pointer.

Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
---
 drivers/staging/wilc1000/host_interface.c         | 404 ++++++++----------=
----
 drivers/staging/wilc1000/host_interface.h         |  18 +-
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |   2 +-
 drivers/staging/wilc1000/wilc_wlan_if.h           |   1 -
 4 files changed, 142 insertions(+), 283 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wi=
lc1000/host_interface.c
index 2fb5697..46fd448 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -86,34 +86,50 @@ struct host_if_msg {
 	bool is_sync;
 };
=20
-struct join_bss_param {
-	enum bss_types bss_type;
+struct wilc_noa_opp_enable {
+	u8 ct_window;
+	u8 cnt;
+	__le32 duration;
+	__le32 interval;
+	__le32 start_time;
+} __packed;
+
+struct wilc_noa_opp_disable {
+	u8 cnt;
+	__le32 duration;
+	__le32 interval;
+	__le32 start_time;
+} __packed;
+
+struct wilc_join_bss_param {
+	char ssid[IEEE80211_MAX_SSID_LEN];
+	u8 ssid_terminator;
+	u8 bss_type;
+	u8 ch;
+	__le16 cap_info;
+	u8 sa[ETH_ALEN];
+	u8 bssid[ETH_ALEN];
+	__le16 beacon_period;
 	u8 dtim_period;
-	u16 beacon_period;
-	u16 cap_info;
-	u8 bssid[6];
-	char ssid[MAX_SSID_LEN];
-	u8 ssid_len;
 	u8 supp_rates[MAX_RATES_SUPPORTED + 1];
-	u8 ht_capable;
 	u8 wmm_cap;
 	u8 uapsd_cap;
-	bool rsn_found;
+	u8 ht_capable;
+	u8 rsn_found;
 	u8 rsn_grp_policy;
 	u8 mode_802_11i;
-	u8 rsn_pcip_policy[3];
-	u8 rsn_auth_policy[3];
+	u8 p_suites[3];
+	u8 akm_suites[3];
 	u8 rsn_cap[2];
-	u32 tsf;
 	u8 noa_enabled;
-	u8 opp_enabled;
-	u8 ct_window;
-	u8 cnt;
+	__le32 tsf_lo;
 	u8 idx;
-	u8 duration[4];
-	u8 interval[4];
-	u8 start_time[4];
-};
+	u8 opp_enabled;
+	union {
+		struct wilc_noa_opp_disable opp_dis;
+		struct wilc_noa_opp_enable opp_en;
+	};
+} __packed;
=20
 static struct host_if_drv *terminated_handle;
 static struct mutex hif_deinit_lock;
@@ -329,10 +345,9 @@ static int wilc_send_connect_wid(struct wilc_vif *vif)
 	int result =3D 0;
 	struct wid wid_list[8];
 	u32 wid_cnt =3D 0, dummyval =3D 0;
-	u8 *cur_byte =3D NULL;
 	struct host_if_drv *hif_drv =3D vif->hif_drv;
 	struct user_conn_req *conn_attr =3D &hif_drv->usr_conn_req;
-	struct join_bss_param *bss_param =3D hif_drv->usr_conn_req.param;
+	struct wilc_join_bss_param *bss_param =3D hif_drv->usr_conn_req.param;
=20
 	wid_list[wid_cnt].id =3D WID_SUCCESS_FRAME_COUNT;
 	wid_list[wid_cnt].type =3D WID_INT;
@@ -372,96 +387,8 @@ static int wilc_send_connect_wid(struct wilc_vif *vif)
=20
 	wid_list[wid_cnt].id =3D WID_JOIN_REQ_EXTENDED;
 	wid_list[wid_cnt].type =3D WID_STR;
-	wid_list[wid_cnt].size =3D 112;
-	wid_list[wid_cnt].val =3D kmalloc(wid_list[wid_cnt].size, GFP_KERNEL);
-
-	if (!wid_list[wid_cnt].val) {
-		result =3D -EFAULT;
-		goto error;
-	}
-
-	cur_byte =3D wid_list[wid_cnt].val;
-
-	if (conn_attr->ssid) {
-		memcpy(cur_byte, conn_attr->ssid, conn_attr->ssid_len);
-		cur_byte[conn_attr->ssid_len] =3D '\0';
-	}
-	cur_byte +=3D MAX_SSID_LEN;
-	*(cur_byte++) =3D WILC_FW_BSS_TYPE_INFRA;
-
-	if (conn_attr->ch >=3D 1 && conn_attr->ch <=3D 14) {
-		*(cur_byte++) =3D conn_attr->ch;
-	} else {
-		netdev_err(vif->ndev, "Channel out of range\n");
-		*(cur_byte++) =3D 0xFF;
-	}
-	put_unaligned_le16(bss_param->cap_info, cur_byte);
-	cur_byte +=3D 2;
-
-	if (conn_attr->bssid)
-		memcpy(cur_byte, conn_attr->bssid, 6);
-	cur_byte +=3D 6;
-
-	if (conn_attr->bssid)
-		memcpy(cur_byte, conn_attr->bssid, 6);
-	cur_byte +=3D 6;
-
-	put_unaligned_le16(bss_param->beacon_period, cur_byte);
-	cur_byte +=3D 2;
-	*(cur_byte++)  =3D  bss_param->dtim_period;
-
-	memcpy(cur_byte, bss_param->supp_rates, MAX_RATES_SUPPORTED + 1);
-	cur_byte +=3D (MAX_RATES_SUPPORTED + 1);
-
-	*(cur_byte++)  =3D  bss_param->wmm_cap;
-	*(cur_byte++)  =3D bss_param->uapsd_cap;
-
-	*(cur_byte++)  =3D bss_param->ht_capable;
-	conn_attr->ht_capable =3D bss_param->ht_capable;
-
-	*(cur_byte++)  =3D  bss_param->rsn_found;
-	*(cur_byte++)  =3D  bss_param->rsn_grp_policy;
-	*(cur_byte++) =3D  bss_param->mode_802_11i;
-
-	memcpy(cur_byte, bss_param->rsn_pcip_policy,
-	       sizeof(bss_param->rsn_pcip_policy));
-	cur_byte +=3D sizeof(bss_param->rsn_pcip_policy);
-
-	memcpy(cur_byte, bss_param->rsn_auth_policy,
-	       sizeof(bss_param->rsn_auth_policy));
-	cur_byte +=3D sizeof(bss_param->rsn_auth_policy);
-
-	memcpy(cur_byte, bss_param->rsn_cap, sizeof(bss_param->rsn_cap));
-	cur_byte +=3D sizeof(bss_param->rsn_cap);
-
-	*(cur_byte++) =3D bss_param->noa_enabled;
-
-	if (bss_param->noa_enabled) {
-		put_unaligned_le32(bss_param->tsf, cur_byte);
-		cur_byte +=3D 4;
-
-		*(cur_byte++) =3D bss_param->idx;
-		*(cur_byte++) =3D bss_param->opp_enabled;
-
-		if (bss_param->opp_enabled)
-			*(cur_byte++) =3D bss_param->ct_window;
-
-		*(cur_byte++) =3D bss_param->cnt;
-
-		memcpy(cur_byte, bss_param->duration,
-		       sizeof(bss_param->duration));
-		cur_byte +=3D sizeof(bss_param->duration);
-
-		memcpy(cur_byte, bss_param->interval,
-		       sizeof(bss_param->interval));
-		cur_byte +=3D sizeof(bss_param->interval);
-
-		memcpy(cur_byte, bss_param->start_time,
-		       sizeof(bss_param->start_time));
-		cur_byte +=3D sizeof(bss_param->start_time);
-	}
-
-	cur_byte =3D wid_list[wid_cnt].val;
+	wid_list[wid_cnt].size =3D sizeof(*bss_param);
+	wid_list[wid_cnt].val =3D (u8 *)bss_param;
 	wid_cnt++;
=20
 	result =3D wilc_send_config_pkt(vif, WILC_SET_CFG, wid_list,
@@ -469,13 +396,11 @@ static int wilc_send_connect_wid(struct wilc_vif *vif=
)
 				      wilc_get_vif_idx(vif));
 	if (result) {
 		netdev_err(vif->ndev, "failed to send config packet\n");
-		kfree(cur_byte);
 		goto error;
 	} else {
 		hif_drv->hif_state =3D HOST_IF_WAITING_CONN_RESP;
 	}
=20
-	kfree(cur_byte);
 	return 0;
=20
 error:
@@ -561,181 +486,130 @@ static void handle_connect_timeout(struct work_stru=
ct *work)
 	kfree(msg);
 }
=20
-static void host_int_fill_join_bss_param(struct join_bss_param *param,
-					 const u8 *ies, u16 *out_index,
-					 u8 *pcipher_tc, u8 *auth_total_cnt,
-					 u32 tsf_lo, u8 *rates_no)
+void *wilc_parse_join_bss_param(struct cfg80211_bss *bss,
+				struct cfg80211_crypto_settings *crypto)
 {
-	u8 ext_rates_no;
-	u16 offset;
-	u8 pcipher_cnt;
-	u8 auth_cnt;
-	u8 i, j;
-	u16 index =3D *out_index;
-
-	if (ies[index] =3D=3D WLAN_EID_SUPP_RATES) {
-		*rates_no =3D ies[index + 1];
-		param->supp_rates[0] =3D *rates_no;
-		index +=3D 2;
+	struct wilc_join_bss_param *param;
+	struct ieee80211_p2p_noa_attr noa_attr;
+	u8 rates_len =3D 0;
+	const u8 *tim_elm, *ssid_elm, *rates_ie, *supp_rates_ie;
+	const u8 *ht_ie, *wpa_ie, *wmm_ie, *rsn_ie;
+	int ret;
+	const struct cfg80211_bss_ies *ies =3D bss->ies;
=20
-		for (i =3D 0; i < *rates_no; i++)
-			param->supp_rates[i + 1] =3D ies[index + i];
+	param =3D kzalloc(sizeof(*param), GFP_KERNEL);
+	if (!param)
+		return NULL;
=20
-		index +=3D *rates_no;
-	} else if (ies[index] =3D=3D WLAN_EID_EXT_SUPP_RATES) {
-		ext_rates_no =3D ies[index + 1];
-		if (ext_rates_no > (MAX_RATES_SUPPORTED - *rates_no))
-			param->supp_rates[0] =3D MAX_RATES_SUPPORTED;
-		else
-			param->supp_rates[0] +=3D ext_rates_no;
-		index +=3D 2;
-		for (i =3D 0; i < (param->supp_rates[0] - *rates_no); i++)
-			param->supp_rates[*rates_no + i + 1] =3D ies[index + i];
+	param->beacon_period =3D bss->beacon_interval;
+	param->cap_info =3D bss->capability;
+	param->bss_type =3D WILC_FW_BSS_TYPE_INFRA;
+	param->ch =3D ieee80211_frequency_to_channel(bss->channel->center_freq);
+	ether_addr_copy(param->bssid, bss->bssid);
=20
-		index +=3D ext_rates_no;
-	} else if (ies[index] =3D=3D WLAN_EID_HT_CAPABILITY) {
-		param->ht_capable =3D true;
-		index +=3D ies[index + 1] + 2;
-	} else if ((ies[index] =3D=3D WLAN_EID_VENDOR_SPECIFIC) &&
-		   (ies[index + 2] =3D=3D 0x00) && (ies[index + 3] =3D=3D 0x50) &&
-		   (ies[index + 4] =3D=3D 0xF2) && (ies[index + 5] =3D=3D 0x02) &&
-		   ((ies[index + 6] =3D=3D 0x00) || (ies[index + 6] =3D=3D 0x01)) &&
-		   (ies[index + 7] =3D=3D 0x01)) {
-		param->wmm_cap =3D true;
-
-		if (ies[index + 8] & BIT(7))
-			param->uapsd_cap =3D true;
-		index +=3D ies[index + 1] + 2;
-	} else if ((ies[index] =3D=3D WLAN_EID_VENDOR_SPECIFIC) &&
-		 (ies[index + 2] =3D=3D 0x50) && (ies[index + 3] =3D=3D 0x6f) &&
-		 (ies[index + 4] =3D=3D 0x9a) &&
-		 (ies[index + 5] =3D=3D 0x09) && (ies[index + 6] =3D=3D 0x0c)) {
-		u16 p2p_cnt;
-
-		param->tsf =3D tsf_lo;
-		param->noa_enabled =3D 1;
-		param->idx =3D ies[index + 9];
+	ssid_elm =3D cfg80211_find_ie(WLAN_EID_SSID, ies->data, ies->len);
+	if (ssid_elm) {
+		if (ssid_elm[1] <=3D IEEE80211_MAX_SSID_LEN)
+			memcpy(param->ssid, ssid_elm + 2, ssid_elm[1]);
+	}
=20
-		if (ies[index + 10] & BIT(7)) {
-			param->opp_enabled =3D 1;
-			param->ct_window =3D ies[index + 10];
-		} else {
-			param->opp_enabled =3D 0;
-		}
+	tim_elm =3D cfg80211_find_ie(WLAN_EID_TIM, ies->data, ies->len);
+	if (tim_elm && tim_elm[1] >=3D 2)
+		param->dtim_period =3D tim_elm[3];
=20
-		param->cnt =3D ies[index + 11];
-		p2p_cnt =3D index + 12;
+	memset(param->p_suites, 0xFF, 3);
+	memset(param->akm_suites, 0xFF, 3);
=20
-		memcpy(param->duration, ies + p2p_cnt, 4);
-		p2p_cnt +=3D 4;
+	rates_ie =3D cfg80211_find_ie(WLAN_EID_SUPP_RATES, ies->data, ies->len);
+	if (rates_ie) {
+		rates_len =3D rates_ie[1];
+		param->supp_rates[0] =3D rates_len;
+		memcpy(&param->supp_rates[1], rates_ie + 2, rates_len);
+	}
=20
-		memcpy(param->interval, ies + p2p_cnt, 4);
-		p2p_cnt +=3D 4;
+	supp_rates_ie =3D cfg80211_find_ie(WLAN_EID_EXT_SUPP_RATES, ies->data,
+					 ies->len);
+	if (supp_rates_ie) {
+		if (supp_rates_ie[1] > (MAX_RATES_SUPPORTED - rates_len))
+			param->supp_rates[0] =3D MAX_RATES_SUPPORTED;
+		else
+			param->supp_rates[0] +=3D supp_rates_ie[1];
=20
-		memcpy(param->start_time, ies + p2p_cnt, 4);
+		memcpy(&param->supp_rates[rates_len + 1], supp_rates_ie + 2,
+		       (param->supp_rates[0] - rates_len));
+	}
=20
-		index +=3D ies[index + 1] + 2;
-	} else if ((ies[index] =3D=3D WLAN_EID_RSN) ||
-		 ((ies[index] =3D=3D WLAN_EID_VENDOR_SPECIFIC) &&
-		  (ies[index + 2] =3D=3D 0x00) &&
-		  (ies[index + 3] =3D=3D 0x50) && (ies[index + 4] =3D=3D 0xF2) &&
-		  (ies[index + 5] =3D=3D 0x01))) {
-		u16 rsn_idx =3D index;
+	ht_ie =3D cfg80211_find_ie(WLAN_EID_HT_CAPABILITY, ies->data, ies->len);
+	if (ht_ie)
+		param->ht_capable =3D true;
=20
-		if (ies[rsn_idx] =3D=3D WLAN_EID_RSN) {
-			param->mode_802_11i =3D 2;
+	ret =3D cfg80211_get_p2p_attr(ies->data, ies->len,
+				    IEEE80211_P2P_ATTR_ABSENCE_NOTICE,
+				    (u8 *)&noa_attr, sizeof(noa_attr));
+	if (ret > 0) {
+		param->tsf_lo =3D cpu_to_le32(ies->tsf);
+		param->noa_enabled =3D 1;
+		param->idx =3D noa_attr.index;
+		if (noa_attr.oppps_ctwindow & IEEE80211_P2P_OPPPS_ENABLE_BIT) {
+			param->opp_enabled =3D 1;
+			param->opp_en.ct_window =3D noa_attr.oppps_ctwindow;
+			param->opp_en.cnt =3D noa_attr.desc[0].count;
+			param->opp_en.duration =3D noa_attr.desc[0].duration;
+			param->opp_en.interval =3D noa_attr.desc[0].interval;
+			param->opp_en.start_time =3D noa_attr.desc[0].start_time;
 		} else {
-			if (param->mode_802_11i =3D=3D 0)
-				param->mode_802_11i =3D 1;
-			rsn_idx +=3D 4;
-		}
-
-		rsn_idx +=3D 7;
-		param->rsn_grp_policy =3D ies[rsn_idx];
-		rsn_idx++;
-		offset =3D ies[rsn_idx] * 4;
-		pcipher_cnt =3D (ies[rsn_idx] > 3) ? 3 : ies[rsn_idx];
-		rsn_idx +=3D 2;
-
-		i =3D *pcipher_tc;
-		j =3D 0;
-		for (; i < (pcipher_cnt + *pcipher_tc) && i < 3; i++, j++) {
-			u8 *policy =3D  &param->rsn_pcip_policy[i];
-
-			*policy =3D ies[rsn_idx + ((j + 1) * 4) - 1];
+			param->opp_enabled =3D 0;
+			param->opp_dis.cnt =3D noa_attr.desc[0].count;
+			param->opp_dis.duration =3D noa_attr.desc[0].duration;
+			param->opp_dis.interval =3D noa_attr.desc[0].interval;
+			param->opp_dis.start_time =3D noa_attr.desc[0].start_time;
 		}
-
-		*pcipher_tc +=3D pcipher_cnt;
-		rsn_idx +=3D offset;
-
-		offset =3D ies[rsn_idx] * 4;
-
-		auth_cnt =3D (ies[rsn_idx] > 3) ? 3 : ies[rsn_idx];
-		rsn_idx +=3D 2;
-		i =3D *auth_total_cnt;
-		j =3D 0;
-		for (; i < (*auth_total_cnt + auth_cnt); i++, j++) {
-			u8 *policy =3D  &param->rsn_auth_policy[i];
-
-			*policy =3D ies[rsn_idx + ((j + 1) * 4) - 1];
+	}
+	wmm_ie =3D cfg80211_find_vendor_ie(WLAN_OUI_MICROSOFT,
+					 WLAN_OUI_TYPE_MICROSOFT_WMM,
+					 ies->data, ies->len);
+	if (wmm_ie) {
+		struct ieee80211_wmm_param_ie *ie;
+
+		ie =3D (struct ieee80211_wmm_param_ie *)wmm_ie;
+		if ((ie->oui_subtype =3D=3D 0 || ie->oui_subtype =3D=3D 1) &&
+		    ie->version =3D=3D 1) {
+			param->wmm_cap =3D true;
+			if (ie->qos_info & BIT(7))
+				param->uapsd_cap =3D true;
 		}
+	}
=20
-		*auth_total_cnt +=3D auth_cnt;
-		rsn_idx +=3D offset;
-
-		if (ies[index] =3D=3D WLAN_EID_RSN) {
-			param->rsn_cap[0] =3D ies[rsn_idx];
-			param->rsn_cap[1] =3D ies[rsn_idx + 1];
-			rsn_idx +=3D 2;
-		}
+	wpa_ie =3D cfg80211_find_vendor_ie(WLAN_OUI_MICROSOFT,
+					 WLAN_OUI_TYPE_MICROSOFT_WPA,
+					 ies->data, ies->len);
+	if (wpa_ie) {
+		param->mode_802_11i =3D 1;
 		param->rsn_found =3D true;
-		index +=3D ies[index + 1] + 2;
-	} else {
-		index +=3D ies[index + 1] + 2;
 	}
=20
-	*out_index =3D index;
-}
-
-void *wilc_parse_join_bss_param(struct cfg80211_bss *bss)
-{
-	struct join_bss_param *param;
-	u16 index =3D 0;
-	u8 rates_no =3D 0;
-	u8 pcipher_total_cnt =3D 0;
-	u8 auth_total_cnt =3D 0;
-	const u8 *tim_elm, *ssid_elm;
-	const struct cfg80211_bss_ies *ies =3D bss->ies;
+	rsn_ie =3D cfg80211_find_ie(WLAN_EID_RSN, ies->data, ies->len);
+	if (rsn_ie) {
+		int offset =3D 8;
=20
-	param =3D kzalloc(sizeof(*param), GFP_KERNEL);
-	if (!param)
-		return NULL;
-
-	param->beacon_period =3D bss->beacon_interval;
-	param->cap_info =3D bss->capability;
-	ether_addr_copy(param->bssid, bss->bssid);
-
-	ssid_elm =3D cfg80211_find_ie(WLAN_EID_SSID, ies->data, ies->len);
-	if (ssid_elm) {
-		param->ssid_len =3D ssid_elm[1];
-		if (param->ssid_len <=3D IEEE80211_MAX_SSID_LEN)
-			memcpy(param->ssid, ssid_elm + 2, param->ssid_len);
-		else
-			param->ssid_len =3D 0;
+		param->mode_802_11i =3D 2;
+		param->rsn_found =3D true;
+		//extract RSN capabilities
+		offset +=3D (rsn_ie[offset] * 4) + 2;
+		offset +=3D (rsn_ie[offset] * 4) + 2;
+		memcpy(param->rsn_cap, &rsn_ie[offset], 2);
 	}
=20
-	tim_elm =3D cfg80211_find_ie(WLAN_EID_TIM, ies->data, ies->len);
-	if (tim_elm && tim_elm[1] >=3D 2)
-		param->dtim_period =3D tim_elm[3];
+	if (param->rsn_found) {
+		int i;
=20
-	memset(param->rsn_pcip_policy, 0xFF, 3);
-	memset(param->rsn_auth_policy, 0xFF, 3);
+		param->rsn_grp_policy =3D crypto->cipher_group & 0xFF;
+		for (i =3D 0; i < crypto->n_ciphers_pairwise && i < 3; i++)
+			param->p_suites[i] =3D crypto->ciphers_pairwise[i] & 0xFF;
=20
-	while (index < ies->len)
-		host_int_fill_join_bss_param(param, ies->data, &index,
-					     &pcipher_total_cnt,
-					     &auth_total_cnt, ies->tsf,
-					     &rates_no);
+		for (i =3D 0; i < crypto->n_akm_suites && i < 3; i++)
+			param->akm_suites[i] =3D crypto->akm_suites[i] & 0xFF;
+	}
=20
 	return (void *)param;
 }
diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wi=
lc1000/host_interface.h
index 76da172..659e8cc 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -35,21 +35,6 @@ enum {
=20
 #define WILC_MAX_ASSOC_RESP_FRAME_SIZE   256
=20
-struct network_info {
-	s8 rssi;
-	u16 cap_info;
-	u8 ssid[MAX_SSID_LEN];
-	u8 ssid_len;
-	u8 bssid[6];
-	u16 beacon_period;
-	u8 dtim_period;
-	u8 ch;
-	u32 tsf_lo;
-	u8 *ies;
-	u16 ies_len;
-	u64 tsf;
-};
-
 struct connect_info {
 	u8 bssid[6];
 	u8 *req_ies;
@@ -288,5 +273,6 @@ int wilc_get_tx_power(struct wilc_vif *vif, u8 *tx_powe=
r);
 void wilc_scan_complete_received(struct wilc *wilc, u8 *buffer, u32 length=
);
 void wilc_network_info_received(struct wilc *wilc, u8 *buffer, u32 length)=
;
 void wilc_gnrl_async_info_received(struct wilc *wilc, u8 *buffer, u32 leng=
th);
-void *wilc_parse_join_bss_param(struct cfg80211_bss *bss);
+void *wilc_parse_join_bss_param(struct cfg80211_bss *bss,
+				struct cfg80211_crypto_settings *crypto);
 #endif
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/st=
aging/wilc1000/wilc_wfi_cfgoperations.c
index 5da03bb..5070cad 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -422,7 +422,7 @@ static int connect(struct wiphy *wiphy, struct net_devi=
ce *dev,
 		goto out_put_bss;
 	}
=20
-	join_params =3D wilc_parse_join_bss_param(bss);
+	join_params =3D wilc_parse_join_bss_param(bss, &sme->crypto);
 	if (!join_params) {
 		netdev_err(dev, "%s: failed to construct join param\n",
 			   __func__);
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc=
1000/wilc_wlan_if.h
index e2310d8..961b6bb 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -47,7 +47,6 @@ typedef void (*wilc_tx_complete_func_t)(void *, int);
  *
  ********************************************/
 #define WILC_MULTICAST_TABLE_SIZE	8
-#define MAX_SSID_LEN            33
 #define MAX_RATES_SUPPORTED     12
=20
 enum bss_types {
--=20
2.7.4

