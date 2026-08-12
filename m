Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581BF374A0B
	for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 14:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786545971; cv=none; b=YNqET0vmfoYnlN1LbYoM0rNMTspF7SghKAJnFNnSn4RdoIavdc0xFra7ch5cvy+ehxywbJhnaL+BYfYeVRgrr/WiWzEPgS0IDpkSY47uj+S3yANE1xMP47spIelzE3OsnXmjl/rL6MfQuE6Jp6c22BGDEuPggOnL/WO6s3wHeWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786545971; c=relaxed/simple;
	bh=cFqGG+1MzXWnp4RB9sSPNS0z7zmYPd2l9Kb59YR2vtw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=V72pR5Gco4fM4xpKhYjM39TIWLQwmQ3XMkRa3BK65PbafS19zVcIyPCGsJcQ4s1XKQxSNMN7OIJsifRY7RuB6KfrvO5HFxsBVuU7rIWKTdy31hcRndN+yd9ZjBMPgNPfRAKHEhwLGIBDZOwep8p0PNI48ZuTdb4Auwm1XmOsKvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EffaJWcA; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EffaJWcA"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5b15dcaca31so944644e87.0
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 07:46:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786545968; x=1787150768; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=o/XYikGcJLG4ug//+sYZHF8ixfSnZ+jEXi7zvDeMcXw=;
        b=EffaJWcA4gj5g6KFE1XpkhWaVFrdBMT1+RL54b+f98075KO6ELK3cH5LD0kNVpPfoU
         cA49m4iNYFsonWXc7wuCnlmXv3PYgAj1nSModYNjKj4ppoUnr9Wpq8OspzkbFKGROmBB
         T+0ExIWR+agicFkfy0yG9Ok8J65z93AxtI0W0+nEBEgXCQvF2c6zr4y7jMRrR3spvl5u
         EnNRBCc5TwHHpjHt21JhYZJJHSfdBdk9jBQp3+aUvywvP8qoC6ZPS/WHhNadeUHUBuEP
         u4FErafrRkI5FiBNugpfPkPx5hNn9LenFVbPN/arTDjQwT34olAZuroN/0uqOjjzqsl0
         2Q2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786545968; x=1787150768;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=o/XYikGcJLG4ug//+sYZHF8ixfSnZ+jEXi7zvDeMcXw=;
        b=IAr22CPBi9bGzhQJ/s9mZjOgaMO4ujWpyp8gZDVE7oJ2HyWQtqKtNsjzlA6YTvq5/5
         X+p1fvi54mQo+0gXpTCc6Z9pLUa5HEU7i1wFRuuyQXsiIygIAIuKPhdGDoI9tFhBpJcU
         ZxCyVDcHtF+kgx11azaki5U8A80/HKee/h5rZXjDP9475ClPmrLVzOTGK7RtvlR1F9eI
         Z9klNbyM77KzhpxSIyfyCYu0sUe6Y0Z++Hv3PAKXdz0eJgZhTgTu5bGDgopkIBeFQAV0
         ePVcM5q5+a6lZxdvcTDerWSh6PdO0DsVkwqNXoBi8uvL8uuQMxKV2AcMNP9LrYgAqIuE
         3tQA==
X-Gm-Message-State: AOJu0YyomSa88mlSQ/kO9TC8qpsYq6MR3sxWnpCuHPwjk6Z2nsGQuaZ6
	8iAUtOZhYMaZl10ddyeS/4qbPvoG/iTibinxgOoPmj4p0b5zxzVvHLOCLFI/3ZFb
X-Gm-Gg: AR+sD12NFqWecQrOqikPFAPjx3nhUNdAbV7RCW0SpBmPJ7lxv16GmjR3X08vLNpMo36
	SVtp6YGV6Qu7kFkDnWEVulTUGeH4I+yCRaSMZALwWhddoInJuLurSQ+p7MgUzyOE1gaBOW+3vkp
	S5r/nZ9SbSViuU74htCdadgqsEl+O/gM6O1zvObT0Ez5eAry0nPlLc9SbjLu5mPVWMMl8rTgooE
	VNZGxvGy5ZrMdjWtjJUHhjeM2/MaBI3qUKcXXc5uT0FJUdpCUKrRvij8ZDoCiyDNi7qbHuRbD+I
	0zq9PBBSSvv70Nb6ZO4zO/Ky1KYahdv4zYCcFn5Pk7/heV0X1CiuuutqZ7a02O/Usb35PUn5blB
	Ryx6q2AyedaQA9ozdaX7PqGRIB0O/kcMl/vfcX7ywjYWA+QfEZ67O1J4Vnu85+RVR4CIUKGeZU3
	GK1vYfGTxKebzGdpG1828ZAn+iBgH6i8smzCkjO5rhrx3xj9OOkE2AxfTEqVcon/+5v6Pas5tJc
	93y/iMJz/B0W2omy9h/6vAJCbAt7FXj5t1CBxFUNlGqPYkN4qtJrnnJoeQ8lsnHtxb1uO1uhw==
X-Received: by 2002:ac2:43cd:0:b0:5b2:add9:d073 with SMTP id 2adb3069b0e04-5b44e31efc5mr671915e87.46.1786545968119;
        Wed, 12 Aug 2026 07:46:08 -0700 (PDT)
Received: from archlinux ([94.180.96.85])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b44cfc27besm552179e87.21.2026.08.12.07.46.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 07:46:07 -0700 (PDT)
From: Arsenii Pashchenko <ulijg308@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Arsenii Pashchenko <ulijg308@gmail.com>
Subject: [PATCH 0/4] wifi: rtw88: rtw8822c: refactor DAC IQ calibration to s32
Date: Wed, 12 Aug 2026 21:45:42 +0700
Message-ID: <cover.1786545572.git.ulijg308@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series refactors the Digital-to-Analog Converter (DAC) IQ 
calibration routines in the rtw8822c driver. 

The original code heavily relies on unsigned 32-bit math mapped over
a 10-bit circular hardware register scale centered around 0x200. This 
introduces complex nested boundary checks, custom bubble sort rules,
and custom min/max tracking helpers.

By migrating the temporary stack arrays and signatures to signed s32
and utilizing the kernel's sign_extend32() API, the coordination system 
is linearized. This allows the removal of internal custom helpers and 
collapses unsigned wrap-around logic into standard linear operations.

The series is broken down as follows:
Patch 1: Prepares signatures and stack buffers, converting types to s32.
Patch 2: Introduces sign_extend32() and simplifies the validation window.
Patch 3: Replaces custom bubble sort with the kernel's native sort().
Patch 4: Eliminates minmax_cmp, streamlining search and offset loops.

AI Disclosure:
An AI assistant was used for source code analysis and conceptual 
consultation regarding the signed math transformation. All code 
modifications, final implementations, and refactoring steps were 
written, reviewed, and verified manually by the author.

Testing:
- Every patch in the series was verified with scripts/checkpatch.pl 
  and yielded 0 errors and 0 warnings.
- Each patch was sequentially built (bisected and compiled) to ensure 
  there are no compiler warnings, pointer type mismatches, or broken 
  builds at any intermediate step.

Arsenii Pashchenko (4):
  wifi: rtw88: rtw8822c: convert DAC IQ buffers and signatures to s32
  wifi: rtw88: rtw8822c: use sign_extend32 for DAC IQ validation
  wifi: rtw88: rtw8822c: switch to the kernel's sort() library
  wifi: rtw88: rtw8822c: simplify amplitude search and offset via s32

 drivers/net/wireless/realtek/rtw88/rtw8822c.c | 146 ++++++------------
 1 file changed, 43 insertions(+), 103 deletions(-)

-- 
2.55.0

