Received: from mail-dy2-f19.google.com (mail-dy2-f19.google.com [74.125.229.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E813D331A
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 02:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790650746; cv=none; b=spJHYUjmwzp860yUUaGOv4uzd0+Evg+azngaMtmsKnPHls7YMA2kWImXaxMxShdMsaZuCgluBKBrX20cNeje01V2erfqlKxRZ7ECM6q7SdE2g92MmK1ksbyEfnJAdfiF2qu7tcsOgdfVcXtcCcphS9MCDtN5zKm2M3fWQBmueN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790650746; c=relaxed/simple;
	bh=HJyTeXVijHdk4eWMa4QoVfAxeX/wDGbJNl64bB2L/eM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qhHOpLsyMV3KrXQLgq/wQx6nM8N7GEAptcSdrJ/8sVIg4jrUTqPj33D95l7BJK2Bix708WTy59UUhqM0ebFpmq7fCk0ZHQFiekCSojFRZUSHdh8X4/7Xrs6ECBRKtSFTkBdyv0kaZWxqD0nAn8DRd7nSBKh0qERJc/zBlKbxdNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=adxscrNS; arc=none smtp.client-ip=74.125.229.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="adxscrNS"
Received: by mail-dy2-f19.google.com with SMTP id 5a478bee46e88-3413069aa25so2439300eec.0
        for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2026 19:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1790650742; x=1791255542; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=UFhWeC8nK54inRKs6I+y3KfLb6ie98THlXPGgVHMi+o=;
        b=adxscrNS0SZFlILvax0Rwzos3fkSpLC8i/kEVM/kXJ3D8ZD86ZQFb5k4bzeUy9/p+n
         jYDJLv+MggeJLPyBausWyooZaHjoTMxZDB5SImSzcvHM4tBwWHbwlvIQsds/7YekO0oy
         m/fqWezeDh0pOKZKNT7Fbet6NtOnAF2C5H72T6PUlci5PRGujDDrdZqucVDCFrB7OcyJ
         kCNxM9Uz42fVnW4K0ge6LNoYuP1NGuduAxO0fZ0SEJ5UqdWp0QMxbVIgo3cEikKmKI38
         D0oYEi59FtEsbAUYOJokjBY4/XKRYhwcbaNAASh1RCxSU8tuP8hmWzH+y8k9sTXlA1TA
         YotQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790650742; x=1791255542;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UFhWeC8nK54inRKs6I+y3KfLb6ie98THlXPGgVHMi+o=;
        b=MXHHV3Ha7cXRXO1NhnwRta/qQ5PPgOdAFFlMZm7wdE/4AKp6Hchnn1T1Ii+PDpJ2XD
         hlYvXynVfw/XA1xbe7yODs6POGohmMkb99PglbocT09JHxzJGdPWR9r8M/9/xzjmOvbn
         ycYpnDZESDt/WaP1NfpnT9OQJA07F0Dia/zTnpGciGh3WnSSgCMiKZldWgFBjXXe3wyo
         ePz9uekOeozlJXSwlmkVtOFTcrtGBLuWS/TVAMd9TKQdVQ/zqcOwy58Zw12b1Xdh1rGr
         gu1jORVhFLx6QVtMBYsgfX+tqk3qcDhWYQnYYyfQ6c62r7htgA3bWAV3PxtkwZCD+V6P
         hhhg==
X-Forwarded-Encrypted: i=1; AKwUvBx4qTllQ7y0GNmZS3eMO0Did+hlrEhMmUFgR1uNUlKDx7ufJ7lWRXrZzTQiS7+h/Gte1nOA6TZ4nCGv6dfidw==@vger.kernel.org
X-Gm-Message-State: AFuF++k2/JNvByhqbHZvwg3lfBn2F+UAYezgXR6huVs5h5rxKP56MZOK
	ovnzgp3KI6y7dKXCmZI23EFrtw69rx+Kd8exBaXP3h11iMK5iFaKtKl8x0depLCka4w=
X-Gm-Gg: AYBFou1Orp9Uu1d00lOrUlG3sgZ1APKhhuqGHYo4sF1TlZ3eQS1jT3EvLzFL01+hEKX
	5ivGd6IxCVmY1CmInw63YXmJbCABqCEk1KNYJMrwOrTBYHRyz01jPQpz7xIc0RgK9iCnm0QV5tU
	hf8LwMaUjEJBK/P28srcdF1nIC4WRD0C97QNqAAySWEGrDn4npb4iTPjbMFPllhXd/rbXgM01lw
	SAcvEN3C7fc6ON6JKh8vCub9hZcntHvZF9lN0mdrIvmendWOlLi4ROajVUVFC1sUUD5bMJKObKv
	YOqjIKay1xdVP2nvbAohKkNLeGbwDtzbIpV5r/UMDAeYxVQ43x2XizZU+iBhje0GJcLEkBSveJn
	BMlbuKvYnR4Hpi7qfkHWn2AXNljc9Rzb5ue4n1WGvm04fiB2VGNntXeAYcAyojj4GvrgPYmcjX0
	UzNYm8vZojN+mgSwrfyEYHtSWQFBXgZfFbD7nksWJ3mvoPJivNeVTt3/chCfiLQie4/r6X4agwH
	vgX98+N0VSWcdrUfAHLClnz4mP3T/H6ZsrlGL9dtf49/81gww3HpmS8f+foP+ZJ2hToB208Afe7
	QxAyWbU=
X-Received: by 2002:a05:7301:1f15:b0:33e:6bd8:8f1a with SMTP id 5a478bee46e88-3426cfdf68cmr15624231eec.0.1790650741745;
        Mon, 28 Sep 2026 19:59:01 -0700 (PDT)
Received: from localhost.localdomain ([2603:8001:5f01:8bab:3481:cbb6:f339:9e4e])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-34571658054sm13111683eec.8.2026.09.28.19.59.00
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 28 Sep 2026 19:59:01 -0700 (PDT)
From: Artem Dinaburg <artem@trailofbits.com>
To: stable@vger.kernel.org
Cc: Artem Dinaburg <artem@trailofbits.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Kalle Valo <kvalo@kernel.org>,
	Jeff Johnson <jjohnson@kernel.org>,
	ath12k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	quic_jjohnson@quicinc.com
Subject: [PATCH 6.6.y 0/2] wifi: ath12k: backport CVE-2024-40979 fixes
Date: Mon, 28 Sep 2026 22:58:52 -0400
Message-ID: <20260929025856.85683-1-artem@trailofbits.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Greg, Sasha, and wifi ath12k maintainers,

These patches are a backport for CVE-2024-40979 on 6.6.y.
The second patch depends on the first, so I kept the upstream ordering
instead of folding either change into the other.

Both patches are already present in 6.12.y, 6.18.y, and 7.2.y. Could you
please queue this series for 6.6.y?

AI assistance: An LLM helped identify, adapt, and validate these backports;
I reviewed the resulting code and validation evidence.

Thanks,
Artem

Series:
  1. wifi: ath12k: fix kernel crash during resume
  2. wifi: ath12k: check M3 buffer size as well whey trying to reuse it
