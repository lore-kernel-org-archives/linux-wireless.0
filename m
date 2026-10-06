Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 394F937DEBC
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 07:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791272792; cv=none; b=t5xXbCxw1R9ApiS1f0LG1vvIFIeMALlV8u/uLJP5BiZ+9uPr2jt1M9N/NLphOHeEn0Gad/ONNZco3NTLkh9wzku3GKG7seZSD4gqdKx+IhPAZt5XyunFvoSE8hJlCVp8nkxI+ZrgU0nFHn2ThI+9j25uPiOGDuQHxeNpaX8MANQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791272792; c=relaxed/simple;
	bh=Dbh4ppydX74jlkNg4Kn6ybU3AG2ilsWVZs+ROAx3A9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fq1gJqu4qzQagCpSSrX1cdemgDgOI6y+dvYJ/v8k8Ri8JBGAiSIkLZ8xNO583cUqq3px3G0dJx18MNve46c1D/5yOBKvZnUNn7sYVj+oiYjPXWODW2Zi1tH7BLJXJxgc7sVkj1immOlFLKmkJuJqytuUYzGooWj84w58GBWh4X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D9/kTnK3; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D9/kTnK3"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-48c4be28b82so250058f8f.2
        for <linux-wireless@vger.kernel.org>; Tue, 06 Oct 2026 00:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791272789; x=1791877589; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Dbh4ppydX74jlkNg4Kn6ybU3AG2ilsWVZs+ROAx3A9U=;
        b=D9/kTnK3xgWTzVttlACBbQ1Lwo7yDUZFuUFLYPIMOWhVp3qOJglSxo8YWcjNrcGMGu
         XGaz3siZPuFc9zMfpkkI+veb7R2uIuNNXKWp1DexYRUbG50fAat4n5RYRB+xnjdhmLnC
         rR0T4Nqz9X7Ru3dbuA1Uy9YFl1s8p/eZj1WPC/lYun5zR1JyfO0s/paKvJ+8G3a94/rr
         uXtYuWHnfc+iGp4dfLwP3ReAHBvi4N0tYFoErD3Ih6tB1NL/5sLqCvF+eusaqIdqjHZ1
         /7nxsrvU4sAI0LmIR4+AtjHpSakFTN+8P0vl4vBYH5J+ZC87jHFdVSAt5WWDiSn5BVUY
         y8gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791272789; x=1791877589;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Dbh4ppydX74jlkNg4Kn6ybU3AG2ilsWVZs+ROAx3A9U=;
        b=w/baF00gKsUxfw5UmrKXPJpChDqxrfwvsDrhpkBcVffXmfxz4u+GFFtZqU9yR69OFS
         gYUy2Q8C5V2VMaZO+ae9bmwvVnzjvz8zqZuN+eQnYvdO/3TrhFxzJNWGKt9hw4NvvE3v
         QSyKIjgyY9IaWOv/ITm7Xa7kIQJki6n2wjuVy6qw6hapak9KvyChOwLYsURfc1DLfRvp
         WgLtb0BUwts2t9SQYOSREbW4mTB3yO/kyNELxzre6grwl5igoyu8cYM7FGbSSFGax+fz
         j47l4wPt6p5tbDPn2uuleX24lbnAyVAc7S927yi7FSkrVODCuNd3FDBaPx9/q1gXGAlf
         /qNA==
X-Forwarded-Encrypted: i=1; AKwUvBxf7nNX06n9FIKOgK8ZaO2hz2JDZL8OkZt1ttjvrKkLfVM2CZFBRD52tl1xm2ZGLkmMD4+NJ8LeBIfAGWY4iw==@vger.kernel.org
X-Gm-Message-State: AFq9FYIPoHYSrjCsq+ZZ6Kpc8Lf+jqeCRiCqx+Zq7qx3KbBGxfcNT/OR
	IoPoUV38e0w73Ws0X4XYtmle0PZuy2rRIW+glGSDqCeE0jQtHVocyn3U
X-Gm-Gg: AYBFou2MLusJkgD2FKftQKPt9j/rg8OSFYmRdxsFel7OPeAELgw+tf73d2eawxFvCSJ
	ygujAb2bdoEy61FY0sEdZNbU56nEPH/6+UageQOaekSU9Iq9v35IQNPFY7DNpK1tRyto2wXD8IG
	TyajHdx4ELomEf+jquc37tnlboDAfQ5kivXLHhO+PlusbtmHG80DZ5BtRfZV6f7tRrYlExjFTG7
	Sl310qrUny6QGDFbK/9S6iQ0HMzOfFnSOxppt79zi04bXgyPdGC60JIxVeB1iwYhEuL6LOfRfA4
	wJSMdRBuxFhOs/Y7EW/xIBzfkIYKSUtpSIXR5NNqC6zyL8ntxIXpf7t9vrqw/tuPWDA1trkdXCl
	ezidJU4rvSZ91AwkiehRzC60T3/wdUDrpPhs4A8aWpEVxXufv+wqAu7TBHOb55kVtxehXa/4WtQ
	AO0OLasWsospnWaIfTXeqRf9oqjROpGhg2L2qQch0Q7mRRcmbe9PbbGSZp0DVGLuKk9rmxRbY3t
	dtC
X-Received: by 2002:a5d:5d0b:0:b0:488:8525:4979 with SMTP id ffacd0b85a97d-48c6d1aa7f7mr1024551f8f.45.1791272789223;
        Tue, 06 Oct 2026 00:46:29 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48c6cd7c326sm1526081f8f.53.2026.10.06.00.46.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 00:46:28 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Luka Gejak <luka.gejak@linux.dev>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: Re: [PATCH rtw-next v3 2/2] wifi: rtw88: support channel switch in AP mode
Date: Tue,  6 Oct 2026 09:46:27 +0200
Message-ID: <20261006074627.372751-1-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <151d3d60da614e00b3a94bebd4f4f3a8@realtek.com>
References: 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Ping-Ke,

On 2026-10-06 Ping-Ke Shih wrote:
> There is single one caller, so just squash into rtw_fw_csa_active().
>
> I asked to move CS work to vif, because I want to avoid this kind of
> getting vif from rsvd_pkt->rtwvif. Is there any way to avoid this?

> I'm thinking if we move back csa work to rtwdev (like v2) to avoid this kind of
> iterative.

> and avoid this iterative.

Yes. v4 puts the work back in rtw_dev, initialised once in
rtw_core_init(), and adds rtwdev->csa_vif, set when the countdown
starts and cleared when it finishes or is cancelled. rtw_fw_csa_active()
is then a test of that pointer, and the lookup through the reserved page
and both iterations are gone.

> Will it be a problem just unconditionally initializing csa work?

It was: a hardware restart replays add_interface() with the work still
armed, and initialising it again would lose the pending timer. With the
work in rtw_dev the question does not arise any more.

> As the comment, this is to download new CAM settings. If CSA is ongoning,
> you ignore the download. Then, my question is when will you download
> this properly?

The countdown work downloads the whole reserved page, which includes
the PG info page built from the current CAM, once per beacon interval
while the switch is announced, so the new settings reach the firmware
at most one beacon interval later. The same holds for the TIM update
and the download on association, which v4 skips too (Luka). The commit
message says so now.

Best regards,
Mehmet
