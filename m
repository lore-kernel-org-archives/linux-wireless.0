Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CABE3C1D7C
	for <linux-wireless@vger.kernel.org>; Fri, 28 Aug 2026 06:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787900144; cv=none; b=fDC+Fo/qL8G0bABuw8J/NLSSXqcQ0F9HS/Nhzw/4Fn3dQI1Zx+gy2Aut8d8B+VO5YRqo3GUUnFlXgXlaDWgfd903jF3c3H7TU3KfdAcJgCd7mWfT839R0mPnbRtpckpOdhp4+xGX1djeV5YMI7Tq9qPZQ2gzFg1Agf++ZalSrHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787900144; c=relaxed/simple;
	bh=oNb9E1q7HXZ8eql3K2fZoYp1+uoNi7D3g464mwIxVNw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VHvnAfXn/kW2yCE/daAGECVFVkyovovo74y+HvqEChQvQzzZwpNRvA7YC3+SmITcQuiSYzbzjsGKtjH7UmU67w6joUvjMRrwUO2kx5clZ6sBHdLgrEST+1Ga9U4D9qgFxIktyJw4FXJLJKPLqkLeYdbFNtSLYGJ/sDZjj7tVtMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Iie2yS+j; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=ggsDHgRo; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Iie2yS+j";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="ggsDHgRo"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67S66TZg2761900
	for <linux-wireless@vger.kernel.org>; Fri, 28 Aug 2026 06:55:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=o2fQ68e9gCnXrHQgHUSdcidWOyupvsi9PXk
	ryOUrOFA=; b=Iie2yS+jxX3GpCmehl1uLyCBDqMk6QmuhSlNC8Ck1zaZLwtfp10
	GDMb3h9xrzVGovTY0bzA8tjlAf+T/0wrLjXxvyy5zL+QivFtUVeu/t5B17R8M2j+
	OZnJXlZmk15Da1s5WB3vVsnNk/68M6YK9d4/akzWDhDQP4ISDm7Cz/s/EwQCGTIl
	RKOHyzx44S0TmWlHHbO3Hea8yfSq2TqLTUOuUrWYBX3RqWGh+hNOAFIDnnjJTHan
	ooRkiREQ385QI8dVQPvkQaLSN635z+yCZfDbM7w9X8cYvFKiI7ud1q+wtX5qk2pV
	auAK4HhmjGcrPh2Q/RcvRRGOZKyntUVNMFQ==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gb42p8b9c-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 28 Aug 2026 06:55:42 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-396638f9a18so1165712a91.2
        for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2026 23:55:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787900142; x=1788504942; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=o2fQ68e9gCnXrHQgHUSdcidWOyupvsi9PXkryOUrOFA=;
        b=ggsDHgRo3CLIRa6d4S4IqFHX2gphAYof230HZ0BlgvStPu9KUQipaXIhPiynXunuPV
         U3wl+RRqUzb3q9ltLeDSy4EQ2eUieZxZVVFLLD5N4FUY/1ECtb/tz1z8kuGXTSQ2vNUn
         z7EqVl6I0RKz9azpc+uCW8iGtO8DCZ+KyZJaZRGM0Y5yNoNJWzgW92Tbcmi6iOKjKXP6
         G5BR6IoVtfUdehs+jmKkMR7mDOx7vFQdmUwATO4EeRI0MjyqeO973gXGgIDdT1SgG+sI
         DhL+B2mqSM7bNwUoldZaVZZb6eY3fFEW8ACxlPS5vSflRvVrm0vxMo5BJqRbF6nHuny3
         MIVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787900142; x=1788504942;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=o2fQ68e9gCnXrHQgHUSdcidWOyupvsi9PXkryOUrOFA=;
        b=lHW30b+J62kZWDEvwBgQw8pwdWFQSjY+/bdg0MjuXRhEH8lw0mCO5IvpsrOVTX+DXH
         fyZfonMABKqPxsbC3IwHBV5jklsdsLV0oVu75Vepj+l9H1BLC+hTw22x5NT3N/MRCa+1
         f5y56XC4l+Aqfg3szqamb8i66x/Y9432ZbgrOj+zmjUvuBLRnHgiEvjIcofhaXgAYpkz
         OURJvDmNhy9gyG5kkDyNPXX+OnRsgmdkDWnZzf96hvdb53FhIsXEW4fS7Y43sTad+kVb
         ZMATPc6QUT4FDVMTKUPh62ArcH8R7eShkLRyByQkGSYiB11YlQ2AMtjKmcFadfJtZt4L
         Edag==
X-Gm-Message-State: AFuF++lCsaDzAwXC53euRFv4m5/CuNvYtJcrKMGdO2naAxULO/q60Wc5
	qfliD1IAGCMbbHGEGQ/GUIpyvm0kJU9bCMrkH51fkfbGiX3br/EJibEPVVhIoaOLJ7gSkZg8sdr
	JMZ4gF7gIuQDbKxJ1lCAOFVfuR+ZPuQ961mAzE0Y7K9sx4v322RCD+FihZSfpuIc3bvE/OPNKH3
	7Q3Q==
X-Gm-Gg: AR+sD10WZetGV1SOqQAfiToIVIBvqjyMz91MxVnjPFx14rGxOun27UYsI6vc/hapVXK
	j9gxnDdXkIVJlnceS3vJ/Q8z8k5or7dDgONvj0zkrVfLirKo6w9T/BOheMfKoSrF2P3D9ltKz/b
	pFUHDJ5Xl5VVerzeFBYfg67PP2Ve8dP3R3/U0KkvTh6qCisehyue4pBcvmvjEvygA1Qn++0Wtwe
	SHtnmJwhgXenE3BXcBKoFhs1Z4RqLcq9qyRrdPKgD4gzYYXQ1yhdLdxPEumoUKfjXp6SkerLooP
	QEq5ScVGUPDbLIqbi85uXXbqQrBNk8Sl/FChoD2QqZAV+POfb/iYEbCuaK+hX0wclJ3QCI9neB/
	kGTmzJ/UaigNcKYtME4eoFSwFZAhpvwnYyoxJp83j8F2e+ZYGc0U8y/+O3nBv0L2jsEI2wiZl7K
	sq5QXnccPa9wmHMg==
X-Received: by 2002:a17:90a:15d6:b0:396:d28e:bd8 with SMTP id 98e67ed59e1d1-396d28e1164mr6132973a91.3.1787900141596;
        Thu, 27 Aug 2026 23:55:41 -0700 (PDT)
X-Received: by 2002:a17:90a:15d6:b0:396:d28e:bd8 with SMTP id 98e67ed59e1d1-396d28e1164mr6132910a91.3.1787900141131;
        Thu, 27 Aug 2026 23:55:41 -0700 (PDT)
Received: from QCOM-kZLYnuwaz1.na.qualcomm.com (tpe-colo-wan-fw-bordernet.qualcomm.com. [103.229.16.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396d29b342dsm804873a91.1.2026.08.27.23.55.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 23:55:40 -0700 (PDT)
From: Kang Yang <kang.yang@oss.qualcomm.com>
To: ath12k@lists.infradead.org, kang.yang@oss.qualcomm.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH ath-next] wifi: ath12k: preserve PPDU state across monitor status buffers
Date: Fri, 28 Aug 2026 14:55:34 +0800
Message-ID: <20260828065534.1537-1-kang.yang@oss.qualcomm.com>
X-Mailer: git-send-email 2.49.0.windows.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: EHLHF9OLWJUsTL0gG463k2QTH-YAL7pK
X-Authority-Analysis: v=2.4 cv=ToDWQjXh c=1 sm=1 tr=0 ts=6a9130ee cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=nuhDOHQX5FNHPW3J6Bj6AA==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22 a=EUspDBNiAAAA:8
 a=Pa4Wmf_9FgtUqcf0cncA:9 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-GUID: EHLHF9OLWJUsTL0gG463k2QTH-YAL7pK
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI4MDA1OCBTYWx0ZWRfX+fxiX67t0sAZ
 Kv5QltSCtYpkpR+FhL6EaFCvC1YxCp0WdIJWljQwgD4V8FhgXlWrcvFLPSL2FZ3hwNTKp2q0N/w
 rQf/1stsVY/wgTJlSU/jgWFPD9InJFQ=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI4MDA1OCBTYWx0ZWRfX9gIi9MtePd56
 l1QhK1bZ+b2aSX0vEklCanjLgbO1HEnp2n1Xg1F9gbdhlloRl4RgmllPjORY9dk0YRU6iH8wBQw
 6+YC3TkqZdcnUMtF82SLlPfSAZYWeZpM36RXofJTfaRrnnfES6FIXtYGfkJon/kNmSwzlZ1eAkn
 xtt3SfSpDB31sSG971EamXZym0EFYIg0oS38H8Q/f0VtrHJrGwLTWHywNgiLTzOYlTKG0AmbPVI
 hGYAN7jyg5C0IUlltYYDvs36wq2BjcceyhBkIlE/RZeh8NRJX94KWxBLFc24c3vujPMnPAKAqPR
 6PWB5gSGF7v/k3dTgS0VfAjR3mGmu+f61XzRIFHgrd3hTphudgakkLUS8Bc4OdphIE+os6DjJXu
 fLAPC5VpT4igRH6/1aUOOsk+qZrM9j4FkGXimOrXZiPkDwVHOLXh8bLqRF0joD5riBa70EyIiPv
 QzJLRe7ruyav1fp+yyw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-28_02,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 priorityscore=1501 adultscore=0 impostorscore=0 bulkscore=0
 lowpriorityscore=0 suspectscore=0 phishscore=0 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608280058

A monitor PPDU may span multiple status buffers. However,
__ath12k_wifi7_dp_mon_process_ring() clears mon_ppdu_info before
processing every buffer.

As a result, continuation buffers lose PPDU state collected from
earlier buffers, including ppdu_id and PHY metadata.

This can cause monitor RX processing to fail when
ath12k_wifi7_dp_rx_mon_dest_process() observes a PPDU ID mismatch
between status and destination rings, preventing MSDUs from being
delivered. It can also produce incomplete EHT metadata that triggers
warnings from mac80211:
	Rate marked as an EHT rate but data is invalid: MCS:0, NSS:0

ath12k_wifi7_dp_mon_srng_process() already tracks status TLV
continuations via ppdu_continuation. Apply the same logic here and
only reinitialize mon_ppdu_info when starting a new PPDU.

mon_ppdu_info persists across ar->monitor_started transitions. If
monitor mode stops while a PPDU is mid-continuation, ppdu_continuation
stays set and could leak into the next monitor session. Reset it
when monitor mode starts.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

Fixes: 78d3d907d0f1 ("wifi: ath12k: add support to reap and process monitor status ring")
Signed-off-by: Kang Yang <kang.yang@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/mac.c         |  7 ++++++
 .../net/wireless/ath/ath12k/wifi7/dp_mon.c    | 23 +++++++++++--------
 2 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
index 9a775602775d..bda055a86f06 100644
--- a/drivers/net/wireless/ath/ath12k/mac.c
+++ b/drivers/net/wireless/ath/ath12k/mac.c
@@ -1502,6 +1502,13 @@ static int ath12k_mac_monitor_start(struct ath12k *ar)
 		return ret;
 	}
 
+	/*
+	 * A previous monitor session may have stopped mid-PPDU, leaving
+	 * ppdu_continuation set. Clear it so the first status buffer of
+	 * this session is not merged with stale state from before.
+	 */
+	ar->dp.mon_data.mon_ppdu_info.ppdu_continuation = false;
+
 	ar->monitor_started = true;
 	ar->num_started_vdevs++;
 
diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c
index 016b0c38e51e..ded7d56cd79b 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_mon.c
@@ -3211,18 +3211,23 @@ __ath12k_wifi7_dp_mon_process_ring(struct ath12k *ar, int mac_id,
 		goto exit;
 
 	while ((skb = __skb_dequeue(&skb_list))) {
-		memset(ppdu_info, 0, sizeof(*ppdu_info));
-		ppdu_info->peer_id = HAL_INVALID_PEERID;
+		if (!ppdu_info->ppdu_continuation)
+			ath12k_wifi7_dp_mon_rx_memset_ppdu_info(ppdu_info);
 
 		hal_status = ath12k_wifi7_dp_mon_parse_rx_dest(&ar->dp, pmon, skb);
 
-		if (ar->monitor_started &&
-		    pmon->mon_ppdu_status == DP_PPDU_STATUS_START &&
-		    hal_status == HAL_TLV_STATUS_PPDU_DONE) {
-			rx_mon_stats->status_ppdu_done++;
-			pmon->mon_ppdu_status = DP_PPDU_STATUS_DONE;
-			ath12k_wifi7_dp_rx_mon_dest_process(ar, mac_id, *budget, napi);
-			pmon->mon_ppdu_status = DP_PPDU_STATUS_START;
+		if (hal_status == HAL_TLV_STATUS_PPDU_DONE) {
+			ppdu_info->ppdu_continuation = false;
+			if (ar->monitor_started &&
+			    pmon->mon_ppdu_status == DP_PPDU_STATUS_START) {
+				rx_mon_stats->status_ppdu_done++;
+				pmon->mon_ppdu_status = DP_PPDU_STATUS_DONE;
+				ath12k_wifi7_dp_rx_mon_dest_process(ar, mac_id,
+								    *budget, napi);
+				pmon->mon_ppdu_status = DP_PPDU_STATUS_START;
+			}
+		} else {
+			ppdu_info->ppdu_continuation = true;
 		}
 
 		dev_kfree_skb_any(skb);

base-commit: ca800a9302764c445de0da0e84d2252400a770ee
-- 
2.34.1

