Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4085D545D84
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 14:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791988671; cv=none; b=hvlnG7zd2aA2dEzJQ8/cvjQsjlP/sjk9vp4QI8PaynOUjLyr6P08XY/qBo4TfxCiRQhN0XnF2852SLWDTvqvR61XwWv9BlV74nvxJCyuBiFjRUlFgeEVcJCBq4ZtUmLlo/UPc9YJh+1NSK+KxYPNzXPo/1qefolZ+3XyhNFQhbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791988671; c=relaxed/simple;
	bh=NIcN1IfAsE3TfzX1Q1mzQZgyutoBSSsfG3MHQhtKahQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=mrskcRSEYz9+5QUuGN1eYimbDNniBLNlXdGVSKj8YMdkLpopDF+qphC8joGjMSPV4rxLI3qFAKuGuaQdnuUsvFqhfGWl6wOpc9okVigpvULG//W7fywuWXGgqJqEArjFZewTBTvro/5B0HljpsEOcws2Z8gfWsgU7fVncgK20Zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=l1xBmcj5; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=gJCAcFX7; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="l1xBmcj5";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="gJCAcFX7"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69EEbANf1583041
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 14:37:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=48UTdyStSoWwcRatCEHEW0
	9klzZq2SDB4NjKSce2Axg=; b=l1xBmcj5C5zVpisYBWLNQMbsiKVFop+935YX5e
	jTbhQ75Ueup5jc9dhGKaziuw8G+HNgZPS8CH8nWUkknbbZJaEdHdJTU2aBYKHB+5
	yZdHG9CtJLGmxnmhHkRlj+ransYhnGLt/JWIY0WBKNgxjb0Qni7lMKRE8hTpOuTp
	6zfT8ursxBVPRx4rpbYLJ0eyM1CAmHN0B/kLFPwQ9IoRwyBzf7xYvB8RQiwelfre
	LZuDFtBCRjFmPTJxwivV9MXnqNRFPiZ2ssNmIpUMypNI24kO6xUCQC1HLBWp1hb3
	Ovx9pmcGugxxSEj1qXia0JMeb069+LDxugOUCz+1kP4mMZFg==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4h9s2b4tk4-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 14:37:49 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-93ae8e7e546so893742385a.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 07:37:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1791988668; x=1792593468; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=48UTdyStSoWwcRatCEHEW09klzZq2SDB4NjKSce2Axg=;
        b=gJCAcFX7GOP5jH2C4QxwFBGp8JE9jj+0wsfzTshAOQXRjDuRGn/o+C5v8CiUHKEwqi
         vBC9c05OvNU+IOI/ltXIxH/hI+2fV6nfgyxaXxxmZ4tN8IiiKoXMp6lucG8GKoO2Kos0
         RjraHqE8gyjFPO8ldznqqNkQUy/jQ+qsd2Q4ynfoUmaqSN3gkVdJmCwsTgX5a6YK+uRn
         0PypQr8EdxEdEPphCCskYQ1I+gdiOrY8QURVMYgJ4LgllpZGDV7Im72QpfhJCpuilg++
         xe4VIoWnM8ChQQ5QOFmlMnqc6I+HH+KepWYtNXq5GhIMXyxuaP8wx7FhFhHaunMy8qPJ
         HD8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791988668; x=1792593468;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=48UTdyStSoWwcRatCEHEW09klzZq2SDB4NjKSce2Axg=;
        b=OfZ0XQ7Ie/DGjH4KbZcYc998oiDmcMBVawiaU8DdV1EO2OsGhXIYU5PqkMq/hPJj78
         sltL6RNnHmNAdaNgvL2qK6Rc2d3wppCa+kTThWK3C0W9nj2HGX8oJvS3bx9b0lB6z/OH
         i0UWyWIw4+JLc7doUzolXSRqS+A9IiJRCAZRAJHZ3Wowq5mCKf60p8CsO/82mYLPLCTw
         lYLjsUPzuJdoo4LVacu1VwcXlDZhNsmfzN06QvSpX4csbKIkXMl9TYTZLZErFuvUz5Kc
         VLRIoyOgUwOByo55sInfC70grnI9MyUo04GiBmtYpKF8gb437bpCW09ag2b9v7LmWbHG
         aunQ==
X-Gm-Message-State: AFq9FYJ6QEHLDMpe8ccysjdI4LywRhTdKl5RrX8kkTlNvYU8vnazhrgO
	3scmzCUVKqpLi/jckWqKKsohMXAVITMoUAREx9OQ3d6WJJuuhAx6Qgsg3a9uUG0JspAdQnJDjFe
	q60uLRbFdtuHjlzATBeTr9uaqR44pA6yV5GpHl/kNrY7aR2krCCyQRe3Fh8HstJMrjI+kTw==
X-Gm-Gg: AYBFou3ZLO3L3Kpni0/d92veRkvvYHscp0ermfxKRybi7nYOFFGqu3s2f9pWB7ga1cE
	QjvlXjEplByDtExuJfCmzLlA5MXhx/oDFMovFL6f1b9HmtpygoPPPOF3EmvJQ2UhV3pT6rMylXl
	tOzyl6DHPUupQCjX+JydLLEHC/3mTNS/WIRnzI+BIJGrZugi9Z/uKKxztChqVJRSWixKddfi5vj
	nvy1wgqrnpJBQPyri4N2WelSpgbUPnrYYsBSb2Pm4sGWuSLRaE4bIWohQJK2RRO9rP+FZ0XGOVX
	T1e7QUHs0c4h6DC9Dn8LPo1W9NvkOv+AtsQuXUN9KZMiUSEYRSrH+jA4GwgSRYVWt2cRIhYzKIx
	Otfjp2A4VDHVMsA==
X-Received: by 2002:a05:620a:7106:b0:93c:7e9c:3bba with SMTP id af79cd13be357-93ebd24c5c9mr2608256485a.41.1791988668284;
        Wed, 14 Oct 2026 07:37:48 -0700 (PDT)
X-Received: by 2002:a05:620a:7106:b0:93c:7e9c:3bba with SMTP id af79cd13be357-93ebd24c5c9mr2608251685a.41.1791988667589;
        Wed, 14 Oct 2026 07:37:47 -0700 (PDT)
Received: from localhost ([188.216.77.92])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1bcf0d60esm5479325e9.0.2026.10.14.07.37.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 07:37:46 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Date: Wed, 14 Oct 2026 16:37:11 +0200
Subject: [PATCH ath-next] wifi: ath12k: fix datapath lookup in
 ath12k_wifi7_dp_rx_process_err()
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261014-ath12k_wifi7_dp_rx_process_err-fix-lookup-v1-1-4670f8f98589@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x2NWwrDIBAArxL2uwsqwT6uUoqIbpolRWVNWiHk7
 pF+DgMzO1QSpgqPYQehL1fOqYO+DBBmn96EHDuDUcZqpUf066zN4n488dXF4qS5IjlQrY5EcOK
 Gn5yXrWDU3pC6kQ13C71XhLr9v57QM5iorfA6jhMTWI56hQAAAA==
X-Change-ID: 20261014-ath12k_wifi7_dp_rx_process_err-fix-lookup-d1a2e08e6c96
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
        Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Authority-Analysis: v=2.4 cv=RPQmjIi+ c=1 sm=1 tr=0 ts=6acf93bd cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=WpTaRW6qxYHRGzLzQsVYzg==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=Vw7K-8P2kW1omTLmlekA:9 a=QEXdDO2ut3YA:10
 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-GUID: Yc8gMPpCLZ8hoLQ6uiCPXm3U6hk76Pcp
X-Proofpoint-ORIG-GUID: Yc8gMPpCLZ8hoLQ6uiCPXm3U6hk76Pcp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE0MDA1OCBTYWx0ZWRfX+FRvHGD2obt8
 VSc3W/n7HsQKvKKLO5wOm0eiSAQ1ceQsexTtaJ7qrwsAaLMS/I/01iAkxnIm/E1CHFjUvRKRTFh
 EX+J/soI5n3inJzcIfukCbRIPFDmd9INemRD+15hAZjhx04vuenYwUURES4/S8E8rUNt7yhANbd
 y5LZ2z1aSzjMyHpinGBBf3vysDvWS0VLANkL/d+zR8qhtY47GmgIkm+sZO+3iHVuNhVz2q0t1lO
 S52SycZkgu8CO+J+g59Kjmxh34KEBUKFcga6VXwoWo2byloDxumFfHbQz/SDKkpivnkokvoJ8+v
 Slyv10JZxk4w1WQHb8+gj3UFCzs0HSI+v3go4K0Ct11V2R16C44rMKNa7OKKFoR1ksbwrYrdGia
 gug0CSbf+lsyYX8mvv0IfVeZVZnfuSka/az8XzMmMytFkg7NJsbI2i4lcxCmoN4bU4XEwcrlxNt
 5AeI2cRck/2Ev/dkJIQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE0MDA1OCBTYWx0ZWRfX3XjomPTHhrDP
 DS+jfXOPKC4phTZHpDoJnHzBdaJVuOQjibox34mWGsJ5lvjC4vnrayuDt8Eg6wVH1/9apj/vytA
 brOznxmWW97LFEGRfCB4WLvxnPLchIo=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-13_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 priorityscore=1501 clxscore=1015 malwarescore=0
 phishscore=0 impostorscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610140058

ath12k_wifi7_dp_rx_process_err() resolves the per-pdev datapath with
ath12k_dp_to_pdev_dp(dp, pdev_idx), using the local 'dp', while
'pdev_idx' is computed from the owning 'partner_dp'. As dp_pdevs[] is
indexed per ath12k_dp, this picks the wrong pdev when the REO exception
descriptor was sourced by a partner device in a multi-device group.

The error is currently masked by the drop condition that only processes
same-device fragments (partner_dp->device_id == dp->device_id), but it
is still incorrect and would misbehave as soon as that restriction is
relaxed. For this reason do not add a specific 'Fixes' tag to backport
the patch.

Look the pdev datapath up from partner_dp, as already done in the other
Rx processing paths.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
index a32c804403e8..633cb91b9e5d 100644
--- a/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
+++ b/drivers/net/wireless/ath/ath12k/wifi7/dp_rx.c
@@ -1536,7 +1536,7 @@ int ath12k_wifi7_dp_rx_process_err(struct ath12k_dp *dp, struct napi_struct *nap
 
 		rcu_read_lock();
 
-		dp_pdev = ath12k_dp_to_pdev_dp(dp, pdev_idx);
+		dp_pdev = ath12k_dp_to_pdev_dp(partner_dp, pdev_idx);
 		if (!dp_pdev) {
 			rcu_read_unlock();
 			continue;

---
base-commit: cd026e68fdbf88b9cc522b76c7a9d92c9a41f709
change-id: 20261014-ath12k_wifi7_dp_rx_process_err-fix-lookup-d1a2e08e6c96

Best regards,
-- 
Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

