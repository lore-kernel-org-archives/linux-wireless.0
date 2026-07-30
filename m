Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B231469832
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 16:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427495; cv=none; b=cTbe2zXPGXak9IurRPmJCwWNq3Q6MHaoD3tBWZIKxf1PnhD/fh+61vwplZoGswxPWBxoXi3FGdUBG1hBgvN98mudc+vqdCTGf0y9g7mdSxL570iGwOgFv9hlfT+MRXG0SfkcZbJsiZ3cIHExwjxxgR7mpycKbDn249DcY1w9ibs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427495; c=relaxed/simple;
	bh=p88XlrozqCp0s3F6xoru/MvtjflcfHotb3mOweyKOX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iZr+6fD5do74z79lhpyTXMP69zg93sBIOmk6DSwE2O+R9FRJubDlZDOEo99cg27FbK8qqjtWybvjjYLkDlqfZ7MXZvRpXYLyrQKH+RKHo2PQ0Pdzm5mPs997OEad6Aj1NFj+bQPfludi/gD2Cvmv3uMZbUzb0q+GPCHzjnjzcw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M/wxPg2I; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M/wxPg2I"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-38cfcb507a3so5655a91.0
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 09:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785427494; x=1786032294; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gTi6VJL4D2x6nJ6t6S27JxQ0hh8cwm7AwOqGNxZS6p4=;
        b=M/wxPg2I2AQhG69R01+nJDGOzBiqu4uvIBSOMB0eEseui6hEOhgF+bE4QWVdgs+NYt
         cT5LN3v+OLAmkRO2YDhpFtuoMssNpVftoYXkGWeazmSfhcJymPCJQAsoZ1BitEa7WkXW
         xY8Sbor1TeC9UZg+jNs8R29f16klfUjEheV0KBQ+c+/z+L7FnRCUITAwSKDLopzCD7zO
         cpqROmUBBbtBlFUbYfr+nUJ7dkLS63A+Qb37/tk+/L6jgLKzQoPy/rMO0UYMhNKm6kcT
         elKdEiFHKEFh4wsCa2a6BHnVMkDJCx7B18m0jdJiiwc8koDY/fIelJbqg3ZhhnoK4zfZ
         P4PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785427494; x=1786032294;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gTi6VJL4D2x6nJ6t6S27JxQ0hh8cwm7AwOqGNxZS6p4=;
        b=dYcXAfDopBOWTlE+Izqkk9Aknk+14QsqwMyrSHO0neFpoqTJY47JK8DE/joQod4kIM
         sZzM8eDKYnS3xIPi1kGnO7Fqpg8BHjtzU14THFS8DJy70vv40tp9o3ElUttItkZF4Fo8
         AF1OvtKHKR7ih34dZHd+A+AygzlAe/1me0+26meYccAu+UXsK+dGktRX2I1/jRqzhFlV
         095lf+5Z4/FLTtHD1/xjbpk4wCNCrpP64gh3IE2yUsQQyN7JK9s+V22YnFslAiR0Qz1W
         c1+Pc77qaeDlFwc+5XbuzokgG1WAlXqXe5R9mA8jrmq2TWNMDbTUJvL1VkYLViCjG2j7
         l/1w==
X-Gm-Message-State: AOJu0Yz5vf9wea8oh+o/K2eY6StX9drgRdmPTNhsVleiPsqz4PDD79T0
	oJKud/uHjYqvCrnmvEtQeSYp24OV52GCUApvr84J5KQp3qLHLJ1+gB4Si57nQEKMN8Q=
X-Gm-Gg: AR+sD11/MfgxIv2P837gkA+GIzGf/YNJFCJ7gOZmRpYm0MqBC6xxTcN+vAKayBNXTzg
	6VRHd4G1/lbLfvJC48Fz1RPCZtB5Wh9ktcorQe/0ubLHfIiq978WRhKxa8ibmlFL3Hm3/tIdMnT
	Fm0XC65C0atT+DyrwqP18vTTQud0GbyWV8xlADZm6HXXfqUusGASnWZv1jhifXhV7scRpJtWlmY
	0HbkUveFX2w7V+0araYUJ0huRKXb3In7Vs01p3Xp2z4H8zre6t6qLiZ/lbYMS29dX2z9yJtU+DJ
	OiIgNxQ5RuPOco0jKUfTU3A8i8fCC7dHLk4r4T2ZFnV10tr8RzjNNwEDTsFsY4mXMJvOWBfDpJ/
	lNitJGLZTdLFX14IChDNxAoUxiFTXI5fsdfSPluKht3Cnb+rgOZEAqiWGeV4PeA8f4tR6zBRrlZ
	gpFxdmlT6SEXCyvAh03g/3/yvexGUDuPo1R2IsBEdYzI8fbaLkbO8q7IQ+qlbL5d1fsN2+AXkzL
	o0=
X-Received: by 2002:a17:90b:1dcc:b0:381:bcfb:e710 with SMTP id 98e67ed59e1d1-38fa8041704mr793333a91.3.1785427493649;
        Thu, 30 Jul 2026 09:04:53 -0700 (PDT)
Received: from Potato.tail66a299.ts.net ([171.76.83.76])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13e72643a12sm35012783c88.5.2026.07.30.09.04.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 09:04:53 -0700 (PDT)
From: Shivesh <chanelshivesh@gmail.com>
X-Google-Original-From: Shivesh <shivesh@example.com>
To: arend.vanspriel@broadcom.com
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	Shivesh <shivesh@example.com>
Subject: [PATCH 8/8] wifi: brcmsmac: ampdu: clarify standard compliance on QoS change
Date: Thu, 30 Jul 2026 16:03:56 +0000
Message-ID: <20260730160425.11933-8-shivesh@example.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260730160425.11933-1-shivesh@example.com>
References: <20260730160425.11933-1-shivesh@example.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Updates XXX comment to properly reference IEEE 802.11n requirements
that all MPDUs in an A-MPDU must share the same TID.

Signed-off-by: Shivesh <shivesh@example.com>
---
 .../net/wireless/broadcom/brcm80211/brcmsmac/ampdu.c  | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/ampdu.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/ampdu.c
index fc7a5dd2e5d8..3fd8bdbd35e5 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/ampdu.c
@@ -516,12 +516,11 @@ int brcms_c_ampdu_add_frame(struct brcms_ampdu_session *session,
 			return -ENOSPC;
 
 		/*
-		 * We aren't really out of space if the new frame is of
-		 * a different priority, but we want the same behaviour
-		 * so return -ENOSPC anyway.
-		 *
-		 * XXX: The old AMPDU code did this, but is it really
-		 * necessary?
+		 * IEEE 802.11n standard requires that all MPDUs within an
+		 * A-MPDU belong to the same TID (Traffic Identifier).
+		 * Since priority maps to TID, a different priority means
+		 * we must close the current aggregate and start a new one,
+		 * so we return -ENOSPC here.
 		 */
 		first = skb_peek(&session->skb_list);
 		if (p->priority != first->priority)
-- 
2.53.0

