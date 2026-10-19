Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6523FE64A
	for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2026 07:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792395750; cv=pass; b=ts99++Dpj910Vw/q4DE0IDQbjUudAlT66PvKNphp2WmfX/ubUiEW0sVtCQGQqw/zHOwLKiLPn7t7L/EE0X8zz6F9MM6cLb98u4u+czwRKvvkEdIS+GFTBXnhEs1PYEm6CY+XQf+uA8rEB0I5dC7KV3Sd4CNPQVJp4rKC4AZ5iHo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792395750; c=relaxed/simple;
	bh=UgudJ0WI4oNl1UfszSq5K5yCfvW/TgnZ/aoECPr1no0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hAGaHmyAdk2RCp8QwM+5P5zaa52SDaAuOykJnPl+E6VKDyJDKfb3R/qpkyjCRGuOYhjxauWspXO4RJikjBzavOBKL9Mna+aEf3vHu60eMHhME1DEqfJglwvHwGVz4FTksCoaYKi35pzrupCDZNmFGDJR6aLaSBiDjP7GrgUzGzo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=lAvmLtLn; arc=pass smtp.client-ip=74.125.224.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="lAvmLtLn"
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-677d35fd1d2so1745208d50.1
        for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2026 00:42:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792395748; cv=none;
        d=google.com; s=arc-20260327;
        b=Pj3wYz7VXhnlpW6z3K8b8VLC3bo6e7AExsYscr/G9DELqutu6qYh4SAZaefs74zn0G
         oiISzOg44zdiaQfJIBXo08VjM6e/V/TdysUXPc4wutxdSiCCEAlPH+JW+BCDxy7Q4qyk
         0ulUcA2h4U0eS9N+9LXc6zhPvcmIZB/GaWdnC0/vxBciEfkS1fFBG9Rj9PidqqejB6Dv
         P/x8D0yexGv3yQbjvgALxzcCs0m3qg3RwLrZfx7xDwdtMBQki++9zkA3RUCVQ8iEbOX5
         DTwhkd9MnYxU+6bpN97kxU4yu9yeBcO5VoTPxOJCINwD/DmYPKBNGpXqwu0h84AlzXRq
         2Cnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=UgudJ0WI4oNl1UfszSq5K5yCfvW/TgnZ/aoECPr1no0=;
        fh=vFznFVsSibX5BQDS9OUILPZ4ZARltuV29xhf4xMQyfM=;
        b=cCeMVmEZhtQ+/vR2LQszZgRCwDX+275vHhbef1+2bevgw/lbOhy9GhvVUSuDvu7CIz
         2wqB7gvHG4F9x8vCPR3M5jeNQA1Cd8FdKmqxjuxloVFM+MyGh3r4MKs+xVtv0N9yW8LU
         GFLczZjSRIUXEfA+MYFHaJc+ZwDn5J4HyWds/5XkmQMNypkiRK87Lby/FlY2UJxu/4B6
         N0RHv+TIvo+rTd2IzqXwiCKKPDTMYU4PtCUOtbDIxlrQp6xrt+6zAQwHcn1+7VfIIpCM
         PimX/3oj60hRUiHuGLBzwBlT15+UjElMktV1XESyovnZRDBjvHk+2jPfhYdA39cqk9ei
         Unxw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1792395748; x=1793000548; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UgudJ0WI4oNl1UfszSq5K5yCfvW/TgnZ/aoECPr1no0=;
        b=lAvmLtLnV5y8ME+8n84oS9JKjOot7NOf5qx7M5W3DqrQGswCIVme1qGIpgtKLmbUQ9
         BkQBTuuasSRUFbvqfFkwPaQvZBRymuZCeZVWvs9RLSoPLUpr2hzbTvnWirgIMJ0WI8Uq
         jo7Ww1rwcMVLCxE+oNiuEKrhF34nPq3tpw+vHxh74Q4700HKiLOeCKBGPRdV0Oq51D2t
         NIdYCuq5Bsf2zXRjlqccrcgxUEu9nIQChmaLrT3dOysAPtK/eeMBQW6vO9JexHMfjIzz
         64RguSc1NaFVEoPvabgV2T5ZG7+9WDovDTnCrzheJJOnFO8Xc3g7OnrAc4wVhZxxCvXR
         a5Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792395748; x=1793000548;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=UgudJ0WI4oNl1UfszSq5K5yCfvW/TgnZ/aoECPr1no0=;
        b=PTsLh7/d2az26U3MMmykGK8FD5yN6jqPuZBWgt8hhPw14QAjIojjZEZCcxNL82M0To
         efxy5pN5VwbzI/DNRBJFmJYUcAeeIRfH0j7xPBPlVDVXI8S/1L8isRoIAfoQwUZXp3Vj
         r28lmmzKOhEoS4+9otIJhAJCuYGoKYw4JHiGf/eXDtsnZwsgu12o7Xs4GFFQVnOXgDTb
         Hv2BhEIx2dUBpFucMF+KuZySgc7+DzMOdStjdpIAjMHq4v2nsSK+WBPAuTbWvnPSfBaD
         WSOaKy8JsPvgVkHbi9VrJtWc/66bakS2Ypvn1okhG7K483WDUWNFQdVqTrPL8rFAYM+p
         8L7w==
X-Forwarded-Encrypted: i=1; AKwUvBxZ4scjp/PKInAnh5p4XfUkSLJA07PkHuUCTJbgCf9vVmcODsHob3pkEl/Oi9pidYtnK4GxX/c/N7c8BhvZ3Q==@vger.kernel.org
X-Gm-Message-State: AFq9FYJX8HIPV/EzZVFbgJmkwBZSvqQBAN6BbheJELKSUzHJW1F0l0E7
	+J0D9mlD/Uu7JXJEtlObvqsZn8W7gnl1RLCSVBkKNP+/x4YP+5XBKlKTDjYS+EF6C22npnGFZZP
	OmhP4nzk3zyTNVr/OC/8VndOqHfKPdZKc4SC4lg6TSOA3yZpo1uFnDLtqHYg=
X-Gm-Gg: AYBFou2m537DzgL1UKql3VGL0l7AJhmTsJjczjJ2pvmuB0b7tk0mbw2zlLTIwZHtns7
	AM7+fYiLHZhcmqeviLh+sO8P3Ew3kZE6D5DdgfU0Cwu16l452keK9CmUgmwSaa/mH7zXwSsT2j4
	9tHxAidLGMQxlEcZSbpZyA8gmUIO8/lQVhiJlQpatnk2JJoGWzatTBzBQLc6utASYNvxbOkCme/
	BjLw+hfmKKYwx9oyYl0kz1oxHAAp2HVuwhXFSBNaigBKR+XjA/tmux8FRUgDY7XEFNEzgXPY5U/
	ohf/XvA35EXiJjvab/CaKUc78+BUwjYn7CZ5/8HW6ZDszJodgnf/LKJLTLpgb6GWHd0x6RvAbzK
	fb4vkAjtrinQdoBxTXWjBefhn1QEHnLchLOHBUXdm+ntekMMeGqj1hEFlOUmAZGm0kDHS519RKU
	aHMdDjaQ+eNX3Rs0Zmi2VIJ58p0SY3ETgK03s7k7xJsvBHEnWHPwLGVNN+ZP6X3YmSRLvjxbfpY
	86sE51RZtXVuhyjQvgaiEq8hBvEGiLrkujCa+9nAmFMhnLmGCfpPmUSLofyQ1DHMT9I63S0++EK
	ksm/aa3Gu0qf4Rs=
X-Received: by 2002:a05:690e:e84:b0:679:8bba:3200 with SMTP id
 956f58d0204a3-679ca7aa86bmr1822026d50.38.1792395748396; Mon, 19 Oct 2026
 00:42:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261018171803.1545946-1-julius@bairaktaris.de> <DM8MPWZ7TFEE.11W2Q780HK4FT@gmail.com>
In-Reply-To: <DM8MPWZ7TFEE.11W2Q780HK4FT@gmail.com>
From: Julius Bairaktaris <julius@bairaktaris.de>
Date: Mon, 19 Oct 2026 07:41:52 +0000
X-Gm-Features: AclHuK8hH8s9UhWNUS2-04GWjMo-KQMgMTX8POhMSkdKvor1YvD5d8cNyp89uvs
Message-ID: <CAC1t37Kw86_eb6nYxG-hHwuL7ynKYFzauy1j5Q5n8FU7Bk883Q@mail.gmail.com>
Subject: Re: [PATCH ath-next] wifi: ath11k: report TX retries in station statistics
To: Nicolas Escande <nico.escande@gmail.com>
Cc: jjohnson@kernel.org, linux-wireless@vger.kernel.org, 
	ath11k@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

Hi Nicolas,

> There seems to be a way to retrieve this info directly per tx completion:

I checked the links and the way I see it the WBM transmit count is per
MSDU, so A-MSDUs inflate it.
The PPDU stats count MPDUs, as nl80211 expects so i will not switch.

Thanks for looking into this!

Julius
