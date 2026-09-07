Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3BEF391513
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2026 07:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788766762; cv=none; b=LQ9E1sNzP1lfOmCIIMjxECRZlIOIdamu2nwCB9GnTIOju+gWqh0mhWhVlUcqRip4wiljaFsziG9c/WwPsQAfe0A+vZ2MQ7PdgvgN3hHXi3CErqU7DMe1FgOoIg07yGAxoneGeZzH8mUXguHmBaodkc4kKLQM6hnF/eU4U9uxpOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788766762; c=relaxed/simple;
	bh=YH7EN93SJyHGL4/HC0YOoTg8JcmyDYujtHLNSSKeWR8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=om9uXDiQsEdClGYdy7iRomXNjeeyhZg/p6vAcBULHgLfUZm5u4lGCE0fycyMxNwV1zm0XOnVMvVgjYXhrUtMuKCj31FFfz8luu5Qi+ySDvxG0818cQYmS2SQL9u0CrprmOgzw1Z9Jl5Trjc/07GJg52Quq1nPe5TuPgz/rV9dcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b=IbMyGv3U; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b="IbMyGv3U"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2d01663d816so21872715ad.1
        for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2026 00:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20251104.gappssmtp.com; s=20251104; t=1788766760; x=1789371560; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pG6ZzZyN7FqXoYi/vZrlLoduA/iEWVxvgelud7Zhj5g=;
        b=IbMyGv3UuaR8ZGs3T+Y5efYBfDoRzuih6ctdS1DCE5lUAaVs0USu75kPzpKRBiyzI+
         Lm92u88jrIE+vYohFbQs/7BE+ItRmtPh/FFOpZpHD4hNJ9V7VuROutYx7r3XD7d5CQc+
         V0Vm1eLiUrngEIh/kmnZDBp/siQH0JwMBm5iD4FNZYUvM1NxenUgp19btmELilzGZ415
         90wgJzBvyOq7PRR0Da7mcSQlXyDUO8UsJ63RTZ9lJOYvQTzsUtCHt7jfba7bxtEJnDF0
         dwtNDie1tWsHhSiY2JVauZmgsIftn4P6mPh4vzghTentL55CnrTkvfyynlRt1lG6EcQN
         2XrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788766760; x=1789371560;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pG6ZzZyN7FqXoYi/vZrlLoduA/iEWVxvgelud7Zhj5g=;
        b=rR9mXuJXRv/gwt3pXu6JQ2QCl+AmSP/L/U/I/ai4B0isWPlyDt7umNV+DYHviklixX
         x09L84OHNxtlBbAQpiO1zeM3tScNbCB1MIxer2dehuvihWTsKowX0hteemckXOM70qi/
         YMxm0q17ovXyIGNUitijZmynLf5auibFZ4lDLeqdTel3ILfshtKirwbBKKlyves5+L0W
         c2PNDrcTUDy8qgu34sg7GS9mYhBUxwePG5RknmnawNGwSm/V1qHiK/i1xsEYe9YWn/76
         uuvf9SM09QfZpecuuX+CJ4R/ZRQRj9NHH8GzxMACwQLbpYzEvvdaZr04MG6mj6jDodQM
         bPFw==
X-Forwarded-Encrypted: i=1; AKwUvBwKaMyzpQ9AzHd9WIj2l5cIKVm95kLKGhnXJmydS1tinwHiYDW7+j/zXOrpbBiX/8S2uMGC9NVDtqkifxmcyg==@vger.kernel.org
X-Gm-Message-State: AFuF++lczWMqMwQHB0+dZhkNgG5gImOG0fGvoGtgF6mVlIO/4fg6xG1n
	baEHh/SOhXqA7VL39YVlldoSouS34Cr01xL3e2T2mcWkpgK7rmQ5BHiRpxBstfUbJUeTvUBNaVA
	Wit4kEFo=
X-Gm-Gg: AYBFou1pCMXnmHZIEPkg3JZC3XjCJUYU9F9M1EsnkfMJkzmUitPYUSxFAMowAkvXV1H
	NrJWOTBe2j/t9hf9kLhfp0RoUmWIZ4lYSA2mJ/S2iRWivLwgG1hJPngt3TA5mzHQXMew2aVclOB
	08PReDN1Pk3LxA3aSVm7s1fgVZ4UHtroS1O/2fcSg0CA7zxRBRYT23ZEuEgqI7dWHH8shm+G/K0
	tjUUtWWTKL+gNuOOnBDuDCmFCFv99S0WXO340LdKkRQgAZijdJsbg+0nCgG9zDvtGadp8i9Up8L
	wwLNL/OWtEDFFegbzMz9xD80+si3wADkJlGswF7w8og7Al5eRD+XJ3/MY/bKumA/Jk6ruCUZasS
	3xPvLk79yPC16qHsJw1P6fy7MCAnmE8PGINOuD0S2LW6nFyR2m1MVfaKnZM+oFIqGR2ZbQDKmJ4
	Dc3evujBWtIzOO1arYfVBUS4hAztsenz76GxM9e3du0NzcZ8ilRrfKaG8+ti7HYpbpr+Kee3RuP
	08fv0Ogq3zY1gl9YCkt3FwLQVXuAr2xGxIv5sPjXmOWxIs4e/Ope03Ct8Il
X-Received: by 2002:a17:903:4685:b0:2ca:660:b1d with SMTP id d9443c01a7336-2db126d8c1bmr309737895ad.11.1788766759985;
        Mon, 07 Sep 2026 00:39:19 -0700 (PDT)
Received: from localhost (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2db1499d92dsm40451955ad.52.2026.09.07.00.39.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 00:39:19 -0700 (PDT)
Date: Mon, 7 Sep 2026 17:39:15 +1000
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: Aamir Ahmed <elb12345@hotmail.co.uk>
Cc: Dan Callaghan <dan.callaghan@morsemicro.com>, 
	Johannes Berg <johannes@sipsolutions.net>, Arien Judge <arien.judge@morsemicro.com>, 
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] wifi: mm81x: validate n_channels in disabled channels
 response
Message-ID: <c6bhyi4vhpwq4o7mltvpv3oh4tjhkucmrl5jr7ldjrkelxrwdo@m76aotjkpjqs>
References: <AS8P251MB0001BD39926B78E73D53A439C8B22@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
 <AS8P251MB00017F5BF791EA475A60A6CCC8B22@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
 <if3rynkyvmxep4jadpqvbxei2j4ta3tkm56yvpolwnxwv3bckc@mtax5yg5yugz>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <if3rynkyvmxep4jadpqvbxei2j4ta3tkm56yvpolwnxwv3bckc@mtax5yg5yugz>

> > -	if (le32_to_cpu(resp->n_channels) > ARRAY_SIZE(mors_s1ghz_channels)) {
> > -		ret = -EINVAL;
> > -		goto out;
> > -	}
> > -
> 
> Your v2 is based on v1 so it doesn't apply. Please respin v2 based on
> the wireless tree.

Sorry, the wireless-next tree.

lachlan 
