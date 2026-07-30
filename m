Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949834519A6
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 16:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427273; cv=none; b=Lgy38xyrgmUzohAO3s4xJA/VA+D/nfoG+x+ovaGnHwz0hWGwH25TACmBuRcPwI4q8JQL7PCzWzWEE8Uh8r0viiXwIaO0G3QTn1HTVoc3Lm5tiqvJPrNRWYiPLixMA4aHEH/Om+g6kwLChtCgkYWUidwL8kBO6U7g5YUz+LZmuNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427273; c=relaxed/simple;
	bh=8FCfjPBXOgeSOCE9oMNfyVBDBWfxZtU2M5HiiMnr1BI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Fy1BlRMKQqtYaG3z89kYUKYs9Sa9IgTfT8T29VXByZXkmMsqy2xX6oQHTYGp/R8ybgcPfnSb5Bif0XTlkDLrMJfqADp94OBbV/MI4tgn6yu53dybv6CIBIQIaEYU8dVt5oZsbOT0iqTaenfjCCkK0KksxohL/Fi9fFZqsKpJQcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=CoQ+dBJ2; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=cHrQXpcE; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="CoQ+dBJ2";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="cHrQXpcE"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66UFQodn2401514
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 16:01:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	r+r+249nF6a2qrtXG3fwd0XKqhJprD40LYapJr4TU6o=; b=CoQ+dBJ2w2OXWcV7
	89Yvmm28+CeLZyllRsKsEYx2lctJzjxebUPTXvnncMJYuuM8mG5FftOXEjE7Pbub
	i+c84ERsedV8jQDpkqL/kyr+aqqvCUcojbG6t4DKyuqLvEHA66yXRnE4TVQy22hC
	REpHvQ0DdAwnpUAwQdeUZU7fkLkcTHMeAy/Z10PpKMBKAamGTX9MaUwnXdH3/IBG
	MDiA7KkJal0svawJPgwTk88UazLOKDygNC0qYWI+dM9DoVjYo4aQaq6ZRdj7B3Qj
	8xdnU8MqzLJLaQiVSlkOSrRbL5SFX1RIrOoJFBUS1yoDaOd2WB0Px17lCZUOAVhY
	iGhUqA==
Received: from mail-vs1-f71.google.com (mail-vs1-f71.google.com [209.85.217.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fr8168n0w-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 16:01:06 +0000 (GMT)
Received: by mail-vs1-f71.google.com with SMTP id ada2fe7eead31-744e80385dbso607137.1
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 09:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785427265; x=1786032065; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=r+r+249nF6a2qrtXG3fwd0XKqhJprD40LYapJr4TU6o=;
        b=cHrQXpcEzZmIZjPHspRJwPF8XAsOh+YmLHLO6p+OW+uMv9/JnO2b055jSIaTwr1xGo
         k0Cehiih41MReG1igfg94QOjm+cfU41lj/o8G6cNZbpc3yyqSwDysxgQfMBx/Z0U/XS1
         5w2/tw/KLaWqM1ZeGBpq5J+7OLU3KRLQmYz3i8zANNNZz7mTKrlkEr0mmW/tqMHfQI26
         pPNHytZdX8WTQUnSgfQbLUzWjiyMs0mYs3dmjqQ3BeY3MPaIX1RTj3vJWG8fRtiTCwWn
         tpFSlIlPZUzkAOmxD1TBYweeGM12X7BQBsp9m2kRQFZ1X55xt3ZqLMoBHfG2pFv4xVLa
         sgwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785427265; x=1786032065;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=r+r+249nF6a2qrtXG3fwd0XKqhJprD40LYapJr4TU6o=;
        b=q/EmRmv2G0bxUTrUSfADAToyc07H8xospDBHDzw5W53It36ccVfpOcrbfKEfbMxPcU
         CXIH0ovMKmLFNvoMs1T2smpHWEqhuJ+x1XKwAEB32Q8EewEDEj+b2BWF+d2sOrZUBTbw
         6I8+FabuIFYuaChslgLeCJXc4HqQOdr63Kp9w600EdAoHr/HumAryNPWXI0zWRVW78lZ
         Jenn5cHXhE1C4umeeLkeN84pV0HnUOc5tqzPt94AnkfPRV96lAjXPD0hHsO0Xezg+cpN
         XVDgHPuC1ZMMMPd9WYgO2/xx6m15XJsjprozWT441U2anGtW8xrhBSmVaob73IA/vIlc
         DnSg==
X-Forwarded-Encrypted: i=1; AHgh+Roamfb9kToFhJL+DQO5dayOnXJaJ03atlNsp19U/WaZrmypopPvE5v2lqTQVRgLcI5eRSuG6hgQkf/LBfYjvQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwrXoZzVkv4AXncedOJ0wPCCBXAEuH1N8n2LyEVHAs4qz+wC+Uo
	TZ8MpmHkoj/JnT71S7X+hQ6H/CVVi2huBs/jiyKUhNIP+AN9VvGbaXa57yJ9hVwgWVfr3EvC+4Q
	b/Q/fnn1hUDcjlqjK80dULetrS+I+UHHjb/YYjA5tcUwWSTlUDmPugzNQxoBM/2ociWlJbA==
X-Gm-Gg: AR+sD111jDHRsNaP/MH7PXCfje2kX0EATs5ZPXGf34eAMxC7m53S4SycJ++i7lNEctr
	XURSnP0FJ3t7ODrr6kxrujNEw83E7h6vRBmMJvxi+i0z51cZDBgEXENkMETNZyDn9tCeD2u30Vr
	ZTeNceH51RyUWF5yeyFX1fD11Cxm+LbQQf5vMilFjIu5BqH7zoIDo5xtt+3nLP9a1pdJS2K4uIE
	15Q+PZLtqjJJZQXs1b6mi/Yj1rob2EKscknYU/NDBE3YY0IPHoPb+903cx7jYYdA081FkT29NSP
	bKiBsMv+tTup3x0jKejwd5yLXq4Rk9dYOFHSJ3LJiUgnqTpLTOX5wlaLFswrHcsZrdt/FU0cGJi
	OH1iQgL0tYrLup36duiBZ+bmXnMTvATNwFN/jig08UaOlWGL+TwuPD7NnPgLBXg4M1d4SEyQCpx
	bBvsCEGnodJ5c7UlOPcYc/joKrSvBObnA+uAYIPRB5T6ha0yckqzmR
X-Received: by 2002:a05:6102:1484:b0:74a:b5e3:e96f with SMTP id ada2fe7eead31-7574dfce200mr1067412137.7.1785427264853;
        Thu, 30 Jul 2026 09:01:04 -0700 (PDT)
X-Received: by 2002:a05:6102:1484:b0:74a:b5e3:e96f with SMTP id ada2fe7eead31-7574dfce200mr1067275137.7.1785427263969;
        Thu, 30 Jul 2026 09:01:03 -0700 (PDT)
Received: from QCOM-eG0v1AUPpu.na.qualcomm.com ([2a01:e0a:830:450:61cd:dcd3:c61a:ac3c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1fa8bb6deesm85168066b.53.2026.07.30.09.01.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 09:01:03 -0700 (PDT)
From: Loic Poulain <loic.poulain@oss.qualcomm.com>
Date: Thu, 30 Jul 2026 18:00:39 +0200
Subject: [PATCH v9 09/10] Bluetooth: qca: Set NVMEM BD address quirks when
 address is invalid
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260730-block-as-nvmem-v9-9-f72935817dbf@oss.qualcomm.com>
References: <20260730-block-as-nvmem-v9-0-f72935817dbf@oss.qualcomm.com>
In-Reply-To: <20260730-block-as-nvmem-v9-0-f72935817dbf@oss.qualcomm.com>
To: Ulf Hansson <ulfh@kernel.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jeff Johnson <jjohnson@kernel.org>,
        Bartosz Golaszewski <brgl@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Balakrishna Godavarthi <quic_bgodavar@quicinc.com>,
        Rocky Liao <quic_rjliao@quicinc.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        Srinivas Kandagatla <srini@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Saravana Kannan <saravanak@kernel.org>,
        Christian Marangi <ansuelsmth@gmail.com>
Cc: linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-block@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, daniel@makrotopia.org,
        Loic Poulain <loic.poulain@oss.qualcomm.com>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDEyMCBTYWx0ZWRfX73paoloIkYVf
 vBTPzihbZrDOpiUSOlPGRdWSUsUtgrCHH9lI7xmWtvsdYesY0/+1W3YUQfNZK53rBg9S+uo5bd7
 mc476BM6bwqb/ZwhJ1SQqGrYQORLoK4=
X-Proofpoint-ORIG-GUID: 26G0acjz2kf7A7xpq0Q_xiFZ-w1TqdgM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDEyMCBTYWx0ZWRfX89j48e0FlAuk
 89S72Im2B1J09tDkOef+x9E4pEVTJG+ezlT81+PAWNxPU5dBwB8I9DOSOuyrqjQecAz8dwtCnzo
 KHN59NYD8sMIFlq7GDQT/nEY4o+cRzjy+yoCmCrmSzCnxbhODAi+iF80PDQVDIRbW3/08liWAAV
 Snjlz5fkopn0flFGAwzyWBeFNg21PC5hxl9nqkMJqKAsjB8GgMklSO3bRjt98RXo7pLEh4c4v3r
 24YuCG8CD/+Ro1tYd8rF1LAfBq/jY9Eq5+4717286dMGhpUue9wiufbJCKZ6mS7uQazSFJ6wUHQ
 LfcpNR6He8elgzIR0uaqnMNcgXjnPhGmXuX9HLLH3fF+SaUUQZAj+9MBq7akJekKKbWB2Tb/Qyn
 mphxvMR/WevrN88uF9bDgc99DBB46Q==
X-Authority-Analysis: v=2.4 cv=LIlWhpW9 c=1 sm=1 tr=0 ts=6a6b7542 cx=c_pps
 a=P2rfLEam3zuxRRdjJWA2cw==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22 a=EUspDBNiAAAA:8
 a=99fXo_IpyjsNTNVBUdkA:9 a=QEXdDO2ut3YA:10 a=ODZdjJIeia2B_SHc_B0f:22
X-Proofpoint-GUID: 26G0acjz2kf7A7xpq0Q_xiFZ-w1TqdgM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_04,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 suspectscore=0 lowpriorityscore=0 phishscore=0 malwarescore=0
 adultscore=0 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607300120

When the controller BD address is invalid (zero or default),
set the NVMEM quirks to allow retrieving the address from a
'local-bd-address' NVMEM cell. The BD address is often stored
alongside the WiFi MAC address in big-endian format, so also
set the big-endian quirk.

Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
---
 drivers/bluetooth/btqca.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btqca.c b/drivers/bluetooth/btqca.c
index 04ebe290bc784ea854ec7743bc753c3e41f556d3..06cb787b0559f3d712ec2b88d9e25a7d46fb00b3 100644
--- a/drivers/bluetooth/btqca.c
+++ b/drivers/bluetooth/btqca.c
@@ -723,8 +723,11 @@ static int qca_check_bdaddr(struct hci_dev *hdev, const struct qca_fw_config *co
 	}
 
 	bda = (struct hci_rp_read_bd_addr *)skb->data;
-	if (!bacmp(&bda->bdaddr, &config->bdaddr))
+	if (!bacmp(&bda->bdaddr, &config->bdaddr)) {
 		hci_set_quirk(hdev, HCI_QUIRK_USE_BDADDR_PROPERTY);
+		hci_set_quirk(hdev, HCI_QUIRK_USE_BDADDR_NVMEM);
+		hci_set_quirk(hdev, HCI_QUIRK_BDADDR_NVMEM_BE);
+	}
 
 	kfree_skb(skb);
 

-- 
2.34.1

