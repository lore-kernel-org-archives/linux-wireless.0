Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.149.158.101
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793748669;
	b=r7gqtan/7wUy132FP4olCqYYLP5rBYDuEvHhcaUr6NGrq37GrxfNxOPIHhJUu7jTDIth
	 CBd4wbLhGDI7iJIvFAydRgBmBt1PQ0NOXlEmg7N/UrHWlHrlaDeK2t8b1YMq/RjTrfYEe
	 W2/xjlYuIE4uLd46m5/ImBFbGwykyUmwtcBFpL3wNOGvFa8aC7JMicFlFUpOIxp9I9rih
	 wCGxxBs0tIrEmGTTiBARCQf4q4wGN/I3zC2Jro8Yza2bKPS79hvNqzeSawHKvKwLAhMwQ
	 648SQVn0W4aEVHvOimqeUm2Vxp04EU3vSnv6Tw6qgm8nweItyAMFqD9tA2X91dSl7Ug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793748669;
	h=DMARC-Filter:Received:DKIM-Signature:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-CMAE-Envelope;
	bh=1cQv5Yv37SP3AJ6YiCsdOAK5DnVQSQnvJ0pajJfDHMc=;
	b=kH5fG9L3Oxaa/Z2G45CxnEYxpQo/6l4lYzOkRBb/kAj7Rud/TnRShEmmxuPztUETixcA
	 VRMi6ADVM7lN057DzRIo+P/sZn0H7E8ZasMkyYz2xhdWvIBAMM4UhlULxcfN7j2yjUchD
	 93AvH7f7rv+MF9INHCVSi6569xRqRGA21YO9af2vwFC/ZMIaa3J4kS29QGXvwtWh8xIne
	 IPV6oeRik9hz/PH7FDLP8wnLXW3GeXaw4jbJ0t9avulw9TrXKj4pC6w016MQhD8+0VMrS
	 xQ9NJaI4lSs58GqUkQYBJc8bl5Ezb0iGq0XFKg/UT4bouYIlqen6CqFrOOsvhkMl26g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mythread.it;
	spf=pass smtp.mailfrom=mythread.it;
	dkim=pass header.d=mythread.it header.i=@mythread.it header.a=rsa-sha256 header.s=a1 header.b=Jcw+Xkp0;
	arc=none smtp.remote-ip=62.149.158.101
Received: from smtpcmd02101.aruba.it (smtpcmd02101.aruba.it [62.149.158.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADDE0606A336
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 23:31:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ADDE0606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mythread.it header.i=@mythread.it header.a=rsa-sha256 header.s=a1 header.b=Jcw+Xkp0
Received: from [192.168.1.237] ([94.34.125.0])
	by Aruba SMTP with ESMTPSA
	id ONxyxz48a7fl5ONxzxPxAP; Wed, 04 Nov 2026 00:30:59 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1793748659; bh=koGz70JWkwxpofy4HnBzQDpBS7jXm5AMZsYlOif0cqo=;
	h=From:Date:Subject:MIME-Version:Content-Type:To;
	b=Jcw+Xkp01IzcrLUJRT8HyNcLOLEADY0rF8an2a6NkkvFIDMx3H1cdldxXUPPHYf/E
	 HATXxvvUtuccDAccfViY+nAFtRuWomXOwF8T3QeV+wa5mpEfWVJyTs6apDhFB982Xk
	 L8Y2Qc9aZdHk9hb1kenM+jpGoqCm2bcFp4QsL6b1AZVaQ2sYka8MOaxwgKirmY47x6
	 E3QceB0KrAdAYIxdXYcLOSViQzuo0zR7M/sw9iYCNjre82GqJPyteZKXBC3q1A2l+t
	 vCHYpqWCqKw7DMxUts4M8gA+jEHDOJlvmnSZBp+CEYghoVbxB/zpZaKfRc5C1c9Ci1
	 lRATCujBQWdlw==
From: Alessio Ferri <alessio.ferri@mythread.it>
Date: Wed, 04 Nov 2026 00:30:59 +0100
Subject: [PATCH v3 3/5] bcma: scan: accept wrapper-less cores on
 wrapper-less backplanes
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
Message-Id: <20261104-bcm6362-wlan-v3-3-e46562b2ac12@mythread.it>
References: <20261104-bcm6362-wlan-v3-0-e46562b2ac12@mythread.it>
In-Reply-To: <20261104-bcm6362-wlan-v3-0-e46562b2ac12@mythread.it>
To: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>, 
 Philipp Zabel <p.zabel@pengutronix.de>, 
 Florian Fainelli <florian.fainelli@broadcom.com>, 
 Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 Jonas Gorski <jonas.gorski@gmail.com>
Cc: linux-wireless@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org, 
 Alessio Ferri <alessio.ferri@mythread.it>
X-Mailer: b4 0.14.3
X-CMAE-Envelope: MS4xfCGfJlQk5zHd5tl9/+3/t67H4T9ssLhpKRSdEehXV6IsMyUJNHfeWsrfsRrgaWaCIaRrPYMb0/3MTJjBvq3OjUoxhSct3m9JtfRO6926Rp24KaQdId/M
 bWjr8Nen32TawHDiBbg8e6LcWMVnppCynapVC58RxzsY1eIIyQmcjnxQ4w75AAOMvVvB65qMw1VMsw8uFUNA6aiixDcmljJ0imJJp3tUh1Up0VHmhLTGNtTl
 AqhiqJmjmd5yJEmLr2upiyejlHqrSq7tnqTfjgPHxNHwLzJ3ef3n3yoTDDA1SXpU27D250ztwRCFusVvakoX0Gg39Gm/XVVvKF7/EwEYEt+qs6CVa6dL++BW
 ++5vRgpx5CTxUK8QYx3Eex5r/RdCkd2McjdFHWsutX1pXmQ4ArMJsXnntA9iF3YtcadtUTOQCeXDhvgElXifMYMpG/kghcZ0T15uy9qctbSRPgcTcC2rgSnT
 kM6QpSpcJtnpbWmdYHjYgP75YpanYkw6Dvrflog8Zs27Kz7Gndxy1FJVs/bmVWca1HRoQjFlI3rigDUc001ddm+N8cUEBdjLsqxpJAx6tMwpRQkS3L4LvrOO
 NnyL2XfWfOhgH/r1vvyVZ+7vPV/rA+ikJLiXsd5ZQTB/YYauvSTk8ynqAgGKaZsyTKjdy+mTwzFcV9s+T/ohEnqCfprfXEzlJtAvrZCTa4DWYw==

The scan drops every component that publishes no master or slave
wrapper in the EROM (NMW = NSW = 0), apart from a few known cores,
because without a wrapper bcma has no agent registers to gate and
crash. Since usually bcma is loaded early, it ends as a loop-crash.

Some backplanes, such as the integrated WLAN of the BCM6362, have
no wrappers on any core. ChipCommon and the 802.11 core are gated
through a SoC-level register block owned by the host driver, whose
aread32/awrite32 ops emulate the agent registers, and core 0x837
needs no gating.

Add a wrapperless flag to struct bcma_bus, set by the host driver
before bcma_init_bus(), and accept these cores without wrappers when
it is set. Other hosts keep rejecting them.

Signed-off-by: Alessio Ferri <alessio.ferri@mythread.it>
---
 drivers/bcma/scan.c       | 6 ++++++
 include/linux/bcma/bcma.h | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/drivers/bcma/scan.c b/drivers/bcma/scan.c
index 983a62ddeebb..ef880b635971 100644
--- a/drivers/bcma/scan.c
+++ b/drivers/bcma/scan.c
@@ -318,6 +318,12 @@ static int bcma_get_next_core(struct bcma_bus *bus, u32 __iomem **eromptr,
 		case BCMA_CORE_GCI:
 		/* Not used yet: case BCMA_CORE_OOB_ROUTER: */
 			break;
+		case BCMA_CORE_CHIPCOMMON:
+		case BCMA_CORE_80211:
+		case BCMA_CORE_SHIM:
+			if (bus->wrapperless)
+				break;
+			fallthrough;
 		default:
 			bcma_erom_skip_component(bus, eromptr);
 			return -ENXIO;
diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index 7ab2b21e7238..5dcf877e2872 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -365,6 +365,8 @@ struct bcma_bus {
 
 	/* Backplane registers, EROM included, are big-endian */
 	bool big_endian;
+	/* Cores have no DMP wrappers, the host ops handle agent accesses */
+	bool wrapperless;
 };
 
 static inline u32 bcma_read8(struct bcma_device *core, u16 offset)

-- 
2.56.0

