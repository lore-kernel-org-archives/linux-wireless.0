Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793566688;
	b=2D0MG/zcS6QhfCXmuIdoF+vUAV47smWczUdjHyhTDmq49TlhipeInxIFBDWHcJCMpU/w
	 3L0IFYkx5c8D7cz6GSDYlpVnrWrmG0JCIVcqixO3tDW8mxDJES0VOvNY1V3Aa1ph+YEho
	 jy5mae0FkoA7IisNq2sbrC7matewZz/diHiRnvOUw++AxG3aVLvuHa/rrJhPAxCPHV4G2
	 AKz7W+STuXJal5vGG3fKSN6O4SzsjLSXW9wsLc2GC9m97rrYU2GCUj5xJbIBwQdUKCMyy
	 z1FpSkGNXLC7utkFhykGRuEe1j0vPd4GbSOr4H+yS8Ek+4y7GP0PZW2cHWN2l5iuOcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793566688;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=rLQnSUGCT9AoEeSMPunujD66mYyzWc6DQOYtm8J5kh8=;
	b=VoZ/lbS1pepLMS/JUvLUOiZB3hMecNxEyzPzvo9c08FVTJBpBo/jNRUccDgDl+TtHvsU
	 XvtMkSr8rJIlY1G1rukUzALLyZTNACVeJWARvd/z7iL0uJu1BnlJK5IgGYiR3ajig2b3M
	 RmRdB8n04DGeM56OSakclmAzpQ9FDt5XGXML6TNofQSFtxsx1k/eLWXS52cSGTBfy45py
	 HV1naM0xs3qbPcPnLbvRqF+2n/7EuQNB4c1ba6MboRLEnqctntr3nGayJDTMZwGi9XK5g
	 GEwmvx3X5tl/MjgJLWN15k+CqfwllCN6U3hSHAbgnPP1ZfuZz4EAPu6Q/pzPvhbUqYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=e2qI6CUn;
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26599606A326
	for <linux-wireless@vger.kernel.org>; Sun,  1 Nov 2026 20:58:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 26599606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=e2qI6CUn
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a207b02a2cso15301885e9.1
        for <linux-wireless@vger.kernel.org>; Sun, 01 Nov 2026 12:58:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793566686; x=1794171486; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=rLQnSUGCT9AoEeSMPunujD66mYyzWc6DQOYtm8J5kh8=;
        b=e2qI6CUnZ3aotOnqIvC8QILPds9SrwHY00NEUcbxzP6NsvYFSURfUJ3iTKg1w3ALfb
         zDXd8gfvXOAWe3WPeKwqxzm+ceirz/PUTkjSXKwMdaUJItt9j8c9c2ynQ1vn69Q9g7I0
         GWRl//DupX/Zs0xz9rT5nmggGpqelOdj/iDV+swzYv5VsmXy0Q9wAXI8m3CKzWoxvbBD
         g6dFJH7olniFyoKhBApFiBRbh5+HKAj5DOAV9k/agS5moqqylnrB6dzNmR47C7JkEH70
         zDjkHNZAEB6dnqUj93bQVflyvpn+nmhBSZwoWWA4IjuhtVYD6IvUNP46usgvWH6SM0Cy
         Pyjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793566686; x=1794171486;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rLQnSUGCT9AoEeSMPunujD66mYyzWc6DQOYtm8J5kh8=;
        b=GqdDCMckRUACGwCEdp9ymBGGNdm0/GhgDbVJGtLYId5XWt0XvDrVlGZxCygPaJzLj3
         90T0SKN7JAdzXPgloSVAwMlW3RF7P0B4IfOsXJQSTZQvlrAVnEFHw4PIUybIj/OtLKLc
         ltoy5NnLWWU5jjH/eaQzcfGrwPp1lh/vLvfta/qp1gZ6Osj3DHrOSi1Z4otaaS9uzEOR
         koyGKtAYxYZZZ6/Es9OkR7HGUK1uyffG6+dMmCunuiVshNwnjsuVTLfaEj8TooWjAT3k
         rpsC8LO02+/k15UIOm3/2kH4SV+ZZNP8AzDD0pO45AoPSjL9lHFsOO4lVPiKlQFh09rC
         BPNQ==
X-Gm-Message-State: AFq9FYKmNvgniaB9g47O6NycmQrc1qWtC1oJ9zSXt9EkoL7HOm+nTDcy
	2TkGcnWF90eaxS8iKhUbnZCrSjxsdaweIPm8GvWBGEOBxEED0RTUQwXD6lnW
X-Gm-Gg: AYBFou2+HMgv8VtX4Ty2unWaXWq1evbZ9dT36Gixr+WArAcYLs+ET/fvkcU5YeDvmxs
	voy4xNWnKp3WLblEUin6NbMjrLclVgkD3AlLmlAaW1LsgQUnUb5vj+3MkmzzwY1lWoQzniXRWRc
	yCDlkJ4g0h8zEmDzK6UurARCA26WDwCKdxYq1/fkC2DHxLl08xBEfywl6HsrUrW/PV9CJQFXBjV
	jKXdC5aeSKnBMMxCRyViOYTsl1oAyNUuLwfvWaJCDvWrW4hAkdDj5isNZSl2sGD6Bl+3gYTAA7p
	7dDZpbWl4yi2TDWu+VYOq59cgGJEw+uhzktlitX8a4MXqzZwOEmXFxVHfjcgU4T0LD59xnWv70T
	JMgX5857W6YNzYjtg66MZ8tWhFDuBco5d6oDA3FSkOOHapjGss4IuNRjG4V4rH7lp4CS6H7h9jx
	cxAmPq6wMUNxURblwkF5rCBUf8dct3IfMu3nP9bgTodqPZbk1ipf7ogKrnFjioypv+WPjHL6wJE
	MWJdZeEDKIb2/vqD7ENLBxUBV/ATyjS4jw6QFC3Pas+a+UBjBPM0rxiXg/8wyrhUL7lnB8DnlDQ
	8SGm8YI73J88BETAmyQ=
X-Received: by 2002:a05:600c:6212:b0:4a4:de70:2ad4 with SMTP id 5b1f17b1804b1-4ac17ffa395mr177259785e9.22.1793566686402;
        Sun, 01 Nov 2026 12:58:06 -0800 (PST)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b9eaeesm16002280f8f.49.2026.11.01.12.58.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 12:58:04 -0800 (PST)
From: Tristan Madani <tristmd@gmail.com>
To: Brian Norris <briannorris@chromium.org>,
	Francesco Dolcini <francesco@dolcini.it>
Cc: linux-wireless@vger.kernel.org,
	stable@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH wireless 0/3] wifi: mwifiex: firmware response validation fixes
Date: Sun,  1 Nov 2026 20:57:59 +0000
Message-ID: <20261101205802.2909524-1-tristmd@gmail.com>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tristan Madani <tristan@talencesecurity.com>

Three input validation fixes for the mwifiex driver:

  1/3: The ADDBA response handler uses a 4-bit TID value (0-15) to
       index an 8-entry array. Values >= 8 result in out-of-bounds
       array access.

  2/3: The multichannel event handler uses intf_num from a TLV to
       iterate a flexible array without checking it fits the TLV
       data.

  3/3: The IBSS connected event handler replaces a buffer-bounded
       length with the TLV header length, which may exceed the
       event buffer.

Tristan Madani (3):
  wifi: mwifiex: validate TID in ADDBA response handler
  wifi: mwifiex: validate intf_num in multichannel event handler
  wifi: mwifiex: cap TLV length in IBSS connected event handler

 drivers/net/wireless/marvell/mwifiex/11n.c       | 6 ++++++
 drivers/net/wireless/marvell/mwifiex/sta_event.c  | 6 ++++++
 2 files changed, 12 insertions(+)

-- 
2.47.3
