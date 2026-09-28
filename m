Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBEC54E66DE
	for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2026 15:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790610220; cv=none; b=NfnKN5e19g1afih3WY41G3FysdhJoYUvJPRDD7HaBmufJoiJQMXS6hHoFbPOq4+o+4IiO/0AhVrEDynosMzWDl43gJXmVzj7/rQRZZqqPZgJp40DHO7dWBkZ2pf5PxM/XPiMXxVNf58+aRwjf5GgYv30Qwwhp/mxI7i4MeC0NKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790610220; c=relaxed/simple;
	bh=lR1OH1Lh86PvSuqYNjDEJkms00P0n+PsbhlW8mwYc4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GxSzbZbR0G8a5++5nHv5xFagHq08MxG+/SRGyMy/es1vaFkGr/2stB6yhPOS0obSdG7OmfP+tCkjM/Hamns1wWLAULD1D6hEPWXJ6n+o11gtF7D6t/4zH0fFXCwocnfhEYvat9QZDK8ONegT18/Sc0ykWXletpxkh5DGdKxrRGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=perenite.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fu24EUgM; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=perenite.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fu24EUgM"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912df756so25186865e9.3
        for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2026 08:43:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790610217; x=1791215017; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7u9FRFVW3KTnKbu7qJYW4kd/AKeklPQypIZL2EecgFw=;
        b=fu24EUgMw77G4gE0MwowWsOoxN8LBL/OG41YbOtAm82nEaskdqjFfCYEWrjtQeHLBJ
         j0eA1Zyk8l66/dxIXiTgGb6CPD/OiF0lIMZIPB93PZ1cgNKIRZKIDytwdkrC4MvRBrzp
         Pr0kdUyuxEF4RF+FhrsSe0g6dDNQfsmSjWlgEfu6KmbYfvjqubQz4oC+1EWGEjyxgVM3
         hkogyDGljMj1KHAo4xaW0sFqOr6us5sl8q7G1k9qpNk9ajGoG5lgC377KLF/jjGMR0mx
         MNI7MZG7mi3fkpWLuMdy+tQwA1jfiyNYgQ6ep0yh3BQ3g4C52F/F7g5JishgXzyXEVw6
         hbaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790610217; x=1791215017;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7u9FRFVW3KTnKbu7qJYW4kd/AKeklPQypIZL2EecgFw=;
        b=aTLZqQPwKittVY/kgte15Ph93TwYOJ6hX9mm9fpGIXSy4Aoffc4MNoZji97wVO6Be4
         EzMdt7yDbB1Owxl3gWZzl8a7JE4KVz0ku6WZmFwxRBLbhRgHIJZYR9munbggAO+7GWCF
         tY4GsC+rBPzTmYniQVp4Wo9PNOfCyfeygfzvkDSxNIbZ2u0xvG+sQHqbYaLQABILb3Rx
         ZZxpx9/IoW7p6oYKoZW05+Ik8FDdjilMwGLafB+rws0gCg6+2SFb1WzO5OlKmwWEB9ob
         Qp3Z7NgHSZg2CFB//xfmUkWh4oaddqHR+2Yghs4uF4E2zBz57fytMLk/Qr3qVi0nY/mr
         /TDQ==
X-Gm-Message-State: AFuF++mO4JLtZE+OErmSP8IsWvqdK9uHDF+X8HWZbD2lAZeJ7x5wkYTb
	hjE7/Apqnu33llSndb1vU2WRfJmsdLpDun8SQ8I7dXtH9Uey9+2LddM9/+5n6buv
X-Gm-Gg: AYBFou3J5a7jZToTnM8lpXrw55YdGiDbcRijCGRe88HPqI70E8vkPBeDKzc1v6CBwMg
	RIZM3/HdQQst6vg/lHRFwOJz62j0L2BX/48iZ65ZsV3wr0so1PUFhp21RwFewvuDlYHeu7Ya66Y
	0uiad9bbrXw5i9lkq6xTRuOIpC7y9q5DDsPCBCPFRWNMFJcqvbB/jKddMytwp9r9HJPFWxcpIk1
	FihdcbTKC6j9YHze/XGmn5uLM8Y3DX/ucTVSftUqPzvgLfI9lPPG2yPgplkYcrUI6bUo/sxr3jI
	nZUA2DJtMo8kzrsnmniYR/1WK29OpQO1EZIpfnkmdcFiAEgR9CDmh1IyrsV3wW7g/dj7rkNUky2
	aAfuTnUqyv3yMVj0KdVzXJJ1pM5JbHP68QLM43JEGR0gO7e3VOxWtRhDK2PblpP+dXpjxVzPZEF
	YbIvnepjPQwYf4Qj5dAIZxW2uogZmLL1A3UUFhBegYYXQKRC9oYoGP1YNht9TDCfR2dzAQaZfHa
	LXsS0k/xZSTmA==
X-Received: by 2002:a05:600c:8b6e:b0:49c:fc6e:8cbb with SMTP id 5b1f17b1804b1-49fe66f9fe3mr237154055e9.31.1790610216934;
        Mon, 28 Sep 2026 08:43:36 -0700 (PDT)
Received: from mac.net ([2001:861:8b92:2c50:ca1:5b1b:d140:af71])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a0062de83dsm48611855e9.4.2026.09.28.08.43.36
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 28 Sep 2026 08:43:36 -0700 (PDT)
Sender: Benoit Masson <benoit.masson5@gmail.com>
From: Benoit Masson <benoitm@perenite.com>
X-Google-Original-From: Benoit Masson <yahoo@perenite.com>
To: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
	ath12k@lists.infradead.org,
	stable@vger.kernel.org,
	Jeff Johnson <jjohnson@kernel.org>
Subject: [PATCH] wifi: ath12k: assign device id from the WSI index
Date: Mon, 28 Sep 2026 17:43:35 +0200
Message-ID: <20260928154335.85628-1-yahoo@perenite.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <3cd93e83-6103-457a-8879-bef8521bef9e@oss.qualcomm.com>
References: <3cd93e83-6103-457a-8879-bef8521bef9e@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Devices of a hardware group are added to ag->ab[] in PCI probe
completion order (ab->device_id = ag->num_probed++). The wiphy radio
array is built from ag->ab[] and the wiphy device is taken from its
first entry, so the wiphy path and the radio index to band mapping
change on every boot.

Store each ab in ag->ab[] at its wsi_info.index, which is derived from
the device tree WSI ring. The group order is then deterministic.
ag->num_probed remains the group device counter. The unassign path is
unchanged, it already indexes ag->ab[] by ab->device_id.

Verified on TP-Link Archer BE800 (three single-band radios in one
group): the wiphy path and the radio index to band mapping are
identical across cold boots.

Fixes: 6f245ea0ec6c ("wifi: ath12k: introduce device group abstraction")
Cc: stable@vger.kernel.org # 6.14+
Signed-off-by: Benoit Masson <yahoo@perenite.com>
---
Changes in v2:
- Set ab->device_id from wsi_info.index in ath12k_core_hw_group_assign()
  instead of reordering pdev_map[] in ath12k_mac_allocate(), as suggested
  by Rameshkumar. mac.c is no longer modified.
---
 drivers/net/wireless/ath/ath12k/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/core.c b/drivers/net/wireless/ath/ath12k/core.c
index 262a204..f43319f 100644
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
2.54.0 (Apple Git-157)

