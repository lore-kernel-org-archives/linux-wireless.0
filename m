Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.130.19
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792649283;
	b=fXTLCJh5kOy4mrPzVssbkTMLMZxPdHi9wbKJ3y4bmifK3eP0X2ekFB/Qh+b6sXB5uSS7
	 a/tKAPF2ZDM+NzhxAdgd3MQfcA3ZqQCPMF5B72hsYUn/vpSUXbGRGRJRmPIJdXGRTa5ht
	 xF1tjBUD4Sj6yi1PO21N+IBnsGK7pdxcAne2We+vQ4U5CBNclh3IlSM1tR6ZAeRH/BGBw
	 /L2FZ5ETDQE5z5abtuD5QOA1LukqMl+HYwJYQAC7yuvEcthVbe2PMzZshTRc98q0qXPDY
	 wXqeZdihsQ7rcUs9hwOj3mxgW9KmSllwn+fTd3vOJ+ZgU7s34HeTBU9X/0UqzUIaGwQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792649283;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:X-OriginalArrivalTime:
	 X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:Content-Type:
	 X-MS-Office365-Filtering-Correlation-Id:X-SET-LOWER-SCL-SCANNER:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=YFthrKfKmSAcUSyW22/xyDsvmiE466rfFMP+jKjZ0Dc=;
	b=FNCsvXgNbaELHrkJuw4H6Zp0onbFFnwKHuA6au+DXEenOKNGjRHc8YYhm5MrxnN/W67r
	 nCvav5yRpkM7L6AT2zpbhiwqjsHhr9sxxpA1yOseeXAFq/7Up/RV5H2RqsGp1IPX2PKiJ
	 yqRGWw1KBbe5zDag5frgcuxT10yxO1KJvjE5CvuPlE6Hk4ZlOcCAJ++so4w7pyuN4wCQX
	 eSP1fw2x/8RPxY8kn9l0DI1j5IPu5LH1RpLWNNSrfRQIKenVdzctUDm7z0KIu8gIKzdPK
	 oet27gSd1SmFqoddnkkex0tW4lKocRKPu9C+i6VPpHxRQH1ml0qqZv/gzDmyimFnVrA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=leica-geosystems.com;
	spf=fail smtp.mailfrom=leica-geosystems.com;
	dkim=pass header.d=leica-geosystems.com header.i=@leica-geosystems.com header.a=rsa-sha256 header.s=selector1 header.b=tTNxSY4s;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.130.19
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011019.outbound.protection.outlook.com [40.107.130.19])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A19606A319
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 06:08:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E2A19606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=leica-geosystems.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=leica-geosystems.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=leica-geosystems.com header.i=@leica-geosystems.com header.a=rsa-sha256 header.s=selector1 header.b=tTNxSY4s
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ADBbxGxI1lO1pvVnlgGA9FCrKsG++X5Qarnc1Bwx90FsW0ScIZxYUIU9FjaEqRRIdKsjs9tmhuq12o617LabRrdBqB4jcGIyyb49LPfzCrZ87a06ULUslDPenWrUF7hzbOQo/tzFWAuTOXoCyahLNy3gB6mcPFGzfaf6m2u2oyaJqNwubh1+trUu2d9+9gu3hggMJq8rej5jKme3Gln/c8sZpmY+sh6waZH8e8eobncsBXaE7s3lfcqDRmFxRz0A7LoT2vhZ943lvklUed5GmbbcIxE+nt04LdsiR4jQ+xVcLpkO2EvR7GJXmLk3Cn5Phm6EPKqT6MncQKfuZeNrwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YFthrKfKmSAcUSyW22/xyDsvmiE466rfFMP+jKjZ0Dc=;
 b=LCsIX/5CKlrx0HgknKY6796781cDh+x6JV7hHklYzbspp8ijhPVZE8prhPVsdp44Ote2QiH2YZuUU8cOjiqeGMec7ZKdVgp4HvKdmW/1gVkY9P/UVK8I/qSur3KcN977hRDCiynlmiP5xN1cxJEx7lhtwF2yaMOi6JFaT62u/r09NLtPjnSEvhFg++aDuKIuY9cnEI9nk+LF4V1qGw0cw32EvTUYKeyuMLJiK+PwKwCJmQzie7LLpcuCyFP/aPA7tgybJswSVyNZ61iRHtAvURwoNZxIyv78MHEWcoRe2zFgexubYQHTxsxmxbdpYlPU8TSw9t93q3zpAMitHPKp/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 193.8.40.99) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=leica-geosystems.com; dmarc=pass (p=reject sp=reject pct=100)
 action=none header.from=leica-geosystems.com; dkim=none (message not signed);
 arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=leica-geosystems.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YFthrKfKmSAcUSyW22/xyDsvmiE466rfFMP+jKjZ0Dc=;
 b=tTNxSY4s0gCNE5Wm0J7+dJwjg9R7R/YoDXXGCXxOeoUtmzTtOEnD0FxJIua3GyVls8E5XRKWNNlB1l/LB/a4Kfa0aB8wWBE2JX2Wv3AUeh0g0RlZl2CSnJ6k7rHWcbd1TYlBKdcap1Z+SiNJAFIfAWo/RNX+8sDMfY8vVlBTVMQ=
Received: from AS9PR06CA0315.eurprd06.prod.outlook.com (2603:10a6:20b:45b::26)
 by AS8PR06MB7845.eurprd06.prod.outlook.com (2603:10a6:20b:3c4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.15; Thu, 22 Oct
 2026 06:07:58 +0000
Received: from AMS1EPF0000008D.eurprd05.prod.outlook.com
 (2603:10a6:20b:45b:cafe::78) by AS9PR06CA0315.outlook.office365.com
 (2603:10a6:20b:45b::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.546.16 via Frontend Transport; Thu,
 22 Oct 2026 06:07:58 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 193.8.40.99) smtp.mailfrom=leica-geosystems.com; dkim=none (message not
 signed) header.d=none;dmarc=pass action=none
 header.from=leica-geosystems.com;
Received-SPF: Pass (protection.outlook.com: domain of leica-geosystems.com
 designates 193.8.40.99 as permitted sender) receiver=protection.outlook.com;
 client-ip=193.8.40.99; helo=hexagon.com; pr=C
Received: from hexagon.com (193.8.40.99) by
 AMS1EPF0000008D.mail.protection.outlook.com (10.167.242.84) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.546.15 via Frontend Transport; Thu, 22 Oct 2026 06:07:58 +0000
Received: from aherlnxbspsrv01.lgs-net.com ([10.61.228.61]) by hexagon.com with Microsoft SMTPSVC(10.0.17763.1697);
	 Thu, 22 Oct 2026 08:07:58 +0200
From: Johannes Schneider <johannes.schneider@leica-geosystems.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: ath12k@lists.infradead.org,
	linux-wireless@vger.kernel.org
Subject: ath12k: WCN7850: PTP hardware clock and time stamping - which timer and offset registers may the driver use?
Date: Thu, 22 Oct 2026 06:07:41 +0000
Message-ID: <20261022060744.1385839-1-johannes.schneider@leica-geosystems.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 22 Oct 2026 06:07:58.0559 (UTC) FILETIME=[AFCC3EF0:01DD61EB]
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AMS1EPF0000008D:EE_|AS8PR06MB7845:EE_
Content-Type: text/plain
X-MS-Office365-Filtering-Correlation-Id: 843d2bbb-05d1-4271-b12a-08df3002d25b
X-SET-LOWER-SCL-SCANNER: YES
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|30052699003|1800799024|376014|36860700016|82310400026|23010399003|56012099006|11063799006|261021123027099003|6133799003|18002099003|261009223027099003|10067099003|261021121427099003;
X-Microsoft-Antispam-Message-Info:
	fc3+1lVhDT0jkGWG2KXzrehTFLBWet8kR0vcuyG0WK/sKIaFyzcpxEE4Vc3oqsHCurmbgXSM2xT8/mW4iePm31bcBTvTDpCauF8p+BojmSu+H5IV0j7yeon84OKmXhDMTLHNc6XpOqOlb02dezzL/DN57HVm7TSJVJA68KzTUZugjF1g1NYOqK/jmRenOyvBb3souIB9KJDQeljzqh3Zzbp3x6y4+v0iCoCaTcTmxgSWUEzKyPtvx85j6eoc9uoN8wpUJcKnM3/qttvT8KG8SXuEHJW+tbj4cbUgW/0+ME8EUFEC8eUp+9vBGxNOBBXONWDl07QbB8eJ/Qrb5f+DYoGkBYhSFBi/u1nZxv/WFN0xoQGOBkzdA6ddCXWuEOaP6ru1URYZOEORN7yJ/8+xAOqgIIaZQb0V7dlaA1gpIHdT2CijhgROyiNV2tB+Q5UqGqnNSY5YzKsCeYxG0eb8CrfGzaaj/8s4XOs6wIipP0CZUweyeuZn5T5SPSJgnhZUjg18cL5dv+DoNL8ut76KPM20xSkx3Up1dMjQSxUcGBrbXu84yWURRkeuQ3h74b5CjsNYJ00r266kZHzX46rJIPWgH/SL1L97j5kGO1R8ZBc+nsI95ta0ILHGwu4yX4QvTgfchvJ/vk4IMGIEni1PBAK6y7X5qG7TxiWAymm9T2G3ftuPLQuZnwVed5DlIDAjgnTC5jElw9qBiSv4JLHoJA==
X-Forefront-Antispam-Report:
	CIP:193.8.40.99;CTRY:CH;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:hexagon.com;PTR:ahersrvdom51.leica-geosystems.com;CAT:NONE;SFS:(13230040)(30052699003)(1800799024)(376014)(36860700016)(82310400026)(23010399003)(56012099006)(11063799006)(261021123027099003)(6133799003)(18002099003)(261009223027099003)(10067099003)(261021121427099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	prZpQuB1IWtPPGJpW6PO0zgWXAcdE257KPf81u4+Ad13b01lHxRqa370i0nUCBhR/buhSNQY9sQGSS3ctNwFu5nGSRxXOCdFYilaAvvkLK6lsm8iFhYqM0dMNbWM6WWO5zU0MPyoJ9IePhj5IatpMB9mF+bhW/2NsfK/LnwCiW6eLlF7y31dexajlFdtnRYrt9MsUoAusVgz3FxNKvBC3HVG3AECJrtQErPX3QzM5WEyJFXgPrCH+qZVDrrNTCTaVAD7zcOZimQnDlPHIimjcyxogmF3HfUIKwjqBhPrD+iFslhzqpNzs/12N4i8ZXPQ/5nMzOnIqvLSeuSqNcz64gX02af3Z0IVlDHfdbf+QDAxy4MPyUzGsXQGZk8wsm5xsLD1v8/zsE4zQBDzsHhGRFn4oCDxlt59ydJKVG71VrRaKp9BDR/Z/6l/CzzBdmKe
X-OriginatorOrg: leica-geosystems.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2026 06:07:58.6809
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 843d2bbb-05d1-4271-b12a-08df3002d25b
X-MS-Exchange-CrossTenant-Id: 1b16ab3e-b8f6-4fe3-9f3e-2db7fe549f6a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=1b16ab3e-b8f6-4fe3-9f3e-2db7fe549f6a;Ip=[193.8.40.99];Helo=[hexagon.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF0000008D.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR06MB7845

Hoi Jeff, all,


we have hardware time stamping and a PTP hardware clock working on
WCN7850 (hw2.0, firmware WLAN.HMT.1.1.c7-00108) with mainline ath12k
(v6.16), so linuxptp and chrony can synchronize the system clock over
Wi-Fi. Between two WCN7850 M.2 cards on i.MX8M Mini EVKs, one AP and
one STA, the client PHC stays within 0.95 us SD (p99 3.45 us) of the
master over 6 h, measured against an independent Ethernet PTP
reference.

Before posting the series as an RFC, we would like to know whether
the pieces it relies on are acceptable in ath12k, or whether there is
a supported alternative.

What the series uses:

- PHC: the free-running Qtimer, read at MHI_TIME (0xa28/0xa2c),
  19.2 MHz.
- TX stamp: the TSF in the TX completion (rate_stats.tsf).
- RX stamp: the RXPCU_PPDU_END_INFO TSF minus rx_duration, from the RX
  monitor status ring running beside the STA/AP vdev (no monitor
  vdev), matched to the frame by phy_ppdu_id; MPDU_START (retry bit,
  sequence number, addr2) to detect retransmissions.
- Both stamps are mapped onto the Qtimer with the PMM global offset
  (0xb500fc/0xb50100), read under the UMAC awake handshake (write
  0x3004 = 1, poll 0x1e04040 for 0x2), as qca-wifi-host-cmn does for
  Kiwi (hal/wifi3.0/kiwi/hal_kiwi.c, hif/src/pcie/if_pci.h, public on
  CodeLinaro, branch wlan-cmn.driver.lnx.2.0).
- mac80211: a driver op to report the time stamping capabilities
  (get_ts_info), so ethtool -T and ptp4l see them.

Questions:

1. The Qtimer at MHI_TIME and the PMM offsets: stable across WCN7850
   firmware releases and chip revisions, and acceptable for the
   driver to read? Does the same hold for the other ath12k chips?
2. The UMAC awake handshake: is it the right way to make the PMM read
   safe from the driver (without it the firmware crashes), and is
   releasing it (0x3004 = 0) safe?
3. WMI_VDEV_TSF_TSTAMP_ACTION with a Qtimer capture request: the TSF
   report returns a global TSF of 0 on WCN7850, in AP and STA mode.
   Should it carry the global time? That would replace the PMM read.
4. The RX monitor status ring beside a STA/AP vdev, without a monitor
   vdev: a supported configuration? Is there a lighter way to get the
   PPDU TSF of a received frame? rx_msdu_end.ppdu_start_timestamp is
   empty on WCN7850.
5. Which instant do the TX completion TSF and the RXPCU_PPDU_END TSF
   mark? We see a constant ~16 us TX/RX asymmetry, and the mean offset
   moves by up to ~2.6 us between associations with the same spread.
6. Multicast and broadcast frames sent by an AP get no TX completion
   stamp. Is there a way to get one?
7. Would a series along these lines be welcome in ath12k, and is
   anyone already working on PTP for ath12k?


thanks and 'Gruß',
Johannes Schneider
