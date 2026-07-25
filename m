Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75BC82E0925
	for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 14:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784989113; cv=none; b=NcTt/mxv7R+TrZYbl4Lp0xrMhzvbqR0u6982mB69LolLpPQXcwvYy289fGNwDS8PBQEDornTRaeI+vGYdyERKDNdAXcLaplwno1O1rVyvTntd8tc0G9+oj74meRewZYBgkbg2hwU4eLO/Bht5OzrCrIfXD1EtXjArXfx0qN9zMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784989113; c=relaxed/simple;
	bh=5VGYxoWHrhJJsYbfgc/9P1Hwpd2kQF19yCwR6r55wrc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AgLxp6MoiBUaWrbxMWwNE1PlDuvHY70JbpYXm4el2Chj8pFUbLWx/xhIVjuXC1j93bF26qRjImm6FWXU3rbtq6cqHr+7D3Z3ys9tY5MituE01E5ZcpA3i5wg5s+8FWVvqIR5KTms/48b8kC2+lqazGEVn3u+M73nRa9p88q66hA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=J+djYTUK; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="J+djYTUK"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6983d3dae7aso3365940a12.0
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 07:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1784989109; x=1785593909; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=NXY4j56rD3KtaSlsN4KTeiYRDj0jhfdXi33CFrmcr4c=;
        b=J+djYTUKkaADp8rjOEdtCNKTX4gqZmWCrgGUqrRjIyWjQS/JbsgKaNEf083YY+ViQ9
         DXXcfD9PSCVXmg9wi61Vj83QYj982puJhlGr/F4YMsQ/0/uy9bxKNiMUhCwTgBv4FtV7
         WH8skWhRQZZ3meuMRmA0r5t6d0Z/qoviby9yqXkCWiVg0yyTpGFO8YIe3wbtpQifPqUU
         QUAJHLDL6h7SQh8DCym2+66xWPmJJ4p+eRAsUZ7838vV+jCIaIS2GNxAtKrXAgoGX63g
         hbR03xHC57ENqDaeMPCyHGnifOVfRZqlz5QRsSdWZ9jFKjcDyb7WEHeU0yeEw6nteXz6
         PZhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784989109; x=1785593909;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NXY4j56rD3KtaSlsN4KTeiYRDj0jhfdXi33CFrmcr4c=;
        b=H1IG6ZcOKHj1sukl9vNgxELoqRI9Ap3H4fKKPWoHuYCnGjycjgq6qCS2Mth3uoFTil
         4cB3NDi2jmT7+x7wFkA7sivR1GXP++o/r4pLCl7xFFxj5Fj/AtEXsMBvCoVcDfKIHkb6
         jwRdOACBKyjmYff/8MhvdQIu27C529C4uuUOcUVNu35TNkrhjfn5le2Nm+DYhp/2B94c
         WuwExsAvcDAPCNuSLjcdhUmL2lGQ78I0l/mtNxVSE6VdIJdnEtBtVQyqrRoddYNri68R
         X9TwvpHmmyoyGQgXoa7uAjzVxQiBG8+XZT61Jx6Ow9oILCZVC8QwRw4i8t9Nh14qJo0U
         aiXg==
X-Forwarded-Encrypted: i=1; AHgh+Rq8TX29Bvz0AFhfXLCvJ7dcJQp3fvQlFuoNoxlTcL5Kg+7s8K+VaQw4Zq95aLkMS/1Azp1BFTWvhYFgM2WXVg==@vger.kernel.org
X-Gm-Message-State: AOJu0YykRmKw0Da7mD7UhVqMrrO56ZfnXTMQ1u/YAoqYqkPtW0YPS9Ag
	MvF1T4MyrrhPON/SugZGvib40g2cIn/MMAOs6QLvn8WmfS8NP3L5QBcOVOCsQQ7GoQ==
X-Gm-Gg: AR+sD11IwXDEO3HmH8kfrB4kQbnzMVQ90k4BuYsBNgBD1N84cEUXhd1ZcLfWZK3K6cu
	LajrB6qYnb7hIeDOFp98D7uFrPl73GZgsG3pHIjYAkswmXXk1DBm52zujVoo28km/72dWZeNPvf
	xCvVW0BLNDM7qnlbYy8J5LCh9nbn04lWHBD3rr0HrcgOQh9mgKkbpeXUUIsDtNonuQPxvvGS4zE
	M6w8A0rFUc98KLVwvLQzZo+4Lg29uxsRt9NTHlGxh3XlDydZt0AfjjSJLg5V8GzpoW1BkoGpWWa
	74P07tkQ8CiFQHrjTG324gTosfKIy3FVKESN5+1TDeUSiku9lBJYnuh+/Dj3op+Y0LKXZRvF+g7
	NusdIXbBkKos0m2DeHhd3v8x+3NnZyQAr5Xao8RSrZ/mkibyznKjXXYWB6BDzVou/PyJfu6AQ/5
	fSbc5fieN798lUoSOexggm6owHMRnAtA7wOldYLH+U3nhMb9gnCF+Yy+pvXjACVNBD72r2sqcVc
	ft7yZGMYECLhMl1NhlGvgxE+liTSBfsmP/E58Oan9/ki6v5YtYzMpMAxhX0q6Qw+hnExr44CsSR
	nnsG/FUgbRp4z8aDQ3dR6X+jolMKflWK6B8m6P4AFiIWNV5QLNn1BCKtQppWR+tNNuoCLdMzYsZ
	WrIp6HgKrSlMWLw4ivXFFD7i9SQxKpBY=
X-Received: by 2002:aa7:d0d0:0:b0:69a:3652:9d33 with SMTP id 4fb4d7f45d1cf-69fb1bb2da2mr1339966a12.19.1784989109529;
        Sat, 25 Jul 2026 07:18:29 -0700 (PDT)
Received: from Desktop (p54aff063.dip0.t-ipconnect.de. [84.175.240.99])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-69fb594622asm894010a12.26.2026.07.25.07.18.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jul 2026 07:18:28 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: ath11k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Subject: [PATCH ath-next 0/2] wifi: ath11k: fix SoC reboot on firmware crash on AHB
Date: Sat, 25 Jul 2026 16:17:55 +0200
Message-ID: <20260725141757.1316877-1-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On IPQ8074 every firmware assert takes the whole SoC down. The DP NAPI
keeps polling while ath11k_core_reconfigure_on_crash() frees the data
path underneath it, and dereferences a ring the teardown has already
cleared.

The interrupts used to be disabled at the top of that function.
commit d455e805de70 ("wifi: ath11k: rearrange IRQ enable/disable in reset path")
moved the disable into ath11k_core_reset(), which AHB parts never reach
on a real firmware crash: reset_work is queued only from mhi.c and from
the debugfs hw-restart handler. Patch 2 puts the disable back on the
crash path. Patch 1 is a prerequisite - the CE half of the quiesce is a
no-op on AHB today because the bus never implemented the hif ops.

Reproduced and fixed on a Xiaomi AX3600 (IPQ8074 hw2.0), with no
out-of-tree modules loaded, using the debugfs simulate_fw_crash
'assert' trigger:

  before: 2/2 asserts panic in ath11k_dp_rx_process_mon_status() and
          reboot the SoC
  after:  3/3 asserts recover, 5 firmware boots across a single 397 s
          uptime, no panics, both radios stay up

Note the debugfs 'hw-restart' trigger does not reproduce this, since it
goes through ath11k_core_reset() - the one path that still disables the
interrupts. Only a real firmware assert does.

Patch 1 is by inspection: it makes ath11k_hif_ce_irq_disable() take
effect on AHB, which also fixes the existing call in
ath11k_core_reset(). I have not managed to trigger a CE-side crash on
its own, so if you would rather see that split out or dropped, say so.

Julius Bairaktaris (2):
  wifi: ath11k: implement CE interrupt enable/disable for AHB
  wifi: ath11k: disable interrupts during firmware crash recovery

 drivers/net/wireless/ath/ath11k/ahb.c  | 9 ++++++++-
 drivers/net/wireless/ath/ath11k/core.c | 9 +++++++++
 2 files changed, 17 insertions(+), 1 deletion(-)

-- 
2.53.0

