Received: from mail-pj2-f41.google.com (mail-pj2-f41.google.com [74.125.227.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03CBC4D98E9
	for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 16:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790353660; cv=none; b=NNX8/XJFKFpesoqNRdLNexypkKBxvqvQI3VtMjfx82/1UouHEnG3dANwkH6+6zNm3fMkJ0ypHkOvdKruIjHp6ecu0uR8M1ZuR50ilAF+7AlnlrpgU2hA1+An2HvjCphKjKSBe4DgYXQphgDJz9zxa1xQOJ9EKo7DjZqYhmXvKkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790353660; c=relaxed/simple;
	bh=cnA9iJJr3Nxwpt98u6akJChlducQvNxcj42cj7VzM64=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qz/kG1c3TkpMJRgRcWg3auveUwDUCphuxRRxkOiAUDh5F6I3QVn1EPHaEmxGlslLM9N1ih91tDTKFoum0tr5oP4FugT4oJdKTi+JsB3Ew3JcxKnt7I7m+Z1HHW4velhq4EUgcI7dlUZcDeKgW8bcuRbvPe5iMCFEsVMfM+BF170=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=dut9aH4n; arc=none smtp.client-ip=74.125.227.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="dut9aH4n"
Received: by mail-pj2-f41.google.com with SMTP id 98e67ed59e1d1-3a0abca97c0so629582a91.1
        for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2026 09:27:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1790353658; x=1790958458; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NilrANqlAP1Fe7hZ7FMLKoK+ykSYxjyywmx2s4rB6mE=;
        b=dut9aH4nE3wgUoH9FQxn2q9sUcBnpzuqV8TUPAgJ7G5WOpw6kOe19cI5yjvGPCMJOi
         rO+uf7WY7Fij1YrZFuCEDOxQ6AWBx4HsqeVSx1kwWgHg7oEneG5qwzhee2Z6UNn3CYB9
         FE0BjSqBqQjmdhvJ+uZHlKrUey9DS33FjStAk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790353658; x=1790958458;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NilrANqlAP1Fe7hZ7FMLKoK+ykSYxjyywmx2s4rB6mE=;
        b=J2Kze6jhHcka4oi1XP6VIKM7RgQZXd3fmN38bNJ82Dp7nloF3ULezMzj7T5joTi2cR
         qH+S6RcBtuOFPZmV9gBiXuzGUNwHLfhypjmNczfkWTyn7XaLUK0Xv/TdzZcLUHljDd05
         wF80+HfPvSFMJlswc6UL4c9Q6AKClkxpNt7zmfUT19LEYkAMGHu1uuIbU7ODnYtW8QQ/
         WFVRQOcyQWHBL7zlxCK/T9xIUpgC24BEXKPCSGhGkCvqxgot2aE/PnJ0SgZHaOPIZZ0Q
         zO8RelHoAeq0cAkV+ZFTqxP6qw/03n3fPG4L5RUliz6nuQuyj7UYTFWlPtZCtGEwb2F1
         EqUA==
X-Forwarded-Encrypted: i=1; AKwUvBx/Mud4aXALcW6jnfbHiSc83K5yJQI75DOmQnsNgZPbEtHoz8NazBh3LvkMsscJYFScOhm0IxddeZ6Lter6oA==@vger.kernel.org
X-Gm-Message-State: AFuF++kViNsShkm4x5rLgwk6JAW3XAlktrCFcP5vYx52/GH9+nduos07
	27bP16d+HB958J47w7h3F537WAVmVbBCn+/UuE9E69gOBGcMelz5gA2rwyv0keXniByKDN9nbOs
	7AL0=
X-Gm-Gg: AYBFou2e+L8Up//VxfvKmZQsIZg8f9p2Zlo/qu6Doo68P9HAXZrKY+0qufC27p3Pi3q
	AG1m7T4vFzjdN8xrWBiS0zbu6yymJ63qUkghIIQeq+RIDTJ+OCjx3iNbfcbYK9RmALiSg73IQ5Z
	2jCQCeLL1ZMsMt+rXiN12lvlsYfsPVr/LLodOnM09mjsWqoH4rReQ/pKhYZz6+MIO20eQQhSXhe
	MJrtdxcxHUB9OOztToGRyyEqPWZrY95OcJBYmzPw6FzPGsVuiqJFG746Skq+dgMewUVCrMNv1Kr
	lIH397tMJUJiURfnXOP5Du9WzEKvNLd7GqH6SDXtwSflh7eYKioeEtXvVjNSXQUIlcajapGhQ1J
	hnX1P4/fyA3TRoDhD2DzxPkE1IdJxu+WT2qOjrbh2DjmpCss4nJcZ6jWsjWF3Bi0p1Lrx5/jP4F
	9/b744Ylbft8BVSIzQ/CEmCFvPZ4yU3p7k7lEEOkBL1P/9tOuelcUP3xhmHTKuTlKW86U3zlhnc
	KxxWsrKGMa3MsGvpGvSORjYoEtdjREkHj/iVQ==
X-Received: by 2002:a17:90b:1c03:b0:39d:e54c:8658 with SMTP id 98e67ed59e1d1-3a098537e9bmr5607586a91.5.1790353658186;
        Fri, 25 Sep 2026 09:27:38 -0700 (PDT)
Received: from localhost ([2a00:79e0:2e7c:8:41fb:1648:4395:5cc4])
        by smtp.gmail.com with UTF8SMTPSA id 98e67ed59e1d1-3a0b9355e49sm5409547a91.4.2026.09.25.09.27.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2026 09:27:37 -0700 (PDT)
Date: Fri, 25 Sep 2026 09:27:35 -0700
From: Brian Norris <briannorris@chromium.org>
To: Andreas Kemnade <andreas@kemnade.info>
Cc: David Lin <yu-hao.lin@nxp.com>,
	Francesco Dolcini <francesco@dolcini.it>,
	Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>,
	=?utf-8?B?VGFtw6FzIFN6xbFjcw==?= <tszucs@protonmail.ch>,
	"linux-firmware@kernel.org" <linux-firmware@kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"lukas@wunner.de" <lukas@wunner.de>
Subject: Re: [EXT] Re: mwifiex firmware mrvl/sd8987_uapsta.bin missing in the
 firmware git
Message-ID: <arag95IJHR5FiFo9@google.com>
References: <20240605160013.6bea8d4d@aktux>
 <_pNnwoI9WHlb2EY635KdIv6t_goU-ZYp9Vav31jkFOCf9fCE9EeKdyCea2m-L8pgfsKIQvODlnQLhQqmWSYip9e6FFZwaJHL5-u5rdOS_kY=@protonmail.ch>
 <20240605174709.5043af8f@akair>
 <20240606101839.GA76158@francesco-nb>
 <PA4PR04MB9638D1FD47BFBFDDB096C778D1C02@PA4PR04MB9638.eurprd04.prod.outlook.com>
 <ZmlEny2W0nArOf1T@gaggiata.pivistrello.it>
 <PA4PR04MB96381A69AD86ED9C9E4AD9CDD1CD2@PA4PR04MB9638.eurprd04.prod.outlook.com>
 <20260925165814.567c9ab7@kemnade.info>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925165814.567c9ab7@kemnade.info>

On Fri, Sep 25, 2026 at 04:58:14PM +0200, Andreas Kemnade wrote:
> The License terms have in 2.3(b):
> "(b)     to copy and distribute as needed, solely in connection with an
> Authorized System and for use in combination with a NXP Product,"
> 
> If I read it correctly, the firmware cannot life in such a repository, since
> the repository is used by different machines. Is my interpretation correct?

I'm no expert and am not providing legal advice.

I see there is some roughly similar (but a little weaker-sounding)
language in some existing linux-firmware licenses. e.g., "permitted
solely operating in conjunction with <company> authorized products".

I also see the linux-firmware README only says:

    Your commit **must** contain a `Signed-Off-By:` from someone authoritative on
    the licensing of the firmware in question (i.e. from within the company
    that owns the code).

I take that to mean that linux-firmware doesn't really try to own the
licensing rules. They defer to the company that owns the IP.

So if NXP wants to submit things to linux-firmware (or "sign off" and
hand it to someone else), they might be able to do so. YMMV if you're
not an NXP employee though.

Brian
