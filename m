Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E01C4EBAF8
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 17:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788542772; cv=none; b=NQDS5aXduFv7jB/KmcUGGmP90r10Rsa+tYajOdgg8S993p9Mb3f6Y/HAYjWgZkkiqd0mbo99+Ne7j6PeLdbLO3BqfBelI/UPBUoA2TU5TWGQ+IZMmpLi1yr9fyRCw8lYcQLwRsetpo3AubwpziS6kk5wIQUzG8xqDq6txV/s4Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788542772; c=relaxed/simple;
	bh=Y5Bn7jdxQw6ehqVkk5oJNtrS7WlEpI5MwesIyHBOiCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OPk9oz06NFtqvNiX0eA4UXHWgbDoQ5vX+WRnhFBjtrRi+7XYNPCUzIfQZwATrKo2CKF/GwMDx0eqDqNZzlq8bZbalpfGDOrYH9ofwHkJpNvFuVJ5YfdHvjueYJrLEGqiRIWjQpoP5VAP4ouRBGMqWwJU0TcldzL0Z5mklpnYCs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EQfQNqp8; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EQfQNqp8"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c255c58156bso245906666b.3
        for <linux-wireless@vger.kernel.org>; Fri, 04 Sep 2026 10:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788542769; x=1789147569; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Y5Bn7jdxQw6ehqVkk5oJNtrS7WlEpI5MwesIyHBOiCA=;
        b=EQfQNqp8cl0n7zgabvELulJsYhijFBEPtAHa0OrbRDim3rEMf9Us8nDywBLZsP9/Hd
         7pJLmiPiWTCvN/F4g+3UmRPUaEbHL+G2rOQw1O1NgfdOWPTT97kgRxAFW54DryIZ2c3m
         uQR3uLfJVOLv8VGJejYLuMW/F2KHz2fxLYdFHwTuPrK5XNp+9F0xguUkkcjyZlLbp2bF
         hI0u5iueuQEJ+I8pYnaMSl6qnqxEaYBapFI/q4nPcYHYEf7J1UHV5S0iLCkZ/RhVtIXQ
         DTQLqllmzHN93jzvynXYsDMLqkrXwLDXQrANycZma0q0yr+h8Q2+PGIi12rUD49znJJo
         TYzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788542769; x=1789147569;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Y5Bn7jdxQw6ehqVkk5oJNtrS7WlEpI5MwesIyHBOiCA=;
        b=nZ4+sLYufEYz6EizjAtYazsK05PZrTMbHx/9amZtUKNsgSp5aYqGd48GpzjIeO+YZE
         a9kv1HKpXL5L/8Fc5wvm/T5cGMNhu67b3cB6Go8wUEwdt1xZ2McMCRT8n+PSubGSVOkx
         qIqq7jEP6EV9LB6Xxd98+6xwiZou5CanNUA2tuK8eAOqhT3Sq4F8lGsOunCIdUBBAuys
         wydhJwqHfb0+OO31F7lgi8TmczqFSZ1Mj8hcm+J/OImg3cQ7znjBCKhw3yK683zAWctt
         I90WLqlSjxT66FsZblhzfELGT5I6H7xofSYGtjFuf5JkFl1mCk7fHd6o9pfGKQGBNNq7
         P2HA==
X-Gm-Message-State: AFuF++mHSI+WPhvCikMSXKFcgbrNoAtjiQyps5DlMy5yacZHSq4XbEEQ
	Lq3QhhvWEGMtazkuv6iCUT0Vcj34YUKTs2ToyxvLDftxqk5ir/hd5bmVljthAhPw/oY=
X-Gm-Gg: AYBFou1WrDye67aGe3Xk1YQDh0w+13cYLfdXFtRrGVyxGEWDR1I+oeTcOjmAeLKJmYQ
	6mUBIjlRRvBX1mUFOrc1hDSu0ucM3NFWj82e/6aiERV7B/pa6fZq7TPvbPGd6AM+JITBITz9Tgk
	5N+ecHvWb+9j/DVTnNCt6slZhfhRFhoPIgPxceGTjK0/MbhFjg9BPgmCD6+e0X4G5do4mPEjheV
	agpz2FOuhwGPXR97jizLXwvxIUkEdpLTvQqUfqFj5ZN+y1xzFo3dikr8U3aUYYf1z5vuKk/pTj/
	tRRbyqpr6x28ZhQ6IVj+0km64FLHGVqtHrAAGlDWFRwOuQpQN3DipuWaCfGM8FV1/409LaFplf5
	AvIcWkRyoRuQiyng12FFhSMZHZEw/PNcQMeaHPKzGDat78XMT3YNrfhS2A+2ZIVWhu6dndkkjZh
	3RhvVqnLyS03Ly3kPFsAYTm6ruRBmz9Qn+ao70fmqxESzSsUqVdJ9dr7aHDNqo9hLLJVmu8CN3y
	Y6YPUbKgxuaPGcFlkuZsIwrCW/wKCHLM94M0g==
X-Received: by 2002:a17:906:730e:b0:c20:af9d:4533 with SMTP id a640c23a62f3a-c260c9f74d6mr339493866b.19.1788542769015;
        Fri, 04 Sep 2026 10:26:09 -0700 (PDT)
Received: from ca91a6afa0c8 ([31.7.57.58])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c260d4aa01dsm139132466b.15.2026.09.04.10.26.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 10:26:08 -0700 (PDT)
From: Valera Kozlov <valera.kozlov19@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: nbd@nbd.name
Subject: Re: [PATCH v2 2/2] wifi: mt76: mt7996: route disassoc frames to ALTXQ
Date: Fri,  4 Sep 2026 20:25:44 +0300
Message-ID: <20260904172545.25-1-valera.kozlov19@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260901194338.110-2-valera.kozlov19@gmail.com>
References: <20260901194338.110-2-valera.kozlov19@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Felix,

While rebasing this against mt76-fixes as requested, I noticed
ece175a8a7af ("wifi: mt76: use ALTX queue for packets to disassociated
stations") already covers the same problem via MT_WCID_TX_INFO_SET,
and with broader scope than my patch (any station that hasn't
completed authorization, not just the disassoc-frame case I was
checking for).

After rebasing, my patch's diff against tx.c and mac.c came out empty,
and the one remaining line in mt7996/main.c was a redundant second
clear of the same flag already cleared by your commit a few lines
below.

I'm withdrawing this patch (2/2) as superseded by ece175a8a7af.
Patch 1/2 (spin_lock_irqsave for reg_lock) is unrelated and still
stands.

Thanks,
Valera
