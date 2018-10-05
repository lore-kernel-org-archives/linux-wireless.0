Return-Path: <SRS0=2ErG=MR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6D24C00449
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 14:34:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B4D32084D
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 14:34:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="buOxxdbY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7B4D32084D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728898AbeJEVdd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 17:33:33 -0400
Received: from mail-eopbgr720080.outbound.protection.outlook.com ([40.107.72.80]:31520
        "EHLO NAM05-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727968AbeJEVdc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 17:33:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JvNxa39nNGOlzAfvUT4nrygkZtLNiFUp9GKD3SZyRVw=;
 b=buOxxdbYNnlB8CXThJgGKS2gg2u1epRseUucgrWD3RDU19Z/Pk6m9B7D6zuDiG+uupkdOZlGAQsx5FyL36V5nZQOktZW6pA1C2dFBnTOQ1aPFQE6midETbArI4Op+mMoFEeRxFvZjUMtkuJWhrF0lcdIDXw3cjnUQJjcjw9qiDU=
Received: from BYAPR05MB4597.namprd05.prod.outlook.com (52.135.233.18) by
 BYAPR05MB4615.namprd05.prod.outlook.com (52.135.233.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1207.11; Fri, 5 Oct 2018 14:33:34 +0000
Received: from BYAPR05MB4597.namprd05.prod.outlook.com
 ([fe80::fc58:438:5b30:9373]) by BYAPR05MB4597.namprd05.prod.outlook.com
 ([fe80::fc58:438:5b30:9373%4]) with mapi id 15.20.1207.021; Fri, 5 Oct 2018
 14:33:34 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     Cody Schuffelen <schuffelen@google.com>
CC:     Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>
Subject: Re: [PATCH net-next v3] wireless-drivers: rtnetlink wifi simulation
 device
Thread-Topic: [PATCH net-next v3] wireless-drivers: rtnetlink wifi simulation
 device
Thread-Index: AQHUXBznuCllGId5gkCyxGUX3pr0aaUQuIQA
Date:   Fri, 5 Oct 2018 14:33:34 +0000
Message-ID: <20181005143323.ezyd2x6x5ymlb7rg@bars>
References: <20181004195906.201895-1-schuffelen@google.com>
In-Reply-To: <20181004195906.201895-1-schuffelen@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6PR0402CA0009.eurprd04.prod.outlook.com
 (2603:10a6:209::22) To BYAPR05MB4597.namprd05.prod.outlook.com
 (2603:10b6:a03:4c::18)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR05MB4615;6:VF0H+UXBEg5ttXnKHAh7uMUo6jGrSycYK5+H2FzshlOk+HR9vCXLBTM9s1ArZ9X75ky025bobEmiV/Drvy9YTIIJODwumPDMV2bRl2U6A4uV7WNz6f8ga9qWsSUKPExW8KWJFXX6iogSXRP1P3r0cZlSoWGhfuWpa3ietFIr/V6hSgkOhXGprPx/sHrSalawmAXrdDC70zccqba7OYxAib/hG/+JdoeO4NxmKrta8ckQqTm2tSv+kNKMTWwuJ3iHTv7AjN7PQmuU7+xFbujhBfRmhZch7KnUL9a25BKRO8uQ4Hb2AJVYt148ZPxR2b+ViXvCxAxPfmvhD6wqUqW0w28v3jgQXPdwhZ5/+tBye4zQMYE21XJb0Xic3V65bvUseD9qsXmb1sptX/GqX8UOswabxR2RohroTHQRTNJWaIJs+GhBHAA4Iz+XcrPcSMMnJmjbBLvhbfx99W+C3U1d0w==;5:qyxrn8peCZv7ILaVyal+lTJ98NBHf4E1JPCIwusyXuYflfIZnAyoN/XkUM8GOlOc9gwRsWy8H4SV3ipxbnHrCkBEcBoKmXVF2ue7b2L9798iYAT2zGNFBpafv+1KpKHwb8vlPFFZ6t5I5fxJDS4XvSleB+jW1y3xc4dERWIFzv0=;7:U4AKJ4LAiktyb2uB89/MxFu4yiFcr/ejbU+TabXgDV1WT2AIe4FVlz+K269nM7q1LtFTl438Z2FP1cqxvDBNL1UMq8J2igNq1DIze90oSiZufe8X/Ckmy4RhZfb5eic+7SLM1PHiGbLxetwKqkBHG2mvlw7Nzf3bTxSjj4nWoGwTfMACcqn7FLnoZ6aWzhHE8FLqAG79JYQTwZlukpWIJkRT9hSTQV4b8CIR+GwhdF1wU6u1P408i8a3+72A1UM2
x-ms-office365-filtering-correlation-id: c3e39206-70ef-486e-9128-08d62acf8751
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR05MB4615;
x-ms-traffictypediagnostic: BYAPR05MB4615:
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-microsoft-antispam-prvs: <BYAPR05MB461531C95C5ACB5730FFFE36A3EB0@BYAPR05MB4615.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:(21532816269658);
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(5005006)(8121501046)(3002001)(10201501046)(93006095)(93001095)(3231355)(944501410)(52105095)(149066)(150057)(6041310)(20161123558120)(20161123560045)(20161123564045)(20161123562045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991048);SRVR:BYAPR05MB4615;BCL:0;PCL:0;RULEID:;SRVR:BYAPR05MB4615;
x-forefront-prvs: 0816F1D86E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(136003)(39850400004)(396003)(346002)(376002)(366004)(199004)(189003)(229853002)(446003)(106356001)(14454004)(11346002)(1076002)(105586002)(476003)(305945005)(6246003)(478600001)(7736002)(2906002)(3846002)(6116002)(186003)(25786009)(102836004)(4326008)(6506007)(54906003)(68736007)(81166006)(486006)(575784001)(26005)(52116002)(386003)(6436002)(8936002)(33896004)(2900100001)(71190400001)(6512007)(9686003)(76176011)(99286004)(53936002)(66066001)(71200400001)(97736004)(86362001)(5250100002)(6486002)(256004)(8676002)(81156014)(33716001)(5660300001)(14444005)(6916009)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB4615;H:BYAPR05MB4597.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: 0AASuXsu3/bpouCqV9Pv0Z3LRKsVAsiSJq+gdPAWQcRk5rMH85E3Lje4+Zz5OTtyiz8dOli2ain/nC1g4JIm7qgyhMRBKT+zHWkkMSmUchmmxHr8aUv4xmrd+W0yVLiClKsM5v1nsrD8CEK4yMG19Yk8zUKYJzu25YTHCqjM+4y6zztZshVz9r6ERAC76SJqaAvmaRaDA7O86FnTgQ907VMqttvfQZ/yWkFr2tuWNSlyxGOhVXnBN7jWVa4LAngrXrVyM5VRgGOg7ok5MFT4BL9vcgtfNd70hz5LAntoda+udenv8TE35ObrBWbffuu755ArpZbRshL+7YVBbnXc88JG6vSRzHz26w+e7YRLSis=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A0C73C402B4DBD4F908E872E3EFB1BE4@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3e39206-70ef-486e-9128-08d62acf8751
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2018 14:33:34.4636
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB4615
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Cody,

>  drivers/net/wireless/Kconfig     |   7 +
>  drivers/net/wireless/Makefile    |   2 +
>  drivers/net/wireless/virt_wifi.c | 618 +++++++++++++++++++++++++++++++
>  3 files changed, 627 insertions(+)
>  create mode 100644 drivers/net/wireless/virt_wifi.c

I did a quick check of your patch using checkpatch kernel tool,
here is a summary of its output:

$ ./scripts/checkpatch.pl --strict test.patch
...
total: 165 errors, 428 warnings, 9 checks, 634 lines checked

Most part of those complaints is about either whitespaces or code
idents. I am not sure whether this is a patch itself or email client.
So could you please take a look and run checkpatch on your side.

> +static void virt_wifi_scan_result(struct work_struct *work)
> +{
> +       const union {
> +               struct {
> +                       u8 tag;
> +                       u8 len;
> +                       u8 ssid[8];
> +               } __packed parts;
> +               u8 data[10];
> +       } ssid =3D { .parts =3D {
> +               .tag =3D WLAN_EID_SSID, .len =3D 8, .ssid =3D "VirtWifi" =
}
> +       };
> +       struct cfg80211_bss *informed_bss;
> +       struct virt_wifi_priv *priv =3D
> +               container_of(work, struct virt_wifi_priv,
> +                            scan_result.work);
> +       struct wiphy *wiphy =3D priv_to_wiphy(priv);
> +       struct cfg80211_inform_bss mock_inform_bss =3D {
> +               .chan =3D &channel_5ghz,
> +               .scan_width =3D NL80211_BSS_CHAN_WIDTH_20,
> +               .signal =3D -60,
> +               .boottime_ns =3D ktime_get_boot_ns(),
> +       };
> +       struct cfg80211_scan_info scan_info =3D {};
> +
> +       informed_bss =3D
> +               cfg80211_inform_bss_data(wiphy, &mock_inform_bss,
> +                                        CFG80211_BSS_FTYPE_PRESP,
> +                                        fake_router_bssid,
> +                                        mock_inform_bss.boottime_ns,
> +                                        WLAN_CAPABILITY_ESS, 0, ssid.dat=
a,
> +                                        sizeof(ssid), GFP_KERNEL);

It is possible to simplify this part switching to cfg80211_inform_bss
function: this function wraps your scan data in into cfg80211_inform_bss
structure internally using some reasonable defaults, e.g. channel width.

Besides, signal strength for scan entries should be passed in mBm units,
so use DBM_TO_MBM macro. For instance, with your current code 'iw' tool
produces the following output:
$ sudo iw dev wlan0 scan
	...
	signal: 0.-60 dBm
	...

> +static void virt_wifi_connect_complete(struct work_struct *work)
> +{
> +       struct virt_wifi_priv *priv =3D
> +               container_of(work, struct virt_wifi_priv, connect.work);
> +       u8 *requested_bss =3D priv->connect_requested_bss;
> +       bool has_addr =3D !is_zero_ether_addr(requested_bss);
> +       bool right_addr =3D ether_addr_equal(requested_bss, fake_router_b=
ssid);
> +       u16 status =3D WLAN_STATUS_SUCCESS;
> +
> +       rtnl_lock();
> +       if (!priv->netdev_is_up || (has_addr && !right_addr))
> +               status =3D WLAN_STATUS_UNSPECIFIED_FAILURE;
> +       else
> +               priv->is_connected =3D true;
> +
> +       cfg80211_connect_result(priv->netdev, requested_bss, NULL, 0, NUL=
L, 0,
> +                               status, GFP_KERNEL);
> +       rtnl_unlock();
> +}

Carrier state for wireless device depends on its connection state.
E.g., carrier is set when wireless connection succeeds and cleared
when device disconnects. So use netif_carrier_on/netif_carrier_off
calls in connect/disconnect handlers to set correct carrier state.
IIUC the following locations look reasonable:
 - netif_carrier_off on init
 - netif_carrier_on in virt_wifi_connect_complete on success
 - netif_carrier_off in virt_wifi_disconnect

> +static void virt_wifi_disconnect_complete(struct work_struct *work)
> +{
> +       struct virt_wifi_priv *priv =3D
> +               container_of(work, struct virt_wifi_priv, disconnect.work=
);
> +
> +       cfg80211_disconnected(priv->netdev, priv->disconnect_reason, NULL=
, 0,
> +                             true, GFP_KERNEL);
> +       priv->is_connected =3D false;
> +}

Why do you need delayed disconnect processing ? IIUC it can be dropped
and cfg80211_disconnected call can be moved to virt_wifi_disconnect.

> +
> +static int virt_wifi_get_station(struct wiphy *wiphy,
> +                                struct net_device *dev,
> +                                const u8 *mac,
> +                                struct station_info *sinfo)
> +{
> +       wiphy_debug(wiphy, "get_station\n");
> +
> +       if (!ether_addr_equal(mac, fake_router_bssid))
> +               return -ENOENT;
> +
> +       sinfo->filled =3D BIT(NL80211_STA_INFO_TX_PACKETS) |
> +               BIT(NL80211_STA_INFO_TX_FAILED) | BIT(NL80211_STA_INFO_SI=
GNAL) |
> +               BIT(NL80211_STA_INFO_TX_BITRATE);

Recently some of NL80211_STA_INFO_ attribute types has been modified to
use BIT_ULL macro. Could you please check commit 22d0d2fafca93ba1d92a
for details and modify your coded if needed.

> +       sinfo->tx_packets =3D 1;

Only one packet, really ? Not sure if you plan to use the output of 'iw'
or any other tool. If yes, then it probably makes sense to use stats
from the original network link. Otherwise, your 'iw' output is
going to look like this:

$ iw dev wlan0 station dump
	...
	tx packets:	1
	...

> +       sinfo->tx_failed =3D 0;

...

> +static int virt_wifi_dump_station(struct wiphy *wiphy,
> +                                 struct net_device *dev,
> +                                 int idx,
> +                                 u8 *mac,
> +                                 struct station_info *sinfo)
> +{
> +       wiphy_debug(wiphy, "dump_station\n");
> +
> +       if (idx !=3D 0)
> +               return -ENOENT;
> +
> +       ether_addr_copy(mac, fake_router_bssid);
> +       return virt_wifi_get_station(wiphy, dev, fake_router_bssid, sinfo=
);
> +}

Callback dump_station should return AP data only when STA is connected.
Currently your driver returns fake AP data even when it is not
connected.

> +static const struct cfg80211_ops virt_wifi_cfg80211_ops =3D {
> +       .scan =3D virt_wifi_scan,
> +
> +       .connect =3D virt_wifi_connect,
> +       .disconnect =3D virt_wifi_disconnect,
> +
> +       .get_station =3D virt_wifi_get_station,
> +       .dump_station =3D virt_wifi_dump_station,
> +};

Hey, this minimal cfg80211 implementation works fine with wpa_supplicant
and open AP config. By the way, if you plan to add more features, then
I would suggest to consider the following cfg80211 callbacks:
- change_station, get_channel
  to provide more info in connected state, e.g. compare the output
  of the following commands between your virtual interface and=20
  actual wireless interface:
  $ iw dev wlan0 link
  $ iw dev wlan0 info

- stubs for add_key, del_key to enable encrypted AP simulation

Regards,
Sergey
