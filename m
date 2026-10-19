Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 898F84973B5
	for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2026 08:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792398701; cv=none; b=HBKPb3ZE69tnhJA+h95YlDhatxbzdDTNZTciUoAs3Mm8wrKywfafrEk3ZdgLYmArmL6MfcLDwi+vSV1CouCnkuNH1jf9cXrinNvAiWdPd+5XktOgrmGwv2UdRhxzn3ouqvT08ceaVJkCbqVImhbVjPwYWfqnr0vzS8Kmu2xGdQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792398701; c=relaxed/simple;
	bh=F6GGwF0UndXrEOdTW5UOAWuVGc3KPqmnTmyKeAgfJao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eLReXLBvqGuD+ZcJvCMnQw9E0cuH8HYhGKl/Y11n2StxsP0RDEvfnO5Wn1H8qXaakgbj1NeYFZvRB4cg19zb3H+8O8AvdAyXHMPn4+fbGqeKgxcI34w0oeO+2FstuhUAEMcKf6kdXc3NlLGDhd+faXc/OJkCyhXc1/2V0jI2cCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vl6yU5ie; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vl6yU5ie"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-48441a2ba1bso983900f8f.1
        for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2026 01:31:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792398698; x=1793003498; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=F6GGwF0UndXrEOdTW5UOAWuVGc3KPqmnTmyKeAgfJao=;
        b=Vl6yU5ieq4TN+jZPAxwre+U8IwR5yIBxoAl3gnQKPP4VUUP7mIJKGbd3Fuz9NkPg3g
         J/9uOwoLIUIbav4KYZ4ENhoCuYesk+juuX80n2i8zFn3yhBaznHOZFy3hjqVb/N0euGl
         jM+nKVgVg8acyRvlU6C8HQkvtRvE5p9OS0IOFsAvRisZ0hr+85nECmIeGtfwOr0JMa5j
         HvwR9RjE8+C34obWHXw+4s+EpYD6/+9WKQGFSoxm6L7r6wiEAinvTZeu25p5MQ1VXltq
         agen/UAop90gaC1ciLTq8oDCjyzZnFdTfcVdbl8F4VSbUb1/LYBvgyp6RIUlNwKzeUiE
         ewWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792398698; x=1793003498;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=F6GGwF0UndXrEOdTW5UOAWuVGc3KPqmnTmyKeAgfJao=;
        b=mW0lCsU3pSauKxTi+1hF8KBVMt+m+KKAlVYctiYj0LmpnN6dy/kYOemEernFSULNOw
         rmtsG5l/R673C/qxdmG57f1b5RovpLHSWDaDm09cRJ3O95cmjKnED+SP93l1ZVaBg/Gt
         oOwrGJt/zSW8bJt60AxGuiwVpm5uoKI54hWWoXCzqfddtMNTcPTtSXlj7xCnNsCby9wd
         BSekgXlc4keiOMK/5lR6RKppXZXFombf6n9Y2VOSWYhGnKsV8GTtu5IGwoXtoH5TWW5k
         ezRrvPMYnwoxnqvLCugeN0sU4afbnpBIdq8rAsXaKbUZQBbjfdXbCRWKtrNAJX82yHqW
         W25g==
X-Forwarded-Encrypted: i=1; AKwUvByfVIIV02CqTyVi+YW8Vsa4QUG09AHdzPwLoYdNsyuk4/tHRFPNBQy4yC6E9vWvZlW80w5xUkKV9DSiNdDxiA==@vger.kernel.org
X-Gm-Message-State: AFq9FYJrDUM2yfq76dOHnPj0wQRlVtCmgBmnpjN/yjGC3RTkMvGD1n9o
	2b+ipQTHJFdMIkVK/N2wDXU/4Slb3u2XaxOtnfEXg5BsIML6n6QEpplH
X-Gm-Gg: AYBFou2nnyvRPDLsvRfr1eVkZGape1y+thsuSshnGIL4vIIbWLbEApYFYLfHiNa82bN
	TMGoQ3Q40fjV0lWptaLpHsSyS2ejG+MQ7VvSwHQX6c1eeIj3iPNz7M+SjBN/kx6qsbj/S/O6wXB
	MVo5Oea/z0OdRccdsY2xqeC0Nx1cEwyWNMFH07BNSNlLlEcltoSBVdFpgSKw1rclRi9+Jd3jPZL
	LgqUVC7cpR9TsEpyakh4595AhEh2pzrrriqW2MP/KcbazL6HO6kbNOnZGjVT/EFgSt+z/bg2nvb
	NO42XB0mx0sWCAll6Fyaot3uRhgH0VPUxNtsUxySj3wGiNxSJxJIL73Kwp1nTXXMVDxoLz+5eNY
	GFux9dFh5ZXDTDqUnZzpx8LOWMWanxXAML+A7uFZaRfKTJbfyecQrJzUkz5P8MugpvuM/ApNLqK
	IeidGzd9ua8LSETd0AtkyfPHfYCXRYE532yQKqw65StYhayHb+pEgR0tnrHS4f2NzQKBVjP4Y4A
	XBolmukmOfj8BY/
X-Received: by 2002:a05:6000:200e:b0:48e:e9e:129 with SMTP id ffacd0b85a97d-48e0e9e0142mr8100420f8f.29.1792398697381;
        Mon, 19 Oct 2026 01:31:37 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd50d1bcsm22222268f8f.54.2026.10.19.01.31.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 01:31:36 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: Re: [PATCH rtw-next v6 2/2] wifi: rtw88: support channel switch in AP mode
Date: Mon, 19 Oct 2026 10:31:35 +0200
Message-ID: <20261019083135.3251458-1-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <b9bdebf6dac043ce9b3e285e0d12209b@realtek.com>
References: 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Ping-Ke,

On 2026-10-19, Ping-Ke Shih wrote:
> If you download beacon to firmware twice within a period of beacon_int,
> a countdown in the air will not present, no? Like this
[...]
> The 4 is missing.

Yes, when a download runs late past the next TBTT. The absolute due
time keeps the pace, one download per beacon interval on average, so
the AP switches when its stations expect it; v5 queued relative to
the previous download and drifted 10 ms per beacon on USB. The price
of a download that late is one stale beacon and one count never sent.
A station takes its switch time from the counts it sees; at worst one
whose first count is the stale one switches one interval late.

Forced on an RTL8821CU with a 90 ms delay on every second download: a
sniffer saw 9, 8, 8, 6, 4, 4, 2, 2 for count 10, the AP finished on
time, and a Windows station followed ten such switches (counts 10 and
50) without a re-association. Without the delay it happened once in
nine switches.

If you would rather not have it: timing the downloads from the TSF,
10 ms after each TBTT, leaves nearly a whole interval before a beacon
goes out without the download. I tried that briefly on the 8821CU;
with a 60 ms delay every count stays on the air. Which do you prefer?

Thanks,
Mehmet
