Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5F1340A6F
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 01:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790126562; cv=none; b=mRh6+UajCHc0U+McYqEWllOJB9H7v1swcuzl3BAomB1hkHwuopuCy+bB9u3ikvplwrrpitTktfQsyqlD9XZFGINhLO4Vl/8nn4TaEBUb3iPhB0+5JOpg7dhEmamStnpdjpg1aoSNvDnnl9/4kMUhynKbg7rffUQaW895GjrTCAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790126562; c=relaxed/simple;
	bh=+h/tQM1KRRz94YnwCuXVu511Yz+gseQKHqy43pFBzq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pYW4OB4sjxYKjqobik3G2w9aaKhYfelkw60z+B6NjdX/Q6ugrtIG96FPtElMCdQkysBmj+W/xC2/DcyITbbBoqDcS3fydPZ57Cld1cNv8lll4nmgtjPZf/rD0CiGHSprfsoxDkoFlx2dM/KwalcXtY/GFZLj5Nw7ZkK5oxlitD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Wy921TE7; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wy921TE7"
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-399026951a2so55331a91.2
        for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 18:22:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790126560; x=1790731360; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+h/tQM1KRRz94YnwCuXVu511Yz+gseQKHqy43pFBzq4=;
        b=Wy921TE7G6KUWuVwkwRzZ16iM036rQS5E0LZMW4uXXGx77jeay2GOyMoEdKuuxoxHz
         QLh0PsoUevwrVZ32ehW1FrRHrXOtZzSRKwjo8wAKTBJ4us88RTPvboVeQv6LG01jHMoe
         xcYRPdV4AsSrPheo8RAYS9d2CVJX73KaEBrBLm6oLKj4pYAaA6SQS7Ognn3KxM8nzTQq
         E8dSg5V4QUnBFYJZ/0woKEjElYcSGXmLS0IVT6xh8y9vApOu369XbZe+aoK/bCZ72PW2
         twIPT1ugSPeslxSCFCAoZF6CJfruYKkTTnqzRpLpCytVdVuXtRt8F3oIKG1K8/AlQ+/j
         apNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790126560; x=1790731360;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+h/tQM1KRRz94YnwCuXVu511Yz+gseQKHqy43pFBzq4=;
        b=av85fjA1AHl7apkiCUu00BAJA+dI9BMEcPlZoB+R6AHCj5/7hZjWHosoKDSyDBU0rl
         CH1YvMYcJxLrkHauWSa1pNuljHwhTAG4bXAcIWh4LZv4lXiHOa5fokoSetuMHUhnBJ7a
         +DmVhkPwpyffAINvPH4uwHV8xAY/H+NkTypk/DAwFlKxwaUf5cyyJijC9OZkefrDSQzj
         ox+x49G40s9LV9lGcY21ZEFCttEojgwnop8EamZaT5M0VqkdPq6p2lq8UARwykXRGF/8
         WlrfY6HWRxIFu20JXBFvnAuEFAWSL8h4a2KANkbIxh6iOOKa/qfGsmXnqQv1PzPwC2oE
         HqkQ==
X-Forwarded-Encrypted: i=1; AKwUvBwBuEV3qub3FnvsU2wy4tHOR9RweNQju3H0qdCVjQHuYNAxoJGnRsgMPVDl7gXeOLQKQoLwKjFdLqZGJSyWzQ==@vger.kernel.org
X-Gm-Message-State: AFuF++nUG2zwmy7g52HVowGYs+qtaCCjaKOgr9DoXoWFFKo/3cA6nMyo
	G20Ih7o+SzBacWh6LrJjNNb0mY7WDmgRBVkuOqjA0MZWI51KUCK9kBUz
X-Gm-Gg: AYBFou0/Z6GvLlsl9AXjtG9cASHY/xDAq2mVmY50YgNU71zVRID6Y+utdYuNQtJdomy
	CRvBSW2jWh5iVcgLmHShNQ/5USwWyWvehgtEUo9TYz3K6dJazAFVDIEz7U5DgOaeECTylY0Z2gz
	maJpnqXjSzOmth7BaMIGX5/l9rI4c4kCVDD0Mnu2EfJ5b8GJeR3G0zvZ7Ri6fmcOLkgtJTWNJxi
	es64ZCzd50qrIEs7lMRjaZEfXCeB1qiOy1BSwgs/AAzjIw+fQ5wql3xfaseJB+UfHdzReeFD04L
	hB7aXtKKmoMR9LivVviIROpBPDkvu3rZgDDYoEXzvhWkEq7inp4V2ZgE/dEBcTFe+Aqw7dSAoAq
	hbhSrYEVeb9aeOxkQAdIWUPq6KnZUEStE+wzbiONvcHmJRj020BZdMCSDy7xYMbn5/Lwwptt7Tf
	w4vNxw/Sm/Sf9wfCZrhK6aWGq9qESixPAbQKjvaCE216Qo4LK1fB60CJyiOM0iiSlXlnS01ZJXP
	tlZT5p3ZteX80eHjnXc+YeMUuOz1Mcvxw89TH/wqS+hY+KqzL+aAdfWw7jQ7NlElMmy9EVdZXSP
	ls61EVZO0tHoDphGkqSoYUXD02nXMg==
X-Received: by 2002:a17:90b:4fca:b0:398:bad2:c10 with SMTP id 98e67ed59e1d1-3a07e773d26mr1573460a91.6.1790126560258;
        Tue, 22 Sep 2026 18:22:40 -0700 (PDT)
Received: from cachyos-aura ([45.112.148.109])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a07de1f20bsm1784885a91.11.2026.09.22.18.22.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 18:22:39 -0700 (PDT)
From: Navon John Lukose <navonjohnlukose@gmail.com>
To: nika@nikableh.moe
Cc: emmanuel.grumbach@intel.com,
	helgaas@kernel.org,
	miriam.rachel.korenblit@intel.com,
	mpearson-lenovo@squebb.ca,
	linux-wireless@vger.kernel.org,
	linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/PCI: Disable D3cold on Intel BE200 Wi-Fi on Lenovo IdeaPad Pro 5 14IAH10
Date: Wed, 23 Sep 2026 06:52:32 +0530
Message-ID: <20260923012232.240305-1-navonjohnlukose@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260829093922.37103-1-navonjohnlukose@gmail.com>
References: <20260722021321.68902-1-nika@nikableh.moe> <20260729125202.33719-1-nika@nikableh.moe> <20260829093922.37103-1-navonjohnlukose@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sat, 29 Aug 2026 15:09:22 +0530, Navon John Lukose wrote:
> I will post two small iwlwifi patches for this as a separate series and
> link it here.

It grew to four patches and is at v3 now:
https://lore.kernel.org/all/cover.1789333511.git.navonjohnlukose@gmail.com/

Nika, if you can run it on the IdeaPad Pro 5 without your quirk, a
Tested-by from a second machine would help.

Navon
