Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792528112;
	b=km8dDUa0EDN7vEJ6W2dmj8TiG0WhAixYAIopnWkc7G5AVL6dx0LF7gi4dmTY3gFjyfy4
	 5Z66beBizYCL5d9J/Z+W5tWX9CIBO2xQfrL6Ylg5vq5ZUdjI/P4gBdrH0eayRHICYzd1A
	 Pq5YAkMefywyIA/iU0U2ZRgJGH6qFVBC6dsNxLXJnhKL2xP5EWIY8g02dq/r/WxoCvDER
	 q1tEQwa7EcKFXxYut+0XG04yWoYGlwRPhHaDKhVrq6AdTP3HU4SGWU1BoktWao6XF9JDz
	 wMVjmQkHv9KPZNzHaoIEhJvDTTLoVFFsJ5rWwOUPoDYBmJtxjOULTToTULvqHnUwzYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792528112;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WD8/5T9Ciuv9waWrVcsqINmUY5GBTSG2x1F4rJwpQ/U=;
	b=Hy9SvPP6SWplqt9xyuY9GA5yw5rfugyEjIhGwyfldC8w0ibFAlg4y2JRtTmymcVlG8E9
	 HZZSrvighYFrLGBqfnsvMUfTAct2ifw3IgxhW5J1MbHlESBS2GQ5aDNCI4/MdhSNaXOom
	 lWvLFq0JX6cp4jxpUQ3n6x9AcQwN5dmVVy17+Wxu+fioP84STetYnHrwyY1AbWPG1aku9
	 DU3z1/x183ugovd6JmeG5hLmUoTsEsshtVAxz2NAnCIN95Zjp3l7vegSUg3mz/ixKtPCV
	 kx5iZoIfcvr7noWLpVqvGo6ka5zWOnMZom2sSIWT7fDT9lFGANk24V0KI0c/F7fan4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=AWU0KiMC;
	arc=none smtp.remote-ip=209.85.208.171
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D35606A321
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 20:28:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 56D35606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=AWU0KiMC
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-3a49a022221so475241fa.3
        for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 13:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792528110; x=1793132910; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WD8/5T9Ciuv9waWrVcsqINmUY5GBTSG2x1F4rJwpQ/U=;
        b=AWU0KiMCQabspfqJkK9CfxUvhC0CCjGRLp7SAqZU6Rc6n5torA6hasvYpWaTV2N3ji
         Jw0FYcG2XXVhTr+R8zjSN8ITdr9miql1hKSRtulhsSD5yOJHtwUPEUokoMiJoZEbPaXF
         9dvaVfjIdr705QrfFXguCgF/8R1xzSnxYnJ3ppeIBDMenoU0rzOASd6YmepZFqbXjfRI
         fVcyHLXCVnUDW31COcZk3S2+Ek+9jH10GqvZKz5mPCBdMsPVNLMMKelgmxwOCPJbcVgS
         ZI7zFmtYew2OObafY/IKGvIlvM4FHVXbnQma71ENcRmeYEfC+naiMqtrfsUxdKifnGsc
         9smQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792528110; x=1793132910;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WD8/5T9Ciuv9waWrVcsqINmUY5GBTSG2x1F4rJwpQ/U=;
        b=Eq13NSUr2dR8iUgqHN2ghrHa4aO1yrCN5+sghv2WLK0grji6OZtbRWGqkYKBhkJDKl
         iLD2kfptglExVXXHMEvDpqxP31hOZOANtJ5sXXRIKauVnhVvvKjqL41MjjW25xfk3Ei3
         41/JT6R9uEGRkZkKS/984JopLxh502oPoaBYrxoTziQaQ82hBiquXazj0T/DDWfDZAf0
         0NTXm9nwcyknQ3OiAuv0FKik4e1Vc+AcMU0Gx0symNYSn1Fju9b3/Qk5rpNh/DBsDsyO
         e21qAXhjxaevnoKGJI757CrA6bN1eC2kVd543EMc9PxdhIJl3S6PQ4HfrxUAGM6scCWI
         sNHw==
X-Forwarded-Encrypted: i=1; AKwUvBzW9CLZLCMcefU609xNSvxUYIlnWD893oqPuxsp5v505TNFzsKnIYHJKBQD1cMfluw/4xboCZuHFLhDHuGFzA==@vger.kernel.org
X-Gm-Message-State: AFq9FYKM2o4BQpDzDFRtARO76uy7GY5CZGotR20SmC2OGXCGyF8cbvBg
	JlSDcunNQDEahKSGNlb9B7DNVarOq30NEO7frpp3aeFsd4OSRJxURCjR
X-Gm-Gg: AYBFou3aQB5HRC5KBZgc8n0H3SpcZLI7wjOOkfkVC7sFo93VIuxyrCl37fWy6OFT07P
	XOTLpiU2KkgydwP/zs/COL18iH0UUUS7ykwQA+U5S52hP5mc4RUYSH5ckNn+5ZYvUZBijjDp1h6
	11E7ThDNMqHMUkJbuTd8RACItKBXyqoug5I5VKzd2LqCj3PYhkAqkq9j4cyYWV3+I90tAgW66BY
	ZffhHEWLR1dHvyXUojXitMR0kiaOfV/TgPsK9X6Aq+Ao3wnzL2pCd8LwUoucPqktDLiiaHPubOn
	jc/7trDwOuqDCi4nmvDtlm8ljTc0qpZXNgKn3nyhwCkwMk6B4O6A7l82dqzH/r6QqUv2D5NyvEi
	iyyUfF0dmHUpaUkAh9OLM5QK0NkQqZ//kcf1KVymc/tEnha0hQsi+0rFO/IlSTd55lMzU7W0sZI
	Cw2LT7jqxEjEy4ShUXue2WpCm5oOL1vJBfNdgFSDvOGcUGboNUCl51oAJyRp7INfg2wM80ssrl7
	qpgtEK0ATGoWpgosG6CvbawH4w4yzhCaMrY2lpUi1DFS+qTQifxS/vL5LS7A+/xl2PH0bGhlbwt
	4AzjA65S2dXL3NpSiqrq+a1dtB+xUOyso9fIoA5LugPCl1EhwPPa2US4e43iQJRMRVsGWiit3KH
	oYA==
X-Received: by 2002:a05:6512:1589:b0:5be:680d:6e18 with SMTP id 2adb3069b0e04-5bfa1be6184mr25360e87.10.1792528109517;
        Tue, 20 Oct 2026 13:28:29 -0700 (PDT)
Received: from kompukter-Systems ([83.142.235.16])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5bfa1230c48sm88136e87.66.2026.10.20.13.28.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 13:28:29 -0700 (PDT)
From: Andrey Derkach <gabin278@gmail.com>
To: David Heidelberg <david@ixit.cz>
Cc: Jeff Johnson <jjohnson@kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	Michal Kazior <michal.kazior@tieto.com>,
	Richard Acayan <mailingradian@gmail.com>,
	linux-wireless@vger.kernel.org,
	ath10k@lists.infradead.org,
	linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	phone-devel@vger.kernel.org
Subject: Re: [PATCH v4] wifi: ath10k: make in-order rx amsdu buffers persistent
Date: Tue, 20 Oct 2026 23:28:25 +0300
Message-ID: <20261020202825.1178464-1-gabin278@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261020195021.1133728-1-gabin278@gmail.com>
References: <20261020-ath10k-a-msdu-v4-1-670b69d39059@ixit.cz> <20261020195021.1133728-1-gabin278@gmail.com>
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

On Tue, 20 Oct 2026 22:50:20 +0300, Andrey Derkach wrote:
> Throughput is the same as with the old version, about
> 60 Mbit/s here.

The 60 Mbit/s was a board data problem on my side, unrelated to this
patch. With the right board data the link runs at VHT-MCS 9, which
exercises the patch much more: during a 120 s TCP download at
172 Mbit/s the firmware split an A-MSDU 211 times in 62,700 in-order
indications. The patch resumed all 211, with no warning and no
recovery.

My Tested-by above stands.
