Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E9A5372C5
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 14:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792074402; cv=none; b=gkmFjLvFxqqbsTLorCTOJcqLLevTsERqDsQdgdXnfhY7tTdmekJmTMi0Y2psSov3nMZUhzzXu9YM/vUFFAfFTBVodfTC35VMvuzIwxUxEcZGlTNTtL35GownlhSjpzsIhZFG+x8TCgDgGGnmxiAzR3tCPTBET+FnKO4fZv+c2uU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792074402; c=relaxed/simple;
	bh=bioD0/+GRSIZztD0rAdzeKFKyqkS+BVldDDZ5gYLA7M=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=g242IZeHxlPDSXM9/hSh8VXzszK4hROq/2iGvmMDZxIkOWocosI9ugE06YMY8kqXPIJwokbCkHbM2AcAE4KcB2mEzqWWfc566mG4wGOajSlEXU77LDAjYVqAW7QgJH7QvQqD+dqXjAVxuGMeCrwt8X9KlltqOCoV2td9Zs6+zUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Iw0htt73; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=NFDgOi+x; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Iw0htt73";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="NFDgOi+x"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69FDYO7e3462817
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 14:26:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	mAQibhB3BU4XK9rhY3Rtg4MZdwMJFrdXgDdCbJcLw0w=; b=Iw0htt73hPoa3S6X
	Ojct/r3qln6GOZp7WBO6DEMClDLMEQJRWp7Td8e9zpUQJ/tu+yy4xjv9t2JEpWni
	KSAhnFn57Ir9dor9hoq7wInt5FFDn9ZEEw0P1k/VCX8NvDjxtbCCdYglrRWVN5Pe
	v7VP2wYwgjuB/zvmgYsLA8yPeSNQG4MEIcXNHtJDGhV4HeU3KcI5py/60TE0tLbe
	LO3Y7lCcX8eDDgiAetqWvqGj1ZSUtzRLmtU633jFMfS/n5mwZ9C9v90ZXBSg+UU/
	vXwCl6wlLs6Tj9TtsZNb3fFuHRG0qBUTO8rN0EFljZhP+NIj5xT9JWfNcGJOUycv
	8LozVA==
Received: from mail-vs1-f69.google.com (mail-vs1-f69.google.com [209.85.217.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hayu6871g-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 14:26:32 +0000 (GMT)
Received: by mail-vs1-f69.google.com with SMTP id ada2fe7eead31-7cc0418036bso147763137.3
        for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 07:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792074392; x=1792679192; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mAQibhB3BU4XK9rhY3Rtg4MZdwMJFrdXgDdCbJcLw0w=;
        b=NFDgOi+xM1sjdIVvmLxqY8MHov43+QyhY4ZcnHNkhiixDyUrxZcHTh0aPGsg7NSSaj
         CFk2AI52ojX8UTLciuievW5tmJWqnB91vX4xaobK4wKMFi98Qeo9LaA/7AaelCZg11i2
         1/gqZSJ8T49IQb+HWP0x4hEkTgnQzprgbfj0j9FAGv7DPIRQLZZtH1P7bISssu5MYFja
         Q0cNQjLZxjBCBV8iyJQdAKfLz8830tS9gS6upLKd0VeKJ+l7vIKDUbTpd1Wybe/4lEaH
         U48uzqOV/Ev2Ui/hAbRkpR0kl0M1peN4pVDUvQ9vOdwDLwgLETscqMLmCh8smq4sNvKc
         tJDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792074392; x=1792679192;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mAQibhB3BU4XK9rhY3Rtg4MZdwMJFrdXgDdCbJcLw0w=;
        b=mh8pMhX9vxzZf8ukBD+X4xX6qzC9nOTXKfo4tqAebHEOq0fTD6i+oTMfhdZeCzLqG0
         KFftoNoILSgK8QdpsxoNX2Kjhtu9Y5t1aRANTOpvl+taZ/YmSKm9igRYl0MiBLZH/Qbb
         SocicDhmYbfqslcGWmf0wWniqRexOgBo8ZcJ8+Q9YlaGDhU+VjE9DMdvRk1ZHGDnJgSP
         lzuxV2jSCAlGl9VgyybrIFr+ydiwu2+ZcD/rPPr8hZSipCuxs5kWCb1PljtoRbS3pjs/
         a2qJUfvJwzwXWWKI7SUhd82i+YD1qy3pFOPINkElVh0vRg41RD62/MG7aZW8t9WhGfVb
         4kEA==
X-Forwarded-Encrypted: i=1; AKwUvBw170O+dGmAIoiX6qAiNl21J7T0XLck0ItUTw/4wD1NiClh5ANa+UyXbJ9E6DvIKFeqEARkT+c91oEvNdUPaA==@vger.kernel.org
X-Gm-Message-State: AFq9FYJ+w9cVyNHxpL4Nl9bHq40GGbnKsdO58w5mdkRikXpK5TmiuO1b
	GZTKaJjGKLxDQ/9LiswPin+FX8P15FtRRiqeMNfW+ZwtB4WL+7nJ6giKYel/7FBO19lYWPQxsdL
	nZ83tnMaPnkLxRDffhxxT9WNqsi5jcskkbCPydpQOxPgaXCTg9nas8GQI5TDYh1+CTnH+zg==
X-Gm-Gg: AYBFou2c5tkUBCDxOGT5QOdgR7d4TYFiw4xoe3/h+cA1Cz1ketbbk4vd5ia8T8HBnec
	UyOVRgRi65nBSjQmCdo6OQyRYwFja8xTc7ZayjnqXNqVh19cfK9Z0/yuDD1wmltDomuZCI8/Nib
	2LDhtaTz1ZLhDLj3b5gvlhHPXS8/l7S6DELVd6hIZWOMVmaqc9pE26AEInANZ4I/acRQfwDrA5h
	ahjxMA4Bkfxi4+q2Nktj5qppumdQbPwialmV3CIes1UUWGG9Z9cO6Lpl1Kv10pFf6r9DztseMLW
	M/uorWRcqMT63kfzJWjCB0+fdZfXnQy+W3l8n5MTAkW3dJCi1jTHhPyyxgI/tMOZ73y2dzImytz
	aa/ZSlc0iAQXEwSJyMW0UcSH64hOf3WMv7/8F1RjdYVseDZoaYz6U5OavQUtWQEnN57V3CkTvv1
	BSHI+t6fqT2q1+7M/IwNCetE40g01/fSgS3vnY0FUJrbG2iuuF4kg=
X-Received: by 2002:a05:6102:5717:b0:7bf:d9dd:82f8 with SMTP id ada2fe7eead31-7cb373808f0mr3918220137.21.1792074391691;
        Thu, 15 Oct 2026 07:26:31 -0700 (PDT)
X-Received: by 2002:a05:6102:5717:b0:7bf:d9dd:82f8 with SMTP id ada2fe7eead31-7cb373808f0mr3918202137.21.1792074390919;
        Thu, 15 Oct 2026 07:26:30 -0700 (PDT)
Received: from QCOM-eG0v1AUPpu.na.qualcomm.com ([2a01:e0a:830:450:5402:5e0b:9ef0:9b5b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1bd6428b3sm69083145e9.1.2026.10.15.07.26.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 07:26:29 -0700 (PDT)
From: Loic Poulain <loic.poulain@oss.qualcomm.com>
Date: Thu, 15 Oct 2026 16:26:05 +0200
Subject: [PATCH v11 6/7] Bluetooth: qca: Set NVMEM BD address quirks when
 address is invalid
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261015-block-as-nvmem-v11-6-f890ac74f87d@oss.qualcomm.com>
References: <20261015-block-as-nvmem-v11-0-f890ac74f87d@oss.qualcomm.com>
In-Reply-To: <20261015-block-as-nvmem-v11-0-f890ac74f87d@oss.qualcomm.com>
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
        Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Simon Horman <horms@kernel.org>,
        Srinivas Kandagatla <srini@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Saravana Kannan <saravanak@kernel.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Eric Dumazet <edumazet@kernel.org>, Abel Vesa <abelvesa@kernel.org>,
        Eric Dumazet <edumazet@kernel.org>
Cc: linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-block@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, daniel@makrotopia.org,
        Loic Poulain <loic.poulain@oss.qualcomm.com>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Proofpoint-ORIG-GUID: lcBM15bCW8dD8DGcrjZTZzk6lr_xGtmh
X-Authority-Analysis: v=2.4 cv=ff04WEQF c=1 sm=1 tr=0 ts=6ad0e298 cx=c_pps
 a=5HAIKLe1ejAbszaTRHs9Ug==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22 a=EUspDBNiAAAA:8
 a=99fXo_IpyjsNTNVBUdkA:9 a=QEXdDO2ut3YA:10 a=gYDTvv6II1OnSo0itH1n:22
X-Proofpoint-GUID: lcBM15bCW8dD8DGcrjZTZzk6lr_xGtmh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE1MDA1NyBTYWx0ZWRfX8+njkesTq4UN
 l1UCzSYFPFEvHjzz7eA3RnMHwX34cc3ECnYQTuRi4aZDkH5pXjPz+4pV5PwRxDvUea1cFf1ZoDA
 6DK5I7vYUPFgTAWzA6gA+0u3/otsgIWRuV4xY9WVVPbIUjkvSbVpz7EQUDrKy1u9s/r/BmT/tJi
 9wIfass0GvvnfYqgnUOXLcpz2Bt+rtLS/G8ISU+4wQsvr7DNV5PA2QeCfDgMOBPmp68FdxwsNlu
 SreMhDiCl2/B6NnqP2z9196F+xcQ/sSqeWg56qdWBpBVNK+PqLo5x66DuIDpE774zih0/8mlhyU
 f43ZWQfhs/QrygKVPcsoteNpG/q4pENMLYOx0sK7bnMbFOBtrrfqu0me9/LXWnxzOT0gF6Fyp2F
 U5zkjnzudgsJg03/egSoQywI0UFR9o/6XDdKwxee5VzvgZq3Gn4zUPs+3Wqr3oNUKrIvCrYXqfu
 0Y5rzlvFMpRmnus2tIw==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE1MDA1NyBTYWx0ZWRfXwgiVUYktIQ+z
 66YxZkC5rRiyvhCkRyR6heu8wxKZbXaQIiV4W4UDTvcwXIpzwPCUY93LuAjd2Dz6urDdXxvYSFL
 +sFqegbiVmIAHVcMZanxG1lLPwTeGtI=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-14_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0 spamscore=0
 phishscore=0 bulkscore=0 suspectscore=0 priorityscore=1501 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2610080000 definitions=main-2610150057

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
index 22b08ab05b829bef2452cacad9c25eb8a63cda19..08600b0fc041cb09c175bf456cefcb6493171aa1 100644
--- a/drivers/bluetooth/btqca.c
+++ b/drivers/bluetooth/btqca.c
@@ -704,8 +704,11 @@ static int qca_check_bdaddr(struct hci_dev *hdev, const struct qca_fw_config *co
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

