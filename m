Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793754658;
	b=Z8tTeNhXYApQU2aSC6jSy9A5pZ4cGELtGOjYbeEjBubDgTzfWNCsXStSQABvhMRbvNRA
	 +9xeicsB8e6tEPV/66Ha3lklgN5I/gBtNlC/KtSdifJgaKfL31NXspXlDiR+tQ1xD6z1S
	 ADe8Ovk61BJq9gcF+02J0dquugz2znSZ6BL0JwuE1peMqW+GoTzR4F60aQH61sSREKfEI
	 p8EUp3zSysSp42KXzs7Nvdr4C0TAalGMmh2Ndje72AKCslhSOpunK12VusfMahrXDS1v/
	 b5gtbGhZdM4ixa7e5fWzXRZ+N5EWCCZ5wJmNuvwRywd5Gyt01vfIwieCJd/NiDcqVQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793754658;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:Date:
	 Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=mOaFG+DBBTxtczIrNwbw/zVuA//yWfNwkVyL7JOIY/0=;
	b=Kris8iIMjxufJNbqSnSpDXy+e7EzPazrCdG93SQMMv88UgLF0Sn3iM2TMQBbPAl8fdTz
	 59GuTf0d2ag4j9j/E/Mk7r2HVlB2EXZ7BRb66eKqAvMQyNbD6RU7m6ErtaogzImZGXyLo
	 wumLR6jSzIv+OKB7xADeumar0Sc25ZvVqqDo4qKYjSkphfjgo5r9G/SQCvjx2vxjRB4C0
	 q6j7RvAwfJ4vlbn4Ori+rxYOJzSH/s7ML7d68ngt+YLHOJgMg+5Sje1pF/a1VFMVt1Y9E
	 d6ZbC6L1OzQfcFwWN61W2Mx7WQiybgbCcfBtqgizch5Bt8eBQlAVnmTbLNWfPXwyl8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=U8T9pzOk;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Vkjd0CyF;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89CC6606D834
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 01:10:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 89CC6606D834
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=U8T9pzOk;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Vkjd0CyF
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A40RGFW3335374
	for <linux-wireless@vger.kernel.org>; Wed, 4 Nov 2026 01:10:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	mOaFG+DBBTxtczIrNwbw/zVuA//yWfNwkVyL7JOIY/0=; b=U8T9pzOk6WCaY0Oc
	8pm3jWsohRx2/wzx+Nj47binhY9OZXIuElGlia8zmUy9S5xYF4O914XqHCYNlfCo
	1xpTlUAkWZGWQIA46fHlq9Z7jz1jYuud+A+ckc7RA57yI2QOM+z4KHW6fx58YWo1
	nwD/RhLQH155AXILAxD6HqmbOG5CZVVjBx9gXf+vtuXlT+Wi4J+EEeLMUHe6TPcw
	q8fwEhgWimGggHB+56WHI2D2Yv6Rf/vCG2gyTsEGeOtSEMR7Eb1Y0VAM00GlP/xF
	utcOoTBOZQscLnAPo7vqrnnuLuojReP22idI7jtvzMPYJsEtNqLHlrd7BmuP7sXU
	/9YnPw==
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hqmjbsf9x-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 01:10:56 +0000 (GMT)
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-33713e5e6daso157182eec.0
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 17:10:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793754655; x=1794359455; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mOaFG+DBBTxtczIrNwbw/zVuA//yWfNwkVyL7JOIY/0=;
        b=Vkjd0CyFvuu8gdJErK3ERs3KNt73ejhfCmgXFGGswOuqrnt4BbKAQ9Z/wpKX5VPG2f
         QxQRgdxyhGdYSMzFDqCWDhiW5SjhlYC4k9aWFON0tNC7+hY3Ygvqgoqrc7gSmD9TC1qj
         VTbZC8CfYOPEH/OepZlfkE8YS8PejfxAlIu5DTCZTsSN6JnTBSiRsfXmeoauucTMZh5H
         9MFkIR0n9rNEWm2j2QWK8wm7ONVDSnCOlnqolUMDZ7/GA9KJ+3TukhRhW8DEjQS1FjVV
         Ce2DUSXShE0TfYfbTlTggsU6sdRjsW+BpYtmnb3a1d6JyfAq6c7WYt/9dLusnXbK3zzY
         iubQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793754655; x=1794359455;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mOaFG+DBBTxtczIrNwbw/zVuA//yWfNwkVyL7JOIY/0=;
        b=CpHua2QNI3JXXY1qaZ9YXPyu0oQWvgJqq6A+EubpyFSXAIl68ox6LtRDNh/YaheKj3
         3a7p6z1jbMvRE6WF9F3VQzC4HdU11zZaEXRTRgyKv20mSEcsCRtY9BGAnxopSX4MB9Zy
         PPJgs5IxwgATdCA3hJzqjShrXFLqi8owhu1Ida/0wCUDijU8FgWBlP4JG3oPjKIaLsV6
         KKt3BIP9Z+8jBSDq60hS1o9blBSN6oM5r5ZYDueMaIMKmbIzQaHXKGya0bFPWo4mVSmj
         aQ+UEgMaxZfevJ/ptaAhZXYX7DZhQ2DCH2JQMq3gXzmMPo0jjBGTCoZ9QsQUYo/U7AKm
         W15Q==
X-Forwarded-Encrypted: i=1; AKwUvByX+zvVc42PWEhiRlm6ChTOjCDQ80XavUuMKN0sH4o6uKC1KnE2fym6cOZYjNAV3av/XqyU7bTil8C6CYVuzg==@vger.kernel.org
X-Gm-Message-State: APuU4Z+XLKHzZNnc7/F1MDqVlnqbSxwuOBW8LT4YO1SvVbX4go0hDuIH
	3C00bHdpgWLR9cDNNsd0pLJebHCgQypL9ekrvld6f5z4GkG/aqGB5dmqtUF+LjrL5dISvFcDEuJ
	PjjZ13P1oLTnk3Edn5LFf83Ph9w2fF3ojmDbhSEvFObFXWQ/t4ZZdpwbJoJ5e139G0JE1Dw==
X-Gm-Gg: AYBFou3p5k1aIo/tpYcU+V/pY+Nemo+AawmItf6CMdwRlQo1q/qEGBASnqyjnEsFj7G
	QSzHL3MNtVuKLNqIaAM7ywg7nWzwnzQiXj+89bsFplR9aKxuI+PLsDw80n1DIAeBaEVKsDzZkCI
	lPP3ca5Uker/uHHh+c73Qo1XJf5L2I3Vq7e2TyabQPX7LXNwrNZClVn+8x7f5yIzDs9IFkYSnnQ
	nv0Mck/BrPY+FXnncId+nSjNzeIncvNjW2G8n8mqobL8nOedWlcUqADFPmcVYFVcYm2Apzj7EVz
	cK8ns46b5L83JWNzIKGezKAeTeQrGazzdYgW294OH3b+hCZ/rt0lO2UYS0PoJcqtp5/M9iof01P
	Evym/Sa8P1OsqeELmkN6jgArx7YVCGA3FxYGsD1E7/9zLloJLQgxDnC7wcLGLvGZ4p3AAlmf2/j
	z+3adbxPVMym5GOgvnR6Oq0QmrY21DoNqA/Z7o
X-Received: by 2002:a05:693c:88c8:10b0:36a:1f:9b74 with SMTP id 5a478bee46e88-36a423bf83emr22051663eec.27.1793754655114;
        Tue, 03 Nov 2026 17:10:55 -0800 (PST)
X-Received: by 2002:a05:693c:88c8:10b0:36a:1f:9b74 with SMTP id 5a478bee46e88-36a423bf83emr22051635eec.27.1793754654362;
        Tue, 03 Nov 2026 17:10:54 -0800 (PST)
Received: from ath12k-linux2.qualcomm.com (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36ca38a54ccsm2288670eec.4.2026.11.03.17.10.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 17:10:53 -0800 (PST)
From: Pradeep Kumar Chitrapu <pradeep.chitrapu@oss.qualcomm.com>
Date: Tue, 03 Nov 2026 17:10:51 -0800
Subject: [PATCH ath-next v3 08/13] wifi: ath12k: ng: add batched REO
 command sends
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
Message-Id: <20261103-reo-cmd-b4-posting-v3-8-861adf04b516@oss.qualcomm.com>
References: <20261103-reo-cmd-b4-posting-v3-0-861adf04b516@oss.qualcomm.com>
In-Reply-To: <20261103-reo-cmd-b4-posting-v3-0-861adf04b516@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>, Ripan Deuri <quic_rdeuri@quicinc.com>,
        Pavankumar Nandeshwar <quic_pnandesh@quicinc.com>,
        Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        ath12k-review@oss.qualcomm.com
Cc: Pradeep Kumar Chitrapu <pradeep.chitrapu@oss.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>
X-Mailer: b4 0.16.0
X-Proofpoint-GUID: n85wdL8_MlahuYDDKdffy8UxxLoSXSfa
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA0MDAwNCBTYWx0ZWRfX/BY6LSMsQ+yy
 nhZKST+I11Apk4A6IbABe1iPAe9xsPoRQYJAG3XKTPsGxpRDKhBbUaqZKZdoAhoamp5neh3aNsF
 rerxTWV0GowSgFqSTPxY3XE82vP4jU2rLLDJ+PPtfyBcDqXkaJnX7tnP4TGarvdNWTXQjDyvg35
 FH7BEP4SqkSNlETIuzVfa0fO34nJAHAAncN1RnpNXBoVQRZ5BHgan6g3Ri8oHim9J5hW14A+3Mb
 BuhxNh+DDnz6ISy7LEuVfvOcapfWq3wFN0kHXyF9+QIc7oTmSl8h35U0g9nPB4Z55Un9hMGUbds
 /nP40Ixew4CALzgJkw7BZhrJ+78fOQlwTohnbVOe/e38m2ERidudp/4gxHgP+la7gqLYanmxIfq
 tdZ2D3zrt+d2YTJSvcwCA1WiECxM4YwuNgL3lCTPPt+QyeeYINGgcRWqYflYIdepgYIb7cMRtDA
 ekCdJDDyxr7xlXBZSaQ==
X-Proofpoint-ORIG-GUID: n85wdL8_MlahuYDDKdffy8UxxLoSXSfa
X-Authority-Analysis: v=2.4 cv=NMhAaE6g c=1 sm=1 tr=0 ts=6aea8620 cx=c_pps
 a=cFYjgdjTJScbgFmBucgdfQ==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=EUspDBNiAAAA:8 a=CnFql80LsPCNzfZI1G4A:9 a=QEXdDO2ut3YA:10
 a=scEy_gLbYbu1JhEsrz4S:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA0MDAwNCBTYWx0ZWRfX+K+XgtrJnKju
 gcTz7Fe+jfFlcBD/sJVuuw5hk7zQkIC0ETMCC4sUmyukaP6nfDVVmSzHQEOHqgYquTVHJWomc4s
 4Fx2qCAtiU986HwBepYp+/D9PPcDIzo=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-04_01,2026-11-03_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 lowpriorityscore=0 clxscore=1011
 impostorscore=0 suspectscore=0 phishscore=0 adultscore=0 malwarescore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611040004

RX TID setup needs to send related REO operations together so hardware
sees a consistent queue state and the driver can keep one pending-command
view for the whole operation.

Add Wi-Fi 8 helpers to submit multiple REO commands to one command ring
while reusing the existing pending-command callback tracking. Share the
HAL descriptor formatter between the batch and single-command paths.

Reject batched flush-cache commands that request delayed blocking
because those commands mutate the shared REO block-resource state. If
descriptor formatting fails after reserving entries, restore the source
ring pointers before exposing stale descriptors to hardware; keep the
same rollback behavior for the single-command path.

Tested-on: Compilation only, M=drivers/net/wireless/ath/ath12k
Signed-off-by: Pradeep Kumar Chitrapu <pradeep.chitrapu@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/hal.h          |   6 +
 drivers/net/wireless/ath/ath12k/wifi8/dp_rx.c  | 184 ++++++++++++++++++++++---
 drivers/net/wireless/ath/ath12k/wifi8/dp_rx.h  |  12 ++
 drivers/net/wireless/ath/ath12k/wifi8/hal_rx.c | 138 +++++++++++++++----
 drivers/net/wireless/ath/ath12k/wifi8/hal_rx.h |   9 ++
 5 files changed, 297 insertions(+), 52 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/hal.h b/drivers/net/wireless/ath/ath12k/hal.h
index 6534e11a3378..b4da48af5a4b 100644
--- a/drivers/net/wireless/ath/ath12k/hal.h
+++ b/drivers/net/wireless/ath/ath12k/hal.h
@@ -1141,6 +1141,12 @@ struct ath12k_hal_reo_cmd {
 	u8 pn_127_48_info;
 };
 
+struct ath12k_reo_cmd_entry {
+	enum hal_reo_cmd_type type;
+	struct ath12k_hal_reo_cmd cmd;
+	int cmd_num;
+};
+
 enum hal_pn_type {
 	HAL_PN_TYPE_NONE,
 	HAL_PN_TYPE_WPA,
diff --git a/drivers/net/wireless/ath/ath12k/wifi8/dp_rx.c b/drivers/net/wireless/ath/ath12k/wifi8/dp_rx.c
index 632ce30fe459..14117430c43b 100644
--- a/drivers/net/wireless/ath/ath12k/wifi8/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi8/dp_rx.c
@@ -50,6 +50,73 @@ ath12k_wifi8_get_sw_desc(struct ath12k_dp *dp, const struct hal_reo_dest_ring *d
 	return ath12k_dp_get_rx_desc(dp, cookie);
 }
 
+static inline bool ath12k_wifi8_dp_reo_cmd_shutdown(struct ath12k_base *ab)
+{
+	struct ath12k_dp *dp = ath12k_ab_to_dp(ab);
+	struct ath12k_dp *central_dp = ath12k_get_central_dp(dp);
+	struct ath12k_base *central_ab = central_dp->ab;
+
+	return test_bit(ATH12K_FLAG_CRASH_FLUSH, &central_ab->dev_flags) ||
+	       test_bit(ATH12K_FLAG_RECOVERY, &central_ab->dev_flags);
+}
+
+static int ath12k_wifi8_dp_reo_cmd_prepare(struct ath12k_dp_rx_reo_cmd **dp_cmd,
+					   void *data, size_t len,
+					   void (*cb)(struct ath12k_dp *dp,
+						      void *ctx,
+						      struct hal_reo_status *status))
+{
+	if (!cb) {
+		*dp_cmd = NULL;
+		return 0;
+	}
+
+	if (WARN_ON(len > sizeof((*dp_cmd)->u)))
+		return -EINVAL;
+
+	if (WARN_ON(len && !data))
+		return -EINVAL;
+
+	*dp_cmd = kzalloc_obj(struct ath12k_dp_rx_reo_cmd, GFP_ATOMIC);
+	if (!*dp_cmd)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&(*dp_cmd)->list);
+	if (len)
+		memcpy(&(*dp_cmd)->u, data, len);
+	(*dp_cmd)->handler = cb;
+
+	return 0;
+}
+
+static void ath12k_wifi8_dp_reo_cmd_queue_locked(struct ath12k_dp *dp,
+						 struct ath12k_dp_rx_reo_cmd *dp_cmd,
+						 int cmd_num)
+{
+	if (!dp_cmd)
+		return;
+
+	lockdep_assert_held(&dp->reo_cmd_lock);
+
+	dp_cmd->cmd_num = cmd_num;
+	list_add_tail(&dp_cmd->list, &dp->reo_cmd_list);
+}
+
+static int ath12k_wifi8_dp_reo_cmd_validate_batch(struct ath12k_reo_cmd_entry *cmds,
+						  int n)
+{
+	int i;
+
+	for (i = 0; i < n; i++) {
+		if (!(cmds[i].cmd.flag & HAL_REO_CMD_FLG_FLUSH_BLOCK_LATER))
+			continue;
+
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static int ath12k_wifi8_dp_reo_cmd_send_ring(struct ath12k_base *ab,
 					     struct hal_srng *cmd_ring,
 					     void *data, size_t len,
@@ -63,25 +130,14 @@ static int ath12k_wifi8_dp_reo_cmd_send_ring(struct ath12k_base *ab,
 	int cmd_num;
 	struct ath12k_dp *central_dp = ath12k_get_central_dp(dp);
 	struct ath12k_base *central_ab = central_dp->ab;
+	int ret;
 
-	if (test_bit(ATH12K_FLAG_CRASH_FLUSH, &central_ab->dev_flags) ||
-	    test_bit(ATH12K_FLAG_RECOVERY, &central_ab->dev_flags))
+	if (ath12k_wifi8_dp_reo_cmd_shutdown(ab))
 		return -ESHUTDOWN;
 
-	if (!cb) {
-		dp_cmd = NULL;
-	} else {
-		if (WARN_ON(len > sizeof(dp_cmd->u)))
-			return -EINVAL;
-
-		dp_cmd = kzalloc_obj(*dp_cmd, GFP_ATOMIC);
-		if (!dp_cmd)
-			return -ENOMEM;
-
-		INIT_LIST_HEAD(&dp_cmd->list);
-		memcpy(&dp_cmd->u, data, len);
-		dp_cmd->handler = cb;
-	}
+	ret = ath12k_wifi8_dp_reo_cmd_prepare(&dp_cmd, data, len, cb);
+	if (ret)
+		return ret;
 
 	cmd_num = ath12k_wifi8_hal_reo_cmd_send(central_ab, cmd_ring, type, cmd);
 	if (cmd_num < 0) {
@@ -97,15 +153,82 @@ static int ath12k_wifi8_dp_reo_cmd_send_ring(struct ath12k_base *ab,
 	if (!dp_cmd)
 		return 0;
 
-	dp_cmd->cmd_num = cmd_num;
-
 	spin_lock_bh(&central_dp->reo_cmd_lock);
-	list_add_tail(&dp_cmd->list, &central_dp->reo_cmd_list);
+	ath12k_wifi8_dp_reo_cmd_queue_locked(central_dp, dp_cmd, cmd_num);
 	spin_unlock_bh(&central_dp->reo_cmd_lock);
 
 	return 0;
 }
 
+static int
+ath12k_wifi8_dp_reo_cmd_send_ring_n(struct ath12k_base *ab,
+				    struct hal_srng *cmd_ring,
+				    struct ath12k_reo_cmd_entry *entries,
+				    struct ath12k_reo_dp_cmd_desc *dp_descs,
+				    int n)
+{
+	struct ath12k_dp *dp = ath12k_ab_to_dp(ab);
+	struct ath12k_dp *central_dp = ath12k_get_central_dp(dp);
+	struct ath12k_base *central_ab = central_dp->ab;
+	struct ath12k_dp_rx_reo_cmd **dp_cmds;
+	int i, ret;
+
+	if (WARN_ON(n <= 0))
+		return -EINVAL;
+
+	if (WARN_ON(!entries || !dp_descs))
+		return -EINVAL;
+
+	if (ath12k_wifi8_dp_reo_cmd_shutdown(ab))
+		return -ESHUTDOWN;
+
+	ret = ath12k_wifi8_dp_reo_cmd_validate_batch(entries, n);
+	if (ret)
+		return ret;
+
+	dp_cmds = kcalloc(n, sizeof(*dp_cmds), GFP_ATOMIC);
+	if (!dp_cmds)
+		return -ENOMEM;
+
+	for (i = 0; i < n; i++) {
+		ret = ath12k_wifi8_dp_reo_cmd_prepare(&dp_cmds[i],
+						      dp_descs[i].data,
+						      dp_descs[i].len,
+						      dp_descs[i].cb);
+		if (ret)
+			goto err_free;
+	}
+
+	spin_lock_bh(&cmd_ring->lock);
+	ath12k_hal_srng_access_begin(central_ab, cmd_ring);
+
+	ret = ath12k_wifi8_hal_reo_cmd_send_n_locked(central_ab, cmd_ring,
+						     entries, n);
+	if (!ret) {
+		spin_lock_bh(&central_dp->reo_cmd_lock);
+		for (i = 0; i < n; i++)
+			ath12k_wifi8_dp_reo_cmd_queue_locked(central_dp, dp_cmds[i],
+							     entries[i].cmd_num);
+		spin_unlock_bh(&central_dp->reo_cmd_lock);
+	}
+
+	ath12k_hal_srng_access_end(central_ab, cmd_ring);
+	spin_unlock_bh(&cmd_ring->lock);
+
+	if (ret)
+		goto err_free;
+
+	kfree(dp_cmds);
+	return 0;
+
+err_free:
+	for (i = 0; i < n; i++)
+		kfree(dp_cmds[i]);
+	kfree(dp_cmds);
+
+	return ret;
+}
+
 int ath12k_wifi8_dp_reo_cmd_send(struct ath12k_base *ab,
 				 void *data, size_t len,
 				 enum hal_reo_cmd_type type,
@@ -116,8 +239,9 @@ int ath12k_wifi8_dp_reo_cmd_send(struct ath12k_base *ab,
 	struct ath12k_dp *dp = ath12k_ab_to_dp(ab);
 	struct ath12k_dp *central_dp = ath12k_get_central_dp(dp);
 	struct hal_srng *cmd_ring;
+	u32 ring_id = central_dp->reo_cmd_ring.ring_id;
 
-	cmd_ring = &central_dp->ab->hal.srng_list[central_dp->reo_cmd_ring.ring_id];
+	cmd_ring = &central_dp->ab->hal.srng_list[ring_id];
 
 	return ath12k_wifi8_dp_reo_cmd_send_ring(ab, cmd_ring, data, len,
 						 type, cmd, cb);
@@ -134,15 +258,31 @@ int ath12k_wifi8_dp_reo_cmd_send_highprio(struct ath12k_base *ab,
 	struct ath12k_dp *central_dp = ath12k_get_central_dp(dp);
 	struct ath12k_dp_wifi8 *dp_wifi8 = ath12k_get_dp_wifi8(central_dp);
 	struct hal_srng *cmd_ring;
-	u32 ring_id;
+	u32 ring_id = dp_wifi8->reo_high_prio_cmd_ring.ring_id;
 
-	ring_id = dp_wifi8->reo_high_prio_cmd_ring.ring_id;
 	cmd_ring = &central_dp->ab->hal.srng_list[ring_id];
 
 	return ath12k_wifi8_dp_reo_cmd_send_ring(ab, cmd_ring, data, len,
 						 type, cmd, cb);
 }
 
+int ath12k_wifi8_dp_reo_cmd_send_highprio_n(struct ath12k_base *ab,
+					    struct ath12k_reo_cmd_entry *entries,
+					    struct ath12k_reo_dp_cmd_desc *dp_descs,
+					    int n)
+{
+	struct ath12k_dp *dp = ath12k_ab_to_dp(ab);
+	struct ath12k_dp *central_dp = ath12k_get_central_dp(dp);
+	struct ath12k_dp_wifi8 *dp_wifi8 = ath12k_get_dp_wifi8(central_dp);
+	struct hal_srng *cmd_ring;
+	u32 ring_id = dp_wifi8->reo_high_prio_cmd_ring.ring_id;
+
+	cmd_ring = &central_dp->ab->hal.srng_list[ring_id];
+
+	return ath12k_wifi8_dp_reo_cmd_send_ring_n(ab, cmd_ring, entries,
+						   dp_descs, n);
+}
+
 /**
  * ath12k_wifi8_rx_spd_buf_alloc - allocate per-ring SPD scratch-pad arrays
  * @dp_hw_grp_wifi8: Wi-Fi 8 hardware-group private data
diff --git a/drivers/net/wireless/ath/ath12k/wifi8/dp_rx.h b/drivers/net/wireless/ath/ath12k/wifi8/dp_rx.h
index 10940dd92a62..2fb56776adb0 100644
--- a/drivers/net/wireless/ath/ath12k/wifi8/dp_rx.h
+++ b/drivers/net/wireless/ath/ath12k/wifi8/dp_rx.h
@@ -12,6 +12,7 @@
 
 struct ath12k_dp_hw_group_wifi8;
 struct hal_reo_status;
+struct ath12k_reo_cmd_entry;
 
 struct hal_rx_mpdu_desc_info {
 	union {
@@ -159,6 +160,17 @@ int ath12k_wifi8_dp_reo_cmd_send_highprio(struct ath12k_base *ab,
 					  struct ath12k_hal_reo_cmd *cmd,
 					  void (*cb)(struct ath12k_dp *dp, void *ctx,
 						     struct hal_reo_status *status));
+struct ath12k_reo_dp_cmd_desc {
+	void *data;
+	size_t len;
+	void (*cb)(struct ath12k_dp *dp, void *ctx,
+		   struct hal_reo_status *status);
+};
+
+int ath12k_wifi8_dp_reo_cmd_send_highprio_n(struct ath12k_base *ab,
+					    struct ath12k_reo_cmd_entry *entries,
+					    struct ath12k_reo_dp_cmd_desc *dp_descs,
+					    int n);
 int ath12k_wifi8_dp_rx_ring_setup(struct ath12k_base *ab);
 int ath12k_wifi8_dp_rx_ring_free(struct ath12k_base *ab);
 int ath12k_wifi8_dp_rxdma_ring_sel_config_qcn9625(struct ath12k_base *ab);
diff --git a/drivers/net/wireless/ath/ath12k/wifi8/hal_rx.c b/drivers/net/wireless/ath/ath12k/wifi8/hal_rx.c
index d78c178cc70d..12a37c395bb0 100644
--- a/drivers/net/wireless/ath/ath12k/wifi8/hal_rx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi8/hal_rx.c
@@ -536,24 +536,116 @@ static int ath12k_hal_reo_cmd_unblock_cache(struct hal_tlv_64_hdr *tlv,
 	return le16_to_cpu(desc->cmd.reo_cmd_number);
 }
 
-int ath12k_wifi8_hal_reo_cmd_send(struct ath12k_base *ab, struct hal_srng *srng,
-				  enum hal_reo_cmd_type type,
-				  struct ath12k_hal_reo_cmd *cmd)
+static int ath12k_wifi8_hal_reo_cmd_fill(struct ath12k_base *ab,
+					 struct hal_tlv_64_hdr *reo_desc,
+					 enum hal_reo_cmd_type type,
+					 struct ath12k_hal_reo_cmd *cmd)
 {
-	struct hal_tlv_64_hdr *reo_desc;
-	u32 saved_hp, saved_reap_hp;
-	int ret;
-
-	if (type == HAL_REO_CMD_FLUSH_TIMEOUT_LIST) {
+	switch (type) {
+	case HAL_REO_CMD_GET_QUEUE_STATS:
+		return ath12k_wifi8_hal_reo_cmd_queue_stats(reo_desc, cmd);
+	case HAL_REO_CMD_FLUSH_CACHE:
+		return ath12k_wifi8_hal_reo_cmd_flush_cache(&ab->hal, reo_desc,
+							    cmd);
+	case HAL_REO_CMD_UPDATE_RX_QUEUE:
+		return ath12k_wifi8_hal_reo_cmd_update_rx_queue(reo_desc, cmd);
+	case HAL_REO_CMD_FLUSH_QUEUE:
+		return ath12k_hal_reo_cmd_flush_queue(reo_desc, cmd);
+	case HAL_REO_CMD_UNBLOCK_CACHE:
+		return ath12k_hal_reo_cmd_unblock_cache(reo_desc, cmd);
+	case HAL_REO_CMD_FLUSH_TIMEOUT_LIST:
 		ath12k_warn(ab, "Unsupported reo command %d\n", type);
 		return -EOPNOTSUPP;
+	default:
+		ath12k_warn(ab, "Unknown reo command %d\n", type);
+		return -EINVAL;
 	}
+}
 
-	if (type > HAL_REO_CMD_UPDATE_RX_QUEUE) {
-		ath12k_warn(ab, "Unknown reo command %d\n", type);
+int ath12k_wifi8_hal_reo_cmd_send_n_locked(struct ath12k_base *ab,
+					   struct hal_srng *srng,
+					   struct ath12k_reo_cmd_entry *entries,
+					   int n)
+{
+	struct hal_tlv_64_hdr *reo_desc;
+	u32 saved_hp, saved_reap_hp;
+	int i, ret;
+
+	if (WARN_ON(n <= 0))
+		return -EINVAL;
+
+	if (WARN_ON(!entries))
 		return -EINVAL;
+
+	lockdep_assert_held(&srng->lock);
+
+	saved_hp = srng->u.src_ring.hp;
+	saved_reap_hp = srng->u.src_ring.reap_hp;
+
+	for (i = 0; i < n; i++) {
+		reo_desc = ath12k_hal_srng_src_get_next_entry(ab, srng);
+		if (!reo_desc) {
+			ret = -ENOBUFS;
+			goto err_restore_hp;
+		}
+
+		ret = ath12k_wifi8_hal_reo_cmd_fill(ab, reo_desc,
+						    entries[i].type,
+						    &entries[i].cmd);
+		if (ret <= 0) {
+			if (!ret)
+				ret = -EINVAL;
+			goto err_restore_hp;
+		}
+
+		entries[i].cmd_num = ret;
 	}
 
+	return 0;
+
+err_restore_hp:
+	/* Keep batched command submission all-or-nothing. If any descriptor
+	 * cannot be reserved or formatted, roll the source ring pointers back
+	 * so partially prepared entries are not exposed to hardware.
+	 */
+	srng->u.src_ring.hp = saved_hp;
+	srng->u.src_ring.reap_hp = saved_reap_hp;
+
+	return ret;
+}
+
+int ath12k_wifi8_hal_reo_cmd_send_n(struct ath12k_base *ab,
+				    struct hal_srng *srng,
+				    struct ath12k_reo_cmd_entry *entries,
+				    int n)
+{
+	int ret;
+
+	if (WARN_ON(n <= 0))
+		return -EINVAL;
+
+	if (WARN_ON(!entries))
+		return -EINVAL;
+
+	spin_lock_bh(&srng->lock);
+	ath12k_hal_srng_access_begin(ab, srng);
+
+	ret = ath12k_wifi8_hal_reo_cmd_send_n_locked(ab, srng, entries, n);
+
+	ath12k_hal_srng_access_end(ab, srng);
+	spin_unlock_bh(&srng->lock);
+
+	return ret;
+}
+
+int ath12k_wifi8_hal_reo_cmd_send(struct ath12k_base *ab, struct hal_srng *srng,
+				  enum hal_reo_cmd_type type,
+				  struct ath12k_hal_reo_cmd *cmd)
+{
+	struct hal_tlv_64_hdr *reo_desc;
+	u32 saved_hp, saved_reap_hp;
+	int ret;
+
 	spin_lock_bh(&srng->lock);
 
 	ath12k_hal_srng_access_begin(ab, srng);
@@ -566,26 +658,12 @@ int ath12k_wifi8_hal_reo_cmd_send(struct ath12k_base *ab, struct hal_srng *srng,
 		goto out;
 	}
 
-	switch (type) {
-	case HAL_REO_CMD_GET_QUEUE_STATS:
-		ret = ath12k_wifi8_hal_reo_cmd_queue_stats(reo_desc, cmd);
-		break;
-	case HAL_REO_CMD_FLUSH_CACHE:
-		ret = ath12k_wifi8_hal_reo_cmd_flush_cache(&ab->hal, reo_desc,
-							   cmd);
-		break;
-	case HAL_REO_CMD_UPDATE_RX_QUEUE:
-		ret = ath12k_wifi8_hal_reo_cmd_update_rx_queue(reo_desc, cmd);
-		break;
-	case HAL_REO_CMD_FLUSH_QUEUE:
-		ret = ath12k_hal_reo_cmd_flush_queue(reo_desc, cmd);
-		break;
-	case HAL_REO_CMD_UNBLOCK_CACHE:
-		ret = ath12k_hal_reo_cmd_unblock_cache(reo_desc, cmd);
-		break;
-	default:
-		ret = -EINVAL;
-		break;
+	ret = ath12k_wifi8_hal_reo_cmd_fill(ab, reo_desc, type, cmd);
+	if (ret <= 0) {
+		if (!ret)
+			ret = -EINVAL;
+		srng->u.src_ring.hp = saved_hp;
+		srng->u.src_ring.reap_hp = saved_reap_hp;
 	}
 
 out:
diff --git a/drivers/net/wireless/ath/ath12k/wifi8/hal_rx.h b/drivers/net/wireless/ath/ath12k/wifi8/hal_rx.h
index 357839c7d9e3..430b0f07563f 100644
--- a/drivers/net/wireless/ath/ath12k/wifi8/hal_rx.h
+++ b/drivers/net/wireless/ath/ath12k/wifi8/hal_rx.h
@@ -100,6 +100,7 @@ struct ath12k_hal_rx_cmd_ring_param {
 
 struct hal_tlv_64_hdr;
 struct hal_reo_status;
+struct ath12k_reo_cmd_entry;
 
 int
 ath12k_wifi8_hal_invalidate_rx_cache_cmd_send(struct ath12k_base *ab,
@@ -108,6 +109,14 @@ ath12k_wifi8_hal_invalidate_rx_cache_cmd_send(struct ath12k_base *ab,
 int ath12k_wifi8_hal_reo_cmd_send(struct ath12k_base *ab, struct hal_srng *srng,
 				  enum hal_reo_cmd_type type,
 				  struct ath12k_hal_reo_cmd *cmd);
+int ath12k_wifi8_hal_reo_cmd_send_n_locked(struct ath12k_base *ab,
+					   struct hal_srng *srng,
+					   struct ath12k_reo_cmd_entry *entries,
+					   int n);
+int ath12k_wifi8_hal_reo_cmd_send_n(struct ath12k_base *ab,
+				    struct hal_srng *srng,
+				    struct ath12k_reo_cmd_entry *entries,
+				    int n);
 void ath12k_wifi8_hal_reo_hw_setup(struct ath12k_base *ab);
 void ath12k_wifi8_hal_reo_status_queue_stats(struct ath12k_base *ab,
 					     struct hal_tlv_64_hdr *tlv,

-- 
2.43.0

