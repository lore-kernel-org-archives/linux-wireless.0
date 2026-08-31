Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03F4E52FE34
	for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2026 13:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183895; cv=none; b=qlPEncgGXIh8NKWOXRuVVyErzRTbj/VfT+5ZhBeOyhTNWPe/a2g2PkskOIuH0fcUi+gpSPKzJW5jo+77qE/pBv9XZreEys0izfgHDcaAl00Z2mLOG+DrmPzPTRK/rEWXG8SyI4+oMG86oOqjKe4d8kzQ4jN6jFl0wwH4uiHb+Ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183895; c=relaxed/simple;
	bh=Lwd3PeZ4xmhycpzeKv1BY13CWcgT0j3f+vGChTb5o5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nQD4kLEmRIS2I8kcUdqT6SyZyso9xVgTrHXbf+dtj3gtvIjKSy7P9EMY/sLfydVMmerP/dfhSr/6cAIoFnwnmzbF4b1lVYncxIAWTnCCrsjhYUd0+Ca3JuBSfU8rcBEBOfKt9R61qDScxDR5UQ0b1LxgQ5sWXdtKBXLVCm+Vk6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U1XCzVun; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U1XCzVun"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-cb2513ec378so434864a12.3
        for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2026 06:44:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788183893; x=1788788693; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Lwd3PeZ4xmhycpzeKv1BY13CWcgT0j3f+vGChTb5o5k=;
        b=U1XCzVunsvA7mNt4uCfvpGStf/QgY/24/2tWUv7dFhsmz+qO7yk7R/BeFshQ/BX9v0
         OQ7cQGok3uxtodBpzRIVhy0/+DrVpnC5Ub+mVI86SNAEMVrzhiGUV5mq0pTlPfcrUTyk
         kbt4/tFKxY9TeE9qofV7vqYTklnh7dVLP+KM8/HvGeKLi+E9Wc/4tVWl3/FIR5jOQ4Gg
         2NdG4Z1EPu0GyBimg7COrn3/jHIPrjtTbxLlIyjIrBbx68nhMqIEdvVhpV9LUNa24KDL
         G/mTdEDtnbzwr23oDEujgF/evot1vMxndAsMF9PxKDWvNP6dD44wKR5FHA/+AM0wZ/f5
         Fz1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788183893; x=1788788693;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Lwd3PeZ4xmhycpzeKv1BY13CWcgT0j3f+vGChTb5o5k=;
        b=G4nZWXcazFD+6Q169aJ8NZPdDfIpEr93o5MnVi2HzGXHXhkW9zusqWiDpE3DlAE91Z
         BZ+2gv9tDj9lnSSegLShsuFKBvjMMSjEbYDwJzt/1OqZ2LpIJ7qS5RuHspbp+Aj+fELV
         it53XcG4io+uOjTQBAVbSihzEUsEy2Z5ESKDeMwb+H3AROtWRurO8YqG6vRFiXRBjbel
         MxInnc4v0b8qEm2jgBFsuWgj0EtBBiKBBGvD1wbwWzU6vQvNzg+qcZhLDJn6kaRUcL/3
         WiCgn7qHGANaF3vzJJsvrTiQ/AbttmoW3xA4VdQ1XzrM381UJifwdLWmtQ8S52u2MASy
         cFMw==
X-Gm-Message-State: AFuF++m//Cb04Hx/3mI2WuNyiQeFbSm/1g1BgdvBbsrR3voyi2tDXLp9
	nVecw2xPgUi+hRphr6pPV9lsV43e8FfOl5Ud/mwF5lUdQq2e/CNs/s9O68yXtb0mOSU=
X-Gm-Gg: AYBFou16po5lXECHH4C0Pq13bTM/dmTaA0PGqkw89vCE2jvvDd39uSpH92lyJvl1W1p
	eRGwi/EuV0tYYat5iVeJ4ujvybQDWDOU8l6uG2/GPF5bUSyvVxXprFcEnmDq6Aj35XK+wTGw5qF
	BVrDguiLcyAUuD8ZYoBvHVp/oXc6KmTFfmxOBLZZEd/8O3apN2sQ9cG9kMkWRoAv4M4LScnTTDO
	cAFH26iEV/8uGS2EuLYzmU2u0Gn9eBrld2xwpIWUP83XX2fHSA988u1IbEfg0yHzKAVD9aT2vnQ
	lP9kkC3NKr8/MyiyRgyqitxp51YpEHVMXFg/XkMXT/PTIrYh41FFVJhac/KkNoprgyPUnT14riC
	mHZciOzD4DmEhxfrcoGvfuadAxRflVbCpn2BKILc4w2ZLRpFthW1ZHmbHuIEg0U2Ufw4UD4D6Qa
	KyN7ritxViHFQ3i+V/soG028evctM7o1f3I/cpvqMV68ycotwymGfAATp6lQLL1F0ktqxLdlVQY
	XwU0ELDye8eoUgNZDOyE+wxsn+r
X-Received: by 2002:a17:90b:17cd:b0:398:bad2:c10 with SMTP id 98e67ed59e1d1-398bad20e70mr11350710a91.6.1788183893034;
        Mon, 31 Aug 2026 06:44:53 -0700 (PDT)
Received: from cachyos-aura ([45.112.149.37])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-142e0e0e67dsm26725626c88.15.2026.08.31.06.44.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 06:44:52 -0700 (PDT)
From: Navon John Lukose <navonjohnlukose@gmail.com>
To: linux-wireless@vger.kernel.org,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH wireless v2 1/3] wifi: iwlwifi: pcie: don't infer CSME presence from a failed read
Date: Mon, 31 Aug 2026 19:14:47 +0530
Message-ID: <20260831134447.490458-1-navonjohnlukose@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831131514.3A1FF1F000E9@smtp.kernel.org>
References: <20260831130332.323549-1-navonjohnlukose@gmail.com> <20260831131514.3A1FF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fair catch on me_recheck_wk. It is pre-existing, but this patch widens it:
a poisoned read used to take the WIAMT_KNOWN branch and return without ever
arming the work. Sent separately since it stands alone:

https://lore.kernel.org/all/20260831134140.480276-1-navonjohnlukose@gmail.com/

Worth taking that one first. The TOCTOU on STATUS_TRANS_DEAD is also
pre-existing and unchanged by this series.

Thanks,
Navon
