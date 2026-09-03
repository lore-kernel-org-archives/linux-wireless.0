Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49CF37BE80
	for <linux-wireless@vger.kernel.org>; Thu,  3 Sep 2026 08:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788422981; cv=none; b=GTVZ4q+PW7fDumB5qvRAU7yHtSpN7iKh/kVPImvYiutmes4tcBScpkxMYJFEEfoA2A2pbqxEqsztPQQv/1t0iNJ/2ff5mIz8e5JPqRdnjG28qlHitMaPBCxPQY6wciiPbpqazkPmpHwmYECdLNwO49jVmUfHtA1jGfpTIfXIRGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788422981; c=relaxed/simple;
	bh=wddQWovUxe2uKJyvwdvKzdgZhQJpx+9myOGJmM3ZFx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AfmLmRSUhqvAJ4sacbJ0inDPgp1mBhLhqFHnTG7MxwaCPzvOjXzNiM6p2udiBDbCh6xMwoYjwkM10aVLTcandIJqrBat9unHOmciUPcLCRlnu8/xpGRlgUNOqWgBGujfrON2nPxTRwZ0e53v0S7ce502UOht6swTJpt1Y+UuYJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YQga4iYN; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YQga4iYN"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-cc439aa0078so916008a12.0
        for <linux-wireless@vger.kernel.org>; Thu, 03 Sep 2026 01:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788422979; x=1789027779; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wddQWovUxe2uKJyvwdvKzdgZhQJpx+9myOGJmM3ZFx4=;
        b=YQga4iYNatyLZQjJHgBJzVK0jpXBhAFsGsc4tFC/2UpSo2cZi09jPMGO5YbwniO7Rg
         62iUyWA9BLCoozK/yDQNhecoNINgh4Aed4+4JMgPs/WYjQ03/NMA+/1yi9YWyJpp8uA9
         icspvsiZ6ZIz36xylflmddcZ3galj7v1gGDiObSn0adgPv62PsxUWwNyr7llxS+Ys8Be
         mpRzaT8MUUk2fpuMBsJRvNkqf7bqi4z/NxbNSATall4k+wndGQyp0FMi0KZiubM7eEZS
         aIVeA16HbmqoTML9FtmiW4uOMu+J3ipcTNiM/uvJf5kdjZ0qTcHwKzgaV4k0fI1Sk/NN
         KJ/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788422979; x=1789027779;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wddQWovUxe2uKJyvwdvKzdgZhQJpx+9myOGJmM3ZFx4=;
        b=THAW4evsyUM7mGnAyR+l5Qs6eME2MPj0M+RUrX7VFfurf/Euj5/DDSL+qPCvQ1vwKh
         2sZ1PZvEYpz0iIBbYo7AbVBEhweCjFUBtSG0I1RgyE9x78o6LYHiDOCjfGNua8GJupyQ
         iE+hLLvbMvj83lncQ766ExXuuONfoFSVHVYdTcSq4gBdXPQBA14GMsUe4Ebw4oKlH9Qe
         leB2grs8dY5Km4iVjbNf3mR8waaCfxQVOmf8amK+IaRT9osu9NKWkV52g2RHauZzAsTt
         L86PyRxf4kQS+IdYBM7qhD7g8aNIApB2sCtBF4MAoW9zkHG4x3x0pAiYAk+adZes81PM
         RYtQ==
X-Forwarded-Encrypted: i=1; AKwUvBzbm67sMeJu1MOevP4xKWQDMw+cVIJdS+dXqI/5DRvsyoU1rKSTLdo9cpA4FNAUTk1tKViqQG5DR0zP40/mUA==@vger.kernel.org
X-Gm-Message-State: AFuF++kHF2NMthMoCfsVCt+YghGUndTgEcsf3+HXA7i3vgCIm9y72x/J
	1mbFdai7S5c005m4fSjEKFinOY38jBLLEFhgGADJqGHmc6W6hV8GjFpH
X-Gm-Gg: AYBFou2twgZZ8uHMut6Vy0Nf+bGT5lXS6jYmogAy/CiX/Dj6/Cy8UPPKtQmg9u9O8SJ
	w1I23nd3qtS5/KGAoe7mGZ9An8+3hmSSC2ubyi7JUjhDoBKm1JolvkDrfh/7ttMO5C0pj1lVcQY
	BXnvNIn8JzD1k/T0oBvioFpBiwng7TsK9i+o2wqKvTh5LIXDsEGMYVbkWDdnwzadVFFmYXhgTml
	+U7CIvVcu/lgcqpBW2X2yy4z4hXQy0lNgfXBUbK4rkGlpzlspJ1wgDwKojsaUniDIKNKkMCL8Du
	pw7y+BlHAQmlEv857tZh/SF7rSbN6ZBicBy+im5qCaHn1ECJUqirFORgGPYggi/5hbx/2hdBCmu
	1m9pkGZu4wBxEM0lugRQZYszpchgDPUPl5I5Dsvna6Cm8fJCcPLRx0gY5fDsOMJqXG6oh6lTvyl
	a5YUyTjrHcWRgZS1hrUQlddVWse+7Pc/+n6+o6PrW6KvZ4i40KnKqgYSSP0SPZmFn4a67jqEx/L
	m6KczdP++pvCHI6amDz3s2OfEr0WBwBOvEy55DAoLnF/YosEA==
X-Received: by 2002:a17:90b:3f84:b0:381:25ce:bcc2 with SMTP id 98e67ed59e1d1-39aedf1922dmr16176799a91.6.1788422979169;
        Thu, 03 Sep 2026 01:09:39 -0700 (PDT)
Received: from WR5220G5-Peking-BMC.labs.lenovo.com ([103.244.59.5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b087b59a0sm4004345a91.17.2026.09.03.01.09.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 01:09:38 -0700 (PDT)
From: Yuqi Xu <xuyuqiabc@gmail.com>
To: Sasha Levin <sashal@kernel.org>,
	patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Yuan Tan <yuantan098@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Johannes Berg <johannes.berg@intel.com>,
	johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.18-6.12] wifi: cfg80211: reject duplicate wiphy cipher suite entries
Date: Thu,  3 Sep 2026 16:09:32 +0800
Message-ID: <20260903080932.92286-1-xuyuqiabc@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260831133314.4125787-367-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org> <20260831133314.4125787-367-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, Aug 31, 2026 at 09:26:35AM -0400, Sasha Levin wrote:
> [PATCH AUTOSEL 6.18-6.12] wifi: cfg80211: reject duplicate wiphy cipher suite entries

ACK for 6.18.y and 6.12.y.

I'm the author of the upstream commit. This AUTOSEL backport matches
7187d145d904, which has been in mainline since v7.2-rc1.

The change is a small wiphy_register() sanity check: reject duplicate
cipher suite entries, and reject n_cipher_suites > 0 with a NULL
cipher_suites pointer. Duplicate WEP entries can overflow the fixed
iw_range::encoding_size array in cfg80211_wext_giwrange(). In-tree
drivers already advertise unique cipher lists, so this should not
affect legitimate hardware.

Johannes preferred this over adding a bounds check in the WEXT compat
path, which is why the fix lives in core.c rather than wext-compat.c.

Acked-by: Yuqi Xu <xuyuqiabc@gmail.com>
