Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749183C1091
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 07:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791272798; cv=none; b=H2rCmA2eFknPy7W8fIwuIaH/FNj7GUt1bwITiYm7VsG8N+Y5Ie9V0Fh8SmXI5kNpvDRgDPecNMOjYB1sfswbmsFnq+/YPHjsI3mtTuIWf55GuNoV+r8JGEUSPHZL+3vOmSAUvY1YIjN68XDYErAdNa33YodRZoBGk7ab6oi7KR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791272798; c=relaxed/simple;
	bh=TBoh8x2Y09OyIbQKjDHDrKf8iTEqOpONJ+F/G44QBy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SU0kKqaZi8TOxZ7tLNba/VIuOX0OCJiH68/6EXJO9VetmH1Zhggjo1sZecX6/9Fq7elROXUxzGf65/1F8fKyHnUCe2uzsKZAE2At0juy6a6IXoWfXjiSqPHNzVRlYxj9rIhu/2IN9AKbFmRetVN0Jn8rE/oexQh2TzLp4RhKRtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PYLBA8cr; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PYLBA8cr"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4998b5a63e2so23806935e9.1
        for <linux-wireless@vger.kernel.org>; Tue, 06 Oct 2026 00:46:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791272794; x=1791877594; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TBoh8x2Y09OyIbQKjDHDrKf8iTEqOpONJ+F/G44QBy0=;
        b=PYLBA8crnkHpTikLCxN2cQGxVSke0VWJJrtntt2+Rt88wJ5BDULTpFmsGDADFcZ9R7
         jV3OM5jvtofPx/E6YSX5hXY0O3l/9TzDRO5QYewpq6AtThV4DaOUV4u8dRiFVQQ6ogcc
         ZkXUVmhhbOC1/4ZcQkAjpq77jbBBYFudTUQ0eIKDnSJ1ravjnhYcXTJv0yXB6ABNN9By
         BqwNXtDWJxnUnm6ZM813oBpJnTEudzrwIehJLu1kwPQxJbhVclySHqSua2va5EGEnJ+T
         CDuG/cjMhg02Yy8SShFtT6i99CW24jtZf0fGeE53bQZjuNd/pB95S13UHp/4H2PwOZ0A
         HxeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791272794; x=1791877594;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TBoh8x2Y09OyIbQKjDHDrKf8iTEqOpONJ+F/G44QBy0=;
        b=fj3zJ5wTpkJ4wIoVakrwiEnUmmLKy1pV5cOGgn9fLFlN1h0+FNV9Gc9yHtqSkSe7LJ
         QvGXTL7dDf+h4j+q2vkAMclbKYdRMio9ukhfEMNxBCBgtqDOmpDbLcUyIqXOrLb5Ppa0
         bnV6L0E7v2mE5FoVcgMxn/GCMKhFwO9FOvjhFBGQQkHHI+tM36ggXp//LfCdmUQJss13
         cyWDaoYxRDis9OIbbUg2j9MN4qtsb5ZVaLYzp4N066SfnfsXv9+zlfZr9Bc73tkf0S3N
         yuUgqUiCfF3fjC3OwJNCz8freuFDY/ZhUKaBbNqrmG5ojLUNENxtxwVZURs/pWVseAu4
         pN7Q==
X-Forwarded-Encrypted: i=1; AKwUvBwGeH8ULMmg/FXEZlLtHVTdIR26zFwUevtCzJwfz31kXQv4VrD9o0f4Gw6sLiQQacHlHsyLdx01HhOJ9u5wEA==@vger.kernel.org
X-Gm-Message-State: AFuF++lPE22WVdy0muHtYErQc2E+rR5yLbFt+M0SDq8TqNKjZXKxjj+q
	vhGFr2h9JjkRC2BQTh0R0WxMuELvUFkamp/BL6KrrgXRpNibz9tiJ4wS
X-Gm-Gg: AYBFou3zkSM0sWF7K+mbE9cM9EaqwxVD3V24umMugSkwWsIgRC65sRUYSbWgPO+ceg3
	YJGpoMZyH8eU1jkZAGN+Y933bkKKSDGZR2WYMngOpK4huMRRkL7z2bUx50WcL/59AfNZe2JviS4
	5hnBjNuIwuCVfZBpxXdqL7huDFV7XZUt67NV0Bi4m9sNr7eFCqlivB5PCyuPFJvYFDoy5C5ssqY
	WG0Si/gLjnbXB7x4+BfqqinW/P7UfXephTU4mtAPrYzEq9lobJHBvunjcA5RmuyCOq32Ct34Y7w
	xnBFkN5lk0Q/K0bdeoJzb1cMQouTeIOV3gErvxYRKjuz/gdFOE7eVz7q3VPdCn4bIQ0229314hb
	G1TSdkDIFoA79kL3B2m8OgItTdGA1Cs48xUXBwmCgL05aQfdyf1vG6AcMqvAbV2DzEc4TfvOImZ
	TI6c+Xx+OkWPuFBvPM6gC2RLtMLvkolumqBHEeq86dBxWJwBnd/SxRPukcl7A5PLh5iI4JnfomO
	hXo
X-Received: by 2002:a05:600c:4708:b0:4a1:706f:b40d with SMTP id 5b1f17b1804b1-4a17b533ff7mr9742515e9.7.1791272793599;
        Tue, 06 Oct 2026 00:46:33 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48c6229ee60sm8311421f8f.34.2026.10.06.00.46.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 00:46:33 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Luka Gejak <luka.gejak@linux.dev>
Cc: Ping-Ke Shih <pkshih@realtek.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: Re: [PATCH rtw-next v3 1/2] wifi: rtw88: download the beacon the reserved page was built with
Date: Tue,  6 Oct 2026 09:46:32 +0200
Message-ID: <20261006074632.372846-1-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <64b006322730e0a078983458932dae35255e65dc@linux.dev>
References: 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Luka,

On 2026-10-05 Luka Gejak wrote:
> Reviewed-by: Luka Gejak <luka.gejak@linux.dev>

Thank you, v4 carries it.

Best regards,
Mehmet
