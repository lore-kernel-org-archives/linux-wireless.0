Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214EF2DC765
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2026 04:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788756211; cv=none; b=cGzjzdusEil4mvrA1A7CVwg4jXueU+nC4S5Newv2oS1I0UwZs1oRQcjDyHuHLd3361qMjPD9F6gcNpjCYAbLJ6VGHk4o8UBEQqxCt+Aajye9c6E4bxy0W+qfaeJXppsEhuOm8FSOdObk0Zenasalmubi4F+xvmoF55xR8Xdha7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788756211; c=relaxed/simple;
	bh=BVw8IY5EYtMD4L+jHzae+iwF/GRDppMCagadCeLC0BA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JaCtqdrVzz1pkECXkhcfY3Sg4VY4HpNFqcV0TLpbKlqXIw3Yo6k8+0rl3CqGjAIImjqOXleAFKA1zpOc9dFR+eLoPuJOI8VCw7mZ1J96nUoS17R1Ih25T3z63LacvFLGN7A2UV4uLejqMnf/WYtvTkrDH2AsgeTbqqa16PKc1r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lCv/cmfc; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lCv/cmfc"
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-3a20367cf82so26021251fa.1
        for <linux-wireless@vger.kernel.org>; Sun, 06 Sep 2026 21:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788756208; x=1789361008; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BVw8IY5EYtMD4L+jHzae+iwF/GRDppMCagadCeLC0BA=;
        b=lCv/cmfcI0lPNIL6Eee05C5xpctiUMVjry33f0ubuwnZftLXWk+H6LGLqeX6A4TmTe
         gRmTAfIMtb83uOVuXJbJ+ltCNFXAioKeUU7a2FVKSIS1V9j94Xl++L7J2oFmzrqtfXOo
         Vt2JfMup8jWVPacc5rBa3c7pUilZHOPzdw6A5wkgGISIbX/Y9qywJL6O2gJg/DWj1b9L
         CYWSOxAPLSTRUwmfzfBzTV7FE/Jbnh9HjG6dM7cIFWLI5P9wJLeWL4jCofkvhMHKkFnQ
         +6H6T5zxBVhzdguuc6pzLt/wo6nhLQMKr2Lb7GMl/gHgTWLveBigLyM9AObLNV2ClPg4
         fMYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788756208; x=1789361008;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BVw8IY5EYtMD4L+jHzae+iwF/GRDppMCagadCeLC0BA=;
        b=dE1LoC5wC5aFKaBgFejBf9mdF8a3+gDAABzY4XDXZp0jxL8ZJJXUM+EOQRLw3NXNHs
         Q4wefxpPeiV9CEluYpirQ9sJLeFKHOjaRoO6TNTq2WuCSCkW42xgjJC7KmsFztWeZsbT
         rMeifyajc0Ofa9Zp3pK+ImylnZX7uZBk8qOCSghbKY68qkTYxCgMhU8K/ZQhOW4aMnhq
         KHFMOtVB+1FbKRpbA006JtELExPahrN/csWS2FVQHJd1pU6b5ggza87Ss5d2lHTN3NRB
         r5gMcLoK8Tnf4D3qwLz9NltXsKKKLnwuhQqbvkO0ChJosmFPDn0tMlu44pJNKGHlpzEy
         DSAA==
X-Gm-Message-State: AFuF++nEwf2oG1jeMkKBp78OwgGvBdML94m/3QF/WJKYMKGtrQBsDkPH
	AC58DdvpNd3mKticyXX6fHsE/Av0fPc3lK8ZPTJ9tuliLhnwA+y8i7pB7vFOq2Cg5jzDbg==
X-Gm-Gg: AYBFou3lCjLxG/Mz1hf/e+NsxOUEpAk2OQ1qN1rtItfLJjEF0D7lsY3wtneZBzU1S7x
	zZZab2x8tt/sbKFFn1rIQAF4l2r3VnepAPgfii4bYQungCJZD2cKLbxsUW4/KpHu0pjN0vKwRv8
	cFRUFGvD2+d8K7W/A3TKE8y5VGQrf0phTtr0NLWd6QRHM71VcEMFSU+eEFBHC77cxniDMWSUX2d
	++wcW0PxA/8IjZrUOFCqy7+voSJFtpkiy+z/5y2qeKDuvxyGLAYQbNhLc2g6sjRQegHjvEgVYlY
	1x87KnHtoTZUpZVkEx/sZ055FJBcZ1Pe90iLLAyjzr/M4nt3TtCsLy5cyTu4XXv4DUfEOXGN/sz
	4sbQkjvxgC2+6LLQvFDNTouNtR1YsL6fZn/ZdoJPl1qChcwqvg4y+VUfaquEG4RQOIXFCyTywjc
	ZuWAzXwDjCkO3PW38R50oT1Rsf9aqhzxj7gWUFgMYIEamKWTVFvsSRh7bZfR1CqCA6kxigSGxfe
	8mKKg==
X-Received: by 2002:a05:6512:3d0b:b0:5b0:1b0a:2370 with SMTP id 2adb3069b0e04-5b616edeb86mr2969246e87.2.1788756207681;
        Sun, 06 Sep 2026 21:43:27 -0700 (PDT)
Received: from localhost.localdomain ([80.66.92.203])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b74cdb1067sm1429611e87.72.2026.09.06.21.43.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 21:43:27 -0700 (PDT)
From: Maxim Skokov <skokovmaksimevg@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wifi: rtw89: fix typos in comments, debug messages and struct field
Date: Mon,  7 Sep 2026 07:43:11 +0300
Message-ID: <20260907044315.4364-1-skokovmaksimevg@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <8906397e40454e45b82c12ea272b3a9f@realtek.com>
References: <20260904222548.19732-1-skokovmaksimevg@gmail.com> <8094bfc474e34b2f826b9487e49bd601@realtek.com> <20260907040138.4321-1-skokovmaksimevg@gmail.com> <8906397e40454e45b82c12ea272b3a9f@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Ping-Ke Shih <pkshih@realtek.com> wrote:
> I think "LLM" should point out the model explicitly, such as
> Claude:claude-opus-5, Codex:gpt-5.6-terra, ...

Agreed, that is what commits in the tree already do. Please use:

Assisted-by: Claude:claude-opus-5 codespell
