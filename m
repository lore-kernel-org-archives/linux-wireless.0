Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C7674BC025
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 12:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784811316; cv=none; b=ZBQ5e88HRXCjg3Hzw4q6+Vz/hgD3wTbYRfvoklvVr6gCqRiG621g6dwCfIk1ZP3K91ayEM17ep+6t/NONHsp2F4zBWCnvYEXzofqOV3LNe/JCydtaoAoyPUWic65JbVvoLqsl24sh1h/bO3LTmknXV15Mb6m4V2YVTKbAAUPwxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784811316; c=relaxed/simple;
	bh=IYpenxD2GZArlZ6y+NTZMTykIWTfZEiEk0leGVMBqb0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=INBtpcZA++PI2LOrSvvKPlUD9DIfLuKXqSiCCINk1YHIew9O0B2cI2xFvFi20msWxO3AWTxX57t5uCfRZmqEWj83hOKMVMJaCIj39RWrC+O0ofr7L9Ln1hGvOsDY30zOskDCxKoIEg/itCeD80tgm2NgHZX3X/1CAjcbX7VrAHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Zf8JtmEk; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=L8t41dFy; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Zf8JtmEk";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="L8t41dFy"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N8qWR53648549
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 12:55:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=kTNHBzUnrq+
	R61lasDSevxcXJ4sgp8cMKYR3vV3n9bY=; b=Zf8JtmEkcdUpu5paH3LoG75nKmc
	FBGB8v1KomvT9jLjJMwyRToodQfOBTnU0xeA7FIPfXmiqJ8rwGLT8zsB3WkL544P
	KrZ/3mwG7dh8vVkpgLZxTd0tSb/ay4IchDIU50mymmyrdkTJjQ26DRBE2DZPKdWL
	tqRWsnfw9qGCCmVTxX/HWxk2TC5LRLhqGYYUYQxmy3uNlSs8MVc3ramEJwEsvN7W
	Sphcx6r768WsB0HbtObdtmBjtCC/FrX/sxibyJcqDJbRTZGhoiXEYKY9plvjlm9p
	JxjZOWyjJsopQAHpg+6Ui9fgKKGfP8kyJdp9Fpi3FAP22+IiMptxs9GecmA==
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fk6c7k3m2-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 12:55:14 +0000 (GMT)
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2cec4226c70so13447595ad.1
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 05:55:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784811314; x=1785416114; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kTNHBzUnrq+R61lasDSevxcXJ4sgp8cMKYR3vV3n9bY=;
        b=L8t41dFyDr9qgcrx1nvWeEGVQ+uwuLhjo/Jg0crSxroOLPrhLPjXKGHeDr+RzZ/hQh
         n2BuLbht0TAlxB4SFg6RsEeFXrcrgqzoxIW/p8h8OJKcS6bHQ5HGg5GEL/PxgIbP2ueI
         GHawnE2AnXMe1t0ZiiI4kc6qdnL5rpOs43tdPg4auuV4gnJMJzHUqcnr/AKZKbTSXWmh
         txlziUvNL9z0qWT0YFxC6H4Gw0ubryNcAKW/5RLXG5WMIVwjr3/eb8MCFpjh+/ifxsKA
         UcPuhTzztXJzRfMhZZabi45Vxy3cXwQ25zYTlRvB9mdfpVRp9HgGubHIfXoAHMuij+Ta
         82zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784811314; x=1785416114;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=kTNHBzUnrq+R61lasDSevxcXJ4sgp8cMKYR3vV3n9bY=;
        b=mFAvu948k3JSbe/jtYeExpwJ9OR8dNmfSacL82shr8U9g6UgRvgDbcR1XkcfJz1YEq
         GiLfD5RoeDo8KHSoUxt1nKymxaNh1wcfYO5XED57fc8MQYFkpR5HWv3XbsR38W8RroWi
         8IgCctQxvQuJT73UHv61tTizG4T+p0D9bxUYvKzAG1nmapojgnbvKTr4xYZrWQbHNzDb
         HZ6a/zo80iSI8X5jZmxnTdjuluJXQ7Gmcg+ZuzVG4x2a6JAgAyNVVexx5FKVzyEUkcJD
         xYrrS+35fg67C3U1cRJVPmIA33+oFwuCl/s/Tmr4dYT+g1p7DGH7e6g5Cz/M82Ga/Lrb
         3D8g==
X-Gm-Message-State: AOJu0YxzWSgyntHLNhFoxOwCWXqk4vxrE3RrUewZ5o6jgDng2hJjtLJf
	C9nRtGXExnYzJ4NW43HK1nyf3dlBbAMMYQPoOoHFIMwXG2D20hdsm9EyU2/DwmPaGZ4XaKsbwEy
	xFtRBfotpsTncZY5kX2dYgM3VP5s6F8Dag/GnS6oDubU//eexUNBaPWOoi8n5ETRFSG+qUw==
X-Gm-Gg: AR+sD13iAWzmQG3vgElJrIYgegrDmzSZx+zYD9LRyx0eeeCCXYXxg14oFVNt/dk5DpY
	MjEA/KpUFbqJwp+7sjYn2YSD0V76udIR1Pi2nry7zWcKEcBrnS+ve19qUV270YLsSn0aMUID5EM
	65ywN4bcCKSVw7w8PLPw3+pAMLvB8GzeaeQ15mEr0Bd0diOqsoZ4s+hLlqzgB68nb3bJlesJB+Z
	0gPhYlUbLC3NXaYAy8Gv2RdO8v1i7kZAW52ACrJwYodExrn2clmtfIEXwOL72ETWSYSBA/fVdE3
	JaL8VyrEsCsALo47rwESrh9RgKe09WEwsIJd5ojnlkctO5VjOWY6HmtskPHCkxqKyUCU/KIeB74
	Xbtn8/ZP7WFpzCRJSQE/I2wjs7KCuPhgPOfDlB93gihftXgjH570H
X-Received: by 2002:a17:902:f605:b0:2cc:864b:539 with SMTP id d9443c01a7336-2cfa6a4395amr34988835ad.6.1784811313804;
        Thu, 23 Jul 2026 05:55:13 -0700 (PDT)
X-Received: by 2002:a17:902:f605:b0:2cc:864b:539 with SMTP id d9443c01a7336-2cfa6a4395amr34988495ad.6.1784811313252;
        Thu, 23 Jul 2026 05:55:13 -0700 (PDT)
Received: from hu-kaur-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf8f350475sm32998385ad.70.2026.07.23.05.55.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 05:55:12 -0700 (PDT)
From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
X-Google-Original-From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>,
        Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Subject: [PATCH ath-next 4/8] wifi: ath12k: add device DP stats reset support via debugfs
Date: Thu, 23 Jul 2026 18:24:44 +0530
Message-Id: <20260723125448.922361-5-pardeep.kaur@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260723125448.922361-1-pardeep.kaur@oss.qualcomm.com>
References: <20260723125448.922361-1-pardeep.kaur@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: u8AWny7C2oLZxzJSJAmoPp_QWBQut7Cw
X-Proofpoint-ORIG-GUID: u8AWny7C2oLZxzJSJAmoPp_QWBQut7Cw
X-Authority-Analysis: v=2.4 cv=baZbluPB c=1 sm=1 tr=0 ts=6a620f32 cx=c_pps
 a=MTSHoo12Qbhz2p7MsH1ifg==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22 a=EUspDBNiAAAA:8
 a=_Iy9b4Js2nCRBGGyCYcA:9 a=GvdueXVYPmCkWapjIL-Q:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDEyNyBTYWx0ZWRfXzPUwx75CIgn6
 iYueE0/NBLJhKOxE43r+7C6GuyLZ5txobz0+UGQAepowBvikVNcBdkozPrAzHSKY3T1zI3ZRahs
 lrVRfcq9qtMzit2fP7ywr8WRDZlXtdw=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDEyNyBTYWx0ZWRfX0Kpx1NWZ4RrG
 5Ma6WKDj1yyPdBvBFDejD7+Zj+PgwMPI8exHM1vQBXGiWTDIUS0BQCEaC3x/AkWE2taCAwuh/F0
 IUaZEAMY/Y0zg9BwDO+fteloZcSFoHnTMxD1Ff9Vchl9e7I/QBQCp5seF904gnYwjMvw7KDNM9P
 s3g/E6KrU2eT89mtW8pOBoKY86DZT2ggu95VuDPd1OVEithGHgJX+bfKqiNG9Bbxtyzf5U5gW7h
 CCS/2dPANuyvJmMx1ZE4wv3x9aGvyH1prfho5koKO98MaNqQwOy72JdLvE6+zQIom1+S+nSc4XN
 y2F7r/xUeD5H/xxIx3jsqFjqAooRqTBU1CCJNIf4zjoEE+zaPnaf0kyLsy9B228JYGghZGZAkz/
 Xu5UtK3tsv1x5agrGGUX+DnbrtYvbPhB8+spwBY8OPUgfzviYxcRVOg7m5C/1BHTOBppzDOxHz4
 JTx8ICtJxMq0MbMUAwg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_03,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 lowpriorityscore=0 phishscore=0 suspectscore=0
 adultscore=0 impostorscore=0 priorityscore=1501 bulkscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607230127

From: Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>

There is no way to reset device DP stats counters without reloading
the driver, making it difficult to isolate issues to a specific time
window during debugging.

Add a write handler to the device_dp_stats debugfs file so that
writing 'reset' clears all device DP stats counters. Change the file
mode from 0400 to 0600 to allow write access. Use strcmp() with
newline stripping to match the input, consistent with the existing
pattern in debugfs.c. Return -EINVAL on unrecognised input.

No lock is taken around the memset since the counters are updated
locklessly in the datapath; taking dp_lock would be misleading as it
does not protect device_stats updates.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6.r1-00402-QCAHKSWPL_SILICONZ-1

Signed-off-by: Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>
Co-developed-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Signed-off-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/debugfs.c | 35 ++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/debugfs.c b/drivers/net/wireless/ath/ath12k/debugfs.c
index 0f8b458200a8..e9eaa23ee63e 100644
--- a/drivers/net/wireless/ath/ath12k/debugfs.c
+++ b/drivers/net/wireless/ath/ath12k/debugfs.c
@@ -1220,8 +1220,41 @@ static ssize_t ath12k_debugfs_dump_device_dp_stats(struct file *file,
 	return ret;
 }
 
+static ssize_t
+ath12k_debugfs_write_device_dp_stats(struct file *file,
+				     const char __user *user_buf,
+				     size_t count, loff_t *ppos)
+{
+	struct ath12k_base *ab = file->private_data;
+	struct ath12k_dp *dp = ath12k_ab_to_dp(ab);
+	struct ath12k_device_dp_stats *device_stats = &dp->device_stats;
+	char buf[20] = {};
+	int ret;
+
+	if (count >= sizeof(buf))
+		return -EINVAL;
+
+	ret = copy_from_user(buf, user_buf, count);
+	if (ret)
+		return -EFAULT;
+
+	/* drop the possible '\n' from the end */
+	if (count > 0 && buf[count - 1] == '\n')
+		buf[count - 1] = '\0';
+
+	if (!strcmp(buf, "reset")) {
+		memset(device_stats, 0, sizeof(*device_stats));
+		return count;
+	}
+
+	ath12k_warn(ab, "unsupported command: %s\n", buf);
+
+	return -EINVAL;
+}
+
 static const struct file_operations fops_device_dp_stats = {
 	.read = ath12k_debugfs_dump_device_dp_stats,
+	.write = ath12k_debugfs_write_device_dp_stats,
 	.open = simple_open,
 	.owner = THIS_MODULE,
 	.llseek = default_llseek,
@@ -1232,7 +1265,7 @@ void ath12k_debugfs_pdev_create(struct ath12k_base *ab)
 	debugfs_create_file("simulate_fw_crash", 0600, ab->debugfs_soc, ab,
 			    &fops_simulate_fw_crash);
 
-	debugfs_create_file("device_dp_stats", 0400, ab->debugfs_soc, ab,
+	debugfs_create_file("device_dp_stats", 0600, ab->debugfs_soc, ab,
 			    &fops_device_dp_stats);
 }
 
-- 
2.34.1

