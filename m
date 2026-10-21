Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792601561;
	b=48GOBpmgtxuDhZtTBLbEaDmVSFqnLwWyUFNixZ2NsnmMcsyhGhc8rbY7wZfiRxMJBZEK
	 PcnkScfs05efGd289QCOXE0XJh0nq9e5Q9XLbMfjmvpjZ8rgCFVuEzTQVjnqd6nX7OhtT
	 QFYVz8ZliXbjn6QgnqX5HY795Yp1VMAmOtT83yaOWh0EuZP5zCg0JkrCH8ttXw+PDcC9j
	 2Hdczjxnh2mSRIABfXmU/YJey65YkZ6xFxWMbT12Cz/kc9cGTDJU6Z1n+xPJSU1j6FBoB
	 XUtOXnnqKOks9IuC8Irk0HNnLRCP89igLt8jOOLduF0SQdmucrL4ToNnrHEWzN+fNtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792601561;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SSE/aiGp07O28xClfqJkfRnHef6QHlRoW33T0GdwSH0=;
	b=UEC6GlF+5SqaiVggUhQx1vaL9qMOgJ0XGxNhdsL9+DMinhRKy/xGRIsszguRJ2YbeoTZ
	 oUc922G3/ZTWtEOcD+c/XEOpCqBSUjP1vzhiWReK4D3adFimSPFZ4vMvoWsj2Ul+7rL1s
	 nKe1GsgwHwL+gYyKvutrnqF3AYZijJEAKXAaTvqevouHoiMUP6CcYv/y84SJ/Ey6lu480
	 foXoCjtI3TOtWhr6BjtjTHnBSwnu6tAIZf9g2aV+zd9joZ/lCjzqyQYZAE14bbjybq8vq
	 qWAY+haSbzeMh3jL063ivSfavA4K1joJKgU8wxkIXivavc1kZ3suTwcp/06LfknTgGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bairaktaris.de;
	spf=pass smtp.mailfrom=bairaktaris.de;
	dkim=pass header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=A2yn1rPV;
	arc=none smtp.remote-ip=209.85.218.41
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC6F7606A319
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 16:52:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EC6F7606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=A2yn1rPV
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c37b612635bso137926566b.3
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 09:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1792601559; x=1793206359; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SSE/aiGp07O28xClfqJkfRnHef6QHlRoW33T0GdwSH0=;
        b=A2yn1rPVq3wKCqK5OuuEP9ScDSxs4aCHw0/HVBi0ol/+VPBJxcOCh5qxLPc4LuCGpK
         DpdHYnz9x3QwUwzZPAVUQISYSHyuNF1vHXiTX1wkWYVD/sZpQ4YPThQw2D4uOnqlQpy0
         8jPfxxWNMJRBoN3xqW/XjoYJfxMGWZjOuk+QCqpvDieat7DlNa8MvHunOtNRj09zngiD
         m20ePvvaeLVxro7AEzcJsjep8k9DSIDMb0x6s6WnNC3ahqoFpOzMsLS8HuYLtNgTNfR4
         LwrcmyimgfqcSB7CaGpEnFJ41gJ/FbhHNFypPtP8Igq+tlL3SxP4IFSQ6Wtr7uXyn8gw
         UaCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792601559; x=1793206359;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SSE/aiGp07O28xClfqJkfRnHef6QHlRoW33T0GdwSH0=;
        b=IRr9tUQ4YVmF4O7XsbzTUSRg/J7jXMFBRdQM9b8hw5tuj0/e89yXQM6wEF4c+wAacl
         vP/rgdQ15LLSoD3Uji+pAbxwO9SzWGSoEjBpUhCPN7tPLrGlMvuXUkdFe4VHd0Dd6VVd
         UZ1Ok1UaOOZDyMzajf9ASVz7z3umYKsoU/3jb5p9D1kPv22mZwz3XRD+4x5Qw0hfZoSV
         V9FzEYxcrZN0ElNmANniNACtb6Y2aIcByEu03qQVFGxHB1rcdH318mdhPdWwlcO0Gir1
         u/5bvcKSKUeRnMlN50AqRyF2nvz25PzwcC0dpz1EhusmXwLxuMAEcmmz37/LlSimEvq9
         IvWw==
X-Forwarded-Encrypted: i=1; AKwUvBzJrGA2+o4HXjiexx9xccmwKw5/3ODxuEEZ4hKtA+BfdV+z5nz5yPm2HGn+6ug4fIGpYYdFcnmcbOd2Zz5XKw==@vger.kernel.org
X-Gm-Message-State: AFq9FYKBDb+PUzS+0mKPXX/BiPqZODroBEJxuEYyuUX6TZ2vVZ4o25cr
	mCtlr9HKoH53I9l5eX+xsNEYqxosSApS0C+vzk9tMm+pORp6Ihum4Z3vuvcRfnj9wg==
X-Gm-Gg: AYBFou3Zj0nMzVvuwDGpTeuZERU8UFS0IGHJaMAUUiea7zkjyNaxardGamRBfantgPU
	PBAi++IOKZ+WZmppojsyal4wZgfxhc78jcWNzJKNrRfnNnTP3TwArDaCBRV2k0qiw8gpWqJdof8
	MMXmrlvd7kIFeYIpS2PXnDqGAj7v4iD0WSDwAsa/eNgRxJo92aLmU/c73vyHP4ZNMR4g/amH7TK
	QgMt+ty0U3NDnA8bteZNZ3Lty+429KThP8LbKMW04s8JsI9MAEQb9vmr7THJN0Nl4H/fVwwCjXB
	vyqlYpAQNb5pC4vC/fYMxyST+KSgbxDTNA4BhCHCESZALSWUnrj3LYqgaXB78064ZREk8ZcRB7g
	cw8PUwFpNFPZjh9qKfy+FVOSxYrz8V6pdPnHibWIsWKwY3EP7KXUJcjHcywxWSahPGuO/GHStef
	pyTXwfJ3FKPPyYdFRjpLYfksA2wcd2KzwZy3ZwNAMj65ARBs4haBHcQ5Lq6mq15G4f0x3VZ5UZL
	aGpxitiMqnnamcCGNnaD3fiXTpFe50fzVeIaxFrE+jmaUJ3YNpnf4vNYtwR7MW3WWd/AUc0HRFY
	Vteg0TvbVdzoZMBX9K7g/uOseGUTlEZ/ERtLdutOsx9fnRzpzz0Yb6pOLInkgEVVlKIb0MYaf+Z
	vl3bEMTnr0VmSPvwiCI0F38sbqbxYwfmxbnRHj3i3WsJwZ6m0Z2tktnPoyUQmeU+Ixzcn+S1kTU
	xvmknCWvbUdq4BeZkNPW508ZFsnSwdDENfEuNJK9Q7aFJI8IDvSiKGa4S88RUuUuWjFg==
X-Received: by 2002:a17:907:1c95:b0:c26:19de:9aec with SMTP id a640c23a62f3a-c4679b577d3mr222087166b.43.1792601559256;
        Wed, 21 Oct 2026 09:52:39 -0700 (PDT)
Received: from Desktop.fritz.box ([113.30.223.169])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b4030daedbsm1043728a12.13.2026.10.21.09.52.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 09:52:38 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: jjohnson@kernel.org
Cc: rameshkumar.sundaram@oss.qualcomm.com,
	ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 0/2] wifi: ath11k/ath12k: apply the 160 MHz NSS ratio to the radio
Date: Wed, 21 Oct 2026 18:52:39 +0200
Message-ID: <20261021165239.388945-1-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261021162023.280823-1-julius@bairaktaris.de>
References: <20261021162023.280823-1-julius@bairaktaris.de>
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

Please ignore this one, the send was interrupted after the cover letter.
The full series is at
https://patch.msgid.link/20261021165138.388593-1-julius@bairaktaris.de
