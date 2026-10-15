Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E13245328BD
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 14:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792074385; cv=none; b=BGfFMBUMDq0w0REOKdfnYREQ81WFDWitXo4V1mDcUCzixQTgkUiK77S/yxPS2/ZLWYIlUC0zg4y6UR7ORfDnKT7dnB3BtPQSKz8jazJDrzlfy96PM146wF6NPY8iYaqsvsnwgIoyoQv0BDN+LmzV3LcKq0myTJlFg+4tYDNQoG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792074385; c=relaxed/simple;
	bh=xh4ucig5hPRkaGw1GggCAwEU1pqdfnGTPbj3vUFpt5A=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=TIZl3mrzDLs88Xu9WxQ6JO2lvNad3TTYmnKWcFJPNewt/bqxNRQ6gJMFpD8KB7dNGjZ/buqhw9/gWkgJsI9Rt8UBvMv5FOPzEwCYbc1DGD6Jzn1qXsYfMgGXTrz+GJdcJ8Y/KVsn089Dp3vBeVWqICaGqbwD7CX/kGt5rcb9WCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=DOuhrj7t; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=M8BWdqYd; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="DOuhrj7t";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="M8BWdqYd"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69F9jggP1955846
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 14:26:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	OF0qK3G3GFE0oahQw0gKGPhEucSp1JH1FwJoY8Lp59M=; b=DOuhrj7tQmzO4se0
	B6M0VuzNCKu4xPUlNYRkUVEipt1H4GDlQTqSqasCCFEfdXEOCTAvOHwmeBt7xSny
	IBDXPVOSQAnY5mZtoH8GNx4LJ+MvpH36fTfhY58bWk6ac9WP5TIR5RxMjqWVAHJk
	/x1I3CCjKd/DuPET7nv8ZfOTOba1zWBrgYhPw6ISNbuYfUfk6EiNk593eU6l1WEQ
	8G3HM3tTmc86SOgFP9HJ+HRRcwL7vGgSTIxhFKae1Soxq4C606Xq62uTF+No20Oq
	Q09M/QTl6S0WxXyxRPjBn4KlDBvlHdfZPrZOC4r7S++kunKvuFyIV8mZiX8g+yeC
	5rDfNA==
Received: from mail-ua1-f72.google.com (mail-ua1-f72.google.com [209.85.222.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hakdeubgt-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 14:26:17 +0000 (GMT)
Received: by mail-ua1-f72.google.com with SMTP id a1e0cc1a2514c-9907539aff7so540131241.2
        for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 07:26:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1792074377; x=1792679177; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OF0qK3G3GFE0oahQw0gKGPhEucSp1JH1FwJoY8Lp59M=;
        b=M8BWdqYdGnAH9S9NQkbKu3ciH8vBFTtO4N0mqEwNcwetBw5oPSSiQY/dhbdmLksM/e
         /XYtbzpu21Yk3c+IHP+hjUjq5w42I8qjyUFfrza3wezWqcN3hsbbbSVSE3Mos+azVkST
         8wwottc+jUT8m9P6DYAm6FwV3/uFHNr3JDRkXl+19tTQLnWsFrOSgwJQD7NRY8MOjOZ3
         5g3+UoqyNJ4gpvucOwxAvjUbaRx5Z6u+0AbmHkcV2+wxc+2PNIffuWv1vgx3C2mK30OD
         YR4b8CcOERa5dIw4bhEAxhFyvzoP0vszFFscpKbbgaPIbwQFXiciCHJllDbyC8xbBaW8
         0gfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792074377; x=1792679177;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OF0qK3G3GFE0oahQw0gKGPhEucSp1JH1FwJoY8Lp59M=;
        b=GcBAdQ65j9YIust47QRwFBkJKx5vJKhizXr25aZ0z9kWB5Tzaq/h292ZDHi1oSsMwu
         nVP81lWie4TKUmj3hKVX6Puz9+wdIpnBti/V96PCsHbgdZDCtIzjjTMJ9PbcpR4rO3LO
         /kSJr/hFEpR+Oq3CAC/AW0hYtVVqzhEFuWB2s/tc/MGXjGzCMYFRjQul86+gzS5njbpW
         lY7mpJNGggiO/c9QldLVIHIr/K4o1AfoewDtKPTgfAeokGBrGC6kU4vJzbzneeZQ2Qf4
         Il0dkkOutmcwIHZtum3b56rM16fIX5J1DRmdzcg1/8zslLecGDZqFZN3c16KAIsgZnL+
         liGg==
X-Forwarded-Encrypted: i=1; AKwUvBxUtmfhE4SqCbmR2TRtMt0/Y9V809J+Hu1mdAHDO/ZDP8zVA1h1sQgMQdUwCM24vkN6wQMwe2lyvSAaMBYMGA==@vger.kernel.org
X-Gm-Message-State: AFq9FYISj3MvwN6PYPfL7IPBkBojID3E+qd/SY6mtU18uhX+6D7KJ7Sa
	n0LOpSLsmIYxC8h/4r73MinvCyZygi/8l/JFSfsJQ/DTeU3UUQByR599loQQ8NO7SsB95MSPUCq
	zwA8NMk7ceH/qdeEtXAlWTnX2xOwgraRoryd6Zmb65WfX8dabmlHyQjLvNaa1jYBCxWkDRg==
X-Gm-Gg: AYBFou3xr5wlM/NR45Lt4zgwTdT6ZzFdqR/EIkwJImUhf5glDhfDkHOl8dUJeQ+8Q6H
	dMWLvQ3ITsF2+UioeY9F4pUIJyhWDTH8Si00U5soPlmo/Qym/r2sjsMFceZL93XRQHjcxFwQw30
	g44gwaraCVquZhzMKYSODVEfA1/ZjVFeKGquu8wKoa2lWF/ymm8gL8AE1+cD6//xRq451pwdeh1
	QXw2IvliXYXksmuz0yTyXd/HgehD09C/EkcBxJDR6/D77/I0yT5t9YR+aasDeFu4Pjco04FUDdP
	/50Ko2xLsrHMEZkZ8MO8k/opzCid/tXanx4Fk/1Zc6V+Amx3nTw6UFSOAdKe5CZ4/1cie8+OvgH
	/Hpkn9R0NOK8QUGvuFqXCEFlQVbQF7nEZdBNehjGiy7G6B9FML9j2J+iI7NiPx5RTHIJU5ngas3
	N8SszfYMKi/t/zyBMR4Q60uZ1FnEt9/XaimtAkrmAj3yclbCMDc58=
X-Received: by 2002:a05:6122:46aa:b0:5c9:a60b:e5b8 with SMTP id 71dfb90a1353d-5e91f4dcdc7mr6746925e0c.17.1792074376574;
        Thu, 15 Oct 2026 07:26:16 -0700 (PDT)
X-Received: by 2002:a05:6122:46aa:b0:5c9:a60b:e5b8 with SMTP id 71dfb90a1353d-5e91f4dcdc7mr6746873e0c.17.1792074375948;
        Thu, 15 Oct 2026 07:26:15 -0700 (PDT)
Received: from QCOM-eG0v1AUPpu.na.qualcomm.com ([2a01:e0a:830:450:5402:5e0b:9ef0:9b5b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1bd6428b3sm69083145e9.1.2026.10.15.07.26.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 07:26:14 -0700 (PDT)
From: Loic Poulain <loic.poulain@oss.qualcomm.com>
Date: Thu, 15 Oct 2026 16:26:00 +0200
Subject: [PATCH v11 1/7] dt-bindings: bluetooth: qcom: Add NVMEM BD address
 cell
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261015-block-as-nvmem-v11-1-f890ac74f87d@oss.qualcomm.com>
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
X-Authority-Analysis: v=2.4 cv=OdENnRTY c=1 sm=1 tr=0 ts=6ad0e289 cx=c_pps
 a=ULNsgckmlI/WJG3HAyAuOQ==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=jFERsaRKWwo8c2z-USAA:9 a=QEXdDO2ut3YA:10
 a=1WsBpfsz9X-RYQiigVTh:22
X-Proofpoint-ORIG-GUID: A4nC8DWdqyUlHDyYiJX4rCLmyruZbwb3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE1MDA1NyBTYWx0ZWRfX6YLp90H3Ex2U
 98MzhkgrWWhLCAb9uPdwvcCpsxLFJJ6Hhmwez3MVEcPaphpfKv1SOZqK4zvTGXmbwP2fGYWYvc8
 +UFd+r1CDSnUzSoDH3cYEWuHQl8PedpE+kfJtIfwFD+8HQSDE/IbyinPyp5iBeY2ntGa/uH8CKR
 kQet8MKWdRyMQMY2I8NtBZnzwcIhODRJDUhnHFK+zo3UCLbwMMJ/RtJxFc6HjgP/dyFcHuXysWp
 uHk6RM8Dj0Za9gWboBZuE8OBhQ3jXWGn0zq+JRkcuR/uNABSIN8JrLberhACwlueswp+3FofJAm
 cKhdU3zuhjtMTLRPgEcI0wvu5rO5txSMRLX0k2cRAZBFcmRdmMiAjabth66MOy9FXUM17uLW9xr
 P4WV9MWTUz048HTnUgkYpMWsKjoNcMgXYnLzfShJfxUKQl655r7nrw8+8Fj0CtNhzGwy7le8pJ3
 p+5VGLFBWBXWWyPoGCg==
X-Proofpoint-GUID: A4nC8DWdqyUlHDyYiJX4rCLmyruZbwb3
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE1MDA1NyBTYWx0ZWRfXzxlljCZdwfTj
 1zJxhwoLltaHMJAZrdueOl49xzyptu7klTrMEHJ7k1kr4idIyOKU8ikUWCqdViDlDtKGmXnVVzS
 g/pMs8vGGdM7WJv1PBTKl3q9h6PbqZY=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-14_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 spamscore=0 impostorscore=0 phishscore=0 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 adultscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610150057

Add support for an NVMEM cell provider for "local-bd-address",
allowing the Bluetooth stack to retrieve controller's BD address
from non-volatile storage such as an EEPROM or an eMMC partition.

Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
---
 .../devicetree/bindings/net/bluetooth/qcom,bluetooth-common.yaml | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/bluetooth/qcom,bluetooth-common.yaml b/Documentation/devicetree/bindings/net/bluetooth/qcom,bluetooth-common.yaml
index c8e9c55c1afb4c8e05ba2dae41ce2db4194b4a0f..7cb28f30c9af032082f23311f2fc89a32f266f17 100644
--- a/Documentation/devicetree/bindings/net/bluetooth/qcom,bluetooth-common.yaml
+++ b/Documentation/devicetree/bindings/net/bluetooth/qcom,bluetooth-common.yaml
@@ -22,4 +22,13 @@ properties:
     description:
       boot firmware is incorrectly passing the address in big-endian order
 
+  nvmem-cells:
+    maxItems: 1
+    description:
+      Nvmem data cell that contains a 6 byte BD address with the most
+      significant byte first (big-endian).
+
+  nvmem-cell-names:
+    const: local-bd-address
+
 additionalProperties: true

-- 
2.34.1

