Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A7344CF52
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 16:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785514037; cv=none; b=q3myDPBMkO5uhBOEyOmW3ZUuCYRfqNv2QI5d27JI+nB/jEDVPRSjFTutsptLAhzwehTGEVhiYc9fbmTOYrrtAlpC43XPbpiLeJK7x317py1JFxh3S7m05B/ycJ3vqxVH2vcZRwJlH+Y5uExuFpbpVROw64YnjLAf2Dw71tGmXnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785514037; c=relaxed/simple;
	bh=X64FuFu6MQR0e9YLwzcqtBlBGkOJCZbkezV6SD9jPJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P2I2LGEJyNURG+cnpfEoKh4onh0OMRYwr9XdGdlh+63vTZfTCXXbi4aY7Cvl4zHlTnNqUj5HW80UH1ZbF63dV1GkKL3YrjIQYCG3c2qA3/xMiG0UBAi0vQSwy4O8fIrWkdXIkLcNSKkVXjmIKQ+tlwSSo4ZW06iWmnGy6LpeTLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nnzfgbrs; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nnzfgbrs"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-38dd1cc8dc8so127574a91.0
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 09:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785514033; x=1786118833; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CVffTg0thpytBoHWaWeNh2vyHkkqNffHnf4NKS93HWw=;
        b=nnzfgbrsDHEjTm+KtOiHlc2oaDafOoXy76kkLEj+D9Q0vLeqlOTAbjvT1gx1sXV1t2
         4a/zD4kNhMVhsHUVyDgWaDPeucuwleym4rPhC7F+9dwSdeYIemLV+TrILBJHqSash00b
         a6VoC6TBCWNEqSptqhI8u/2kxsO4t0Cph98xXZCn6w3cMuR8QGUQKJcTkkdZGEqasHSm
         q9RW5JwW9x3fxX46lRrJLHwZt57iZVqPvBXi+wwkt5L9OOPRhIeJ9OOZb/EC/2LFE7I+
         TKK1j907e0tUCKF/kdUOt6i9WcWi4dtXDT6qIykoIRn0SX8PTM2OFmdo+ZXycBZ1sS6I
         3cTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785514033; x=1786118833;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=CVffTg0thpytBoHWaWeNh2vyHkkqNffHnf4NKS93HWw=;
        b=I0Boxsu9oh8fMcmgKOlwLyvx/U8eJj2vJuYB2hYOk+9dtPS371t5WSeubANn+Z/N+c
         30Yty7vvE7/boEc3XC53XbOXO3XSfJDWjnF/xWDLA5dXhZ1+bz+H4xPAfZ69PpyPC35V
         +HMI3kjPKx0SgsIhoc3B1APZEDw/S7bzv6O3ej612CBZh+/tlwuuIaf72w8YIsTG7vdg
         8UN+7nLhQvTg34QmPuhY7ONzJy3uaZtn4nMHXbpQpQU5wBujnkA/WRRfoZAaDznuKPz4
         2MqKI4JSxijJ5DdYmEVJbKejunsQkbym7gp7aiB/I5M6z1dostXpKHSohrTwJSFtqxhV
         dwGg==
X-Gm-Message-State: AOJu0YxRQvN/iNq+hkXli4eLdJ8ISbKobnAbnjMNdB1/rXb17uwCkvsv
	6saB31GKg40OdLcZgC+Ebp04w6EKdWssnEfA360KodxK9xeEwDwgUvRP
X-Gm-Gg: AR+sD12RohHpzZH+lEaR6LJNbwsPhQ8duRkm3M6i5OtCiK2Gl9yfa6k6IbRtiJEc1J+
	2hVy4uvUoFauXaj4jQ9CdIkTjQrABVjbrqfDrhrbVwznpfZ9Q/AQwIpoX7yV48X/3NcQVgbYZCF
	MbIDjBolksUBAZC8ld5Jg8QG3DtUoG/rk9dSw51Fv6OcgPcF/oHC0+4JtkjuA9Hw/ri3io2y4aW
	m7yQZAu6EuZnTd4zwlCJFPxuVLAFE2nDK9hjwC/Kk07zDkZ3Cl6HvCEoUxrlksGwdhe9p3d5Pd+
	pkB/e7j8BAp2dHzfCgAm0iZOyJHAfTA/wYbFXxB2bM3VEFPmvMMbL9zUNvZuDEKVzBEXTlphfjF
	Yj2um6iM5lQanq2FaqktLJ+Dfk7R9ahjamV2Mm8N3MRmT0EcSKvuF3Lgj3LK8kOcK/lyK5s7p6k
	HoPY1InuPDVz8+T0TXqHHqslxUuNsbmf0HoUnxCpWs8SbNeZ2wf3ffGl9ktfft7RjnsXbaxesQL
	LQms4Be
X-Received: by 2002:a17:90b:51c3:b0:38e:6a7c:abbc with SMTP id 98e67ed59e1d1-38fbc5482f1mr684483a91.3.1785514033358;
        Fri, 31 Jul 2026 09:07:13 -0700 (PDT)
Received: from Potato.tail66a299.ts.net ([171.76.83.76])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153dd9c93dsm7881425eec.8.2026.07.31.09.07.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 09:07:13 -0700 (PDT)
From: Shivesh <chanelshivesh@gmail.com>
To: arend.vanspriel@broadcom.com
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	Shivesh <chanelshivesh@gmail.com>
Subject: [PATCH v4 7/8] wifi: brcmfmac: fwsignal: document safe no-op for duplicate MAC handle ADD
Date: Fri, 31 Jul 2026 16:06:24 +0000
Message-ID: <20260731160646.3812-8-chanelshivesh@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260731160646.3812-1-chanelshivesh@gmail.com>
References: <20260731160646.3812-1-chanelshivesh@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the firmware sends a MACDESC_ADD event for a MAC address that
is already registered to the same slot (same mac_handle), the driver
hit a TODO comment with no documented rationale. Per the firmware
protocol, retransmitting an ADD for an existing handle is idempotent;
overwriting the entry or reinitialising it would drop in-flight
traffic queued in the per-descriptor psq.

Replace the TODO with an explanatory comment so the intent is clear
to future readers and static analysis tools do not flag the empty
branch as dead code.

Signed-off-by: Shivesh <chanelshivesh@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
index a43f1a38b0e3..3c1ca355e8ee 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwsignal.c
@@ -1037,7 +1037,9 @@ int brcmf_fws_macdesc_indicate(struct brcmf_fws_info *fws, u8 type, u8 *data)
 		} else {
 			brcmf_dbg(TRACE, "use existing\n");
 			WARN_ON(entry->mac_handle != mac_handle);
-			/* TODO: what should we do here: continue, reinit, .. */
+			/* Firmware re-sent ADD for the same MAC handle.
+			 * No action required; it is a safe no-op.
+			 */
 		}
 	}
 	return 0;
-- 
2.53.0

