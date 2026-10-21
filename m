Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792573809;
	b=XRLw90e3rrTit1so216asfDqaFDZEEBgTNtDa+u1zpkw7F3V3IuakWdZQ7Mnm7Ec1lGw
	 7On2rbZZiBqsVAXFHHj8TmWSIPl0zimq26Q7nmloBjAT/kokdkv0Sj5ZThgKV4n3tCfrX
	 VEVxT+cZMvbWwVMmqXetAQF3UgJyMrQzVEC10YMkvufhrt7kDyS9Gux9ymlYdMxf1dqOr
	 TZ8TSAquAvTStg+5VDgABWUlMD2pCJbv637RSSqIh+eLxL+5g3epsbA9qYligMyU6HhaI
	 ygsOGFreGyYTndUV9bX/E57mevpsllBE+dk+LPh2QiJrlsSJ0+igoQI6XvTf0WEpNGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792573809;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=5NgSXnEEmgfgUTlanAo/6OQIO26bhBCj1wawXnORXqw=;
	b=wvqrjSRRUmX22IN68Q/iYKad2oT6R0+bxnu42IrnNHzCdiMZMVNxR4xgt+w+KfUyq4hE
	 X6xaW/wYdlBMqk1kAc2Cy0Tcxm7x0vZNhD9SZH4jd994wt7NPJrV8Zor9ioTPIF11bkmb
	 0HRVw+41krlZ+AV3geEHQNkDwf0HR3cjTkcbQ7g5/FRvUZdU94k5894d/cdSg81+u4ub5
	 w1B4qiAYSHfEVFtHCJYe/ZKD5cjpOQ4OqOZQgZ2L3xMT+L6aRrVLlexHOnv5PH8wA1aV4
	 zaf1NQDvh+iTvgtnJxR/kEm56h0OhPTlMJesjE8gZBU2v/9TxWons2t8d4XL33MZZcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=AZA0kGTc;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b="SWuhm4U/";
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2313160A3836
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 09:10:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2313160A3836
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=AZA0kGTc;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=SWuhm4U/
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69L5j6TN793360
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 09:10:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	5NgSXnEEmgfgUTlanAo/6OQIO26bhBCj1wawXnORXqw=; b=AZA0kGTcLAf+I8xh
	4qDURjN4lQIRJ08mfAH9igKwlyztL0wrOPrwpBO+IGGHv2IzP5Ix4/X5nMu17CCj
	KZuSuPYgSMIlv2BdoRDVjJGji1k1DAqxx9xXepgKBODSPOlPF4yx6yWYXRmN/SOZ
	W1vCs4MZI7fG5wDHLXAfiqiLcHP5463RvL/OPcQ6G8AEbM0gC5rcP+fwl3C0TYtc
	IMvtIUfIzH7ksm1beFrbQVRoFzyFT4TGoK+lzOFVpfHxwQKhtTOmtxpIMA50opki
	gyItfhgBnecM7DwzEcrgTtIZ7m5vegfQut6jIlivQAFRxvxyGL379VkhdYAUDQVJ
	QrB7NQ==
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hedabk6rr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 09:10:08 +0000 (GMT)
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-844195cc415so663660a34.1
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 02:10:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792573807; x=1793178607; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5NgSXnEEmgfgUTlanAo/6OQIO26bhBCj1wawXnORXqw=;
        b=SWuhm4U/lp89QE8iZpz+qV20uuGwPD0NuNjz6f17VovKfkHtc0HZ0v7fbiOo9Devys
         doZM2nohLW/O2am+WRxAqpBlvmFcgstxLp//93HVNFORTpppTJsTaUnqI95oeKHpIwwa
         gtOrijEt9U9S2PedFQs3WPd1OY8lus/cvhFAqVE7zSx545MftSxLuf10XTg6FpS2YfGf
         QpGdSfQYXqY4aFbE7CshdcquVFfSGpX0mybC4CeAMSSSfQ+brARmPHSSeiK4h4t8Bn/n
         vhITxpy9iRQuR/cXwZ7DjgeUDm7lmQ+BlvqXJnT+9oGA5YBXH1nuxcPZchFCOppf33+o
         11mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792573807; x=1793178607;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5NgSXnEEmgfgUTlanAo/6OQIO26bhBCj1wawXnORXqw=;
        b=gLFOT4XtNE2uFjA5oqpyQtIdHdo4lFqpFpFTHGtxwMH2zHzabIUc3VwkbJNV1KE/xH
         sAyOIDLb2Yrk9TAXqJhxJ72qilMTNXrc7s6e7qt2erKdq0cCyyBq7rZP2u98fdcsvBOF
         8rGbY+uWlN4HuJIv36pYmCcNRRElSMWsT8091kBI9EVfdgx3JBl70A6XsH7BbZjIW9Mo
         0aMxLy0Lt1MCzUmrY8mSFWQoyqk+3ONlAvJ3Im52i3QCQ5SMBxlXYQXvdKYyKNGXA5Jm
         5tqlRJuJGz0ebXn235k7wepYwaPVvdknxMZC96kh1Gfl35Dbc8vU9oA5mTAyO5v6oJGr
         BJug==
X-Forwarded-Encrypted: i=1; AKwUvBwMOBSShHLZEoJTEG6/0AtdQX+jIWhNXTVNo5RNwLAcuSaHn2Y4zjx+tmY9hrfku+TaHNm5rwaYDMv5TODhIQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYKE4HV5XK251ozqIEJK0hJuFOtFR4x25uODwaSFSaZTZCWNNMab
	7BzEbWOD7WbP7295qxid3iKYpvQI3yezww1BdVzzUDgt5RKA08sEnnUUqIfhkJdq9hjmHrQV8z6
	9ZVDgAt+jjSywHjlBCQfIUcWFOLqjcmcpHyiXc0/wnEMD0qpHPnIwcg8vlSou1zDbhOW/id+FBZ
	Wg/cK8
X-Gm-Gg: AYBFou2MgCkXS2KHV9y+VjYvpW2mnHdm/84cB0IaFKuyc290oGXtOV+LbLiM9KiHS0t
	SvPyfag4sh034sNAYbFH6LOuDfACkyUpVaPRWYYMboemppPQmnYhAvvvG7AGtD7q/XS81Odr1Fd
	VTlfLeOtmgO3vINUgOtBvXPdAaARwLnIOwww06kEegpftbBKoG8bqh+P5G+74WwynKcA4cEO5x/
	yeGDTg0aX+aPwIM2SO63FC/19KkktPRJbelAr2IJjreQ2hRzylRfNPpb3rp35mwA36F4gGAGLLt
	r/dQSH6IrL7ZRBxnR/zpEKfjabKItbz44yQfhOwh2iKNGg8OFPoH1mSZflhZh25MBgtrE47QQ4n
	UBAT8yyakxe1OBK+JEn3K7xH+HeXKj/bESe2vH1N6WnlDEAH58Q==
X-Received: by 2002:a05:6808:1822:b0:4d5:295c:a82c with SMTP id 5614622812f47-5536436a25fmr803763b6e.57.1792573807522;
        Wed, 21 Oct 2026 02:10:07 -0700 (PDT)
X-Received: by 2002:a05:6808:1822:b0:4d5:295c:a82c with SMTP id 5614622812f47-5536436a25fmr803747b6e.57.1792573807082;
        Wed, 21 Oct 2026 02:10:07 -0700 (PDT)
Received: from hu-kangyang-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-552a182d59bsm1554595b6e.0.2026.10.21.02.10.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 02:10:06 -0700 (PDT)
From: Kang Yang <kang.yang@oss.qualcomm.com>
Date: Wed, 21 Oct 2026 02:09:36 -0700
Subject: [PATCH ath-next v2 8/8] wifi: ath10k: trigger recovery on PCIe
 MMIO wake-up failures
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261021-10k-sdio-crash-v2-8-5df80bf16e86@oss.qualcomm.com>
References: <20261021-10k-sdio-crash-v2-0-5df80bf16e86@oss.qualcomm.com>
In-Reply-To: <20261021-10k-sdio-crash-v2-0-5df80bf16e86@oss.qualcomm.com>
To: Kang Yang <kang.yang@oss.qualcomm.com>, Jeff Johnson <jjohnson@kernel.org>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Loic Poulain <loic.poulain@oss.qualcomm.com>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        linux-kernel@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792573790; l=3505;
 i=kang.yang@oss.qualcomm.com; s=20260921; h=from:subject:message-id;
 bh=aqXbHJb+y8P/i5hcNxNZ05zuFzzRiubjGC5cyQScfYw=;
 b=l0Truq/CdJjBKD+I1n9QpDVhmTitSnzL5xp6Iue8hbgm/N6MO92AAOvYxxTmXICaCd7XDGB9I
 6tP197zOE6tA9BEerYOzBo64UcSehOeRbJ9H5uzljajwCprHSYzzdW5
X-Developer-Key: i=kang.yang@oss.qualcomm.com; a=ed25519;
 pk=qz684ZqyU2kfjPKl3UVYeUcHg1oCLfFIhi0n3vK+MFk=
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDAzNiBTYWx0ZWRfX6e6HX4E7440/
 IyEN9GN7YgBUcSxNEd2jgvzWvRALV8nIaimNDBsjfYNUoEb5xJOjPS++8oThN2FTMhd5y90TelQ
 478MhoY4GpyksL+XpZbyeEPziRV4rdk=
X-Proofpoint-ORIG-GUID: _zUGu3OhyZZw7sUFbUrl7Ixm2s6JiD90
X-Proofpoint-GUID: _zUGu3OhyZZw7sUFbUrl7Ixm2s6JiD90
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDAzNiBTYWx0ZWRfX4ChkrEeXidxF
 527OZ/8ZB4lrFzUkIZ3dfb724w5nGh+mhg7WS3+EBUJFPYzSa7mrNicwQrqoAAzaMyEMfvOH/yW
 /tWZL41LoTu+WkBOGP+Z82BfOgMBM8urd8ypKELKX6kx1xwVoIJOwah6cfeKxkeO1fVwV8+B26O
 xTjqt8xdyxKkKFXdxN2U5dHmMszCb8D7I352nIdFOdEIye7oAuI6YLC7mZQaLdIuesCCeOhsCsN
 HY0NALNfz0gh0b1gHAgirDROcBrqQDkhQbmvlsElnG9xFxHVShgKAenK17lY/5oXu9M7jbPlRqQ
 mBx09tCtr7bu0GoKSa+1c1NiE4biCpK+r8lY4tppU8XsZk4dNidtD7a0xLm2C+/ecRdf+Yt9SYE
 1cY+TrFaQBPoAzaQYPbuyhxrCkt7a71zc6G9ZVz2uLoPNkuEgiIVJTsRrVdSIoxo7krQzbFhL6r
 JpfkKiosdoYlC6bWESw==
X-Authority-Analysis: v=2.4 cv=NLpAaE6g c=1 sm=1 tr=0 ts=6ad88170 cx=c_pps
 a=OI0sxtj7PyCX9F1bxD/puw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=r31ynADB2PxU4kuVuc4A:9 a=QEXdDO2ut3YA:10
 a=Z1Yy7GAxqfX1iEi80vsk:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-21_02,2026-10-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 priorityscore=1501 malwarescore=0 clxscore=1015
 impostorscore=0 phishscore=0 spamscore=0 adultscore=0 lowpriorityscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2610190000
 definitions=main-2610210036

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
Tested-on: QCA6174 hw3.2 SDIO WLAN.RMH.4.4.1-00189

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

