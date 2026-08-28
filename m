Received: from mx0a-0002e601.pphosted.com (mx0a-0002e601.pphosted.com [148.163.150.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A1A4360EED
	for <linux-wireless@vger.kernel.org>; Fri, 28 Aug 2026 18:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.150.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787941552; cv=fail; b=Jre8y0aDhX89foFfqH5Uuk7p+opBYvgJMw3KWf1K3OKTVqoQcMmEmp9HgTrZjhz4i3MTjY1U0p6Y6PUU9ftNB+iQb5XLRjPZqiiVl0iPN0RgyG5ytDfdoFITPNzosWU8GmkckVtt+ehaWiRV/gQwP6iMw1IUynB08+soGlwtE2A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787941552; c=relaxed/simple;
	bh=bINtlYAxzjQRVl7Lbn0dXKpyL79Pmz2Wv/OznyR3B14=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=NPFpssnB6qGdOmHiyh+IrnAsoBizg/hv1G49NrH3C5Xp49nVXT4zFxXicBroYA12PTkiqB2vq2syvEnXQ+r5DGQtZ/TCCoPUhfdi2sBGUpl/9Ay/R5/Kcz3lv+RuTL3wGB4Vjyr6XaNFxB9gmTqLnhQkVltiVHgLnoVx5ZJdrd8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b=StB/SytC; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=L/+O6ZEc; arc=fail smtp.client-ip=148.163.150.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ti.com header.i=@ti.com header.b="StB/SytC";
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="L/+O6ZEc"
Received: from pps.filterd (m0380145.ppops.net [127.0.0.1])
	by m0380145.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 67SGLI4n1947144;
	Fri, 28 Aug 2026 13:25:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=proofpoint-05-2026; bh=noqh8w/XmmhVV
	41iOoEU4DSc3erTfhEGvQrwztliFsY=; b=StB/SytCrv3Lt1/9Sd1gTy9GjPcvA
	g1U7HQbjjVDP89koMy4Jd/LJzPddqsBPXpP6+cHXoOiuEsqFH4l8dy1L0aN7Z6p4
	pAAqHdBxH5pa84Trc1BVW5G0bnzc9iXyYx6I3xboAKt+yenPN09L203MWVaFs7q+
	gyiNlsJyHOeAqglsisPuEGqcQUeQFyxqj4cQ8c3J+aIN88RW6rkUwSJV+2c8wr8U
	Iq5uCrQ0Bi7ab7oJURMPDrmAHm5QKDy/jo9S/cHxFMYdnaGB4gLPYFjjPYfinNIl
	YFwpGj4OiVlgnw7TA3OWPJM3yKAKJt1KaKMO0uikQ5wm1UmiwUQpiuKXw==
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011070.outbound.protection.outlook.com [52.101.62.70])
	by m0380145.ppops.net (PPS) with ESMTPS id 4gb5kdkuu2-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 28 Aug 2026 13:25:44 -0500 (CDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BokaWwajpg8LUEx1ysfmntWsXICLCyRIJ5OzY9qeX6NmEzhXcA2CwZHwmtYPsqVAsDL2eSYkx7n0tDaHIstBb/WKlekKMUDyWYIDodSqe1ygCLiAjjkHe8CTxuvfX9Yl7Pd33C2OpCI/Xqh96AUzoMMD/ivqvZk+b92GnMjBv8qG3U5f/JTckrUYaJqoYidwwE/0rPdFQBJH9F2Mkx6gofPzxTFehmJ8ZjaR8XQCiOwNiLsuE6p51NRKoWrPKAnCJS4CsSIPmyNAM7QnKW68JMfBLkgiQQB4VdgZtdUaPi5Ypk4BDUFF1TAWfbhd0qXaREIBYeASChh04pbl3+9+jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=noqh8w/XmmhVV41iOoEU4DSc3erTfhEGvQrwztliFsY=;
 b=Oifke3KLCAkVvrYENTbN5eEWIBqBJz8QHNQdUJ1gDr3ok3dPyy5Bj6IRBQiEjJktD5TUPt3vCiAvTkN2dcjXPeBatqqGOD5rU2zfR1pZFdfCZOFhxk/EGWJ9lV+7jOkR8yXIw8Ww+QOFu2aCB6QgUkQZ3KmBVq7974K5rzue8TtKAAoV/78QpZ9BAqaW+9lzU3IzjeFekvHRD98r4BixKMXidbur56WEAzeDsA3NlF3d5SUo7NGeDK0u3W30ynepJzY48XQEQJO+XrPYwRFd/OoXtjYxkCPfjeloC5BXpk6KRfgvs46MVlAVgLxV8JbzO1yI0bfBe0Heo+8XFfNYPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 198.47.21.195) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=ti.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=ti.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=noqh8w/XmmhVV41iOoEU4DSc3erTfhEGvQrwztliFsY=;
 b=L/+O6ZEcL6m4KEVa4AQJz2J7BITyJfIuUPJKx6Dohr6kp9U3mcNI6UCACfc3YdaZxj/gFyvzfLj+tzlGmReDEEduKoB+D5hDK4n7ecLBG11o+pcA+fTbI/0o3ZSZBQoj8TCxZPPmgR7DJKVnR77+SdCxag4yry77ife3bvPOags=
Received: from PH5P220CA0007.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:34a::12)
 by DS0PR10MB8198.namprd10.prod.outlook.com (2603:10b6:8:1f4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.7; Fri, 28 Aug
 2026 18:25:36 +0000
Received: from SN1PEPF00036F42.namprd05.prod.outlook.com
 (2603:10b6:510:34a:cafe::3d) by PH5P220CA0007.outlook.office365.com
 (2603:10b6:510:34a::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.11 via Frontend Transport; Fri,
 28 Aug 2026 18:25:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 198.47.21.195)
 smtp.mailfrom=ti.com; dkim=none (message not signed) header.d=none;dmarc=pass
 action=none header.from=ti.com;
Received-SPF: Pass (protection.outlook.com: domain of ti.com designates
 198.47.21.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=198.47.21.195; helo=flwvzet201.ext.ti.com; pr=C
Received: from flwvzet201.ext.ti.com (198.47.21.195) by
 SN1PEPF00036F42.mail.protection.outlook.com (10.167.248.26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.382.8 via Frontend Transport; Fri, 28 Aug 2026 18:25:34 +0000
Received: from DFLE205.ent.ti.com (10.64.6.63) by flwvzet201.ext.ti.com
 (10.248.192.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 28 Aug
 2026 13:25:11 -0500
Received: from DFLE207.ent.ti.com (10.64.6.65) by DFLE205.ent.ti.com
 (10.64.6.63) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 28 Aug
 2026 13:25:11 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE207.ent.ti.com
 (10.64.6.65) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45 via Frontend
 Transport; Fri, 28 Aug 2026 13:25:11 -0500
Received: from thinkstationp3.dhcp.ti.com (thinkstationp3.dhcp.ti.com [128.247.83.245])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 67SIPBk33282498;
	Fri, 28 Aug 2026 13:25:11 -0500
From: Sabeeh Khan <sabeeh-khan@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, Sabeeh Khan <sabeeh-khan@ti.com>
Subject: [PATCH] wifi: mac80211: mlme: allow VHT/HE connections for 20MHz BW STAs
Date: Fri, 28 Aug 2026 13:25:01 -0500
Message-ID: <20260828182501.1540352-1-sabeeh-khan@ti.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F42:EE_|DS0PR10MB8198:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c5c0988-b66a-4a6b-c693-08df0531c05b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|376014|1800799024|82310400026|10067099003|5023799004|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	/Ct454/5vmMAqtBfPXVdr5IKZZR58WS+TAZX6+PZnGTw86I8AVd4Kk1W6M3uXy6WhGkKzC7ql80jyyI2Bn9V3tbU59XwU5jlt3OWxudV2oYt1lPTW+RQGGpwSkqiqVeSXKRc5yefmpqXstfPDiJCfxvvCYz5OR1g/H6t7j5pSf+njVig0A+mj6eH+mZSUe7pCsbljn4+/dnvkqngNFdAZeanrv0ksJMGZwS9CrkFDv6Z34gaz5hizqMhl55EekPtTfVUPp2WJNaKX8UcIeNHJoOc1/sgZ80Cp8hZrgVdt1XKTVWT/93gDEV27TnpLnJIFtu+0uaJFDW3GtHqdSt+EYu7iOLyHweXFiUWJx2TeOF70QrH+fAVVpP+yAfDM7ZKvNPjq4QZ0XG+5LOm/XTsw5oSS41TAhSM1rwFkTITL30eTDt2W7UthqTUbXCqjgk+iN9fXH78Xs2C+mLdfkd49rM5wjKvFUp9aDI+H2+mIo80gL9sXvNpBnPyxnnXShrjrn2zjx1vyFI64PQjjxT9KM62an9LEZQi9dSGn8sdT6ivzfzGlaunyIAcrcDgoWSzxAKMg7W/OAnaIkq2kxaZhA4bqysO0jwoN0m5dmTQlZJVpsfi5ZhA/dkuAmd0KB/CZULrgjjL3jVjBcWTFubIKvmMru+DI55MhsYJdmgn4fGPemfg9QJulS2Bn8ioFReW11BZiCmxnvaknWQz9XPqoA==
X-Forefront-Antispam-Report:
	CIP:198.47.21.195;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:flwvzet201.ext.ti.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(376014)(1800799024)(82310400026)(10067099003)(5023799004)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	7DHUrmn4swbC4E6lodIfoFE7hpBcjGDdI6cGiDkvzZRlljiFCM4a222DVR+o+DHOR7x0Cx/8NXwCJkjRuv3e3f7CvDDwteDg7HCz9KZMcH34GVyGIdeuypE6h0btNV/WU2aTQ2SUr9YMFk9O3sr823pIG3YDOVadj+ecPTMQtQDF/6giAn/178WwOlOsWT+NWWgfZ8paqfCLggpy5qPacZYW8GWX2DC8Mm5UJYJm/6Osk/T9jcyF5zPWQiu89G1wtoVXmY4ZvwHaFJ0eX6TRsatWKBnfYB4a6RC39Ji6MytTTvsgtsMS6nqwB8qoQIMhp7Cy5zO7URA48Dc7N8YVPMC2Xi1jmsXS2V112wiSwH4sqYUQ4ax9SjB4c52sW3C7yX+z57LBvbqieEk/DCwaWCJyYR3ci9e+wuudG6Weyx7VJVXeV+oA8aHpAbvTc3lO
X-Exchange-RoutingPolicyChecked:
	Tsr0f6f8/G5g/T5lsm6Gq2P87r9JzfN3Qn0lyhoMHDvjOqpn4gTBx455rBXIJzKwL4v32bO/7IJDcvDIW3Fs9Os5WEqI9uQTbGAAHVUdPq1/aZxRoZXvi1/2pR3wBckgqvDXp+MUAZK/TYzj2RhwvHY15/nxZOUKeefZcrLp2s8Z4hv5SyrFXISNbSdOwbgB0FKrNSmJsfKWbnVfTHFZLlYK33Y6d8mLu6dj0w/6+9rgccLB2jyClK3BkP+VeETCPqIHZliw7u9t/8rYkTILImyOCHnNEZPtQQOOHjmxFKUURgYwXCdT04O4UzERbS/ZjNSTMkgx1we2IyvccHoMAQ==
X-OriginatorOrg: ti.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2026 18:25:34.7980
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c5c0988-b66a-4a6b-c693-08df0531c05b
X-MS-Exchange-CrossTenant-Id: e5b49634-450b-4709-8abb-1e2b19b982b7
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e5b49634-450b-4709-8abb-1e2b19b982b7;Ip=[198.47.21.195];Helo=[flwvzet201.ext.ti.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F42.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8198
X-Proofpoint-ORIG-GUID: IZBia5BiMmtOendgT08PnFYANLJIOcDA
X-Proofpoint-GUID: IZBia5BiMmtOendgT08PnFYANLJIOcDA
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI4MDE2MCBTYWx0ZWRfXzsb0WSJKEE8T
 3Uw41WEdtEC1szG4ZzUn7ugUG2NGj0e3f4LcNNOcE3fbDfzc4OvoyTckXx1D3IT5GWQBr8Vn4/O
 VaGISkUfrNwYcfyUnZ0zpGeLQHGcoWY=
X-Authority-Analysis: v=2.4 cv=UPPt2ify c=1 sm=1 tr=0 ts=6a91d2a9 cx=c_pps
 a=CrKnoqqb99nOpAJSR4mnrQ==:117 a=tJyPKKxUohctrY4NYmUjkA==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=Sv0fKeRqtYgA:10 a=V5UXEbMT0ywA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Z8NIEmU8O1QQgoT56wFK:22 a=gO1vWkAQAl3rybz1DQOp:22
 a=sozttTNsAAAA:8 a=9r33CVE-P9eGOcI5jScA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI4MDE2MCBTYWx0ZWRfX9tiVAN5XdNG3
 JiMCLe+AiHoED7h5n786gLdCF2gtu9bHNFPP63EkWq3cwAaYeQZ83t0t2nH83EIGCz5mC+CdMtd
 j8tpnIfEDuc6CW1rK6lKS2uoxE17krEfo0Yoiu69sKTZPlBfEYzhwFPrUviFVtb4g+t/SxjT1Kg
 2261fjEarINTd+jZsx8FHz6Bj442cwe65EYz4cMkqIaWB63KLRFwW2POQoqpByDr1UxRMD+2z9A
 wkEW/g3QVPttYyfuOTPWMPne9oLZcipZA/pcfr+ONHlye8S2sXG4+WmPugLj5s8mPHVzXs9iPus
 AezKunC3jVzsul0IjRFMa8dDeg9wUP/a5u9XrOnilFGLYdLaiGtQW3QQ+PGwTe2TRZ1eQ9M5m0m
 qbA4kXvpsppbrimQyzZr4dUab1q13QpM3w15zOr8Da+50Yi0tBD6JXT8YfBC1ToPf0ZYgfqPrEc
 E88eMisqa6lSSwah7AA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-28_05,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 phishscore=0 clxscore=1011 spamscore=0
 bulkscore=0 lowpriorityscore=0 malwarescore=0 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608280160

The ieee80211_determine_our_sta_mode function assumes that
if a radio supports VHT and is limited to 20MHz BW,
then it must be limited to use HT connection.

This is incorrect by spec as VHT/HE connections can still
be allowed. Specify VHT connection and then goto current
checks for HE capable and flag.

Signed-off-by: Sabeeh Khan <sabeeh-khan@ti.com>
---
 net/mac80211/mlme.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index f51167f0fc46..eed6294f4c65 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -6586,8 +6586,9 @@ ieee80211_determine_our_sta_mode(struct ieee80211_sub_if_data *sdata,
 
 		if (conn->bw_limit == IEEE80211_CONN_BW_LIMIT_20) {
 			mlme_link_id_dbg(sdata, link_id,
-					 "no 40 MHz support on 5 GHz, limiting to HT\n");
-			goto out;
+					 "no 40 MHz support on 5 GHz\n");
+			conn->mode = IEEE80211_CONN_MODE_VHT;
+			goto conn_band_5ghz_vht_bw_20;
 		}
 
 		/* Allow VHT if at least one channel on the sband supports 80 MHz */
@@ -6626,6 +6627,7 @@ ieee80211_determine_our_sta_mode(struct ieee80211_sub_if_data *sdata,
 				 "no VHT 160 MHz capability on 5 GHz, limiting to 80 MHz");
 	}
 
+conn_band_5ghz_vht_bw_20:
 	if (req && req->flags & ASSOC_REQ_DISABLE_HE) {
 		mlme_link_id_dbg(sdata, link_id,
 				 "HE disabled by flag, limiting to HT/VHT\n");
-- 
2.34.1

