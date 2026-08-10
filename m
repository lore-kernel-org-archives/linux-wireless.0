Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17CD63F9A1A
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 14:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786373105; cv=none; b=ppchvAZyXAGFLu++NLeHYpD2hjfj3U3P65106Shh4rsVnPo6nQ7QDjQ5agDfNpihkusQLKfY3F9XfOt0bF+JImwW/PIM7hSngFWOUagTKTB4kEHyswldMg0VcYog9kSYOYoIhkPhrF+DqrjEbmB9oTV2WDD8OlFw3/0bCjbK2t4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786373105; c=relaxed/simple;
	bh=U9mCQovM6NfXk4dgHMYq+NkiVNT46kVRx6eRxjLluzc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LhdiIi/rmAaqKSiMWHbqIdbUhf1SVNqU9ESt/zhOl7X9QhDD7RnSaY+X8uEVb9ivXwUd01AxB7bWxFTTNZmcY5bWdySXdtnERZNRLeSF0MJqRCMsqrp/GcmmyHpZocOgRXCkZttfzkxhYtmjAis+mSTmEorMEuKUKg4JGF+FbKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=cFWeLK6F; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=AIz5249d; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="cFWeLK6F";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="AIz5249d"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67ACj9XH1308431
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 14:45:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=+WJ7sdDIIaW
	CbwHjnubOI53f7w9wnVfPNsX+qZmFdZ0=; b=cFWeLK6F+70UW+AnFDj486TCkA2
	kcwLH/zVC2L2mdwP1E7gixiKOdGt95RoszZDMlV5FbwmncBHGrX//g6kK4UwZkfx
	g1zXltNgq8GdsnpePvXdXiFGtWLFfrhuhJFUDj5EyZ4zMNMeuuX42RjAn+CxgyzD
	tOUTAhQvn3uFp3ZoUauXB8Lm0O6m479MrDX9ldzt8NJk5OatCvorTM4237Gu5ZDq
	MZC6XPXJWOgTFHlvZcaP1TVY3bGrw+hO01yVgWPPrGOF0Gvg1mGXbyxqvAwIc7bu
	iqiS6mDQ28scBFIUoz5iztELlYOW+s6Q0zv2qJGOFJanLIYCwXW7441RKuA==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fyccqs4ve-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 14:45:03 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38f5ac7416eso2429039a91.3
        for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2026 07:45:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786373103; x=1786977903; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+WJ7sdDIIaWCbwHjnubOI53f7w9wnVfPNsX+qZmFdZ0=;
        b=AIz5249daoXZSC5suBka8f5eepQJgC7bRLS+JShN92cyZglB/BtK+Fcr9JJ5dh5qXx
         6hrrGoTjKccemRV/eg5xrnK6uGa36vAZi8oNqv26vsB6RwoF12O3C4xbqO6PtbZRwJWN
         p2u+D7nBHPj8b0tjwHsfkpF2JuCP6VH12QrR9P8sAWRb9URrMqi11XLQsba3XktMkwel
         6cGm/R5Wz+zk3h0h6/itzEAbILLqomwpqwpU9YB350HxX0ysQ07LmfOj1WJK5V9/7f9J
         d70rz6bR+22DSI2RCj9SB6bB/3uQBm1ctf17SsKrDhmd1IAr50HBD3lqC/wv/+mY55OX
         adwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786373103; x=1786977903;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+WJ7sdDIIaWCbwHjnubOI53f7w9wnVfPNsX+qZmFdZ0=;
        b=StIcBcpR0PTGVUZ3Xiiv1GtODsktEZYudFJ1j+dRR6qEUyW0iIQXTS35aKBsIIq3qz
         UOHh5zVKy31T8JknNB9TjTmFZ+cshDGMnnnBqICkcYXq0isONDkly/12RG6IOz5VrAkM
         WAKvH8hd+lzay9Sxck2PwHZilq9csPF1eYYwJeTpJ+So3f82lGXTgyO2JEDmP3gKMcSC
         TZB6E3bz5Ny30K3SGN6Tuy+qw74CQsg27lLqFgiTd9XId+uUzpaArNSdapP8GmzwB4R8
         VDctTyRMhVk8g1H3iueEtsJhuMUZg8vBG/jJxVajgnFsnSXPBqb/W5aZt+rByIBe9cCy
         mY2g==
X-Gm-Message-State: AOJu0YxwiG3ntLj83yz2Y/oHn+g4g/C0C6iW1dSqDSaOBU3J9y2nttsq
	gk+VD6W3UxMa/HNyNbcAEAzpbvgawJABchLuKEMBKBtxy3ZjzeagC7ZCCylmHCZIlYuKs57RFaI
	0J1Dh9oUGPhW/96DcnnM9DGiL2sh8oB/rDIDPONwRjlqSKLol4S1UliBcmnFARvH3p2DZpg==
X-Gm-Gg: AR+sD11trPQ9o1BquwybreadboDGzNnJe0qrD1k2mNJQgJKX8NH41RtzXkFwQzqb1fJ
	UFZr+XIpggPBY5vdtbskHZQfT/4crqX65YciNR/vRaSJdgEvLxFYgozRLioG3E8UPbGNqcQuDao
	jFkel268S15acDr7XetYER4T7mA6gpQWIJuOyoo9Fl28dOM06mCHH8NgenOh/wYbSNaf+A9Nh9U
	FCnxwkGsXWZciDcdGxhaXV1u94loBhFLTjPggXuBAqQydTNfnpBM0rFWwgCOgdxsAJiolm+8Z87
	1urbtxs7iu2os7YTcsknMmDftmLdDc144jzaqiWeemgdB7h3ojUAb1QSxIyAUAZYmcjijdNehXF
	sCdzrTQ3VhlFhluq8yxW7H+g9AslgGyUEKbJOaI/VgXg69nHmwzq0
X-Received: by 2002:a17:90b:2684:b0:366:10f1:3d91 with SMTP id 98e67ed59e1d1-392821f55abmr21702985a91.1.1786373102584;
        Mon, 10 Aug 2026 07:45:02 -0700 (PDT)
X-Received: by 2002:a17:90b:2684:b0:366:10f1:3d91 with SMTP id 98e67ed59e1d1-392821f55abmr21702935a91.1.1786373102128;
        Mon, 10 Aug 2026 07:45:02 -0700 (PDT)
Received: from hu-kaur-blr.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com. [103.229.18.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3926254ee45sm12797317a91.2.2026.08.10.07.45.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 07:45:01 -0700 (PDT)
From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
X-Google-Original-From: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>,
        Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Subject: [PATCH ath-next v3 4/8] wifi: ath12k: add device DP stats reset support via debugfs
Date: Mon, 10 Aug 2026 20:14:40 +0530
Message-Id: <20260810144444.2033607-5-pardeep.kaur@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260810144444.2033607-1-pardeep.kaur@oss.qualcomm.com>
References: <20260810144444.2033607-1-pardeep.kaur@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: rZaoplLrnbCjjk_9WkkZ134B6aEEnb1Q
X-Proofpoint-ORIG-GUID: rZaoplLrnbCjjk_9WkkZ134B6aEEnb1Q
X-Authority-Analysis: v=2.4 cv=WNVPmHsR c=1 sm=1 tr=0 ts=6a79e3ef cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22 a=EUspDBNiAAAA:8
 a=_Iy9b4Js2nCRBGGyCYcA:9 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEwMDEyNiBTYWx0ZWRfX6VfJdRYq0XMi
 dptNIta7PmmdRzw4ctdDcxnJVaU+dIPnO2DNY7sQwUB8GPbJ9pe+qGtBS7YWmwRXNOXbRcdBTp6
 j+IMpEibVwQdOfZDDQzh/i4MaPOrCDR9Sj6n1ExJvdyjeMlbgpAYoLgQEf6xdQtohv8z4oLxJxd
 vCQqXJtofNOF1XkqX4rWReVFXo7xT+/rlTKN0QoYaClV5WEwGr6CiXncIDCcoxB8sFPM9rJyl5D
 +gAKl955Iis2ItzMglCWDJoKM3eUKWLm/RY+VYze5DQxXmhxudWNUEb/SkXslQg1vC54mVYStj0
 E2yQXR/MHobmB3hDw5qkRJcZGsq3XrHMlq+DEVNu6ptE2u8ZPI6piB+2KW6sWsaAzQ8ZSbuVVwN
 ZEoSAIorf2yu5At3ps5BQfyO1Jm7hMAzAm0KaUnpmlCR4wZ7ECRZ8QQInk9G3f3E4BOvkqjZVUS
 ND2tEfQq+eOEg1J8O4A==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEwMDEyNiBTYWx0ZWRfXxN9MFcYVZWvK
 G30InscGw253vvLkQsVuLPliLvJg9CJ36CDGLCehfwaNfvh0FmGAk8TrFDhzKuA1ICAoWzjgRNH
 p6qGhQQ161U8vKMmljkFUzoagrFl2cg=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-10_03,2026-08-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 bulkscore=0 clxscore=1015 suspectscore=0 priorityscore=1501
 impostorscore=0 phishscore=0 spamscore=0 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608100126

From: Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>

There is no way to reset device DP stats counters without reloading
the driver, making it difficult to isolate issues to a specific time
window during debugging.

Add a write handler to the device_dp_stats debugfs file so that
writing 'reset' clears all device DP stats counters. Change the file
mode from 0400 to 0600 to allow write access. Use
simple_write_to_buffer() to correctly handle partial writes and
non-zero ppos, consistent with ath12k_write_simulate_fw_crash() in
the same file. Return -EINVAL on unrecognised input.

No lock is taken around the memset since the counters are updated
locklessly in the datapath; taking dp_lock would be misleading as it
does not protect device_stats updates.

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6.r1-00402-QCAHKSWPL_SILICONZ-1

Signed-off-by: Hariharan Ramanathan <hariharan.ramanathan@oss.qualcomm.com>
Co-developed-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
Signed-off-by: Pardeep Kaur <pardeep.kaur@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/debugfs.c | 36 ++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/debugfs.c b/drivers/net/wireless/ath/ath12k/debugfs.c
index ec49692107a8..cbda754d8656 100644
--- a/drivers/net/wireless/ath/ath12k/debugfs.c
+++ b/drivers/net/wireless/ath/ath12k/debugfs.c
@@ -1220,8 +1220,42 @@ static ssize_t ath12k_debugfs_dump_device_dp_stats(struct file *file,
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
+	/* filter partial writes and invalid commands */
+	if (*ppos != 0 || count >= sizeof(buf) || count == 0)
+		return -EINVAL;
+
+	ret = simple_write_to_buffer(buf, sizeof(buf) - 1, ppos, user_buf, count);
+	if (ret < 0)
+		return ret;
+
+	/* drop the possible '\n' from the end */
+	if (buf[*ppos - 1] == '\n')
+		buf[*ppos - 1] = '\0';
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
@@ -1232,7 +1266,7 @@ void ath12k_debugfs_pdev_create(struct ath12k_base *ab)
 	debugfs_create_file("simulate_fw_crash", 0600, ab->debugfs_soc, ab,
 			    &fops_simulate_fw_crash);
 
-	debugfs_create_file("device_dp_stats", 0400, ab->debugfs_soc, ab,
+	debugfs_create_file("device_dp_stats", 0600, ab->debugfs_soc, ab,
 			    &fops_device_dp_stats);
 }
 
-- 
2.34.1

