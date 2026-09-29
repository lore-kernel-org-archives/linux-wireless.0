Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 850FB3D5673
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 21:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790715937; cv=none; b=bWs65QGvI8ogFkHH02g8kMra23rYfrg/aM/biBlpKik0e6jw0rbKClKOA7caf5hS/7R+9E75MW5KaU05kDiYvintsXphWdtD2OS3B8PxlmHOdWQHLSo85uIF1qqtcg9UdHLTnqFOdB+s8KqSyBvGEtLGa5Iv8d1VPT3lQqx/58M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790715937; c=relaxed/simple;
	bh=DByqLeGFPLw3TJVUX1MfUPhScKwNvQQq1GjX/vQm28o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iLptF+YH5Tg70pUJIfMa9bc+VDxhJ8aFRlVZoRkAySKgacGWsh7FS8pS0r/Vyc1J0ri9U3UQ+EF88+5KAeTrqS+xSdZRlfzSxrxTNXpy8xW45QvXvNWna4mAfop7WeacWFbYMe/nOW3ZYNWBXuR3tgIyTOJjG+130vXSLsCK+b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gZKKoP9i; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gZKKoP9i"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-4843f22dc83so3867058f8f.1
        for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 14:05:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790715932; x=1791320732; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DByqLeGFPLw3TJVUX1MfUPhScKwNvQQq1GjX/vQm28o=;
        b=gZKKoP9il0Mhnr7m1zdPljHNTEL3uqTCa+vUF4V85tyqPvojKTvZbJjBfI7LMzCKeP
         3kyqOXVL2J53c+rZ/sgBRY2bX14MpWo+ah9X11AcF2w2TToRldC1bnFuyY5aysFls26g
         gu0ZHatYAZXKc2i6vhJcXyhpNZ2cdnvfKYraIAbiLnDOLShJRgxVeO9K7taysraKagW1
         VnYEsOdwR3a7Vk5OsDN7adE//l1qBAN6QCzg9UuB0AZ957fqvWcBzxNVA4tOEyzKuc+8
         V6hDNTuyXxb4EGh26UQ1VVd9n3V9KYgYhgMTR/s2cp1zlLi4Wdjq6YZ41Op7W3l4PdlE
         kF3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790715932; x=1791320732;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=DByqLeGFPLw3TJVUX1MfUPhScKwNvQQq1GjX/vQm28o=;
        b=LstMVKjvD0lEPssaQyUYR2tVo+l2xiqNJ4XdYlsSZOJobRtVlxMc7pIZYdoNUjlOP7
         lIEruWLtxlue8dolWAe4w/TZvtQMC9HIF6Y1id7+FwlX14Ul0QpxTKd6bXZNCmMS6Ner
         nzAoN46C/nsetBvrC/A+OpCWW5mVa9KXbiQhwQ64iLdFJAW71pE6MToFlGsSHzN0gQrU
         RjO4xtmO2G4ZvHShCL1d+pnFqvu2bZb9y/Xk2tScVuOnzeJ8Y/UGUyKVDQ6/gu8dKZ4A
         /SI9or2ldJOS/p4MU+LeTPFTuOmjiu7DxGrijF/OnvvZty01apiwyc2M5u9LqER22hc2
         0Fww==
X-Forwarded-Encrypted: i=1; AKwUvBxThChOhSERT0sYEul5MwTIrHKnhHfa3P4pkKNUULzPfXZZMNzDifq/EgPDQyYRg+qWatDBBqFrj53fODK5SA==@vger.kernel.org
X-Gm-Message-State: AFq9FYIUmoClpof7UU6UYPeYcEbHSEUEInAn0iEzF/rzu8+4brsu1iAI
	uUr91+J+KjFp3/ugiXEScdV33vLXi3k1KrvEOGQYsNYXZlNX7DFKQQ0D
X-Gm-Gg: AYBFou2omRhbQmIMkXS+JNyum4O6phutg/iAHvp/UvqYX/98IdWZkDgeVrOA+Z3lOje
	DRD/ufUCJ2gWnMTlTYWplCLd9hOYlOyKKWIUuwOvhza5/tZhleLuJIZmUq6HkHyA0JvScRE10Wj
	i4mym5k3JY+inIxZ/YxSASjWLgl/YVHaeufiO/yvkCSFaSUWgOEsOAQNi+WZwIa1J28DfCfgIuD
	PhhOYq2H2UbXzhr8C0hlvYqPjO+37pMNQd7Byo0X/QULLRF12d0bYtxms6kCyDvbzCcBDFkD9Hx
	o8F7mDqdWLAYD9NX8qL7/l4wG/6ncTeDirTOok2xT1gwDbrDXJhyR6cO4R52vXgW7kgwGmjZI6D
	v2AmEO/fzE4tm5IodpXssuFkipEWZikb2norTEIa2pTSJAlvD0t8amjPkRxSOUdyHo1nDRYYu6a
	P1uycPdwMRZjm66bhi6BuRCltfrXwFe+jhYB5Eu82UyG/qXqk/hr9mUP04wMuVDxHZxCm9RhFoc
	vPC
X-Received: by 2002:a05:6000:240c:b0:488:5db4:791e with SMTP id ffacd0b85a97d-48afe71cea2mr1016150f8f.11.1790715931559;
        Tue, 29 Sep 2026 14:05:31 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48afe6c1260sm1409464f8f.33.2026.09.29.14.05.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2026 14:05:29 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Luka Gejak <luka.gejak@linux.dev>
Cc: Ping-Ke Shih <pkshih@realtek.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: Re: [PATCH rtw-next 1/2] wifi: rtw88: download the beacon the reserved page was built with
Date: Tue, 29 Sep 2026 23:05:28 +0200
Message-ID: <20260929210529.1848479-1-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260929191136.1315-1-luka.gejak@linux.dev>
References: 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Luka,

On 2026-09-29 Luka Gejak wrote:
> This breaks hardware scan offload while an AP is active.
>
> rtw_download_beacon() no longer fetches a beacon of its own. It reads
> rsvd_pkt->skb, and rtw_fw_download_rsvd_page() clears that skb right
> before it returns:
[...]
> Could the scan path fetch its own beacon, or could the retained skb be
> released only after the standalone download, with care taken to not
> advance the CSA countdown twice?

Thanks, you are right: I checked the callers of
rtw_fw_download_rsvd_page() and missed rtw_hw_scan_offload().

v2 takes your first option. rtw_build_rsvd_page() hands the page-0
beacon skb out to rtw_fw_download_rsvd_page(), which passes it to
rtw_download_beacon() and frees it afterwards, and rtw_download_beacon()
fetches (and frees) its own beacon when it is called without one, which
is what the scan path does. So the countdown still advances once per
page update and the scan keeps its beacon.

I can only compile-test that path: the 8821C and 8822B firmware on my
dongles has no scan offload, so rtw_hw_scan_offload() is never reached
here. I will say so in the cover letter.

I will hold v2 until Ping-Ke has had a chance to look at the rest of
the series.

Best regards,
Mehmet
