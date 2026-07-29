Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6928C3C1D7D
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 15:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785338797; cv=none; b=hQu58O9I74NbCfH/NkUxMOW77YstIFytzmyhNlIkcAnZ3iNYj1NOeqF9HsDTNn4O20IKDDtONR/LBhrsvBOClbGyr4z6KekHZbOnUjEj8k+LYA3aFcNfj/f1bKKRKd8sMbV5IurBcwGwipx0bZVbyfDdZUczljCZDXVVTkH4mKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785338797; c=relaxed/simple;
	bh=sKzNszAqX0VVzSvbZMWX0RX1ihCY64pCtcvl4yCI5kQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=grp5Jd1u1ZsEwC4a5yMPLIXpqLBv1SVF8cX06Kn3zc06qZbxfkqnSQKxqXYuZ3YFY5ZoOB/jFHT7GHh6yhKAJzGlmBKaFJR5KDk+LDhMZypxY1GmFKpCzZged+fsVGEoxyhhGiaiqmLZ4GWYJ/5QHPBro0D75t5kL9mFZt7UjKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=j0WjjaTp; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=jL7ptfTt; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="j0WjjaTp";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="jL7ptfTt"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66TF2dS12327104
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 15:26:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	R7OCiOhUvbS8MmL9dYvzzL3m6qD2Zu/mwC+MTVmjD4g=; b=j0WjjaTpS+tOMc7j
	me0QeQjyiUzB7d1Z84iSuBb19qsVMR0jnT1j8kA5e7IOh41NfpsUES27gsrinPBg
	PAqYS/ICmSpLe5qP+0YNhF51a9HKWtiVueCmtH7ilhi4GKbcs14Ojq1eO/Ph6kxW
	VKDXhGHYGMZ40wmO+mD0Yk7Z8kdGCnXjLQpp5B/u/cEqlVLfDffuuTpyR0h1G7tO
	APuTGtT4bZSqBVXrJfEy2M04OVs4OoGDKOlPk0cm5SOvoI18FdPjsDUBKgTQ6in0
	0pJIV9sXDRCdnrW+YCv06MS0IgE9oSqA1M4gJp1gyPu9ipRQvXzWhbMEehKtGd3b
	j3bBqw==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fqgrch2py-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 15:26:31 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38827cee19eso1396502a91.3
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 08:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785338791; x=1785943591; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=R7OCiOhUvbS8MmL9dYvzzL3m6qD2Zu/mwC+MTVmjD4g=;
        b=jL7ptfTtVHpVLtisRwm1/Uy3Dmxzi9kVgNepNmrLbZZX2rg1umzUT5vSUpfveorjLL
         UNh023NOmKJwPyaOFC0BC6A9hNyeKoKuFrVzUj7QKISGA0GovUXD3fZnLdQiiKLKzfnJ
         EpOdmVE+/T3FZNjKXwS6H8moHf++HrtHEZ4neD9Ig1DMcx0IdJkYEZxH27wpI6ghplAs
         gSNhTF/pUq7eZSqaik4DMUUYFnvG+fAUzE7iHGkSZckCqW41NHBxF/D0K95UHubjtUlc
         dSxGuanZRbCRcurr9waek6Q6djCP1RH/2QuJ/0KSB67esDLsEGLrCZKTeGsClqMZKoKQ
         RPJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785338791; x=1785943591;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=R7OCiOhUvbS8MmL9dYvzzL3m6qD2Zu/mwC+MTVmjD4g=;
        b=bNS9Ot1ZRGE/eG2RKvXviYJIUCMrE20i4JDM6xNm7c1flQLSyKH67lvLdBbmQTjMOV
         vNdN2aMcjPXe5j00l6sCfH58rxHOBsW5GHESsA0jZ8XFa5Xo1fBLokCAQL/zkL2PEhpV
         RfcUhkGSDKfaQQD36YKy5G0LSSY00Vv66l8/I81R7mFDo9wgiOuWm/R/6sJcO8zW4UFt
         OIy/QKPTkCoHlNu09lezOt1v16no8ZNFgdBuB3V0GLNxVHaF9V5xXQJmDddqroVzMMZK
         7lqIp28vjtXUotFI5edSNJ1BWsRhHaEzYDWO3AActqOwPQej3Va0VF+/yEUoyV03RLSs
         vKQA==
X-Forwarded-Encrypted: i=1; AHgh+Row6CNkCYsxmGCMFCsiL2xv5wA6DOWTKkD2s/RO+JhuLu4os+2PtEPX1W3kCtP8tHXlIW8hkxKne/xQUdNw1Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YwkvGiKwVImh4i6or5cDEuc1W3d5mgnC7ucGWmfAvGodQtBr55t
	JP+mRHq+ZJmN10k34XA2rYjFhNTToNC+lHD5ycC6RGvXMEpxT2fW00dddIRjdOasIAhVrBIMMWN
	yeQ7lzG67Qh5mx5b2RftB25NxAoNyX5fo/frSvUHv/h8x9aGtmFiRB3Ry8EmICDKnWs0Dsw==
X-Gm-Gg: AR+sD12ygw1rTvJEqlNcZNKYHYaTrbcb62aQ//ZjWyjcg4/xErfGNgUkKImF9uXTkcl
	hEfmcJ9Zz8Kk6HbRxFuv2GI4i/IM7HVhmVz1/3EHb0ImRON2eyvXMHG/qZPA4ByY6jmMSADh2JV
	5XZ8OHBWjRIjihKP5o1zN2szDgFWYmgkjsO/tMWO60uoKk9SIsDIcdHRpjbTcuRU+LRQnribmAW
	9o4XEIQfCA8/MwmWCt62zo3+ohhLFayvwa/5gyWAbWlVAfWBwh1X/UImXOA0o7JTDy6i2CbNhkp
	Nyp3ySQrrdULE1DLFJRa7zJLb7FzY2Tf5OOKQr3vBUPfCjYsOjP/qb969qiRti7cb4fc9TSHDUW
	t3AZWC3+mm6o3SB85gSdkqPpUlHz3bBuE5gHUj0og0vd2ldXJ73FF3gM=
X-Received: by 2002:a17:90b:5146:b0:38d:3ca9:434 with SMTP id 98e67ed59e1d1-38f6a426f70mr7781895a91.28.1785338790932;
        Wed, 29 Jul 2026 08:26:30 -0700 (PDT)
X-Received: by 2002:a17:90b:5146:b0:38d:3ca9:434 with SMTP id 98e67ed59e1d1-38f6a426f70mr7781857a91.28.1785338790523;
        Wed, 29 Jul 2026 08:26:30 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31504d480c5sm18005300eec.25.2026.07.29.08.26.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 08:26:29 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Date: Wed, 29 Jul 2026 08:26:26 -0700
Subject: [PATCH ath-next 2/2] wifi: ath11k: fix stride mismatch in
 mac_phy_caps_parse()
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260729-mac_phy_caps_parse-stride-mismatch-v1-2-077a1a0c50d8@oss.qualcomm.com>
References: <20260729-mac_phy_caps_parse-stride-mismatch-v1-0-077a1a0c50d8@oss.qualcomm.com>
In-Reply-To: <20260729-mac_phy_caps_parse-stride-mismatch-v1-0-077a1a0c50d8@oss.qualcomm.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: ath11k@lists.infradead.org, ath12k@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-GUID: VAqSX4-jVJnid59uExD2kvzjX2g9NP74
X-Authority-Analysis: v=2.4 cv=Id+3n2qa c=1 sm=1 tr=0 ts=6a6a1ba7 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=EUspDBNiAAAA:8 a=y0DE-vWUm0S5MY-z67AA:9 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-ORIG-GUID: VAqSX4-jVJnid59uExD2kvzjX2g9NP74
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDEyNCBTYWx0ZWRfX1QayPGnZe12D
 +7dvnOLmPRtmfqpwoerCnSBQCKlPGytDIidiR5wq8Ts8rM5V1gcldRsafznaUEAfYCdvgcuPl+k
 lhPACjxRVlS+ppMWphxJZn8xKCdATlM=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDEyNCBTYWx0ZWRfX3c48IahaZOdp
 2bJlqvHBDDd4LXYrs0DHR0jk4IAg+1QRpZUhf9CiGIRqPqDJC2yKxKvtT78IJRhBXC8K57//VdC
 dI4E8YE+wYVGmJPwXDvMFLvjYaCGSLE6cELSn7SuZ93uSDslPcZWEW5/y9y6Y8FWj4KVmrD9gmg
 H+w8kA1uGxUmxYRWgjeyVUs57V0gOBO54DD5Vnb2rUJRn9xL+C/TtFfTWKW0aLvn/O2Yauynznz
 QBPNYpTQEi+P7l2fyrNO1yo62aPZScxWfjgAl/y4QsNuVAPDaDDWYlv9gYuFgSmtq8chI72Yob5
 b2WF6/dfWd/GpGln106xHCzHaeOL/b9Wzh3Tf7JdYCcMuJZtMSbzdci2sJDk4L9a1meyHyQ9m31
 PG2uPaLZAwnf8Ay+z2aSK+aSaXdZVPPd85flfmXDY3I//rMucQDpgSBk7azFg/n938FzqYYCUTU
 Hs/2R4B//FtOr2UaIFg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_06,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 impostorscore=0 suspectscore=0 clxscore=1015
 adultscore=0 malwarescore=0 spamscore=0 bulkscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607290124

Currently, in ath11k_wmi_tlv_mac_phy_caps_parse(), kcalloc() sizes the
mac_phy_caps buffer as tot_phy_id * len, where len is clamped to
min(firmware_len, sizeof(struct wmi_mac_phy_capabilities)). The subsequent
memcpy() destination advances by sizeof(full struct) per slot via C
pointer arithmetic, not by the clamped len. When firmware sends short
TLVs, the second and later slots are written past the end of the
allocation.

The reader in ath11k_pull_mac_phy_cap_svc_ready_ext() also indexes the
buffer with full-struct pointer arithmetic, so the allocation must match
that stride.

Fix by using kzalloc_objs(), which derives the element size from the
pointer type, making allocation size and pointer stride provably
consistent regardless of what len the firmware provides.

Compile tested only.

Fixes: 5b90fc760db5 ("ath11k: fix wmi service ready ext tlv parsing")
Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
---
 drivers/net/wireless/ath/ath11k/wmi.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index 2d2c6d7a4a3b..f80e9b4a8a39 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -4800,14 +4800,16 @@ static int ath11k_wmi_tlv_mac_phy_caps_parse(struct ath11k_base *soc,
 	if (svc_rdy_ext->n_mac_phy_caps >= svc_rdy_ext->tot_phy_id)
 		return -ENOBUFS;
 
-	len = min_t(u16, len, sizeof(struct wmi_mac_phy_capabilities));
 	if (!svc_rdy_ext->n_mac_phy_caps) {
-		svc_rdy_ext->mac_phy_caps = kcalloc(svc_rdy_ext->tot_phy_id,
-						    len, GFP_ATOMIC);
+		svc_rdy_ext->mac_phy_caps =
+			kzalloc_objs(*svc_rdy_ext->mac_phy_caps,
+				     svc_rdy_ext->tot_phy_id,
+				     GFP_ATOMIC);
 		if (!svc_rdy_ext->mac_phy_caps)
 			return -ENOMEM;
 	}
 
+	len = min_t(u16, len, sizeof(struct wmi_mac_phy_capabilities));
 	memcpy(svc_rdy_ext->mac_phy_caps + svc_rdy_ext->n_mac_phy_caps, ptr, len);
 	svc_rdy_ext->n_mac_phy_caps++;
 	return 0;

-- 
2.43.0

