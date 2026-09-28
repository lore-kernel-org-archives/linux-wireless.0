Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602F94FECEF
	for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2026 21:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790631209; cv=none; b=ff+D8fkKBDfW79a8pI2iogrwzIqFy0uG42QVNd5MQGWlw+vQ6soVzNjXOSbLAlPNI9TXSkxsxesyxxRFOuK9VN1LazWlKfzEDhQn9l78MK+FpesdCQ/0dc6eAeAFee7n+lk0UNkj1xnzAmfUxeFkShpHqvtCd0anxd6zMrH6S2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790631209; c=relaxed/simple;
	bh=yQmN9ueNDx7oub64Hh/xzDJO6RCrU+L/hm+XnPcuf0A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VjMKexfUOQLS8aitnYmN7WRDogu0C9m5M1E6YIYQKqboh6MShWiY6iQXQZV4bkqQhPUvcP0N8xXjH42eEnZ4RNv46L9lKtnINcKZgOiWEhDsr7kFuigy8u5aSwkBZX3yMgEslqU2obr1iQaM82fiV5j+uJQTFmGK8x/7tENxHIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=perenite.com; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=perenite.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-485984ebf5cso2807986f8f.0
        for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2026 14:33:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790631203; x=1791236003;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wyL1tn+mP5nVx2w+7Pq20gMgeqZvEvpVrUK6ny4B9pc=;
        b=UKWJ+lP3e9uou8eZST7Usl9HORvmVsrtJW2NOXedxND7erNDXrc1hxi3FrnchqoqLC
         bnH//oHD9ZQ5plWUm3rAaGXe3CzrYjPGgnkJuCrK2JTu/jvIkMQvHHb2WoxSc8qwjSgk
         KJXn9TJjKRDFF1giEqeKWzOnXHj4kLqZupu1FZ66vV87IdECuFJ5qZQ+fxpmGCaquTGq
         qAnRq9yMB0Pjpk4PUCPop1lnadIO2bfQANTv75MYtKWqt9nVctIaWIh7nmNUaXOqchiP
         mVm5YCKzhKrtecIT+Yxr7SKk/kYn6+YDAAgb2B5tdnpgfnFip3oRAtOsZoIai65zxLiO
         PDfA==
X-Gm-Message-State: AFq9FYKGGUWPmxpKZH/NjiBKFP0NnQU/jgu97sh2Wow4z76IT6yv7eZw
	IvfwXvpDsHxB/z+fP/Bapb9vtcl5xAsdupGpwkldm0B9u/lb7QvU+qlIfTRP1rsCkG8=
X-Gm-Gg: AYBFou25hb2OlbY8i5uYP3kcmLg4vJ9qIfOAcPgE9OrBhUbLmqovIXJO5567T78ATjc
	I+t/AW7EXezSUSZGSnaUxrGUmbV5+R4kVjI9HdtZtBGV28eefeV6H95FlFrsoQym/LIKHQ2iz6P
	ngMr/C6U1e+urUlOFFuu7ILE8/e+XLMd7ktV3l0rfitTIxgoWf0LNHIcn9fO6mjzvkfaCb8zr7z
	CfwKtfJ+i53ZTfJ2MSZBYloDYFe1GVraD4bUtgSsuafLngEOPlaf+TJZWvQbI8MueDDjSI1lK4L
	poTtc5iMj2pJQTV29bYgV+Hm48sWd2Wx33PS/TA2esUUe64FQkI674igNC9Q9C8gqOcvScq79Nk
	Aa7rzWLCrRNrjY27vbG+QhwO4oK9350B7FmqpRJ6XjQ2WrzZHGngv9wZYkNscS7oAZB1vxM8Bxi
	r4CG7TKSIDo2veS49HuPJZQ1Fbblfsqw9NUHOFPQ0DBDKPHCOWJx4dw/TLMrLZk2v8yEk3bbW6g
	c5XNDDX01AtpA==
X-Received: by 2002:a5d:5d12:0:b0:48a:eeef:b4a7 with SMTP id ffacd0b85a97d-48aeeefb641mr1919631f8f.48.1790631203458;
        Mon, 28 Sep 2026 14:33:23 -0700 (PDT)
Received: from mac.net ([2001:861:8b92:2c50:ca1:5b1b:d140:af71])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4887a34a4e9sm25993824f8f.11.2026.09.28.14.33.22
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 28 Sep 2026 14:33:23 -0700 (PDT)
From: Benoit Masson <yahoo@perenite.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org,
	ath12k@lists.infradead.org,
	stable@vger.kernel.org,
	Karthikeyan Periyasamy <quic_periyasa@quicinc.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Benoit Masson <yahoo@perenite.com>
Subject: [PATCH v3] wifi: ath12k: assign device id from the WSI index
Date: Mon, 28 Sep 2026 23:33:22 +0200
Message-ID: <20260928213322.98949-1-yahoo@perenite.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Devices of a hardware group are added to ag->ab[] in PCI probe
completion order (ab->device_id = ag->num_probed++), which is not
stable across boots. The wiphy radio array is built from ag->ab[] and
the wiphy device is taken from its first entry, so the wiphy sysfs
path and the mapping of radio indices to bands change on every boot.

Persisted wireless configurations reference radios by index (e.g.
OpenWrt/hostapd "radio0"), so such a configuration attaches to a
random band at each boot. This affects any multi-chip group with
single-band radios, e.g. TP-Link Archer BE800 (three QCN9274/QCN9224
radios in one group).

Store each ab in ag->ab[] at its wsi_info.index, which is derived from
the device tree WSI ring and is therefore deterministic.
ag->num_probed remains the group device counter. The unassign path is
unchanged, it already indexes ag->ab[] by ab->device_id.

Suggested-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Fixes: 6f245ea0ec6c ("wifi: ath12k: introduce device group abstraction")
Cc: stable@vger.kernel.org # 6.14+
Signed-off-by: Benoit Masson <yahoo@perenite.com>
---
Changes in v3:
- Expand the commit message with the problem statement (why this
  matters for stable).
- No code change since v2.

Changes in v2:
- Set ab->device_id from wsi_info.index in ath12k_core_hw_group_assign()
  instead of reordering pdev_map[] in ath12k_mac_allocate(), as suggested
  by Rameshkumar. mac.c is no longer modified.

 drivers/net/wireless/ath/ath12k/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/core.c b/drivers/net/wireless/ath/ath12k/core.c
index 99bf5cf..6505255 100644
--- a/drivers/net/wireless/ath/ath12k/core.c
+++ b/drivers/net/wireless/ath/ath12k/core.c
@@ -2029,7 +2029,8 @@ exit:
 		goto invalid_group;
 	}
 
-	ab->device_id = ag->num_probed++;
+	ag->num_probed++;
+	ab->device_id = wsi->index;
 	ag->ab[ab->device_id] = ab;
 	ab->ag = ag;
 
-- 
2.46.0

