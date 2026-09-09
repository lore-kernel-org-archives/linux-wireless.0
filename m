Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005013822A6
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2026 08:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788941820; cv=pass; b=qBSEzTviwfr8UJBQbz7DSNZXR9WdGGKzGUaB90QZTW1EwWxUf64uDnhMTlp2bMFtY2EyiicmYnsVmFJhfBOTEu1niFBbGtmuxbF6bb7iTyoaDwcEojjoL6H/Bo6RDbAhWME20oaQ9eb54RZTOFJQZ132IV0qJw/ojY1DfkuytQc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788941820; c=relaxed/simple;
	bh=RL/+hNFUOj4KbQxDutCqWOoq2PWgaMgLTb8N05pdrrQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=APAkk4DIWx4BKjt1q/52wLTQX7Sja/ROl8ptuelBB6mhysNsLx0ItFXWEpFcNparOUlzbWBz6yxVlAbQJWY6WVNWm+L6huheOE8gXITMUmEHqTlYbLSX8IukTNmfvhNYMKVQNPbLsKjOgawp8/T08kJ+dmXkZaFwiV22gO3b+/I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TUV0+3u5; arc=pass smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TUV0+3u5"
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-47b47de8b4cso604760fac.3
        for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2026 01:16:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788941818; cv=none;
        d=google.com; s=arc-20260327;
        b=n6z9UFy3t+6MMsZoUWA3XkFPHu8KnojyN30xQSscG/Nra0xN14yM7Yei6Gz/WHldN1
         AELhVH8Sc1Qb1nC1L8fnqvNeU/s9TkJIBRzqWIvhSJMJd6BQ1gFNY23AvNWeKmyQF6wz
         4Tj0t6CHW2/11flyMPat2rluFblqlmEWcgxObO80xJ7vO0YLbNqvHHpF5g567RlhGhAB
         J1kiBK3vGnBlO1Yf5BZYYs9N9wkoySShuRosKXt1yojtJ9JCo7/ZAp/L2r6KnJIISr7c
         MTvYAZ1XC4EwMQanDlOLTAfdFug4T5COFmwzQ67drpZcnsKKRDNKw/CrAdl0NtR/Wa8x
         BezQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Q+AMEHPfgfNjqHmUbcG8IHBJQwLJWm0A6vsCsHD9A7Q=;
        fh=FEQXUUBwpt4ihqTdO6FzTAR1oHRvdmXO4qMy4OOJz2k=;
        b=V9ifRQIgp0A5c/+FWSaUctHidUDHqSUVAglI8Ra2DETqUbd/scWE12uIfBZSAk34rk
         v4eXW0C89Oz2utpFgtEx0LiPQhgipfeXB7MkMI+/w5zkE1a2EiG0vbieirBhDG/lYSRB
         NJEZf/Y7tQURNZUwrn1hncaqfK9HoJB0LMXt+W3sy9i/D84k3vtBEe+9/C6ZDvOLs8Tv
         aKX45dLtG9XpEKOeQ8seTTEMGcYQ4b3sptki4quksJ8ysoNYz5Z1MYid7p2GAH/8LoXI
         Ysyypfd6cfE3Z034g116znprjCE4sRHZzf4yWcoeyuo9ZCnF56n/KvWAPzJKugbUpsq8
         nAOQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788941818; x=1789546618; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Q+AMEHPfgfNjqHmUbcG8IHBJQwLJWm0A6vsCsHD9A7Q=;
        b=TUV0+3u5nyvPYtfY4FVhqB9In5GGIJ9Vkc0eu8gGKqKcxe6Lj8PXhWhf84nI4sFUmc
         5Y2YD4ML9CCI72kVmNoqgzjJdllRIV2fcpVbC4p70u9lQVx5YJ7L1htMccD8JWwx+fV6
         eyqp8ODnSxKOnlFIf22hxZkl5Xesr0p/WLRYPGyx2sK4iB1ngLYKTih2OBxFJv5rWAke
         BWNi538ZJT5xuOsl+YqsiJI5a4GWNwIroXLXtb2U5z/bZO0VERYzlVEftf2S4OfVclar
         pIVrrih+OE2B7RGu26+nW6hsQxrUi3L3QhLVSjClve4QANB0qDbbjnsJYyWT0zSktllB
         5u4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788941818; x=1789546618;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Q+AMEHPfgfNjqHmUbcG8IHBJQwLJWm0A6vsCsHD9A7Q=;
        b=kpqzF5evKgfOvoWdS02OlGLamJZIEAdMXEdE6EZHR74ZpbjWNQECX0fRlGA3QRxowD
         JGIJplId/RSxv3mittLNzUlfq6mD6bsfW7GdbopxCnOvAqYtDmHLY8OLXaoKehAOUbzr
         aHHP999SupbYfv+Ub79M0e5JdRo0u5gxFOSeOA68+nL7nMYsdLhgd7WxfLPwBIhV20Qu
         sO2fP77wMTsgZ4246KB4q6wE8oAG9XhM/xbbW+LLWBsvdB6AdAezR/lZQ7F248TURLPm
         bhmjN/JCHuKWzvfmjElJgaAx86APubk8fNbi8Hj2BgJRB6v9bLYPv6BeoznCvdRwQdB1
         IRNw==
X-Forwarded-Encrypted: i=1; AKwUvBxpH3vDRkCbqmDoF8SpTCiq7freYF9uL4O67HeN0Pq0dtt/tgQF/WaDHkraK7ibKDuRZ5b6WuleTw1wagp6RA==@vger.kernel.org
X-Gm-Message-State: AFuF++njXsEPaCEslA6AJObccq+6UA0dL2ub6yRZS1iycvD9Bm7cbNGF
	KLHEJTJBwXCIgevDScnlMYC3f53nSDLEeSWXvaIgFWQUi+VBXxxTjSyNzAokwwLFvtuv94FIpNC
	8yjEdgfTbDI9AnDLLlglSJClI3UYVL0jwgC1QaIj04g==
X-Gm-Gg: AYBFou0H9+Q16cZ3h24q9Nar286wswbA7GxXYaiUX30W5W72qL5Pd8PfRPrn/ESF5wd
	bi7azDJMedq50ZUigQP7fc7cgXkczgS0wZ9YUnVFO/K6+kJ/E+DoEDtGGE7pjGl5/pqG2SrNuhU
	UVoLR00d3ijcFUV0Nn1ul6NyDR01a/wL5VwWaJHzCI1bnNCzotLxvAYJv+Zj9FsAHfovJEP2lP0
	mV/uaJrDxrkrcjtu25QyiRL4oWNei9nxTGyQ8SEDCHQo2p/XErf1bjjbpvp75ZUrfr4w5cgimgM
	gZxi5zwgUUsGhIrCJGS4eFd1NHc8OCo4pnpyiAig/g50wtGBz5PQPg==
X-Received: by 2002:a05:687c:418e:20b0:456:bebb:a894 with SMTP id
 586e51a60fabf-47801f0fcfcmr13266895fac.8.1788941817673; Wed, 09 Sep 2026
 01:16:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260828150227.1062217-1-khurana.ridham222@gmail.com>
In-Reply-To: <20260828150227.1062217-1-khurana.ridham222@gmail.com>
From: Ridham Khurana <khurana.ridham222@gmail.com>
Date: Wed, 9 Sep 2026 13:46:46 +0530
X-Gm-Features: AcwNN1WCK5pqFslicnAE2Tiwfm5AldxOvhq7qzmoOZmdii5H4B6WhszyAfNnHIA
Message-ID: <CAOu+XQJjYeeRUc+9rj1ckLQ6+UcEtFJzM9Pv_8-v8t+_qbKVVQ@mail.gmail.com>
Subject: Re: [PATCH] wifi: mt76: mt7915: validate default EEPROM firmware size
To: Felix Fietkau <nbd@nbd.name>
Cc: Lorenzo Bianconi <lorenzo@kernel.org>, Ryder Lee <ryder.lee@mediatek.com>, 
	Shayne Chen <shayne.chen@mediatek.com>, Sean Wang <sean.wang@mediatek.com>, 
	linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Shuah Khan <shuah@kernel.org>, 
	Jori Koolstra <jkoolstra@xs4all.nl>, Brigham Campbell <me@brighamcampbell.com>, 
	linux-kernel-mentees@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Hi,

I sent this patch on 2026-08-28, during the 7.3 merge window, so it may
well have got lost in the noise.

Do you have any feedback for me?  Is there anything I should change, or
would you prefer a v2 rebased on the current tree?

Thanks,
Ridham Khurana
