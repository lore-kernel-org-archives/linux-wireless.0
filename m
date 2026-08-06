Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48EB5456DFB
	for <linux-wireless@vger.kernel.org>; Thu,  6 Aug 2026 14:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786027132; cv=none; b=kkJ5eVBaOI2XeBZvrNr5QGxIu0rAmYwOoUKjat+o3AXTjZe7T2ewqWktyhLhYqqonS0ERMIg9fPPHi/jh/lgXCXZiV57NRkNdd/TKq5Z9XT1SdYzZxNadMaKI5+K6B5f6GkroyCOVleIR0Jc7Raa8G+dI1aStiG90j9Q7Rg0pUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786027132; c=relaxed/simple;
	bh=036KrKutK2s+JBYYvV0r0UOnKyUPsfS9tqtbriE+abA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=p+iyP1EPIsd7HNltcP5qbnEvP/EsfTnAHRuM6byZGkLp/tiwpJpgMP9dGkltDyxfoWDM39qvgGSQzXjCiha9aEyI7bnHVXmgqy88Rvr70VdyITeAvoLr948bzo6IpuXocTYLst2PLz+tjmVnNqpbpHQr4rHqesdY8W8ClqQjoek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=mbTS1Pxi; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=NiNcw2tz; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="mbTS1Pxi";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="NiNcw2tz"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6769ncmh1580566
	for <linux-wireless@vger.kernel.org>; Thu, 6 Aug 2026 14:38:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	JU8Uh1sAxaXOEPqhB1RXVJGiUv22Sc7mcVDSZZfElb8=; b=mbTS1Pxi0LuRvOGw
	B4YG69hlkx2gjIGqX/GNaXgfcg+nm47kht9/dZYqeBkXlDDaAW6bJEN5TA5hBV8s
	nhNLGDafbeVWioOj/2WsdA/el7v8zGDUK5GUdOvX4nIYkH+CA8bHwLb3WTZc/zTI
	dGKKYl/Dc3h8vwG6+PoCF4QMhl+JARatBo0sYovrfLLj0j6DFZoXPk4ockY7D/SV
	4k6bFus/opI4VlNi7B4cLFBfuG5qOF7SWgnIN7XBjt7fPJxnUO0bfKkimah1ATzY
	pncyWycc92RH3Y/jda/2JdsmuZvjMs46wTx6/q5hNPQXAJjLw47d4ddIfuPEE1yy
	IPfDMw==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fvmrjj8mb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 14:38:49 +0000 (GMT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-51bff5c7035so40585011cf.2
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 07:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786027128; x=1786631928; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JU8Uh1sAxaXOEPqhB1RXVJGiUv22Sc7mcVDSZZfElb8=;
        b=NiNcw2tzWlcSjetDKlJW4mbKD4eH+2TYhgE77FgCeUiEYZ7CGI2b0PfVNFj1kLLX9+
         aB7/gcLMd3eAkn/lUlw3Lr83gwG6tHD8+ws6Y+ASOqyjpVU+p1EgERz1WsG9iZ2pS5p1
         1fSSoTFY/U5kKGsafebylUGOw5r5wMRFKvMYjYIkZifxY/o/z/D+of7Fns9y5UZ7RrfR
         t45N6+7mKfDoHz1iTacu2d4BWOcoBm2aRDeGOTIVGFhNIT5XtfuZm9O+xYnr0UJbsZPQ
         ibGpLFsJ1Da/3WE0KbBh5vPgts3VWWN6ogoefYmS0Tyy8UhJ9dixdNycHfSNZoPNniGI
         26qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786027128; x=1786631928;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JU8Uh1sAxaXOEPqhB1RXVJGiUv22Sc7mcVDSZZfElb8=;
        b=brnK1ApIW8q/rQfoPWdHdhKA969I6aSQtjtHT+utGAFps/84blIPvraJcWA5UpKu++
         Yl87pB7ig4EJ8LUF6zTy+DU4sv73J+R6uGqjrl1pYOxjo3GxFMjvYL17m3DU6P9Gapd+
         DeJfeGvhcCi9DT+W1QA/PjZsr4rFxI2pKNPLaVW5URttNfwoJPyXKrxnZFGq9CufABlM
         42ngW21YEzEuz3MHnbbZ15xbULeuTkVgefw5Jo1x3ujRKXPzfd+RE8Qh+FmV35fSG8ZQ
         JN01jQLl2a4eXsgEMp76rpJYX83cYeQ0YseA3IT2Uc0p1rMn6/6QrH3u08uOO5jaro/k
         H9uw==
X-Forwarded-Encrypted: i=1; AHgh+RryFUNyMYcB4/sxSyCDsCxKLLR0/4+zqrgG5ktyFq8EXj538IUcIeEFYvugQg1XaINJ83coZmyYyeiiswwKIw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyjx10abotze2eTFllvpjr3EJXWLdaOD8sTOjZeJoDHGIqeIsxz
	TVFwXJnGA5VM6J0E3UuElWmfaJqmmmX+WQyUc4yG6hVEEWByOA7K5/y6EP3yi90hCXFHudRLylI
	/awamRxGUPfQlp8ppQCfYJkhmB/faNS0m3k/Zs9fD9Ts4vc4cTbSqeOIsyXVCMU/tvDsrWA==
X-Gm-Gg: AR+sD11uSaYky6US2DTkmKph6EkHzeDeBe/8hGbpV+PVDsYHgWUZrEq85ah/LtAp3P8
	F4SeTN7iJkghUxObs/QJeIYsCJAcpcFfZGRvGFpB6EFfUCBlvb47/KZp+Av72jx53S0rvx0veii
	OFsdzvDE1yOktJzV37/KYK4XlK+fj4pHB/rFkum5AHb+hMOGq3GCf7cIA7NwIRbdh05IvbNoR1r
	+C4Xok4Jx3l59HHuwkG+j7KX+Q8Ukc00vNyJ+nmvCpdhz5uGhDavG5RwD2qBaEJj+88wGS+d3f1
	klus9y+Oak8z2K+pbYmEdXRdolag0IzDyNp9Csb7LX3m2qV+HATiS+506kAJR1wx10oxk1iDv8N
	4W1n66L+Uat7o5SXL6EoNP42xHbvKGV6d0jUhZ5707muvXE3Z/S0XgWNNOKz897Yp6z4TD0WuZy
	zgGiBfWRSjfR059EFrvZ1qnhhJ1ZVkneI9u8xMG5WNyEaObKV7sA==
X-Received: by 2002:a05:622a:22a2:b0:517:2c1e:8b6 with SMTP id d75a77b69052e-52ce61e7a0dmr167527621cf.38.1786027128560;
        Thu, 06 Aug 2026 07:38:48 -0700 (PDT)
X-Received: by 2002:a05:622a:22a2:b0:517:2c1e:8b6 with SMTP id d75a77b69052e-52ce61e7a0dmr167526851cf.38.1786027128119;
        Thu, 06 Aug 2026 07:38:48 -0700 (PDT)
Received: from QCOM-eG0v1AUPpu.na.qualcomm.com ([90.85.108.51])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2036276e58sm270552166b.28.2026.08.06.07.38.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 07:38:47 -0700 (PDT)
From: Loic Poulain <loic.poulain@oss.qualcomm.com>
Date: Thu, 06 Aug 2026 16:38:34 +0200
Subject: [PATCH v10 01/10] dt-bindings: mmc: Document fixed-layout NVMEM
 provider support
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260806-block-as-nvmem-v10-1-be598b2a5606@oss.qualcomm.com>
References: <20260806-block-as-nvmem-v10-0-be598b2a5606@oss.qualcomm.com>
In-Reply-To: <20260806-block-as-nvmem-v10-0-be598b2a5606@oss.qualcomm.com>
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
X-Authority-Analysis: v=2.4 cv=VNPtWdPX c=1 sm=1 tr=0 ts=6a749c79 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=JDRa4Jy4r6/BpSpxP2cCow==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=VqbvvwzL3cOeFLaalA4A:9 a=QEXdDO2ut3YA:10
 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-ORIG-GUID: N4P0_AGYq95j5BsezfV05Fd8myIKsEuj
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA2MDExNCBTYWx0ZWRfXy6sT+lIC4r+u
 84SdZ1EPSZ7IWk6Mszy7f7pvwj0h+mgkYFEtFHVtdKWz0KwNRhr1YE8o0OIDHJb6vwcVEYSS4a7
 9HlTXcvfBFt2eQgh2Ksr9GaPfUMiEq0=
X-Proofpoint-GUID: N4P0_AGYq95j5BsezfV05Fd8myIKsEuj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA2MDExNCBTYWx0ZWRfX0Rxqg8o9+4lD
 M1XTRB1t2lR3QdEvftpZGA/WrZM7sYywir7V0ndCRAxCKBoOal2tZOjvdRU3tHypOkGRTyvlYep
 K6lfV1GlJq5wRbrOrAPdbub104j63GIThju6KCP+gMP+WTb7ToJRNrWh1V8d0j8HvOKmyPXX8JO
 gQvwKKg4Olb//SPa7NKTjZNGf38G4mblL/9Sn9y/0UZ39pWvRwbYS4bHCAV/u5iJoofjstVAG6N
 kAH46FE2sTjMVa9H79aLzzD+QOvW9eLd42XiNkBP32O740kWpBhVDPrYDi8bqWJGQE9aly8HN0B
 66bAhhMDCuDaRiO/Z9HGjTsO9TYkxe+ORSmejIcI7TX9njex1MNuVzmm/fKujKX2lCmIEs5mKX3
 U2L5iVfPJAnzivaWjYAD0/v1fun8nqPlwsPJr4CCzUOKhKyjh1z7xPCprhDyFC1Tf4WO4sXUCBL
 BJzOsE7a7yHXnr5sa4Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_06,2026-08-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 bulkscore=0 adultscore=0 impostorscore=0 priorityscore=1501
 spamscore=0 suspectscore=0 lowpriorityscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608060114

Allow an eMMC hardware partition node to describe an NVMEM layout so the
partition can be exposed as an NVMEM provider. This lets a partition
(e.g. an eMMC boot partition) store device-specific information such as a
WiFi MAC address or a Bluetooth BD address and reference it through NVMEM
cells.

Accept "fixed-layout" as the partition node compatible, in addition to
"fixed-partitions", so the layout can be described directly on the
partition node.

Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
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

