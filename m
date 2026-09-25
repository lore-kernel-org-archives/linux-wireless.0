Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40F791EBFE0
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 12:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790339224; cv=none; b=nrhJaXiXzEq6BCJIYTqbsh2zEiqW+gbUc71p0GEkDpr/wNKRflcAfdWn7wgYewiJQR8XJfGR/ONR31jDO0SZd692N1NP0oQL53zzDZyR2Xg0MmGCTv2oMJ1Gfkh5UlP/baNmeVHUROvbpbeDGJBLbx7kQKT8FqOv4QgTvjULEzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790339224; c=relaxed/simple;
	bh=6DlQdupdI3sE5KW4WGC+fgLIQP6e+cwnTKfsVyYBx90=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=XvEQRxUoiQtCaVSHUqs1PYuHxVjv3gkRo0deP12Ipc/FV2mjMEyMrJ9ylX/cD183Lml4XdFb6l+VhcJMvrBgKP6EKR5iKOTbjo9LreXxprbAM6pFmsjMFrpDDpLItkt9XTU47BTbA6UXLzAJTBuRYxsssFUHBlmlBv6fTHFcLkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ZmIWHjNH; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=TqGcHzH7; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ZmIWHjNH";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="TqGcHzH7"
Received: from pps.filterd (m0279866.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68P4YbjS3532122
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 12:27:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	AcaOZ2fJU6ffhgF2BemXGqCQZS+ca39vbxcg6RAcAgs=; b=ZmIWHjNH+tQzrCP2
	+tJr76stlndraye3ZsgeNNwRYxRhzOS4DNNBLwX0OgrgsVMTSAbKpKxtc+mLApz7
	io2JriGAXcKvkjflFB3FdMGXO+NcLfVLtyl9AlX0qQw7N1ehzB7btt3aHLICsZwr
	7PowrzjUq59vnVSS2KRYJ8L/9oJtB6mBIpEBfWYHNWSFyXUCWCF6ClzWS2TQWgkL
	zBQ2D4DK7QeUhFeNuqruwdoiFZDz/8LAV/nH8lFt4d3rkC2PCWtcMvI7N5uWUchc
	EVowx5xE/MR5j9inUwQevOf2Ezc5G8Z1I3tqYz41jjrWn0QGTt27sSAvI5DfC2EV
	jscg4Q==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gw94kb4wp-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 12:27:02 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38f97b3f853so1088935a91.3
        for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 05:27:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1790339222; x=1790944022; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AcaOZ2fJU6ffhgF2BemXGqCQZS+ca39vbxcg6RAcAgs=;
        b=TqGcHzH7xw05Emg2s4fJhf/VElDwHeGBPzuWPz9TO29b/u0ByCP6XZ2dFkRzGevRXb
         chy3wWY6POzGwsgshM1OB3xi7QlF/JCCzi5BI3aNUevHApKdoFaIMpeZ3Q8kWybgU0dn
         kfJwzaV50p2H/dQ7BbYcrNcKeJcRXExNEqbGndQN+6dkbWL5vigGvOKW/GdM7f8L1jyY
         3z7NEJxiKVJNUuP8xAqEnmqZHA9Oa+TyzxF9txC+dsPh3ih8NBdV3WzLtZw0PgfmM00T
         IEnhtjlm++rIfe56NoMWpZK2MhkNs6dc03r9K7UD09TVgyCKk8UdN0XFWIru01myWo+1
         07cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790339222; x=1790944022;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AcaOZ2fJU6ffhgF2BemXGqCQZS+ca39vbxcg6RAcAgs=;
        b=jhlj1UPiL2WpQRJJW1GRAi+mlJnDQqVqrULL7LljRGGlPxvtA6JEm/19f3XwlQMOMm
         Uz6fF2GFwsQ7VZrQbV8jqgIDPvuQL7N1wJv8hBsFfU6crhr4IcEC/FNVuU78ZNQy8rXY
         z4uu3JMdJWIhakWh/Svc/hS/1MuzhoHguu8exwwy1zq1b828N0Ey6PJxQPqf/dlgmrzV
         A4rsq1PFWZm9KZXhf+Tj2S3YCjWTl04LXaXXJrnPsJZ4YhmlWLD7ql5c4HmK2gTnI7OZ
         DoFXfh2TRERxTlNPCNE0mY8KmBL+/FTi8UZHvXCkhRla/ocbHeHGCvKqMOLU1HaSx+LZ
         Cwiw==
X-Forwarded-Encrypted: i=1; AKwUvBwkCgpfznyeV/Fh5hxm7x3ZNRwwypE5jyUjkxtc8KA9Iq++EAaoh3IkfV1cAY26aDIbPNfJYa+eSrHhZW1rHg==@vger.kernel.org
X-Gm-Message-State: AFuF++masaNg/IT0lw37ckWQzSd2osZ/Diz3tDcc3sr8qMvvCU2XN5rc
	LM0SDI+OCGWDG/QYnQAXm0/L5+CGy+9+vXMvyTSzJT/wQ2hd/ArVo5CMTlRxbfPJcMH/rqE+Aoz
	8elbaH3EfP6yJv8HtjtiA0LqZ8leNPD4twGbzl7jZvvxjhznh6+LysqTiKIA9K1GgVZD2q/jaxw
	TAZf4kuIM=
X-Gm-Gg: AYBFou1lH8CL2ztJDVpI1/saPDxIIoaq6RkPaLKHB5pET3jqNwHOpfdtHmM6GoPuGG/
	RSsGbj8pjXMCVikJLOaWWrj7qaMZa2Dsdefar3D3lm15Myf+G5XQvqq10Q5WkG1nkfUhjZ21rB5
	aFeEK9DwkhpK4NwgL69lZ0RMG3gflv7tO0lBU7Y78LzR8Nw3BbkmNCJnxVufctcPIgxp6SUF1nS
	2oVrzn28ZLVu4538Ozu0m0WtEM+K36zlVcZl8JLlmmbiufuv0nM8VNozKNfRXhQiI3Z5j8y6crt
	pGjwfVmQmDksa0umF2L+KlWJK5J0Z27fJXaBLhcSPCgzhVvuD/yl68XuFeH8BVCqBW2PKBczw2I
	bM+QVCIaEtzYg8Ut/26wWUSvXvQzEWe7HEkm5VH0wepzyMDQv1hE=
X-Received: by 2002:a17:90b:50:b0:39e:5c88:ce10 with SMTP id 98e67ed59e1d1-3a0bb443ff8mr1713084a91.0.1790339221623;
        Fri, 25 Sep 2026 05:27:01 -0700 (PDT)
X-Received: by 2002:a17:90b:50:b0:39e:5c88:ce10 with SMTP id 98e67ed59e1d1-3a0bb443ff8mr1713069a91.0.1790339221103;
        Fri, 25 Sep 2026 05:27:01 -0700 (PDT)
Received: from hu-kangyang-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b998dbf2sm4401671a91.12.2026.09.25.05.26.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 05:26:58 -0700 (PDT)
From: Kang Yang <kang.yang@oss.qualcomm.com>
Date: Fri, 25 Sep 2026 05:26:38 -0700
Subject: [PATCH ath-next 8/8] wifi: ath10k: trigger recovery on PCIe MMIO
 wake-up failures
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260925-10k-sdio-crash-v1-8-14baf913df94@oss.qualcomm.com>
References: <20260925-10k-sdio-crash-v1-0-14baf913df94@oss.qualcomm.com>
In-Reply-To: <20260925-10k-sdio-crash-v1-0-14baf913df94@oss.qualcomm.com>
To: ath10k@lists.infradead.org
Cc: Kang Yang <kang.yang@oss.qualcomm.com>, linux-wireless@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790339204; l=3453;
 i=kang.yang@oss.qualcomm.com; s=20260921; h=from:subject:message-id;
 bh=6DlQdupdI3sE5KW4WGC+fgLIQP6e+cwnTKfsVyYBx90=;
 b=pyn7qwTmLSuu7bN1kmnRtgC+n6zLAzS5sF8LU5fbeUXkF6Dz6Ull/Ncj4SnDjRQ9a6uQdcmA+
 3JAyq0brhLdD7CfKbpA33Btefxs1FYdRzSxF2RdU4Fb+6AriyyNkqNZ
X-Developer-Key: i=kang.yang@oss.qualcomm.com; a=ed25519;
 pk=qz684ZqyU2kfjPKl3UVYeUcHg1oCLfFIhi0n3vK+MFk=
X-Authority-Analysis: v=2.4 cv=aaj0Dhot c=1 sm=1 tr=0 ts=6ab66896 cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=YMgV9FUhrdKAYTUUvYB2:22
 a=EUspDBNiAAAA:8 a=r31ynADB2PxU4kuVuc4A:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-GUID: cXhqCN7dAN-Nup71if_IF26Y3DK_Wjpf
X-Proofpoint-ORIG-GUID: cXhqCN7dAN-Nup71if_IF26Y3DK_Wjpf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI1MDA0OSBTYWx0ZWRfX6qe/YEdFV7yK
 JWiIbOJUKU+TrJhZAUPpQlCxQ3UkCX0VSD+KIo1vpdiNqENXSbaX2yoYuBcaBCwHMz1t1dqX43U
 4bpWM7LRPyZala5tzMG9QxdZubYeiwakVS9h36kY9T60KFwsM6nHB77dpzgXc7Egulxy35nxMg3
 OSEkbJYQpMo3qDys92ajinQrXyQHf2wkvuUa0g7MuDtOVDFNKRX6m5UJD/GvduZI2jeY5ffF6Od
 S0uJRYMzw3Lp+HYefjuaHavbMpQlXSstaDjGK5jR0CZKYdoAiAYkaIQqDx/9LPyFwljyu+Omxe8
 tHyhkQwUFuiF6Zl2WnngOXEmp2gEO5W9K2nV+lLS/w4BJfg1f60Bzga7iQIRJ3WfwQ+jO1WpA/1
 7D889InPfUZmlIKAg3wWIxciAcracOjKNFDdiUR0o2DknHazP4K33gAF0JvE42m+pT34Otq8wPl
 1zfrr9W70EDxjeUvL2g==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI1MDA0OSBTYWx0ZWRfXwtQsiJhxmjtU
 bjkJNZtkvHj1aQxCL3g2xMjAh8qcyWVQr1XpLUglUQAx4neO+lxaQz+eIa0bT1W1engfzn59jZ+
 2BUsiLIKCs7piNmpK6hAS4bZA2/nZ34=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-25_02,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 malwarescore=0 priorityscore=1501 spamscore=0 bulkscore=0
 clxscore=1015 phishscore=0 impostorscore=0 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609250049

Commit 77258d409ce4 ("ath10k: enable pci soc powersaving")
introduced MMIO wake-up handling through ath10k_pci_wake().

Current code only logs MMIO wake-up failures and returns.
This becomes a problem when a PCIe link-down leaves MMIO
wake-up failures as the earliest indication that the device
has stopped responding, because the existing recovery
mechanism is not triggered until higher-layer timeout paths
expire, for example:
  failed to wake target for read32 at 0x00036044: -110
  failed to wake target for write32 of 0xfffff81f at 0x00034834: -110

Improve this by triggering recovery immediately on MMIO
wake-up failures and by aborting MMIO-driven waits once the
device enters ATH10K_STATE_WEDGED, because no further forward
progress is possible after either condition.

This shortens known-failed recovery attempts and helps avoid
suspend watchdog timeouts on systems where recovery time is
tightly constrained.

Tested-on: QCA6174 hw3.2 PCI WLAN.RM.4.4.1-00288-QCARMSWPZ-1

Fixes: 77258d409ce4 ("ath10k: enable pci soc powersaving")
Signed-off-by: Kang Yang <kang.yang@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 335bc7c488e4..0c671630cfc9 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -478,6 +478,10 @@ static int ath10k_pci_wake_wait(struct ath10k *ar)
 			return 0;
 		}
 
+		/* The device cannot wake once it is wedged. */
+		if (ar->state == ATH10K_STATE_WEDGED)
+			return -ESHUTDOWN;
+
 		udelay(curr_delay);
 		tot_delay += curr_delay;
 
@@ -642,6 +646,16 @@ static void ath10k_bus_pci_write32(struct ath10k *ar, u32 offset, u32 value)
 	if (ret) {
 		ath10k_warn(ar, "failed to wake target for write32 of 0x%08x at 0x%08x: %d\n",
 			    value, offset, ret);
+		/*
+		 * wake_wait timed out; the device is unresponsive at the
+		 * MMIO level. write32 returns void so the write is
+		 * silently dropped -- kick recovery here instead of
+		 * letting an upper WMI wait notice it seconds later.
+		 * Guards confine this to runtime; cmpxchg dedups.
+		 */
+		if (test_bit(ATH10K_FLAG_CORE_REGISTERED, &ar->dev_flags) &&
+		    ar->state == ATH10K_STATE_ON)
+			ath10k_core_start_recovery(ar);
 		return;
 	}
 
@@ -665,6 +679,9 @@ static u32 ath10k_bus_pci_read32(struct ath10k *ar, u32 offset)
 	if (ret) {
 		ath10k_warn(ar, "failed to wake target for read32 at 0x%08x: %d\n",
 			    offset, ret);
+		if (test_bit(ATH10K_FLAG_CORE_REGISTERED, &ar->dev_flags) &&
+		    ar->state == ATH10K_STATE_ON)
+			ath10k_core_start_recovery(ar);
 		return 0xffffffff;
 	}
 
@@ -2248,6 +2265,12 @@ static int ath10k_pci_bmi_wait(struct ath10k *ar,
 			goto out;
 		}
 
+		/* Stop waiting once the device is wedged. */
+		if (ar->state == ATH10K_STATE_WEDGED) {
+			ret = -ESHUTDOWN;
+			goto out;
+		}
+
 		schedule();
 	}
 
@@ -3308,6 +3331,10 @@ int ath10k_pci_wait_for_target_init(struct ath10k *ar)
 		if (val & FW_IND_INITIALIZED)
 			break;
 
+		/* Stop waiting once the device is wedged. */
+		if (ar->state == ATH10K_STATE_WEDGED)
+			break;
+
 		if (ar_pci->oper_irq_mode == ATH10K_PCI_IRQ_INTX)
 			/* Fix potential race by repeating CORE_BASE writes */
 			ath10k_pci_enable_intx_irq(ar);

-- 
2.34.1

