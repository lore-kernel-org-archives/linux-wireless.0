Received: from mail-4319.protonmail.ch (mail-4319.protonmail.ch [185.70.43.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E6B53B33E
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 14:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790693163; cv=none; b=IaIDX3dUeOX5EpEHmVuZWzwO7EkvKDs+44LDBYKUA0FVuWlj3LJInHkTco68ON/GtkA+Sh7MSn7sRyIVODjNNXzyLP11mZssld6bbh0D8sm3QfkB2VjmZIuwMeGxGCgPNV2Ln8bFAbMfgJn0koo3rqPL5TZbd6w+hP+pwLDeIRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790693163; c=relaxed/simple;
	bh=YqRb0Lt6o6cpf5+myrECVbP/9Jgh1swBc2Lgnr6DRn4=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Cg8B8dT9pbeYdEebVIpKtv4wJ2SbAVp1g12Jvj7tjSy49EH0oDbDmx9fuhtA1d+oEfWGyRYtuE7dSS2IEwY3Ci+mU2Yieh7HJ4bp+GhnnL96foWuuOCSmKndJJKNIUrTEr8CxQdBSIvr6H3EuVCpPUJ3K3OPmC9r70c7BXVRO+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=v7zpD7d/; arc=none smtp.client-ip=185.70.43.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="v7zpD7d/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail2; t=1790693147; x=1790952347;
	bh=YqRb0Lt6o6cpf5+myrECVbP/9Jgh1swBc2Lgnr6DRn4=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=v7zpD7d/tjzU7MDr1QYrvJi3Ol2n5YL6R609Y1xgYAWh6kSelWmrS11nhTN7smA5p
	 Ii3ijYby2iIBkO0OP4H3/ccdcU1zY/ehPOPXVnEzGRK+KnpwS5KEriws1Fs8Hmw5BC
	 Ant8I7MEJVKKEN4kVEY8xkl9f4gSAZ7Exy2ZO/w0ENQnGgGtjjw9mEFpv9rrwa3V98
	 75km9cSAEpqYnecesmpWjjUAClqGQZOTfqy8Fp+YVaOaUoKzvMKMKOXxEUO8XtNFVv
	 WQYDcgtDztp+cV+6MfhGybMM6jqWtOs8l9uZob3rVcI3w+Vk7Fn0BfZx1Ne1AJUk0r
	 0yOe70pLsL5uw==
Date: Tue, 29 Sep 2026 14:45:41 +0000
To: Alessio Ferri <alessio.ferri@mythread.it>
From: "andreas.wendleder" <andreas.wendleder@proton.me>
Cc: "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>, "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: =?utf-8?Q?AW:_Re:_BCM4360_AC-PHY_support_for_b43_=E2=80=94_reverse-engineered,_seeking_guidance_on_a_clean_path_upstream?=
Message-ID: <OG0AU4A6pMu865qvxpXQjF7NvEP6p2bwR_IZRaLxONsn_3Gdxm00PiOOaGuWbYy-AmxhLGRyz29ZPtUKzDwsKJk_UjTLAU1bctgCzdWlNlE=@proton.me>
In-Reply-To: <20260929113109.2c561844@DELL-MOBILE03.ad.smart.it>
References: <rOzY3WnW4q5L1osv7iagU81dLGldzZEsu3EqHxmH4d7Z4vxubBYvRNT0vsrbr8n-CUSEYyXxGFE3h9PHLHgePjm3_rMK_B_0m5loTpyxX-M=@proton.me> <20260929081403.6076a6da@barney> <20260929093405.79d9f4ec@DELL-MOBILE03.ad.smart.it> <hCBGuqVmDlV3Y7f2t6L8DtnoyBNbC8KghHXm0fZCHLDLrtfaoYw9e0UcCCsQHHK1X4TBz0DuvSL4zmAx_dVS3q54BZ0JZXtjXXNnuSAFtyo=@proton.me> <20260929100544.343ce6d2@DELL-MOBILE03.ad.smart.it> <d6tVX7HBAW4Qnebx5Enj79edWG_LVmnRT0bjhcfv9bb1h0cewrTEDHK-VVoSy0NZcMzv3FB8OVEyTFNgA7rs_zaplEfiLXdwcCqhYDeonMo=@proton.me> <20260929105859.364ea71b@DELL-MOBILE03.ad.smart.it> <oYmDL00YinKfSdWHxkjmqPRGHWmeA_0SCR6tpafsgCvGyqYAEKuCt0kg7w_C47be5hm7IwFsxRnulMhvPFJEXQNDaDPgZNzMIQ0vfRKnOLw=@proton.me> <20260929113109.2c561844@DELL-MOBILE03.ad.smart.it>
Feedback-ID: 189422222:user:proton
X-Pm-Message-ID: 5e49b4a9dc59e1bcd3755f763168d34cb421ad69
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

> If you are using an older ucode, probably my driver don't work on your
> device because it interact with newer ucode, can you look for mac
> behaviour diff from yours? Maybe we can merge the handling with some
> ifs, repo here: https://github.com/aleferri/b43-ac-wip

 I'm on ucode42.fw (D11 core rev 42), firmware 832.127 (2014-09-19); my dri=
ver checks SHM UCODEREV against =E2=89=A40x128. I don't have a captured rev=
 number to compare against yours off-hand =E2=80=94 what ucode rev/date doe=
s your driver target? I've mapped a decent chunk of the real MAC event loop=
 (dispatcher + wait points) and the watchdog tick (SHM 0x158, ~1.024s) by d=
ecompiling wl, so a diff is doable if I know what to diff against. Game for=
 merging with #ifdefs if the divergence is small.
