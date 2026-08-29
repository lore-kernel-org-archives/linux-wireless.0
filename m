Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7CCA3502A3
	for <linux-wireless@vger.kernel.org>; Sat, 29 Aug 2026 05:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787982266; cv=none; b=HjzMQfr0WXNoTIUnQLASaw16lU7tTwydU0wXPbUpxc9eJIYx0Rjb5//yvdAYy4+VfYUI0l3mEGwcXkdsrCbWOP4v+C9SohLB7cMKFV6gtZ2UNFHIi29lM1zZBmG/gXybrrNSgqsQuF2NhmmW8YuGo4XJaZFqT9ik6wbCUY8lTdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787982266; c=relaxed/simple;
	bh=qsFwjBfu2NKtEcsDviKHxw63ntmppkT8r3P6UxlkbOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mU+T9Ia+c19Narvo3gdzexWMEpYYlaMSIiRIHehqZYapkEIExmcRfSZeTLULeNUbhMWUX/aRRYwJNZg0VpNrPqkbJHAJbpAhoNe01VH2wpug1toDG0qMjCwpQTGISmzlCsTdUH+/aDpC4MQV/pGF56gH0ZzajkC9AYyOaPP4iKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DwnJ6Xbu; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DwnJ6Xbu"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5b28c91fba5so2039077e87.1
        for <linux-wireless@vger.kernel.org>; Fri, 28 Aug 2026 22:44:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787982263; x=1788587063; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:sender:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ShvhKa6MyfZ1jEWheQQ6SuhEnn7upG8Sh84fZvzR0n8=;
        b=DwnJ6XbuW9HyStr/+sjdmqX/1p3AwRzsRfcaXD+7D3hY5507Q3LcyEpzMljSfekt9D
         JY9UEtaVycKVOzZldxacosJEtlpNSpzoBd1R9R+D56FoOoZqPWJu5kZx/OJTZnSWg9r1
         NzCnCnPXdOWyAQc9WBp7Y1tf2q81PWfPjDnwgknUHK5PnV+KYkXcJJHWNBC6E7eHB1K0
         uLIh9NPl8pVlhqekUUKmCChpli2UCKFNw/BxvaQProsf+l3NbEy93sRQv9MhL8/jYjeT
         2vuMNtHeBfmlfa4pThNnkpYqnnXMzbtDOoyfh2p5vSfEUoCHjrjCm7L4aqvsE6SrKgwC
         YARw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787982263; x=1788587063;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ShvhKa6MyfZ1jEWheQQ6SuhEnn7upG8Sh84fZvzR0n8=;
        b=qFQPjb1rudpkNcGNaABSvDzC6XRcwSM1kIcuUD8DT1WE/PNJ3cBZnB/jp8frj2CIiV
         t8G90hUAM/E2dcXtgioHKrZPoj7mGoAkQ40eWh0LS9oCJ4/qtd0RBnBvJ27XndizmRzf
         z0//Qdo1nIe3qeVRlXyaNpX78z2IyVASljZmliFcslCPU+ZaqUq/yQzzW7+9i4o/f0hP
         tS4EYPxTSSTlW3/yR6aC2DQ2COSSrCFSqYFxoBFh2/atbZNMuu0wkcw0eq675rd7Omvc
         am32rJkKGbYncSWmhI5s7JEnLGLMjqcZoEKo6Qr4xQHlpGF05ydJ5ucR3Q8sbcE6JpMx
         5L+g==
X-Forwarded-Encrypted: i=1; AKwUvByLQX8OO1QdGBabkuMxjPytOTFNPsUw+xjGm5v8ytHWBuSX11DWBnBSToAnb0Ue34xrHo/KDiONQHEV1qKE6w==@vger.kernel.org
X-Gm-Message-State: AFuF++ln/mVXw9gmhqjc1ZQGgwOB6mByU5lLU9SGUc4wE/20kGqYEKS0
	l5q87GRuGS4epNAaykHKvXDpf+V8Dy+6SzGBd1ShD94dpY/S31RhNXbnSlIr
X-Gm-Gg: AYBFou04bmLHyjl91EetTvPdpC+vc4Yyy5b/63xoOycgErrUORRmeoT637vrWmqrhhy
	QHIyZrGwSrq+EW/TjhHv9hGm+Pyojksb20lSUJS0TO/bntAsz5F3IO0YQdB0ZU7BT6RwRWv1ibo
	4EmqnncatgCWjSG0E+DZoihNiyFeLg1EwYaxsuI4nP/gaPtaKncestHWIA2p4gqhIpPGV9Wm93a
	jBOzWXeXys1wMHHeNHIdVP/2otKX6Jjfi14tZamn1PKCw+xMAhbxuW2C9Z5yCQwJMOysNwJ/yOh
	2hNlOBg22rjmykhWR3zchBzQP7U6ifLAvifxX4HO7VV+tE+c289Vf9JoJWj5Wyd9/qNnkWDXwRx
	hYbkvl8kjT6zpW/dlOMEUDW3UQwEmQjf03xdGLS48qSMFQjVNih3/iOA+BwPGDh6PJLl/1zqxFa
	Kcp7vpcrJ6b6OnwCEIUsDYNteByL5ogwD9HT15xg+UuVleaQAhWlmyf/5eeBg9jSSIZEE2g++Yi
	nY4/Ur2AHTQzX5r5LCAVU5BG2ZE//S3Lhc5Dzx9G3VyjWv9Pq+tmj484WsNGqXsIQMyxVafM9Ba
	JpoU
X-Received: by 2002:a05:6512:670b:b0:5b2:a22c:50ff with SMTP id 2adb3069b0e04-5b4afeedfe6mr4552889e87.19.1787982262802;
        Fri, 28 Aug 2026 22:44:22 -0700 (PDT)
Received: from nn ([2001:1ab8:1003:0:5454:f357:ba89:4e22])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b5e89c5b86sm803040e87.12.2026.08.28.22.44.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2026 22:44:21 -0700 (PDT)
Sender: N B <gen.benner@gmail.com>
From: =?UTF-8?q?Nerijus=20Bend=C5=BEi=C5=ABnas?= <nerijus.bendziunas@gmail.com>
To: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] wifi: ath9k: skip the departing channel's noise floor on USB fast changes
Date: Sat, 29 Aug 2026 08:44:01 +0300
Message-ID: <20260829054401.1198574-5-nerijus.bendziunas@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260829054401.1198574-1-nerijus.bendziunas@gmail.com>
References: <20260829054401.1198574-1-nerijus.bendziunas@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

ath9k_hw_reset() reads the noise floor of the channel it is leaving so
that channel's calibration history stays current. The readout is several
register reads, which on the USB devices are as many synchronous WMI
round trips, and a frequency-hopping monitor pays them on every hop for
a value that only matters if the radio returns to that channel later.

Leave the readout out when a fast channel change is asked for on a USB
device. Periodic calibration refreshes the history while a channel is in
use, and the arriving channel's noise floor is loaded either way, so
only a channel that is left and revisited without calibrating in between
sees an older history.

Signed-off-by: Nerijus Bendžiūnas <nerijus.bendziunas@gmail.com>
---
 drivers/net/wireless/ath/ath9k/hw.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index d204cdf3fa8f..64fefbec46d5 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1878,7 +1878,13 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE))
 		return -EIO;
 
-	if (ah->curchan && !ah->chip_fullsleep)
+	/*
+	 * Over USB the departing channel's noise-floor readout costs several
+	 * round trips and only feeds its history; the fast path reloads the
+	 * arriving channel's noise floor regardless.
+	 */
+	if (ah->curchan && !ah->chip_fullsleep &&
+	    !(fastcc && common->bus_ops->ath_bus_type == ATH_USB))
 		ath9k_hw_getnf(ah, ah->curchan);
 
 	ah->caldata = caldata;
-- 
2.55.0

