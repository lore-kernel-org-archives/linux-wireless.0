Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAFBA302146
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 20:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784232099; cv=none; b=qBFNIQ0Q0OSi2UVSPBJ164IJRI8As0cFJ4F0PpWD3I/7J7IENqY0OrRLAcVjAsomIL1Imjb8dY3PX7vcg4UGGsOVJtrFqyhKm29Dn02TUfaj5MEj5+wKuCStFOlWQbW9qkGeC/jMUDjGTaPZlPCnjF/cVHOmBG+GS7WGCy99bvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784232099; c=relaxed/simple;
	bh=AfgwtvLUNhoN8yxW0/rij6cUaoJlxhV+qfVXjrqYeyk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=Gt9BxiM12IzC1LgF67m2xI7HgEpqKsNP4q8nYzzOOyxGY43sw0eMjbCFoaQgLzYMeAJNxWbtERwGU37WI0/5RiE8dcI8nMmxCFOtlgUoNctVOQIULcpm/9fwvaNJxEtZjzRDihsSDlYrGe1oaEUpRf/lZgjHW8LLiwkqLFHxs3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=RCABxmpk; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=NF4O5A6H; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="RCABxmpk";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="NF4O5A6H"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66GJoOOk3753225
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 20:01:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=LJYuXI+l3H92FDVQZkdHpw
	i60M9fwa1cK5EJ/lFjmIA=; b=RCABxmpkxGxT2TEx6LfSYotaaCzJolgaG/ZtKL
	GcyYmgHfQH/8Eb+JJCpL+Cqr6M57URfwVO0a08ECyVjLuurLNOz7MmKwoNnlE8/f
	sOUAxGbO7Q+CF6uCSnVe6WUcA2l3O9M8HP+Jw/YXSi3Oach+sZ6KFsDLAuSH1smV
	M6qJ+kQE2DGLuKhsaV1gZuOjV3JVUwtFk/auIDf7ZcKWV/wr5oALnyDTEjSB1Ks+
	jYVEiBdYgJeWTl1ecNg6cAZWmLNCO0vZFPFp6+z/2nOkCOSPBZ3WR7S7OlE6OkNG
	DoU2eReRsuHmUMbPqyFqYv5+OiKdnU6/iFxr+WnQoajgPkEw==
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4feuex33rp-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 20:01:36 +0000 (GMT)
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-c88aab7c1fcso16602941a12.3
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 13:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784232096; x=1784836896; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=LJYuXI+l3H92FDVQZkdHpwi60M9fwa1cK5EJ/lFjmIA=;
        b=NF4O5A6HCHewy9BPdRchPN0PArawDr+RSizkcnFOwYju35zOXddWG03AZnmjBDCR9J
         Ldj5D8KUG7450VCKZq06q7WCDIo89irIjAoKbN/84khz6KYI7CNv3zMlCJ24S6IbDl79
         v6p8TN0ExzNoNFy2rI0D5BD0qjtPfEv7TLdssOcamfjbn+aH8rfxLnofrozdffhAZ4FZ
         K6QsCP27PntV2rACd+lJA9o2e7569RYMGZOYAr86gfsa0AFvoGZQzPzKJ2SFgjAocJEU
         Ag9ym9C9FYjzhbBsaAOt8i41g0TaCzpGjKalT4MbiTIOt/2lWi+wXHQepMfFd/ZUzEbl
         jOpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784232096; x=1784836896;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=LJYuXI+l3H92FDVQZkdHpwi60M9fwa1cK5EJ/lFjmIA=;
        b=Y7SrS1NSksFuoN+akIuf5+EEyAIgZfIl6GB/JPzyoaFZmxLLeKMhXCh6dGPVkaBSis
         BDJQa+HxYhCanucspJIIyz3Pxm/DDgo7vvatE+1iismj6ARsgVqpXfPJjeoI78hHj5SU
         BAz1Yo6SJMCY3ACyYt0VI9VT6RxZUre1VYleRGJN2LCYANHcfHlcjBSIOM8oi3d6bdTU
         xFYGvpendmLHNUeeKQKSXaDtuWU0hSnFm68T5JWZY66kTHbjnw9MYs1ATJGimr45wNgQ
         u/woFMQsGEjE8rkgW6tlp67n/X2Pn6m2gB2U3MyU56EQBL7nGPS3Rmo2vITl7r5zOH5K
         5SYw==
X-Gm-Message-State: AOJu0YxgVZRZEOsu6SYEHy3NQObsdQ4irl6rFf3bZ4FNiYLdm1n7bOlL
	4v3kdv83gSCEcCXH3uDmw1PEHIE6Hism+fqXqyCK+EY5CW4F9da/UWWK+TmhKDBnSwk1dpDEJeZ
	XnWH4tJeU/lxiFKCqbblyA9EMKwSBJXyprBcl5ynTRa5VCu6V93F1wfnhqGekFFD6GK3OIw==
X-Gm-Gg: AfdE7cmmdvtA1xGABmAy7rif0Swl4lI/kE1MNspYNouFAL2caRzwxuNTeCerJHyWdi0
	fQNgQEQvYCCAzWwhAfgtnr7DDkiTBqooTbnYuvw236KZuv8pVK5nHtsxKYS3cyIn2cdYHUBKkwX
	qI7Uq5CFyZT32ewq4TEKoRHwhxVKrGNJsirIi0WTikHOLeU0GMTvnszXyLqRrv9X0lWNKueuLEf
	CiPYUoIN6EghDIQ2mYZT8cHwCPhw8UbwKA2Kbt0WL6DJx7Ud3V0E52AjeSmlNzZw8gz77l17Bkz
	h7DCdPzM7PpqI272A6HdBXcZOOVxfzXVc9lW1uV1ycM+c6nicVpaRrVLnTaRvnnZmD7+Y1eFaBV
	YvjKTmg7v2fcS4pliOBCf5vrRZGL7eSEAO9FVHU8Xzt36LR+5+tujfC8=
X-Received: by 2002:a05:6a21:4882:b0:3c3:7cf0:3874 with SMTP id adf61e73a8af0-3c37cf06741mr6718743637.7.1784232095452;
        Thu, 16 Jul 2026 13:01:35 -0700 (PDT)
X-Received: by 2002:a05:6a21:4882:b0:3c3:7cf0:3874 with SMTP id adf61e73a8af0-3c37cf06741mr6718708637.7.1784232094986;
        Thu, 16 Jul 2026 13:01:34 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3140e6ec32bsm11998196eec.29.2026.07.16.13.01.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2026 13:01:34 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Date: Thu, 16 Jul 2026 13:01:31 -0700
Subject: [PATCH ath-next] wifi: ath11k: Avoid buffer overread in
 ath11k_wmi_tlv_op_rx()
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260716-ath11k_wmi_tlv_op_rx-overread-v1-1-0b972b3f1368@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIAJo4WWoC/42NUQ6CMBBEr0L225IuFjB+eQ9DmgqLbBSKba0Yw
 t1tOIE/k0xe5s0KnhyTh3O2gqPInu2UCh4yaAcz3UlwlzoUsqhkjaUwYUB86M/IOjyjtrN2i7C
 RnCPTCUKpjDRl1aKE5Jgd9bzs/iukqZhoCdAkMrAP1n3344g7//MjokChZHEzvTrW6oQX633+e
 ptna8cxTwHNtm0/+YW1edsAAAA=
X-Change-ID: 20260715-ath11k_wmi_tlv_op_rx-overread-e104a0a56c10
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Authority-Analysis: v=2.4 cv=JeeMa0KV c=1 sm=1 tr=0 ts=6a5938a0 cx=c_pps
 a=Qgeoaf8Lrialg5Z894R3/Q==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=Tx--mz5Y_93-EySAq90A:9 a=QEXdDO2ut3YA:10
 a=x9snwWr2DeNwDh03kgHS:22
X-Proofpoint-ORIG-GUID: XmtRu4yYjm4DcZcZTMBTl4OxwGgaGqAH
X-Proofpoint-GUID: XmtRu4yYjm4DcZcZTMBTl4OxwGgaGqAH
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE2MDIwNCBTYWx0ZWRfX7eNGFpO/b+RU
 paIJk1fend5BKvcVM+7MMmuP1fg7aXAHLqmY0o8jyPkk6FyAXOWDhQLNiQy5jT1OPHVFvdtWqRa
 M291LcS4BspI8dwQBj0U6gGCuaz6LT0=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE2MDIwNCBTYWx0ZWRfX6WiNeoXdrBRK
 417mzTA8Xy7lzm/Qkt6ffjQ0RxXKTI+itBGdwwlHd+qOGQuxjxtDIhmqU6NdDGpJLr6tQEB7wwr
 JVu8KbNc/spzjG1jhNWguMgEv7vdE+so/Hkk8oFxOh1CFJ9AgPyT5FJLd2fBKBc33BaEUK0LEnK
 FfHoapgjr0SWkjcoXVoa+PhbtLozhgHLv48NeGT4/lm0oT5XRUt64uGmHRkJYukQn/Knds87H+z
 dE5xtIjm7fRqHbYaEgoW+spceod+MP1b+Dxk6wP+Fomdairl7cb4ppkzNd6upO83hi8JjjBEmpA
 3tcfNzlCtUcUuEmq8JIlSh3gTTbsKFKlisE9+KGlRwIuVDDnj6RSKzLE75nwaHLXIHDNRVJ/VCB
 cYuHjIffiZUcv4d7Bx3VWjQ4VKNaWcxbhJuar6kAWRNPnXaBMjkw0RkR7iRg0VDR8O9u0QJ0OYH
 q3ciIu4JdpY2OfiRQbA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-16_07,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 clxscore=1015 suspectscore=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 malwarescore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607160204

Currently, in ath11k_wmi_tlv_op_rx(), the firmware buffer is read
without first verifying that the buffer has enough data to hold a
header. This could result in a buffer overread.

Add an upfront length check before dereferencing skb->data as a
wmi_cmd_hdr. The check is placed before the trace_ath11k_wmi_event()
call to preserve the existing trace semantics (tracing the full raw
WMI event including the header), unlike the analogous ath12k fix which
could use skb_pull_data() directly.

Compile tested only.

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath11k/wmi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index dca6e011cc40..b10f0054c81e 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -8895,13 +8895,15 @@ static void ath11k_wmi_tlv_op_rx(struct ath11k_base *ab, struct sk_buff *skb)
 	struct wmi_cmd_hdr *cmd_hdr;
 	enum wmi_tlv_event_id id;
 
+	if (skb->len < sizeof(*cmd_hdr))
+		goto out;
+
 	cmd_hdr = (struct wmi_cmd_hdr *)skb->data;
 	id = FIELD_GET(WMI_CMD_HDR_CMD_ID, (cmd_hdr->cmd_id));
 
 	trace_ath11k_wmi_event(ab, id, skb->data, skb->len);
 
-	if (skb_pull(skb, sizeof(struct wmi_cmd_hdr)) == NULL)
-		goto out;
+	skb_pull(skb, sizeof(*cmd_hdr));
 
 	switch (id) {
 		/* Process all the WMI events here */

---
base-commit: 0ceb105245b5e57f803bdc0e79dc077fc06ff384
change-id: 20260715-ath11k_wmi_tlv_op_rx-overread-e104a0a56c10

