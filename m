Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792763490;
	b=dkU3JzVwGLy4nQ5BbXr6Z/qbxvYBB0zxSvFOoIpZ6wBubm1o9wstnygyi/LSbqD0B9Jm
	 xEp0wk00QCfdykKqztIGTzQqxpvTuxndDpBwyIDiBHKFxqU+3XpyeVn4+MqfF20AVmhxp
	 1F82R/mBj8CZhYuzvt0SkdK9jPR32QGUIw6d7+oKpO7mD5a3DSBtHVlLttCEsPQBB6GNh
	 BrLdzmBP9ieCBEBC7Q5kmHnKS2DfGOUfnK1k8nGPUOWIgRolhfbFdF/pxeIzb2EwUg6ru
	 L8fBBZZbY2D+lEs1b6UHsOdMwqlRYNZmu0cHKnqkxl/QA7jE0i0xYg4hZYiqu5+Fmjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792763490;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=rQJmhMDaRAsTP37CWAcROukZCu5BZelTc8z0YsFLDJo=;
	b=CrLJCmm6zDdBJe7vOcap55lMBatElrfaR6dtOqywsrkDhTNF1pWKdJRZeLWyRhTZtfhQ
	 H/6b5tmY074GkqfL0QxAI72nX/uz7PKICOPyE3SN+w3ynAdOa6A/JiadeDKq4q9xC8WOo
	 +jGcx6oagGAUxN2qQNwSE2pGxnA6rt9IQJhcg6RWQp8JvEyzPxcWnZ47YrthiKkJMm+HD
	 FLEFIAajWsNl9aSGt9ExhvWAOxYklFsfvvKMPMiXJ2tDWFWNytrmq4zFwTDcM5pcCIOG2
	 bpb0ncbEod57UMkXmq5b1djyZyX+sVg331rKy69k4GKhgGGLQKrlxpgGbr4JoMHm9HQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=iInoVN56;
	arc=none smtp.remote-ip=209.85.221.51
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D96A606A31B
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 13:51:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8D96A606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=iInoVN56
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-48e20edd106so762255f8f.1
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 06:51:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792763489; x=1793368289; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rQJmhMDaRAsTP37CWAcROukZCu5BZelTc8z0YsFLDJo=;
        b=iInoVN56UL2VtfQF+kbCbg5rcjOLrsexQXa/aZ2PfbOPcY/hGVwibIyX3jKCA5De4H
         xlsWb5JNhqbYmmruGskDCB6YBFepHN8HbJAXXG5DceufWfddc/DWer5BMwUUcuSMVOO5
         mZtenmvjs5m3nEMRbAuVilJTO1Mg208ijSJsJF4Ua/NujxJmNDmGkg5PqfwzE534pkbO
         7EXlSps4a39moMgsm9QiJVakgv7137hXul5tmBXalepv9jN6MmQ4Rb2oa/CjPL6jf4WA
         H97ts1HhekEe9uxNSTmGkH0dkTqlbv4HreDcwjCZyQNO6nqnBBYvrClUIPGFALkDz3Yw
         AV4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792763489; x=1793368289;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rQJmhMDaRAsTP37CWAcROukZCu5BZelTc8z0YsFLDJo=;
        b=YcsgCbwEr9a8kgSOxnbfT0bD8w7eMoCjJXVPESq5HqZKD34I05rpdXiynicBFCO/tZ
         uZ+utdUJYkRM4NTsRrvvrwZOCRUN4+R0FP74Jrf/beI0sJoIuV7KvjhzDvwT/aY3awbS
         Hxg6U2HepzNf9IY0T+Dfgeg0PqmIOEjMSWRPwqDGz6mItXScRYuSs8sHBrYE4hbQUZg9
         ZD762+9zTOmHu7FBZvbOPimsdEqdTIzxyf7eWZCPUV8QcsPAusL39wT0Q2Qk/OOS3QzR
         UqweMKvvbffa5Fv2pL6OYiEjCQe/HG+9qZjS3aXEAvzcblgWmaxDecFDDejM6GZQ+tLf
         BzVg==
X-Forwarded-Encrypted: i=1; AKwUvBwR1RVcGBqlqqvtzQXOIz1qIDZ152KqnZbB4cdlDf/dgUmm8bMpANMFO4Zsr8utQnzUAuigmXzC0qyTfAXvug==@vger.kernel.org
X-Gm-Message-State: AFq9FYJd668Ihk3oOaQ25Fv46OAGqvKrt+aYbNK5x+8Pymsv7jAamdT9
	T71JCegEuIzqBfNs8GhwqivUYiELc8WspjXM8vOaga8wW+g5TRJYcM5qfSDUgUdU
X-Gm-Gg: AYBFou3MUvbOuWDtXwcNsd70IN6sr9DBjkVg8A8vAAiaH0mY4uf04JIldRq4/M41GWz
	BFTAAyyI01OD5orPwpIvgxAT/GqPTnVpGBuGpn9BJEcX3+fhkJ9/lycT+o4STQn2cmjah5nkx9Q
	rrjN1B2UZ1DKQKO1yGy4jO942dLiiUGYuVAhzpYcVauy1LxgEEnPxlyRNfIaZ9EBrHdVnYPH1d7
	tFjd9KGI8fYkeUOpgYOmUg3X6oXnqyKzvSAeIA9sQ2syh+Zl7AF330Ma1VpAUYJvi7bc8Rudu1g
	voqmsJH2AlK2eB7P/tZvGH/bA6k8Y0CmKvAa3iz06quqnd0q9+TPutHP1oB60KV9e+pb2mkrasH
	wjLSsNRE0ONiO55lFKcR5aX5Fkp/0z+7NvsKPoatIyu/QJt0B1oJYP8tJQhUXNjUCico7yI3h9b
	Gqbchh/VWDsFOZ+h0DMl6Te6rbgdit6Dkw1ANMHaeo5q/8QdbbmtrscGxYgHEJ9FzDf3rbXyWos
	7PQ/VPd6FMtRTophNaDq+3joUf8hOxIP1QrKe7jxdhv8dj37HHKp+rDuIgmYg==
X-Received: by 2002:a05:6000:29d5:b0:48d:f025:110d with SMTP id ffacd0b85a97d-48e385a0752mr2736643f8f.43.1792763488617;
        Fri, 23 Oct 2026 06:51:28 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3805c596sm5486156f8f.49.2026.10.23.06.51.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 06:51:27 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: "Felix K." <fk@mutemail.de>
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	linux-wireless@vger.kernel.org,
	stable@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: Re: [PATCH ath-next] wifi: ath9k_htc: fix beacon slot selection once TSF exceeds 2^42 us
Date: Fri, 23 Oct 2026 15:51:26 +0200
Message-ID: <20261023135126.4118569-1-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <8733twsm6o.fsf@toke.dk>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2026-10-23, Toke Høiland-Jørgensen wrote:
> Mehmet, any chance you could test this one? :)

Tested on an AR9271 (firmware 1.4) as an AP, 6.12.113, with the TSF
moved forward by up to 23 wraps of 2^42 us. Without the patch the
beacon goes out half an interval off from 10 to 22 wraps; with it, it
stays in place throughout. Beacon count and a connected station were
fine in both cases.

Tested-by: Mehmet Fide <mehmet.fide@screeningeagle.com>
