Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793698831;
	b=h15sbT52ZNKwO3ccugvITa/GQ2rVFyrc+6BUX7p1BZXA0jsS4f1rICIrvepkFPE1i3Tf
	 nxmOZbVlYm/pYm2/NG1YBSSfQYAwAkSjwHU6FK7gYdz8PSF5mskH+AYLFiBCowMqbWpfj
	 yYU2erM8X30YZAGLxQD3mrK7BC9nrpkmJZcX0YiWfsAfDaVo/ZYMroQ6la2za51pI1DxX
	 xhrVpnlyR+YQ7+y14R9eb1ao8X9SkEJG9G3mUncInwBLSW6D02DmOr7aknDrqNWL0aTcq
	 L0gKZDFkcWPTU+4PKHt54bppXIxGf5UYdfiHYbwb0svg+vzMA2wlVV3UKStBMyLyxrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793698831;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:
	 X-Received:X-Received:Received:From:To:Cc:Subject:Date:Message-Id:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=7WcHWaVy/MY/Uug0kH1jhCYe8yeKUPTCjdedoHBj4Jc=;
	b=j1jPf0u381PYA9/l9DWvTE7hW2ev2Lv5skpO0TYE1hhRBpFVi3DsoUKJP+3NyZgLF4b2
	 NVES1YvmKuDXX0Rtjxy9EPp+nWHuCTKBKQ3iFOXurn3vMA+FQ/3PDfBPdgZrfH6PE3nLL
	 S5niFQ3KrtH35XsZ0CCyVvqeoP715YCytgpm/h0rVj1VUZxr3UD++1wKbgxmVYe+i/5Hc
	 3FI+kSz8SfPJHR7vBcvo6It/TE80pqt3lks9O2a8HW+8tzpbm3UANqTjEiSVu2QssYRL1
	 61i+khFK+zmrWcqBHRw90/+4QoLQuA2NmgKrBt4yXbhL2I06cIgD9sc632F3igpzZkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=G0Hilzew;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=bng99sug;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAAE2606A33B
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 09:40:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EAAE2606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=G0Hilzew;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=bng99sug
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A38Jwxo1082774
	for <linux-wireless@vger.kernel.org>; Tue, 3 Nov 2026 09:40:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=7WcHWaVy/MY/Uug0kH1jhCYe8yeKUPTCjde
	doHBj4Jc=; b=G0Hilzew92v6MVHzYKhdRR1T6oucmlGAkKRf2fkOt2EJYHK0iDp
	tG/cTxEaNRH2qiBAlQQ9ZSTOL7fsgr6/99VJUSaW6CEdDnpZZhw5Y/Y0tE1UFe28
	mx3Z0T0bRNwP9uDCvISW7iOgoM1mJ6lxlevWt3d3D1XIBnrxv2vx6MTlHtQ8XQBo
	cce1I2VFySXs+kjtvcXAj6eiWaDVQ+BDlg2NXTXefezxgSJMEkJrwy2Pl+jsrMYS
	fLXt5vOi+M5/F9HDnmSP8SCmVKSskT8gYdQSkFhtD3SJs6w+4TQBf9Y/m3TqbCUw
	li4GKJ5+4YU8qBysC/0KTK2VdXz370lDzZA==
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hq07r32md-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 09:40:29 +0000 (GMT)
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-843cf077bf7so5324189a34.2
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 01:40:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793698829; x=1794303629; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=7WcHWaVy/MY/Uug0kH1jhCYe8yeKUPTCjdedoHBj4Jc=;
        b=bng99sug6S1saeieI5S8gIOH+ylRDc5rA2ydBTTsHzCj/YRL9I0c65MfSv9JI6Xqb4
         ajXg9D9iGw+CDElgk4dtaSrXoJdRppN4Yhtvio9fwFbTkyveiIHcXKOEVgc2zQQ0em8m
         k4KmJIxeYKrJEUSGoPKeTZPvOk8lGBFo58nM25U3m1CrEEjmW7Q7JaY2sYLXM65TsNHu
         PwxtItAySJKHXoFiwJOinW+UCb8wUTN+XX8yjAHsY43aVdCiFdzq6kN9b8gNxA9HelJi
         1Q+FywP+rdQpxLp2yZyQkqSDLF77HYCshZCzQ9bM2nL6nIXxnpz9ncZjHdQX00JHeVec
         QabQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793698829; x=1794303629;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7WcHWaVy/MY/Uug0kH1jhCYe8yeKUPTCjdedoHBj4Jc=;
        b=eeK4yArjLaH+FcAz9+eLE9CNHX+DyEwbN3/azrb/SEqpR1UW37fiBpSQeBgt2m2URy
         ejLZTDX+mZ/tIKUVqs/3uzoVCKaBl5+05qHthY0AZsO2+DRctb7zjwgA2LDKnqkRWmS9
         FkfjS4xH49SWYUHolM4Itjgxdgx7BsV75KAqHbW4w5bvTW0MYhAN/J1vEAcsCdO3Gu2H
         Mx4pEqzJAmF749Qw7gV6otZwz01QG5EWvRKOMNPQ+eA9NnPSDN+mp/fkr63FFuL47Ohp
         r190QSChz0UR3qc0ldpVaGFU+gatWVfMAznDgaI9PNEAtLn5mF62yaWe53CznQ6IMHf4
         j67w==
X-Gm-Message-State: APuU4Z9Fw0JO6qthyUWGNe6aIq5gx1XPxWfEVQK/VWZxuJKjEP+WZsUd
	s03hXbNw0obK0AEtqE+M1Hj+KFVXGPVzp+JLBtevgX3MT5RXhzwVj0yAHXbnpiSMqdXeAroG7Pg
	j3RtTseQJy5Xrbf+S7LJ3B8gOR69NYBrCRykdGKgVwtgjwu1f1SmKIuU7/qv+Jka3RMMFFA==
X-Gm-Gg: AYBFou3uMsCZD7s4cwAvX9JE4gCuK4/6q/mhjLiWT4C/Xai3n2hIJIHwzxNGWYDW91o
	YJ4Aygo/p5uYs5jT4lI5PsFYrFZ9MI3Gc46c8KHDNYDsaOQUQrqkM93ouLXwYaR6CPwH2DB5wsL
	wSbrgZJNxeAHtmIGuwOI0lYdnFyBFJ9av8kmjIPFl5Bu0hX3q6w8vrc8ok0Psp7xFU53nh9Jecs
	BKlpoFrhvP+He6MsEHHU22Fa98OaNFHToMVjfgqgp4Na0gSV1UR2jhOsptfeFdP2oLWZ94IGMFV
	6rtvlFZ4e0t9gIbbsnvbJlkVrT7X0MsEjhTLnqK/Mv7xQDNkU9vRvXXWaNpJnaX5vc9FAGmB1d7
	6hePKnDSQWfIrrmNp1BozBF60Sjoo6Cx5ZbYi8hh9+7yU9t+C6s0pixCr5MaPSJ2rjOQZBkHvib
	PlzdPZr6T23WxxVUseXVETC8rl6HlRrRhx7p9W
X-Received: by 2002:a05:6830:913:b0:843:56a6:c881 with SMTP id 46e09a7af769-85d3636ce61mr11809098a34.8.1793698829096;
        Tue, 03 Nov 2026 01:40:29 -0800 (PST)
X-Received: by 2002:a05:6830:913:b0:843:56a6:c881 with SMTP id 46e09a7af769-85d3636ce61mr11809082a34.8.1793698828668;
        Tue, 03 Nov 2026 01:40:28 -0800 (PST)
Received: from hu-ggarmidi-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-85d354f660csm11218241a34.22.2026.11.03.01.40.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 01:40:28 -0800 (PST)
From: Gopikrishna Garmidi <gopikrishna.garmidi@oss.qualcomm.com>
To: jjohnson@kernel.org
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org, sibi.sankar@oss.qualcomm.com,
        Gopikrishna Garmidi <gopikrishna.garmidi@oss.qualcomm.com>
Subject: [PATCH] wifi: ath12k: skip hardware rfkill setup on Surface Laptop 8th Edition
Date: Tue,  3 Nov 2026 01:40:24 -0800
Message-Id: <20261103094024.1764151-1-gopikrishna.garmidi@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
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
X-Proofpoint-ORIG-GUID: 0wPLMzOk4W0Q0bN4hOU9MGe9nGmGG0ak
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTAzMDAzOCBTYWx0ZWRfX/UHW0Z6qE+Y0
 vnTzLnXX0pczcdJZyNO9rFMtI8h+Re7jVG+C7Q00RAP9DKGjfu+gPj9J1jZnwYkFYYaYtUbfQOX
 F47W7+1rY7dYKVm7kiwOxdC/1D/TA3F8/JA67aufPW4GCnwbv+XPe9WJn4GqBbwQNvGiTJtvR0p
 d27kvghKQ0Vv0QR7nwuDTBbT+1p3HRreFw24bF1mRkmquLY1BIGKEGHOTWVBiUFJpHQUBorO+Ly
 gRxt4e5BdPxPwGzZLC58UFhn2kNS0zR0cK0c+cJCyZb35mhSLNacJUeAJ7369Kdy0NqXYFw6GQ9
 2j6mkdFRzLXqwXJIVrDDYErADun8j5rTO5ZLAh2QbN3UpDObHGg0bO7x9q5Tu5q4BCcgZUQJ4bq
 5WRDbr/bJxzr5RdprqgrT7n7FVjbOlM3hePt7eT5W3jkHfzjRCRvXeQsW50Lx2dBpISoIWeYNBh
 uX36OORI9XpFbPOLFbg==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTAzMDAzOCBTYWx0ZWRfXxD7an8pwXawt
 W/KR9TuRpFZ5zAyh43yb+vfG4nIF5YtBfWBePdgpzID3NxBIfdo5Vt/UuvzdfVIptw/vNiUEiWZ
 N/aiYqRGZWt27dDL9P2eSkXKPHGPQSI=
X-Proofpoint-GUID: 0wPLMzOk4W0Q0bN4hOU9MGe9nGmGG0ak
X-Authority-Analysis: v=2.4 cv=NZlzRGD4 c=1 sm=1 tr=0 ts=6ae9ac0d cx=c_pps
 a=+3WqYijBVYhDct2f5Fivkw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22 a=EUspDBNiAAAA:8
 a=UtmVXepWBbLK2i_37A0A:9 a=ZXulRonScM0A:10 a=eYe2g0i6gJ5uXG_o6N4q:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-03_01,2026-11-02_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 phishscore=0 priorityscore=1501 suspectscore=0
 clxscore=1011 adultscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610300000 definitions=main-2611030038

The Surface Laptop 8th Edition (13.8") has the same broken WCN7850
rfkill input as the Surface Laptop 7, so Wi-Fi stays hard blocked.
Add it to the broken rfkill table.

Tested on a Surface Laptop 8th Edition (13.8").

Assisted-by: LLM
Signed-off-by: Gopikrishna Garmidi <gopikrishna.garmidi@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath12k/core.c b/drivers/net/wireless/ath/ath12k/core.c
index 25987bc58556..35a440742456 100644
--- a/drivers/net/wireless/ath/ath12k/core.c
+++ b/drivers/net/wireless/ath/ath12k/core.c
@@ -87,6 +87,7 @@ static const struct ath12k_core_broken_rfkill_table {
 	{ ATH12K_HW_WCN7850_HW20, "microsoft,denali" },
 	{ ATH12K_HW_WCN7850_HW20, "microsoft,romulus13" },
 	{ ATH12K_HW_WCN7850_HW20, "microsoft,romulus15" },
+	{ ATH12K_HW_WCN7850_HW20, "microsoft,surface-laptop-8-13p8" }
 	{ /* Sentinel */ }
 };
 
-- 
2.34.1

