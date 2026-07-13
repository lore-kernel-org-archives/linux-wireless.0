Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C3933B6FB
	for <linux-wireless@vger.kernel.org>; Mon, 13 Jul 2026 16:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783959368; cv=none; b=Mt9gs8jw/t9EfSHE/G0pu9EHBTkIMZDi77NumszXgNTpD3HBXkregsXi5uW2nxNGjREN/pW0LCqIzyWP99Tmt3+qBlSVmsmg8kSBip+JvxhUws62W/cLgBn/sYZtRVIsMd65GPZoQymZFmX1tqeic1WfaZF1DlcMfAd0SHnIEuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783959368; c=relaxed/simple;
	bh=MIjeDp4DsBs3ZEwHd1kmVPwMrrBmLKBXKQavZ0/BOWU=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=qcph/zcLeTM/uoqSHnwFyp0r2p0k6h4vVF5q9JkDfwqoQEJeDnpT4UGiPjc7+5IWyWNK3sXB83di29wps1mdQMUc7+JyZv9pD7gUKKwru7tI+w9MMh8Wb9QyJHZ+fCN1QTI0InmRDlfTxf86OGZ6VHgjPhGiSVbIdyyu+DT80Bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=WtnFqytG; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=A3MFYxXn; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="WtnFqytG";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="A3MFYxXn"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66DF8Hcf1709145
	for <linux-wireless@vger.kernel.org>; Mon, 13 Jul 2026 16:15:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=WNGUPRa2nMu1ajQvnmZN5w
	+JKhB37vaeHCrbmFos2tg=; b=WtnFqytGP7MsMjXWUKUdaI1dLvE5vcwATVWfA5
	fuPvGC0CIYZPllH8FEqpjD49pktUIxllKTzY+yenThgbpIGFw2JdAoDyesYO6+Oo
	nKiv3J1NSK9IaHuQkNn2HqeO2Pls+4QEj3nzivXsA3TdGmd1LsbR3Ds2aR9VgR2e
	DWYMmtkU7arhs3cdV7opIGxEsQsGVQg8+CErGgtsfbDbS6OozauMLW639samUN6Z
	wII9M8wvIaJxyAn01SUHgh2FyDs3MIGfjcCbqdHUQgzpJX23+rrNP+HNmJdGhEoX
	EXi9MGDXiAJda+c6WJw8n0FJo9dktppqEm3U/Q76nGylGRGg==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fcwk9sjqx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 13 Jul 2026 16:15:54 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38dc8d877eeso3090605a91.1
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jul 2026 09:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1783959353; x=1784564153; darn=vger.kernel.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=WNGUPRa2nMu1ajQvnmZN5w+JKhB37vaeHCrbmFos2tg=;
        b=A3MFYxXn0hy9zFYMkj1wG9o2UVAFbwsoggj07YT1e+02Yaq6Z6dAVHiSYYCqdHQXOk
         IVMF7akFXETvtEDNibCasD78I5oVhVQmSZPplSQjcfPj5aoPzooBvZzTLLnxy6gQRFIL
         u/yowXdZWer7rmhYdQYZQDeB9+dbg9iJc32jwRdU8+HmtgyXNQGS4gD9NUHGS4DNi4Xc
         RPvvbHS7YrCYcCTy7qXx9Digty2oyUbyTWqU9A9XIPuVJbIbFgI1j8tDMFMTeR0j+Tyd
         v7dPtL3pZQYF07sV1RchTeKvHwD/bLZMKHNs5g2NivDWrzCfHVQ5JDN2Hrx3eM5fIEUq
         Nt9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783959353; x=1784564153;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=WNGUPRa2nMu1ajQvnmZN5w+JKhB37vaeHCrbmFos2tg=;
        b=NtyAnuZ/hd0+DEhd4X3CCb1voW02Wpk26JiKp6bd3QXDO2Yebzv/Wt9I+YeKp7xZt9
         YRZXdHDIxK2/iJRUZM00TtGj2rE0PM+TJ97GsB0Vt8Xk/ko5MYFgm3Jvyf5eFpq4GykV
         AWVd7BlAtOAv0MB1EXVHLR0G9MC3JIwqiP2kWTAyJ6HQbGILvQTEVPY6kY8LFi2Ps88l
         SpM0uGkJkoyRrjgp9SYEPk3a6qpASo0DbVhGXBJHtUK3hUlahTIMKDReOfXdy5gbR6S/
         G28OC/4DjsrlTsXiwS29pr7y4VW2QW78ASaHBPpmZCnIB7AnVvGVrd+/MKtcfgVg5Tte
         o1CA==
X-Gm-Message-State: AOJu0YxhA+B9uqEhZNihvSZLtBf8U3KRDHmTtmkTMJUtW0y9T8jQO9DJ
	SgwgLbYMEvL/Tznj4zciYziP5mqZuIpePM6O1spp+zMk7KUTx0duzJpv1qKi5kbGPvWQePUxYIK
	bTrAVPd106GmI5zTb0hMkCJT6FsydJidmMrJFoP11rh7Xc7gHr6eDTdOkUo5xdsT9I6rn9g==
X-Gm-Gg: AfdE7cn89lZL35KqN5B/SCLipV0QA0G0p+/ALF7uPDhZHX49IOqBWTWATut4hhbM8mq
	zslUdMvkLo8UtT8YMCNoWHc2yL9HOlpiVouMYyeP6cv9conPZYN+9ZNhNvjIrzq+DnL79P0VYeN
	uGfFxxGVGW24yXRtoTMJaKhzQwx1G45EfdqstP580lnbvry3DmiKcSl3DZB+vUv2R2aGX91cE84
	JeHPvlBP3BqbaCaXgRzdQCB3mQE8o6dL7mr8ss74ESO+yvF/cSJK4wjWvnPAI4sUrJUq8BYwVYx
	C4bGmChze+hXgs9UNOiYRoQW/ea7H7lphVAWpJnYn1tK6dq0B7oM4fKzEvUTxD2nAEFQRFXhk9E
	11Bk1qH+vg0bltk38DyRMK/bVdZ6HMgjqX5wftZdWBXLrKvMaFblLGqVNkU2a9M9ILQ==
X-Received: by 2002:a17:90b:562e:b0:37c:6910:5758 with SMTP id 98e67ed59e1d1-38dc761b1f9mr8969551a91.1.1783959352994;
        Mon, 13 Jul 2026 09:15:52 -0700 (PDT)
X-Received: by 2002:a17:90b:562e:b0:37c:6910:5758 with SMTP id 98e67ed59e1d1-38dc761b1f9mr8969522a91.1.1783959352497;
        Mon, 13 Jul 2026 09:15:52 -0700 (PDT)
Received: from hu-jjohnson-lv.qualcomm.com (Global_NAT1.qualcomm.com. [129.46.96.20])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3118389d9bcsm60877039eec.20.2026.07.13.09.15.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 09:15:51 -0700 (PDT)
From: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: [PATCH ath-next 0/2] wifi: ath: Correctly copy the hint BSSID in
 WMI scan request
Date: Mon, 13 Jul 2026 09:15:48 -0700
Message-Id: <20260713-ath12k_wmi_send_scan_start_cmd-bad-hint_bssid-v1-0-4ffc4a472992@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIADQPVWoC/6XOQQrCMBAF0KtI1qY0EZvoynuIhDSZ2EGbaiZWp
 fTuhq5d6Wbg8+G/mRhBQiC2X00swYiEQyxBrFfMdTaegaMvmclaNrUSktvcCXkxzx4NQfSGnI2
 Gsk3ZuN7z1nreYcymJULPtdKNb712IexY2bwlCPhavCMrUzzCK7NTaTqkPKT38sgolv5HcxS85
 hulGre1WmoLh4Gouj/s1Q19X5WzgKP8C5EFUV61Mriw0aC/IPM8fwAmwidSYAEAAA==
X-Change-ID: 20260712-ath12k_wmi_send_scan_start_cmd-bad-hint_bssid-8786dbd8cff9
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        ath12k@lists.infradead.org, linux-kernel@vger.kernel.org,
        Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
        Jeff Johnson <jeff.johnson@oss.qualcomm.com>
X-Mailer: b4 0.14.3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzEzMDE2OCBTYWx0ZWRfX+DEscXyf8MMA
 nlg9ekfsuOc/q5iH1xdkh6V6wj1lLRaCC/P+zBRi2WiTHXmaALYXg+pAko8HYlG0wek+/Tx5D/N
 vWy1owNidJVFtfgvtH6B0cN+SaRGpcvjsOSRSbHOUkQUkpEYU/M9JcbJGZuCn0uxcXQiSajimjG
 3yNRU4ObWouexq7NFkZJc+2gX5biBA0TNPZKMwfCWbdzXh/wquoaz7Uhk0fGQsPZqejZYoQ/ipA
 zTSYcyOhCDImEJNsn6l8NLjr0SCggC4jLY9WnGIV/OXfwjd4oCGdjyMHJLfeoev0Mab3C3qUrPN
 f9Qwmf/I59Tdp65D9LI+5T/RJ7w+/TizqtqI/7EJ8KUn+mY7ZwodUwmo3wLDPGN8uNuNH2riE0J
 d35E3OatpLZnN0Jewj+EUd/qCXxn9uWayZontbJVQ66RWIslxNpc3l1Hu2ChgZTpoz5XMoqWWpu
 6yHvNMmi30AdjaXli0g==
X-Proofpoint-ORIG-GUID: njBxmfKWEQEyOgjSBmIuTadZI7Qb23IY
X-Authority-Analysis: v=2.4 cv=UMHt2ify c=1 sm=1 tr=0 ts=6a550f3a cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=4LN_5y7tnHSoj7lUZi0A:9 a=QEXdDO2ut3YA:10 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-GUID: njBxmfKWEQEyOgjSBmIuTadZI7Qb23IY
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzEzMDE2OCBTYWx0ZWRfXxW0dj91kKp02
 DdTx0Qqy05LlVaX2NPpbWX5tkqPkNVBqNO5RBgdA9XrDHopwheJVatVqR03pm2W6hM1YXI2TX0Z
 QFQmw45Qi/oSd+cPYtkIAYbit4tybyE=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-13_04,2026-07-10_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 spamscore=0 clxscore=1015 adultscore=0
 malwarescore=0 lowpriorityscore=0 phishscore=0 suspectscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607130168

Issue was reported in ath12k, but exists in ath11k as well.

---
Jeff Johnson (2):
      wifi: ath12k: Correctly copy the hint BSSID in WMI scan request
      wifi: ath11k: Correctly copy the hint BSSID in WMI scan request

 drivers/net/wireless/ath/ath11k/wmi.c | 4 ++--
 drivers/net/wireless/ath/ath12k/wmi.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)
---
base-commit: fa1b1469f1c5f0f54ed9dab80106a117e7736bfd
change-id: 20260712-ath12k_wmi_send_scan_start_cmd-bad-hint_bssid-8786dbd8cff9

