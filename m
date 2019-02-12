Return-Path: <SRS0=LoJ4=QT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 299DBC282C4
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 06:17:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D213120863
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 06:17:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="sxaxG6Ro";
	dkim=pass (1024-bit key) header.d=marvell.onmicrosoft.com header.i=@marvell.onmicrosoft.com header.b="PZ6Me+vG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbfBLGRF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Feb 2019 01:17:05 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:52686 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727004AbfBLGRF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Feb 2019 01:17:05 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x1C6B6JV031150;
        Mon, 11 Feb 2019 22:17:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0818; bh=VUZTkjL2sHy1/I46zFm6q2ejs2ytfRmUXA6D5/6ypN0=;
 b=sxaxG6RoXDNSlN1Q8mmJbGGcR7zNPu9KHl+X1qkfVAL5ajB9v3akH6OTBmezlovFyD22
 VLxjJdgrh1cDPF2dXHotqhfd64+phrZGNBOQIrjEIX3r9Qn1K5yaGu16hTBHJLJVFMrC
 AGR8i5MLTlhBwouSDwi1z4YH7vTrPlRtS2C9ls8iz7Swri1UAL2SITfF60CefGgZDeH9
 +4ggdEKdCxc6yNlMZ+Wk41nC6q1gRenu1gfLgTy3Yml/KDulQJnMKMIKeJ5131hnPWHl
 2n2yXMOxVWvZ2wb/a+gDXDtj/4rYGdYPU6K08F21/UZ/6blL/5tV3LelBWZUxex9OIin HQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2qke3wstgr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 11 Feb 2019 22:17:03 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Mon, 11 Feb
 2019 22:17:02 -0800
Received: from NAM01-BY2-obe.outbound.protection.outlook.com (104.47.34.52) by
 SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Mon, 11 Feb 2019 22:17:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VUZTkjL2sHy1/I46zFm6q2ejs2ytfRmUXA6D5/6ypN0=;
 b=PZ6Me+vGsrvOL79uzNk0j1poYZn4dyn1p+DUHzFV7oGHCE0hqPq7aaO+2eJhkEksdF/sMW1VxgmD9mZ/raVgU0xbawXFV7UZpgjBbvY/LnBttrlgtqhZeEuIC8I6u9dsfqPd4uUOUz+8Gq0mgtyVcHEGPIVY50qzHeuH/esZp90=
Received: from DM5PR18MB1241.namprd18.prod.outlook.com (10.173.213.19) by
 DM5PR18MB1436.namprd18.prod.outlook.com (10.173.214.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1601.17; Tue, 12 Feb 2019 06:17:01 +0000
Received: from DM5PR18MB1241.namprd18.prod.outlook.com
 ([fe80::80ab:3d5c:ce35:9968]) by DM5PR18MB1241.namprd18.prod.outlook.com
 ([fe80::80ab:3d5c:ce35:9968%11]) with mapi id 15.20.1601.023; Tue, 12 Feb
 2019 06:17:01 +0000
From:   Ganapathi Bhat <gbhat@marvell.com>
To:     "linux-firmware@kernel.org" <linux-firmware@kernel.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Cathy Luo" <cluo@marvell.com>, James Cao <jcao@marvell.com>,
        Prashanth Ranganathan <rprashk@marvell.com>,
        Rakesh Parmar <rakeshp@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>
Subject: pull-request mwifiex-firmware 2019-02-12
Thread-Topic: pull-request mwifiex-firmware 2019-02-12
Thread-Index: AQHUwpqDm1hAdJDnLEOcjL+AE9KoDA==
Date:   Tue, 12 Feb 2019 06:17:00 +0000
Message-ID: <DM5PR18MB12412307A7C6EDD99B522785A0650@DM5PR18MB1241.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [182.72.17.59]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a1ab86b0-23db-4d25-25dc-08d690b1b344
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600110)(711020)(4605077)(2017052603328)(7153060)(7193020);SRVR:DM5PR18MB1436;
x-ms-traffictypediagnostic: DM5PR18MB1436:
x-microsoft-exchange-diagnostics: 1;DM5PR18MB1436;20:EKbeBGdH9iHZbPGmkSguSx356UUHuwnmTJDXtwsHdtcYTwbWZgShR/1TXG5bf4kjWeFZi078dinLSDiG5YLjk5sQ5cgcGQwV7nZ2B1LVFpwBY65Z+rQOzzQPPE4fnyawfYOlrZeCA4wn9L2Dp7mUncqcenvUHj1cMFkLXgN4jEU=
x-microsoft-antispam-prvs: <DM5PR18MB1436FD41F63D7E52812490D8A0650@DM5PR18MB1436.namprd18.prod.outlook.com>
x-forefront-prvs: 0946DC87A1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(396003)(376002)(39860400002)(346002)(199004)(189003)(9686003)(54906003)(53936002)(7696005)(55016002)(5640700003)(68736007)(86362001)(97736004)(6436002)(14444005)(256004)(25786009)(74316002)(316002)(4326008)(107886003)(99286004)(3846002)(6116002)(2906002)(305945005)(6506007)(55236004)(81156014)(102836004)(78486014)(105586002)(8936002)(2501003)(81166006)(4744005)(7736002)(71200400001)(71190400001)(2351001)(476003)(106356001)(14454004)(66066001)(6916009)(26005)(186003)(8676002)(486006)(33656002)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR18MB1436;H:DM5PR18MB1241.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Ct8XbdwQ2WZGQYN+ojx7eyjzqJMFuqh2PKQNRJULIfIR4gdZ/DOEFoKPqJ817vl7qfI7zw6B4TVXGIShX8fiPVE60xfdzCihOgGApwibzYmFMYj//QbuFafVw65PA1zJJeW7MGVWjnQBnlbxsL12AZ62Hgx8CxrfhvJKMfRxF7m/AhFoglxp3bPxnTekWQzrBujgSofvc+uYZ/iKRODVFfyJI2eWi/qxrNB3nTkMiSBCAsBJ0gJQYFYa5QX3u7r2czp1VW+oJ2muMYsuiSsZRNyNH2ASYp7zL4YrszdV8q/6o8SfbQl++Iputy+FNBYH3sWfbsLUrk+xHROCWfQAd/LMFK00qpLgFPX8q3DNtMjTIQVFghcwfV/Nu56wr/nPZ1jPeMPa/afTolf/l7EElDXw0GiNV/FRrIn3b8VwPKo=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a1ab86b0-23db-4d25-25dc-08d690b1b344
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Feb 2019 06:17:00.9091
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB1436
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-02-12_05:,,
 signatures=0
X-Proofpoint-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=713 adultscore=3 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1902120046
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The following changes since commit 63ca64a73c05fa5bcceb687422cbc28185bb6355=
:

  linux-firmware: update Marvell USB8801 B0 firmware image (2019-01-09 11:2=
4:42 +0530)

are available in the git repository at:

  git://git.marvell.com/mwifiex-firmware.git

for you to fetch changes up to bd72387b8e49b1b7268ee60c97a131419284fb39:

  linux-firmware: update Marvell PCIe-USB8997 firmware image (2019-02-12 11=
:42:24 +0530)

----------------------------------------------------------------
Ganapathi Bhat (3):
      linux-firmware: add Marvell SD8977 firmware image
      linux-firmware: update Marvell SD8897-B0 firmware image
      linux-firmware: update Marvell PCIe-USB8997 firmware image

 WHENCE                        |   7 +++++--
 mrvl/pcieusb8997_combo_v4.bin | Bin 631012 -> 634228 bytes
 mrvl/sd8897_uapsta.bin        | Bin 821024 -> 701072 bytes
 mrvl/sdsd8977_combo_v2.bin    | Bin 0 -> 587052 bytes
 4 files changed, 5 insertions(+), 2 deletions(-)
 create mode 100755 mrvl/sdsd8977_combo_v2.bin=
