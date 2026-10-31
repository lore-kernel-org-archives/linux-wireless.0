Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.149.156.86
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793438190;
	b=h6zNFzY6wUL1X0YuUBJe1+y+JFO219y0f3Dayhh7y3++acDlZU8JPgylWOeJoTrJfjan
	 CB70T66th5Uvb+L7ILsG2UEMc16PGT8XIYHH2Ml5Bh2w//cWOtFNePI+0MmD6SRaG053f
	 kLPUIhbPNdlbKSCK+N/AwekqJ651lCrXp0xrGH8vbt9sM9pKHhgyvb097LpAGsF8+jFVE
	 u79JQuKoWcxEDSEKeOUjzcSKkwePGyyhttHLQUD3KfXbDWakuaw9hb/us4Tln5bJSUf9R
	 KYh/t3SkCfqvxcZ68n2o41ORhhJXZ82+zP6SdzLztBAgg9JPESeZRB+Su4e3ad2Q4Pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793438190;
	h=DMARC-Filter:Received:DKIM-Signature:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer:X-CMAE-Envelope;
	bh=ZT5ES7iCUGrHfIPoUjMqyjrbW06HQNL08TDdLmdJ9bA=;
	b=OPSi33RM2p+BgVuoGn/YG9TqX3Iz4F+kfdVNli+9+d4UyrxLbRIdSfAPZkxl+onWd35C
	 VL1eZB4iEpd34H5sr6IUIw8VrWKcPmIyx6ncykAwYglA6ZzFHd2CDJlcMHZHpifc/EsGd
	 ijDkgPyxPfQYo57cGqx8TtNlwRVdfE2w8ztX/T1AT6Sfe1VcxhHatzaOiA1OcTaOXVtiJ
	 y0esjtTqCMYDUVWWyLorReNbw9AiGaarUzVD7yY4dgXbm1ENTOssUAVv7WcCeALlXKO5E
	 OiiVn1X3XGDb8G8z4l+csFCJL5gpH3YdavyBOaGTaO4SMXJgbh9bzqjEfnLNv55CiIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mythread.it;
	spf=pass smtp.mailfrom=mythread.it;
	dkim=pass header.d=mythread.it header.i=@mythread.it header.a=rsa-sha256 header.s=a1 header.b=VmEeVKJq;
	arc=none smtp.remote-ip=62.149.156.86
Received: from smtpcmd0986.aruba.it (smtpcmd0986.aruba.it [62.149.156.86])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B77C606A31F
	for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2026 09:16:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3B77C606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mythread.it header.i=@mythread.it header.a=rsa-sha256 header.s=a1 header.b=VmEeVKJq
Received: from [127.0.0.1] ([79.43.52.162])
	by Aruba SMTP with ESMTPSA
	id N5BMx1hYL6q8sN5BRxVoV4; Sat, 31 Oct 2026 10:15:29 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1793438129; bh=sPLveYh2c5dZKVXqFU1dIE01tkyk2MNNwMVes4PnLCM=;
	h=From:Date:Subject:MIME-Version:Content-Type:To;
	b=VmEeVKJqjxrRZdtUa4Sxp5IEDYBJPir/hBtS2w9dTJez/KM6ZmVZGglQD4yM8fzp7
	 A2Fu7C5X25TQx3YgTLPbvM6oMrREuFzzpil6GYN3ZpnKLnH4Z5IOqFei9BnQwJxsWT
	 R3a8hfxc+jzqfF6nZkNhNvw0ee2VfFTrTE7F4EuOhx8PLRvP6OwqFvqamA22++WSkp
	 me88Oli24rPqaFdivsyGApT5m+6287MgAZ09PmYZFjzxABdsBZ/u5qldWpvL/vsYP/
	 fbSUfORqgjkUFl6jMbYvXQEiMztp6t73goiqmP+/I+sasroXkYn67FRVnGCVFtaRyN
	 dz/EwrpMau4pA==
From: Alessio Ferri <alessio.ferri@mythread.it>
Date: Sat, 31 Oct 2026 10:15:30 +0100
Subject: [PATCH wireless-next v3 08/10] firmware: bcm47xx_sprom: read
 boardflags3 from NVRAM over the SPROM
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
Message-Id: <20261031-bcma-ac-rev1-v3-8-1fbe38e8179b@mythread.it>
References: <20261031-bcma-ac-rev1-v3-0-1fbe38e8179b@mythread.it>
In-Reply-To: <20261031-bcma-ac-rev1-v3-0-1fbe38e8179b@mythread.it>
To: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>, 
 Michael Buesch <m@bues.ch>, vit9696 <vit9696@protonmail.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mips@vger.kernel.org, Alessio Ferri <alessio.ferri@mythread.it>, 
 b43-dev@lists.infradead.org
X-Mailer: b4 0.15.2
X-CMAE-Envelope: MS4xfBquXWVKbtw0SEhOKbdbXouZGKYZ2kXTor0QTiJO8zQvI85TLhqBw8PYg59AlNu1D76ywnY2MifXuPuhC8YHJRxx9Gadh1YXjDH/n70ilvRUd/nX5cgp
 LYOORtmUFcp1/HKwJDjHpM4WIggOKfwQ5MKsUM5uxr+9xszmNkdAjcu0zp/5Mw8LwyPyQVn2YO+689yVat7rW3goCXT0VbKBfdJ7c5Q2z7YyTrLJ9Fl6A0Og
 C0wY2Cx87zgQOYQn4QmwkZkBC+dm+tiRm5ZSDGTJa5miqfLDJQGQ1TiJUY1TApotFzYS22MXgKnD7kdhfXR1bi5PyW6E51WFFrRo7GOkNVA/IEWllvTfPWn5
 +dhg94o/yhFLdqpi1Gb3ZQxqMKuBeO33GWQtQnLuV4O4IFqY2lXyJ3zmcQzUSE8MpdG5z+l3KXxZQd0OWS+TflwWSLEEOw==

Read boardflags3 along with ledbh4..ledbh15, so that a value in NVRAM
replaces the word of a SPROM read from the device.

Signed-off-by: Alessio Ferri <alessio.ferri@mythread.it>
---
 drivers/firmware/broadcom/bcm47xx_sprom.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/firmware/broadcom/bcm47xx_sprom.c b/drivers/firmware/broadcom/bcm47xx_sprom.c
index 46a817d71..39d7ac8c7 100644
--- a/drivers/firmware/broadcom/bcm47xx_sprom.c
+++ b/drivers/firmware/broadcom/bcm47xx_sprom.c
@@ -217,6 +217,9 @@ static void bcm47xx_sprom_fill_nvram_only(struct ssb_sprom *sprom,
 		nvram_read_u8(prefix, NULL, name, &sprom->gpio_ext[i], 0xff,
 			      fallback);
 	}
+
+	nvram_read_u32(prefix, NULL, "boardflags3", &sprom->boardflags3, 0,
+		       fallback);
 }
 
 /* This is one-function-only macro, it uses local "sprom" variable! */

-- 
2.34.1

