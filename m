Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792573802;
	b=jtIUUDGG9hNmWtj9pF5bHRQ85TzvLcTfF+sM/s+pwsSsHEOiUPYN7/Cj/u6NaXKmNNSk
	 sgIu6qaxDLy9NqreJNr/j4Fmc3/6MEqWWxSGQCA/ITSx6F2OpLoHpqXXUUpBCnLyCUV67
	 7TfRZckZ63YOWOI4uEX4FUotRaOWlnn6II6q3qfd5QuAuDVuTXHIS9NxdspQ8dRn8icOi
	 9DUbZa7KcVLprfCFpVTwaN6R+rNadUn4LExk22fv1W/J5RCkRhLwRJ8FiZDAgN5X71vyc
	 ql7WJBYSLrGuLg9RmAzL/wtOFVO6qiW3tBNBZsKSnCLNP7GNPAytOwRTIyf8TTnXSqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792573802;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=otIwjrkbsLNWec0npAnJUqCgDqh7U1EWf/DMekBYQGY=;
	b=E8jk44s1SHMbu1Pyazcl0AzCcNtKj4nSogJ3ioAz7m1VP33EaHTTdfEHbNE6wdZ87OG0
	 uBiCE/NdVEBd8qCcYUb93DbJpn9bLTotP9F4VKWlNuTeXG+5SZmmql37dlLkBiyoIQKXe
	 D5pdu8JUWnzgiPtsUY5MJWSMvi7dVhDTGKozhr7aC9Roqjm2d4EEuZhiA4+gfAmCmG36z
	 imCbiim+V9/hXkD48MlQG6JHr1fvJSAvbeA7ZHpY2LKfugxUtmicudvu+o7xA8HVa+2ku
	 xrYt8VWaTsUMOfUWqoQUKCx9QNyb7cT+JuS9kCezRCmeCxOgHfcE7LwrIApOPXfrV9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=P8kF0uRb;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=d+zzy0vc;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4E2460A2615
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 09:10:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D4E2460A2615
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=P8kF0uRb;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=d+zzy0vc
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69L8VRYV2795038
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 09:10:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	otIwjrkbsLNWec0npAnJUqCgDqh7U1EWf/DMekBYQGY=; b=P8kF0uRbe8eGz+Xp
	Vwum07iLRg/bTDiX6w/q1gn4UhPIPHV8M66pTQ4/QAx2NE/lZ0osRZMMgh6CV+vB
	l9hngmkUQeWKt5LhuaAUZFenRTJfVjyDbKpNY67Dquoh4Kud+kX60g6YkMN+12jf
	QwIjPTR1lbZleP0HL7hjZkIChSEWGuSCLqAQXKWSkunvHl8vYW2XJVbhyZLE/PSE
	LGBJQfOjpwLVCdaw2HsgBoA6WASOlo+kPTY3V2k7kVfEPhXRidugMTdlQjf0C5pB
	gRsGMZdCxaBSoCJOC69Ecy32QsjxhfRnqPwSVTd+9k4bfteYkcgqB93i8alPNNZQ
	6cVTDQ==
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hesy78a21-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 09:10:00 +0000 (GMT)
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4d2f0f77124so588315b6e.3
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 02:10:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792573800; x=1793178600; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=otIwjrkbsLNWec0npAnJUqCgDqh7U1EWf/DMekBYQGY=;
        b=d+zzy0vc/J4ef9IHX3NDNRw/lV0J+JTx/tbr1xM0FHDlRNkCte5qoYNKjBr2pEPCLA
         3mcg85svjP1jJk7ZrNN/HQ+J5zmI1PJbXjQ3qDxP0DF8QuwNM20LvtpZoKIPwAclYv8/
         g3VDN839eiG01u4huCMCvy2m8LE/n2r5G2+pQ3bfVOIOTEKOU7IqdgWLUXFUxj2lmuer
         T+9iP1ybM9TQuEgoYTsaZkxcmvR6MD2ldEa908oHlgRQMucEdUs6RGricPNa4qVuA+SL
         b6GUM/XTyUOzSN/rxcPmp6BDhfQK1avJZIC4uHQW8FUhSSUB/iRPmdNIWKa0mfdQhLM0
         RnNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792573800; x=1793178600;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=otIwjrkbsLNWec0npAnJUqCgDqh7U1EWf/DMekBYQGY=;
        b=o1H/EDUvLYtH0cEBB8GCuxTeHB2GjWNGaR7MqFUAA4eM/1VnJ8s21thj6F17uPwp39
         NqvBREEP5D4ruvzsW80mZlGKJQMARhzX8DOBcr6HYQ1d204YpYacALIAEiO6drTG3LMk
         MyN0i95ew4Zxq8qh7RqmHiB2J4DqUb5Quj3U1BaOjOuhLInfcTb3jTQ+Gbhb54jD+GsV
         lq4UpAfqt7p6fxNqitS3faWI9CA6jsDNjP9VX4mYG83b4+peRu5iEEd9mtRV5wz+5OIL
         qiz4grY0hOtIVSgxhEretJkTxXKnPuBQbbu37jx+x2nC55jsm7Hd77WmbvIqXzTdgQip
         pnyg==
X-Forwarded-Encrypted: i=1; AKwUvBz263/6J0t5YQrDJet+osqhCdpTuzlkPW4wdWnfktu+IhsVPY0yryJMIg2SuhcjmOYpI+fwKR4dkbW0TioGpg==@vger.kernel.org
X-Gm-Message-State: AFq9FYKOqsu7vSyneUGZAZ2UHHYsp/ZX2MrFhBHWgmurczhzliGpDr7v
	fZSO+DgTp1T2onQ55gjtfTTLPwdAad1crhmu4/lIwgWRfo9cMEakzz+LVw7L7kxXTCsPdOu+heY
	1Ky80bKLnoXX/2P/TFfW/FyDxRBa+8QD4Ld+MyEQc4pKrd6kc2XYAycCNk6FgZK5VxJYvYPs/cO
	oycZec
X-Gm-Gg: AYBFou0z2a1bEbU1kGtuFGzG+oGchXAbJwvzOj49cut7jf4y9Q81msGiD1jnAlqgGzv
	9jlDBHRHZF3SuJBOggMvE16OsLa/yEcbluIEXh5v45fQozD7tk/38qQblunXt6UUOeepQQDawCy
	C4zo+hxseUk3XqtxLcx2R0W+wdTqXpHPI4CNWIdUZmfJ2WfIY+Zq8ycDQ3PyjHLXaX7HCb/dD65
	ULVn2WzasrAr0svOHYSLILwOXZ1Gm+FItLPP5HW6NoYi63NEb/5FdQjtwOQOfjqe61EP5SFnUAv
	PWjMxrxqlGzYix+Tu+Otpsty1bOT7pthMVgglCnkchEpPlctXP2IqKZZfz6e7SACo8G7zLEgRRg
	lIBiOX2ALeKqzwuNPr5TPtJRUlDEoYWQKaGaJNDam1Y0cwEh7Fw==
X-Received: by 2002:a05:6808:c3c8:b0:4a1:296:adec with SMTP id 5614622812f47-553559a2129mr911707b6e.15.1792573799741;
        Wed, 21 Oct 2026 02:09:59 -0700 (PDT)
X-Received: by 2002:a05:6808:c3c8:b0:4a1:296:adec with SMTP id 5614622812f47-553559a2129mr911699b6e.15.1792573799289;
        Wed, 21 Oct 2026 02:09:59 -0700 (PDT)
Received: from hu-kangyang-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-552a182d59bsm1554595b6e.0.2026.10.21.02.09.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 02:09:58 -0700 (PDT)
From: Kang Yang <kang.yang@oss.qualcomm.com>
Date: Wed, 21 Oct 2026 02:09:32 -0700
Subject: [PATCH ath-next v2 4/8] wifi: ath10k: bound recovery time before
 entering WEDGED
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
Message-Id: <20261021-10k-sdio-crash-v2-4-5df80bf16e86@oss.qualcomm.com>
References: <20261021-10k-sdio-crash-v2-0-5df80bf16e86@oss.qualcomm.com>
In-Reply-To: <20261021-10k-sdio-crash-v2-0-5df80bf16e86@oss.qualcomm.com>
To: Kang Yang <kang.yang@oss.qualcomm.com>, Jeff Johnson <jjohnson@kernel.org>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Loic Poulain <loic.poulain@oss.qualcomm.com>
Cc: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        linux-kernel@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792573790; l=3465;
 i=kang.yang@oss.qualcomm.com; s=20260921; h=from:subject:message-id;
 bh=aI36eG+GzocWwLCMMibADJ+IZVoI80YgIbYKQuwNIN0=;
 b=em+kyqEp5au2slgZnedoA3xlXSO8GkOskCvL9Lli1nGEjuxN+zIJxElYFOrIPD82FmdTCZfZx
 rdWnBKyR/ZXCa8FAmAFivsU46GJ2VXT+f2Ljg2O1SQCVWgUMe4S2JTC
X-Developer-Key: i=kang.yang@oss.qualcomm.com; a=ed25519;
 pk=qz684ZqyU2kfjPKl3UVYeUcHg1oCLfFIhi0n3vK+MFk=
X-Proofpoint-GUID: 8I7r32CROpJ5M1oyS5gYe4ZxATC2Ppa1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDIxMDAzNiBTYWx0ZWRfX4FY31U/3BsTQ
 L7PsJ70NoK8Rne7YHBlBmJnF/39SnSB5VUguscVTxovDHdPOyASbdd/edg0N8lr8jYgvAPqf6Ft
 RZomQyUn/a/4ePb2TgACrIwyojBFcnEdSh6F+eqLBPEExyexGhpr6IOGyF1+J4DahQW3FnnGMBD
 XwtoggNUGpij/VraXD73bAfa7FzTDC7epGuk5cYqjRAXgH4MDfMNqJrz34RTD03rcaixUblA6a8
 /W43UuElInKjmbXRGJeyh6MeShVtHd7I8fVaiXk/KF18U8fOP8ZBXz3eTzK7LvLbmjpo8Z6zziT
 feLEzt5SOCekKnxPDw64+e0z7bhktQ1hoKo6EDdRJzvduDRXX/2vpTNiJNQufi8+u1AbSgBwB45
 sR8EXoXBzlvpKz+qDUKd8lOhhR8h/NJp4UpEYv8XvUanB/c1nJdBr9OGk5aT1g6El4fjIBjOSHF
 zwoUoQdBe6D0mItjtdg==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDIxMDAzNiBTYWx0ZWRfX4N7muZ+qQNJm
 FXxuiElZWQ4m6o8YZFfszycI+3jhdhbkoLp3sQAL+ZmhX8RQFyX9v6hJIzjiM82dv28IOpgts78
 iq+lfyiKlAXRv7Fr24wzURV8xwrIvq8=
X-Proofpoint-ORIG-GUID: 8I7r32CROpJ5M1oyS5gYe4ZxATC2Ppa1
X-Authority-Analysis: v=2.4 cv=IPaXmQvG c=1 sm=1 tr=0 ts=6ad88168 cx=c_pps
 a=WJcna6AvsNCxL/DJwPP1KA==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=VCOL0f_idG3aiQAZe1wA:9 a=QEXdDO2ut3YA:10
 a=_Y9Zt4tPzoBS9L09Snn2:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-21_02,2026-10-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 phishscore=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610190000 definitions=main-2610210036

Commit c256a94d1b1b ("wifi: ath10k: shutdown driver when
hardware is unreliable") added fail_cont_count tracking and
declared the device wedged after a fixed number of recovery
failures.

This relies solely on the number of observed failures and
does not place any bound on the total time spent in recovery.
As a result, the time required to reach ATH10K_STATE_WEDGED
depends on how recovery failures are observed rather than on
a fixed recovery budget.

In practice, recovery-related delays can stretch the interval
between failures and allow recovery attempts to continue far
longer than intended before the driver finally gives up.

Add ATH10K_RECOVERY_DEADLINE_HZ (15 seconds) as an independent upper
bound for each recovery attempt and declare the device wedged once either
the deadline expires or fail_cont_count reaches
ATH10K_RECOVERY_MAX_FAIL_COUNT.

Also reduce ATH10K_RECOVERY_MAX_FAIL_COUNT from 4 to 2 so
repeated failures reach the WEDGED state sooner.

This keeps recovery time bounded and helps avoid suspend
watchdog timeouts on platforms with tighter watchdog limits.

Tested-on: QCA6174 hw3.2 PCI WLAN.RM.4.4.1-00288-QCARMSWPZ-1
Tested-on: QCA6174 hw3.2 SDIO WLAN.RMH.4.4.1-00189

Fixes: c256a94d1b1b ("wifi: ath10k: shutdown driver when hardware is unreliable")
Signed-off-by: Kang Yang <kang.yang@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 8 +++++---
 drivers/net/wireless/ath/ath10k/core.h | 8 +++++++-
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 677e582b87e4..25e9a8f0ec8a 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -15,6 +15,7 @@
 #include <linux/ctype.h>
 #include <linux/pm_qos.h>
 #include <linux/nvmem-consumer.h>
+#include <linux/jiffies.h>
 #include <asm/byteorder.h>
 
 #include "core.h"
@@ -2544,9 +2545,10 @@ static void ath10k_core_recovery_check_work(struct work_struct *work)
 	/* Record the continuous recovery fail count when recovery is late. */
 	fail_count = atomic_inc_return(&ar->fail_cont_count);
 
-	if (fail_count >= ATH10K_RECOVERY_MAX_FAIL_COUNT) {
-		ath10k_err(ar, "consecutive fail %d times, will shutdown driver!",
-			   fail_count);
+	if (fail_count >= ATH10K_RECOVERY_MAX_FAIL_COUNT ||
+	    time_after(jiffies, recovery_start + ATH10K_RECOVERY_DEADLINE_HZ)) {
+		ath10k_err(ar, "recovery timeout %ums, fail count %d, shutting down driver!",
+			   jiffies_to_msecs(jiffies - recovery_start), fail_count);
 		ath10k_core_enter_wedged(ar);
 	}
 }
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index c739fbadc8bb..0319da3ec022 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -88,7 +88,13 @@
 #define ATH10K_ITER_RESUME_FLAGS (IEEE80211_IFACE_ITER_RESUME_ALL |\
 				  IEEE80211_IFACE_SKIP_SDATA_NOT_IN_DRIVER)
 #define ATH10K_RECOVERY_TIMEOUT_HZ			(5 * HZ)
-#define ATH10K_RECOVERY_MAX_FAIL_COUNT			4
+#define ATH10K_RECOVERY_MAX_FAIL_COUNT			2
+/*
+ * Some platforms configure suspend watchdogs as low as 25s; cap the
+ * total recovery time well under that so the WEDGED transition and
+ * any teardown that follows still have room to run before it fires.
+ */
+#define ATH10K_RECOVERY_DEADLINE_HZ			(15 * HZ)
 
 struct ath10k;
 

-- 
2.34.1

