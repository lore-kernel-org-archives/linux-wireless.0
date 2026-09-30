Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B8744F543
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 07:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790753228; cv=none; b=c+hh/Os/4QfWoTofLIDDru6Q+0KBAypNZoo+0xandSTtl4m0YBh1fO3kC2z44ymzVYMsshH5PRybFUAL/YaUqrWdgdQ0LHTCtHnm+fU7GoUe+Br81tb2jjWRYcQfhyV78tmViVYtJrizbjtRHHLPHmD7TkSl3zLka56LEd0lv38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790753228; c=relaxed/simple;
	bh=D9vwwProX17BLsM0UFpS5a9cgtGgzRvu+3832nOt/F4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vf3CwanFqHG1IQoRy89rX+IOonTc/Z1YZmpj6KSkKfXci1610N4t92M5vyRfCQzhltlx2G25BTFc90mEuJzp5KCkJv5L689yIzK+FfHZa79uhEo6YHCBITU6ug0R/Bjra5iisegz7alA9FLJamF+x9MVhEHB9UBRTMYihT4JNqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c6FHZTkr; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c6FHZTkr"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912d822dso36945825e9.2
        for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 00:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790753224; x=1791358024; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=D9vwwProX17BLsM0UFpS5a9cgtGgzRvu+3832nOt/F4=;
        b=c6FHZTkrbkp81Xos5XSD0I+jrxaLwk1zgGD2Xk/yWGrmvj74qKoGGv0c4tP4pkzvVa
         fLtJI3trYItWoE0HXLuVGrU6ZUW6FUPCdq8c3qR/Tl/ppfamGT9S8+uJ19oEiaMtULAp
         7S6URxniS/1f3RM3e6jZ4FPhsfzwYVWGd1ur/xV8e2Ees8Cy2kZRkbS7t3sRq2N2yobh
         3AdH56+HEQCQBHxLiOnt+d0NqS7E5OkYdpiSw0uOOd5LNoCO2L7GdfmcQq6DzF/XBzdF
         lYyXX2mbU91oiyL6bCabAIxg1TOEkPHC5ttFQ//TJNVeTpUg/Xz0DwdAFg14nnS/2i0S
         ha0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790753224; x=1791358024;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=D9vwwProX17BLsM0UFpS5a9cgtGgzRvu+3832nOt/F4=;
        b=wIWMZmWYXMdTOwd8nwDjdYGAge//4X9IKKiScM2m/d5EtRF4qwl85o3P1VW6CvjCME
         BJJtB1FqzzuoVZXbJcWSX2HV2mWn/MRPJ1mL3460sojiQuimadfypWd03SwbdaCKKa4Y
         JRjqMKS1ConZKfJp/8xUHi0t0+lcajQgKbFRLdhHDlJxnPzhHtK//7wRNk0yJkoNrAnS
         f2H3IBhcBdCC4w6pa2lkqxuyVPuC5fUNy2vnFWSBulSM0garZxiN1IBeAsaNOUxrvKnl
         /l9KZw6ORrWLoXR5uHV+Rs90rGoBFhYlfWThB92lmlitI1sdEhbcxXo75helLovg4cAq
         qLQg==
X-Forwarded-Encrypted: i=1; AKwUvBxsfNX/h7Pq2sv/lMBfcvlXk5vTlghH5isi/MvJoU8WmjWh/RbU7z8EW5ivduOXpX5voCzXNl+6s9kLzxUC0Q==@vger.kernel.org
X-Gm-Message-State: AFuF++ma3/jNgtrmLCQgkK8JK+lRJW/cF0jwynKfVd7oKruhYNCy8Glw
	Fn3JlPHD15T8WwUp6QuvBIhT6tcIeHA+OWWj+nEViiquX+rCiMGLt/y9
X-Gm-Gg: AYBFou1z6qdC4/YukGGsxSPidq60/NWz5kZfEl1cYCrbZCf18kQgRijzLD+3cVWcHRq
	VwxR4ywOCbsoFR3n4Llr9MXWX+ZyVhqmKzsNaT8iVa6/V8R9GPn0+RJy9HrrUqtSiU4csagRkWb
	bWvgDvhV2HRdnqyFDdvsYVcjYQddI/TCwuR4YUM8t7yqqQIiuZTdivu5+xACFiof5vd/XEfw7UE
	XRahNpFNYzDFaibImwYQec2RUcdJyUmEo/rhzidDEBuzPc5uEvU/ttj/uun/q2uMqh2JVXnk8Z/
	QVS7jbum1OZHqZjy24Pgu1Bx4pbefAMRWsBSVy/6aQX+AlT829muS8rwNzAsi4UbaT9Opa9TIj9
	Y4IhA4yQq/I8uMZAdgNTs+lk5mWVeUEkXD9ZdGh7nDmY2BVbjuAndqmcc2BQvft29YLzFUBktxV
	m0mjlw7/2728DQDd6CHVJRoFRQdfYPzTqXXhEVCbh0qfISi8J2SdEMKOUsX5ytElicKDt7bW/Pa
	Ss8
X-Received: by 2002:a05:600c:a45:b0:49e:6c27:d093 with SMTP id 5b1f17b1804b1-4a01afde48emr5913265e9.15.1790753224196;
        Wed, 30 Sep 2026 00:27:04 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a017520e1bsm26495935e9.6.2026.09.30.00.27.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 00:27:03 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Luka Gejak <luka.gejak@linux.dev>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: Re: [PATCH rtw-next 1/2] wifi: rtw88: download the beacon the reserved page was built with
Date: Wed, 30 Sep 2026 09:27:02 +0200
Message-ID: <20260930072702.1981397-1-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <fd3beaf9c2e34b03890707e4dc663ef7@realtek.com>
References: 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Ping-Ke,

On 2026-09-30 Ping-Ke Shih wrote:
> If scan request while doing channel switching, we might deny the scan
> since peer (STA) might countdown itself and jump to target channel
> but no beacon listened causes disconnection.
>
> Therefore, rtw_download_beacon() fetches its own beacon without affecting
> countdown (channel switch isn't operating).

Agreed. v2 refuses a hardware scan with -EBUSY while csa_active is set
on any interface, and rtw_download_beacon() fetches its own beacon on
the scan path, which then never runs during a countdown.

Best regards,
Mehmet
