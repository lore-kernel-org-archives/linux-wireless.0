Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793028347;
	b=SeybzkrwzG7XKKteAkUpHXnBVrSa3tV8kcOj7pEMfOUtetr2XXHKFZ3kcrylABkffblp
	 0aFiCDDnW27sqZoA9qdBu4KotPqDjliaBpmkrTbE6q8q66YkZg9AKomOPHIvhv1qLdGOJ
	 Rl4UfgdFr9U826mL5/Om47UBJrMsA/uRhoGGy7lfco7NFPVvEQmsSaXgM9i+LVhNHt8yH
	 k0jCuUxWqPAxzaib4MP2d7//irOFoYux4hUbaH0mUYrSVCcxAUKAUiBwQ2i9WL8c3Jx4/
	 mo2q/sCTCwy7frYbXvTi7nj1sRDfQFwylahNDilwgZTU3gVVyQ8I/bRdI70SvRsa8yA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793028347;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c/MQjvVEIaGIIhFl2Ewnuj39H221k2u6PHHaq/5GTO0=;
	b=mLPA27C5uQ2T047xvC4Z31cP+pAn/b2dlhvNrjHJskyqUVkRLNZXX0ZS1Mowfij39+Xa
	 jDq6OORf+jAKM8EARJ66gIgZZXnUU54tF5H8TVjb6NRZSqwh51+Iy85KzRqd+AUyucEOe
	 qUcsucYQJxOXFXJXoF4RAfG+eZoTGJrqY0EK7S2K02MvgtffqO0wRBt8u7BzsaOHwMqvd
	 ysaQRSmxO/gmfWVTN5JIOE/BnhFf0htmvqSaARuGCvcg/W2MOA2tN5OHrByAl5WAs7DP/
	 fivdsyD3KfIst6fwJLXa9QN9R9VLL09Lq50XALsFSCYLvbLJsoKL0FiI+yB5DPSGl8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=BCjv1FPk;
	arc=none smtp.remote-ip=209.85.221.52
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12798606A31A
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 15:25:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 12798606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=BCjv1FPk
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-48e0d1da913so800f8f.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 08:25:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793028345; x=1793633145; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=c/MQjvVEIaGIIhFl2Ewnuj39H221k2u6PHHaq/5GTO0=;
        b=BCjv1FPkyBVCZwvsSAw+OzouYceN5Q2EkF8j3i/rNpHcmNSg5MWxtL9L8Fi/eS/v8y
         S+LoZxGEAzxeYH9iA41E/jD/zljQJV6LhWfOoTzzcmsJusxLxFUib/rjZzXn9Dll8wpu
         W2RwC9f4pY84bBccePLQ9xN1zcsAunpx9ykU/3Qa2SMAweZIaXauuWfhSvsiXId9i5m7
         ikjUieTG8KCKzbOJbZksiNychzJuXEfmigi4QejJeSdsYY+1gzTnEImrdO3Ws7poegPB
         Yb9hrn8pEoFXKigxh4j9nfebjwWXN/AovLUGhVJ3XFzgv3PEQhy2c2hXoY894V49QXoq
         cNaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793028345; x=1793633145;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=c/MQjvVEIaGIIhFl2Ewnuj39H221k2u6PHHaq/5GTO0=;
        b=G0ggvuR/c6mmurwVykBw6fm3OGjZLMU4cXdllwASeGVuQo8Cs9zZXq3GPkDFoJDt8l
         gJS8Zaq0g+5IUy7J1mDBXhIvmBOLCwWe/Hf7w4uo72uFl+19UoaBG37SLS+J2t29FpW/
         DEnjzVeT+Qnthjm309cGmwrD5XjrFU66fiWOt4fFY8rj/ogdAk1vt5e1RF0D/P5sOYX0
         lrf9yGoAJmRucibZTmsZwphpWPoHsmOQPXnSiuLtMTqnWdtTOnaIXoErPRtjsQC4tagB
         wJJEyRXQu6lHObaoiA2muh3zz6zeojzOQKMmlI01fgWu9srOcyC3Qgp0+O8UU7Cgw1mu
         J6bA==
X-Forwarded-Encrypted: i=1; AKwUvBzbyQW+tnUF3pInrqjCa6dL81o+T1qlMsoShRT6xPDnSyr1w71Aci2+V4OUeiy319bvTE00eqPqVWeMGYSOyQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYKq5xPu32dBwL4XERxiNDdIBlN7knTtakzFHxtPElsHbBjoweJ1
	xukMmNGCHR6Nb74mBgu7O386uM9oH3w9ZE+MVdyTHluytliLjHjvx4Oj
X-Gm-Gg: AYBFou1I3ie8N/Au2OjcQ+3Ehr/gVoY5xuKkyB97CVbMKWk9Q2kpo/Dm+kgIgnsmMXn
	qbPZFuhWFnGCk+SZ83ut6BrbpZMswsZrc+Qf9fiW5pT4nf11igPYB/nnDS3RYECyOt3DcX4lKA9
	pjbAk1qURoXfv/CnZS75gyk6Hfz0u67lzN8S/Uf4grgXKuuzK+kmwTuEIqNv2nwDbzg4mZRXX0t
	/+srEHIezJO3MjmGaLjgMZRTAskbOrKdGjni6gaBd9ecYX50aAcuSNvyEjdpTJjsJJC2UQKJu+E
	g/is1skYp1LTjv9tA1r89T6mXyGQ3iYElmfljK6dkTRvhm6oti8Tal5CgiQrFDbpaIQd/a5V2ID
	moW0cSBfsGGbZyLzNcgDb2Ik0EZxzExAs8q4JIvhx3aGOdF8+af6kPlkzCS7LiQdbS7JUSrA8LN
	tKNscdwXCCySecqtTeaWkANJbYZoCINE0IEWfKOUhq11mee7axHbJZphlS4h1MYUAgipuTRG+uZ
	8MsUSB3I/9vdDFhVCWj2NOrXRQN5NLYdkQxBUXxi2TfeNt8Lo9h2TQF4+FKa6g=
X-Received: by 2002:adf:fc4d:0:b0:48e:3c5f:a24e with SMTP id ffacd0b85a97d-48e3eb73979mr9752906f8f.11.1793028345178;
        Mon, 26 Oct 2026 08:25:45 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ecd3705sm20057337f8f.45.2026.10.26.08.25.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 08:25:44 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Luka Gejak <luka.gejak@linux.dev>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: Re: [PATCH wireless] wifi: mac80211: abort chanswitch when leaving an IBSS
Date: Mon, 26 Oct 2026 16:25:43 +0100
Message-ID: <20261026152543.1272978-1-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <c8bc5affa75d7519b424ea98c07c1d6b65942347@linux.dev>
References: 
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

Hi Luka,

> So if I read it right, after leaving mid countdown and joining again, the
> next switch with a countdown now gets past mac80211 and runs into this in
> ath9k_htc_channel_switch_beacon():

You read it right, I reproduced it on an AR9271 with this patch. A mesh
point hits the same WARN already without it, since ieee80211_stop_mesh()
aborts the switch the same way.

Dropping csa_vif whenever beaconing stops is too much though: off
channel, e.g. a scan during the countdown, beaconing stops with the
switch still active, and the switch then never completes. So the fix
drops it only when the switch is no longer active, sent as "wifi:
ath9k_htc: clear csa_vif when a switch is aborted". This patch should
go in with or after that one.

Mehmet
