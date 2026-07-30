Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ABCF443A9D
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 16:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427246; cv=none; b=LqhPurnys+xJwTAmLT9WtzxjhGLiPH/LDWQKcumiDtxbWFM13IygF939Wl8FQIo/scKQoLbXkGqBZED9IpYv+r1ZbslUhYfRbNGkvJFoW6wO0eUxOM6S9U2iJxRIG16YhHpRgmDcTlJxu5nbtI0e+WXRuBwcBHLuc7EG99PFMTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427246; c=relaxed/simple;
	bh=k3X2tgRd1gwg/uwGuGSAVWLEEcjC1WSvGA4Lio2zQzk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Wn351eyaFscXMdFzRRSz+D7aQhb0RllzUg3KwDiYXCYcHTgzBznnB+VxqgaWuesGzpNIbUFC4Fq2WQWz94mi3wNCi80G756+Zci7AmoeUbXkIoijixNpAApqroZ4DH2SClQIsd0MyghH/y/li7+p+gBmNKj42czMselOybfKSaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=aQ/naMfJ; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=RnnBHcne; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="aQ/naMfJ";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="RnnBHcne"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66UFQutf1225920
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 16:00:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	hE5vnyYn1cQDkxfnxwPBASs1NDxIF0ypO5EEm3REHf4=; b=aQ/naMfJL/eXOSkY
	sW4u1BsAtcWL4xBVIXWzOT4Y5OjCS+pcvEQoAayCe4obG9b+yJDKdV8HcIuPeyL8
	g0moUS6y0529FrLk4p2d7OYpHyAT6CZiRoNJHQL/odMCeNjb8kZu1MEXEANETa3W
	QXJc98GHfx6AL/F/8cOsjtJQUD32au1niPzUo2HT3GUsr8EOYJS9dlEgIm4MRfwb
	e8O33IUym52qZ48RHx4dBRj4mlVCQz/LzhYUTN1LD4+4B+ryFTwzPZF6wRHv4HVW
	qhcHL7Sh7mlakv7rTdEbKii9Es5IPyOvUTZLgYG0rWm08ZPiMUJv6hk+AbWNOH9q
	OQkJKA==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fr8kn0eqg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 16:00:43 +0000 (GMT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-51c1d30035dso19400541cf.2
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 09:00:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785427243; x=1786032043; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hE5vnyYn1cQDkxfnxwPBASs1NDxIF0ypO5EEm3REHf4=;
        b=RnnBHcnetM7RnvpI0jDOU3fmTMFVQe9cyaO0JciiJyRVwgIXjNxZkeUQ07kc3T/caU
         uF/SWCBeT+jqdHPhATHf3ZSj6T7zJgqCGUKmhYtn2oSLbIjtmFRec21V4QJM7/1QkgGJ
         llJ54konuEm9zowmEV8C7BdjID+bx38QpEsJukm4QyXw8soiOc5McC+AA4TdbxTg2zrz
         HOF0fBYpHBnSyGkLbMEkBA+RVcgbb6flmryIeWqWaZBZGWJI6vvYlq8PaOKaNDYFW3Al
         1r0YadW31FTFkSPLRbKiZX36asquWkve7w6fXUNecwfVvSJLzKhyx/mPNnHepZhMlRte
         S4Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785427243; x=1786032043;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hE5vnyYn1cQDkxfnxwPBASs1NDxIF0ypO5EEm3REHf4=;
        b=GWQ5cDVGUoHD1FTbz+FlssOa5rAHPf9eZ1Hp5cy2MJ7Q85+ednD7IYN/jXpnGNsGv6
         iKMFQRiB2pohNo/ce66BXDOf45V7QarP8/Uq4NQKXG6JpdrcJKxkthdffcbOW8/PQfmj
         xDOVJTTcakh5xBscz7Sv/d1/4q9tO6mU2w6MeNvxxYT0SYqiLiDK92/ubUgiwzit5dwJ
         yynLqZn6aYc0rvMw9qsHV3dWwsYabDlmHRo7h2afNHdL55gp97viK0alnkTdlF6CUF9G
         p7QbyTbVv/ocCGdSQ25QdQMgWKu2Nju0HAlzePWDMDh9OgFpLrIE6XWLHMLGZKvQcnhD
         qJOw==
X-Forwarded-Encrypted: i=1; AHgh+RpY5hwWj3gFpmJMcXvkhYSxaLACAfuktPOljk6tCEeOMVT5YbBpFULz0t0VN9aaou0lHcEH/VSAeim0pwIbjA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyLWGl77UoghDpBdOyhIbyplwBILqRRcW/AOL4VsFaqCf7dMeEE
	w0ESFw3fgM/+Zh4z9mMuX7Qb+/xM97xIk0hou48IVd48d04/BFccddgJPt9qfDs8Av2eHsC5cSm
	gLmaBe+16bCX3Ch2mz9BLYj82Ixbahbx7KX5lphEhV38TTh5pAo4rhdx68V+fP/i1e0yZuA==
X-Gm-Gg: AR+sD11DB4Dc5voK5Ryu6zc0JSyzFJrZ/StdTw3W9VyeteX2DQAgJVdZprnyNsScUZk
	xK8LI4C636kammu4qclJ0zhCV+SbpgTWUAdB6aou36HXsiDBMETuwJirPnZd7s0n3nhkWS042tp
	hePqAxHEN+AIN4kiUeSW1V64R/2TtyOtpRGDAhz84Dcr+fGFt6fyVnl6Kkttn6686vlJVcAEQSZ
	C8nlvSST04J8/801ppAypBTtC50y6yz7Jb8KYiILzJVK+qn8xKoYhv+qfPlLJKPo0WYxYxDJTHM
	2HFcT63xg5yOke+n/L8xQTxUY8M67yAz4AM1/Atz3na5V0fUbumOedY/ttNzAHzqbHDnJDv7/jZ
	lKP7ooaohK6ojn1R24Ax1Ao6Szpemy6YWYt4obP3v0ukO8FDSKzwVtcun7bsa5+Nw5+92pYz9mP
	F7qEQM2KQ7iaJQpJo1dAX9VBUCbZ1k23WztL+dHPgagEq6hXQQbvMy
X-Received: by 2002:a05:622a:58c5:b0:519:efea:cf41 with SMTP id d75a77b69052e-52b384abc72mr32749401cf.28.1785427243011;
        Thu, 30 Jul 2026 09:00:43 -0700 (PDT)
X-Received: by 2002:a05:622a:58c5:b0:519:efea:cf41 with SMTP id d75a77b69052e-52b384abc72mr32741231cf.28.1785427237652;
        Thu, 30 Jul 2026 09:00:37 -0700 (PDT)
Received: from QCOM-eG0v1AUPpu.na.qualcomm.com ([2a01:e0a:830:450:61cd:dcd3:c61a:ac3c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1fa8bb6deesm85168066b.53.2026.07.30.09.00.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 09:00:36 -0700 (PDT)
From: Loic Poulain <loic.poulain@oss.qualcomm.com>
Date: Thu, 30 Jul 2026 18:00:31 +0200
Subject: [PATCH v9 01/10] dt-bindings: mmc: Document fixed-layout NVMEM
 provider support
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260730-block-as-nvmem-v9-1-f72935817dbf@oss.qualcomm.com>
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
        Loic Poulain <loic.poulain@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDEyMCBTYWx0ZWRfX3559mkOaDtPN
 GpFczArN2vazNgvQ+Iv0ALcQiOMemUxcl1k//M/PIHzR1r5SUPjE/BghKXCJzfVeHZqUQMtgNEh
 ezYBuIQNMoxGQVUjgHjWxxkxFJpJa88=
X-Proofpoint-GUID: sF_WHPNlRlLq51OandVL22IUufDksCQz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDEyMCBTYWx0ZWRfX7xf9O5Dko7+M
 uVwL4OV8q2qaURh+0XhiEpJkaUjdA13lMI2vf4SCjMOz1M0pEXqSMhGQ8WWF5OuVUMBGAUew0iJ
 mTYL0VatILI9zUHA0kJvzN42xRaXWyKDTiJoJSg76cNCTbmfpREFq4+2ZNrkih8lcGQZ8blbVZk
 npG1zXJHB6ZvP7QNvQSHvD64X5RZ1ileXeHLU13ckygKqaN4/gmZTHW+aTzJKF86Jaa471GK6IF
 EHGHH4ngjo9B8UOpDwHAzZwaXCyVHYUdZ8a7XVYLOmy84k9jXkUTWK8bQSgsKDfjRonRUZyCtsh
 BpSWj/rw2sucXrh0PPqx+1IEnH2LqSxDk9S1KkXraKKmimRJ5AmONSSXrqkisnpHaTjxgWYCB2f
 wPluqudG0MtC90kWWv85RbMTDoCehusZbV6ghfmJik6jnQCi6/NHMrQ/ckZ5PrCJesHMzutttGd
 XmnUDaGbOFgpwMp9wdQ==
X-Authority-Analysis: v=2.4 cv=V7NNF+ni c=1 sm=1 tr=0 ts=6a6b752b cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=M8sXMW5dAYDte-7YvdsA:9 a=QEXdDO2ut3YA:10
 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-ORIG-GUID: sF_WHPNlRlLq51OandVL22IUufDksCQz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_04,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 phishscore=0 suspectscore=0 malwarescore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607300120

Allow an eMMC hardware partition node to describe an NVMEM layout so the
partition can be exposed as an NVMEM provider. This lets a partition
(e.g. an eMMC boot partition) store device-specific information such as a
WiFi MAC address or a Bluetooth BD address and reference it through NVMEM
cells.

Accept "fixed-layout" as the partition node compatible, in addition to
"fixed-partitions", so the layout can be described directly on the
partition node.

Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
---
 .../devicetree/bindings/mmc/mmc-card.yaml          | 23 +++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/mmc/mmc-card.yaml b/Documentation/devicetree/bindings/mmc/mmc-card.yaml
index a61d6c96df759102f9c1fbfd548b026a77921cae..0422894508478c8d0ca68292b58a5fdbee218358 100644
--- a/Documentation/devicetree/bindings/mmc/mmc-card.yaml
+++ b/Documentation/devicetree/bindings/mmc/mmc-card.yaml
@@ -38,7 +38,9 @@ patternProperties:
     properties:
       compatible:
         contains:
-          const: fixed-partitions
+          enum:
+            - fixed-partitions
+            - fixed-layout
 
 required:
   - compatible
@@ -86,6 +88,25 @@ examples:
                     read-only;
                 };
             };
+
+            partitions-boot2 {
+                compatible = "fixed-layout";
+
+                #address-cells = <1>;
+                #size-cells = <1>;
+
+                mac-addr@4400 {
+                    compatible = "mac-base";
+                    reg = <0x4400 0x6>;
+                    #nvmem-cell-cells = <1>;
+                };
+
+                bd-addr@5400 {
+                    compatible = "mac-base";
+                    reg = <0x5400 0x6>;
+                    #nvmem-cell-cells = <1>;
+                };
+            };
         };
     };
 

-- 
2.34.1

