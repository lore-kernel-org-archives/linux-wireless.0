Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63EF43FFF8E
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 10:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791886912; cv=pass; b=SLZ8W5dKTrQ3JenuluRtW7N7g9CzcTgpuAxaFOxMN+NZUcyRW+fWGSh0Gu7tjMTnMz/LVBN276XH3mRwOLe9/zfpSH+6Z0YEAVUymQsbgr0PlgLCLdvhw30CQvGe2A8P/KLK6Po2e+go1uFrjRyefirEEzMdE778pKshujKQQ3E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791886912; c=relaxed/simple;
	bh=kw30L9v26HRhBA7ngRHFl25NBDemgZ3UJ42WGs6r17k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PjPSjCqXug2JdXpD460cBoz28xXS6kqtyh71ge4JdAnyYo3+NlQwYNvc2l95kXVPPSAXChuBxkYHapkCCc8a8UOQHvK9NbdAUQPCJOKl3BLVl65Akl2owTmbVKcte8qopMfjE7qUpkH3s4rCNGgIFh5kmmAQzIDotWZy+H6m0d8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GMb/PDFr; arc=pass smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GMb/PDFr"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5bcb1f1358aso1851231e87.1
        for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 03:21:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791886909; cv=none;
        d=google.com; s=arc-20260327;
        b=Tzo3xfQDKM4j4EgX/nk2lPYxTryCaKEy4Ym/SOHHoJtZz8wYmmJyfy0wEshwdI6TFj
         YWCXQB97ixcUU8iB2aeSmkLCVjqCSC9K+7oifrcmqo36QnXa6ncvIpsXoYiWZujGwYwe
         GNnIeGoOH2M90TLmqMnKtst/COaSBIcivzq5xWfmIjAjrKEemPXX92pnHNn5bHIl8Qxk
         axaEet3yJLPL5jgzSu12aQ74cQ6BM3o0Jg1S0W04W3YxFDFwFDE1Y/BTeSnbaW83v/V3
         qwthh4BlzcXgFb8JsrzCvlyXISUNu42sAT1HoabKHCX5lUpksOmgau+5j2MJjtklAED1
         0U5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=kw30L9v26HRhBA7ngRHFl25NBDemgZ3UJ42WGs6r17k=;
        fh=Xk8xQOMHVC3QXyFHXyYchA3nGRdn9keX3GyGnpXUkRo=;
        b=nEmexpuWk8gt3WYqJ+e66TR5UxoOS4OWcycvLC5sspnbKNMdKLMeJXwgZS0WJqjMz9
         NNwt4KXqK7yh9v39ZBV1NmGNPZnyvelJh7BTwIjZhqXdBnkf53qCrXEf3cbznH0zvYgc
         AUNjwoj7SFrTCCx0e8/BgMD9pFS4h8Hkod13jVN+d09ZHlOqw4sQdvsfMJXfvs+xlhcR
         /owSWZcT02PsN4to2vuEFcVZrvtr2UxM0a2DLrR1Y0rivMAI6h9Gfawcm79XhVWEIOxx
         sphvWHMOeCr2PswMvvTl1JeofoJCyAZWEKQ17DvnwsErc2sD042Qxeg7P/4Br90DBJDg
         th+Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791886909; x=1792491709; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kw30L9v26HRhBA7ngRHFl25NBDemgZ3UJ42WGs6r17k=;
        b=GMb/PDFrWoHJRy9pBHdTZo0/lj8Cg472bjve20axVR+DmIqGmLXL/J5FQr2lH0o+sk
         5nydQS0hHGSFh2Fixw7CV3fCrG9ZVkJGzEqLYfvS/LIdZ8DGZrSMGnRB3V0e5dQrb0tj
         GnKR8QJs/8IJhdGLSXgNcOPq/1dAUtyr/t//GhSGYxA62aGyTxtptqRuQaQizH6AhrAr
         kjX3vMYK3hx2QiF0x8qlGFTRSmXLHANPyVFQfkxR1QLP1iU/z1cZMX6f53hd6grXJFm4
         q7Pm2e2riBVfBSIWE8dgwbwNViO+K3MY2IsiG7XqfI2KUVZgdArq5OMNNUp5FmvsI6ky
         nUrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791886909; x=1792491709;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=kw30L9v26HRhBA7ngRHFl25NBDemgZ3UJ42WGs6r17k=;
        b=Ynt4RWhYqC3RWbcfQfUv2gBKiKwh+rW065bo/3DtTK20qCzSXUqgdkidPrnTW4Bw5F
         nrcwwvKx+f4oT5qxmZauGkw4bXYKbYcR/rbH0U9HEpO0lJUy19X90qd9h6GGHznKC4XO
         7LkMCXwq6Uudf2NSIV8mU0QPeCqwIvIhX0HkFpp9MDGaRL8zyKlKShWm4AYZTjypZlch
         qXlFjJ1zVgAyPLiKN8S1epSnd27vlEoDGgbcqR4c6lGuvupVhboNQZliYok4Pbh63Bpk
         yGjEeBdxNwOccMBR2ZQXrIVnainj1wXklxRga50Ga1+OG+serpFIbLPwUiPO4GXi66KK
         aSQA==
X-Forwarded-Encrypted: i=1; AKwUvByvutart+on1muUTAOb0aD/KnU6iWkQ9I9IchVDteFyhz64JXE7Mp7vMPnV0jOQ5O6O6QvV+7rnU8NZ0MWlew==@vger.kernel.org
X-Gm-Message-State: AFq9FYIl243TqbK+sa+mvViq7X1yqr9lpYagGRk6kYFJI3S7cC5d00E4
	WwdaOvJFTK9ap7PyKmqMiNpLA7eISwYeB8yKpobWAc7cYiZ07FULCVdAIQX6inqixmRXuuSW7hK
	wHA/A5gC6QX4sgQ+LTyOoMBv1ete+B80=
X-Gm-Gg: AYBFou36M9jgq8cLT7cLYc2WO17qCjrvKWZyxeGjkTpio1Zx2jg6Aw8uB7FcHKgVL73
	N24MiWCc9K6dyyifxP8Y0QLaA41PhjwOevWajAq3HcYg9DhI4IZx4A3Ti8ggldCEatU1owcs2Bm
	myMm/hh4AhFqfeDHryci9Z673rX81mOjrgva/ZM0XlfKpCRzO/sGmDI4piOnmZxWO+Im31GF3KC
	0RZlGZckH7FLK8E6BbF7ld7ivQ15qx53aplMOK/86Ea5CnEdblOPhriwmgJfOlOeKDmQsZX15w1
	MpihIwTLokWg1j0RXpyugsBbSBvcbennqWJhq5lVCABkCYrU1xY5o9TwY6EtDbRtdzcF22aUCE5
	Q71n6KEhtFzE=
X-Received: by 2002:a05:6512:1302:b0:5b7:593c:244a with SMTP id
 2adb3069b0e04-5bcde6cb1b4mr4214429e87.44.1791886909214; Tue, 13 Oct 2026
 03:21:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261012011707.3378-2-sigefriedhyy@gmail.com> <179185709784.434549.17899680533305071231@kernel.org>
In-Reply-To: <179185709784.434549.17899680533305071231@kernel.org>
From: Yuyang Huang <sigefriedhyy@gmail.com>
Date: Tue, 13 Oct 2026 19:21:38 +0900
X-Gm-Features: AclHuK9g3jw3wKxZcfUo-DjkbmbxBzgQ-U86o5Pm5ByOHON1wyGjQ9qc2fnRD5A
Message-ID: <CA+7S2v+LjXscrjWYE6kTu0uBR8co7G4xqXaHq30Za32rbg5FDg@mail.gmail.com>
Subject: Re: [PATCH net-next v11 1/6] netlink: specs: rt-addr: fix the type of target-netnsid
To: netdev-bot+sashiko@kernel.org
Cc: ajay.kathat@microchip.com, aleksandr.loktionov@intel.com, 
	andrew+netdev@lunn.ch, claudiu.beznea@tuxon.dev, davem@davemloft.net, 
	dsahern@kernel.org, donald.hunter@gmail.com, edumazet@google.com, 
	idosch@nvidia.com, jacob.e.keller@intel.com, kuba@kernel.org, 
	johannes@sipsolutions.net, kees@kernel.org, kory.maincent@bootlin.com, 
	kuniyu@google.com, nicolas.dichtel@6wind.com, nickgarlis@gmail.com, 
	pabeni@redhat.com, sd@queasysnail.net, shuah@kernel.org, horms@kernel.org, 
	sdf.kernel@gmail.com, vadim.fedorenko@linux.dev, willemb@google.com, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> Should this have a Fixes: tag?

Already discussed in previous thread.
