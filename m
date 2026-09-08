Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C2215111BB
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 10:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788862907; cv=none; b=FTBeDAm3cjs110+wNRG3/thGXLnw2jeHoQ1Y8rKzIsuXSPaF6QousYhG92xOMYwPJzV+mc628wGWpDdgQ4vu6ZqveAOtEQ9motAzTED33+mzSKS2e+9xrmEwts61SzCIVBGC04YoRBuHey34v5Gxzz5WaGo/BPCNzzQhqMM65iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788862907; c=relaxed/simple;
	bh=2g3OVqHY7LPB5Tu9aJ/as+ex+qcAnM31F0nhSqOscTA=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=njhzJ7PvPBPmnhlnEbxRL2eaZJjnOodf2E49KnwirLREfJVv+LSlWCHS6ay5fSEMoanERfH7UUlOgLgSkxP4CD4TwhtA8WxsimglrVsQaMCwYf3sWMkC9T53eNDS8Xzbw3BOFNebKe9MkPk1K1MyvtEee0+NrM8/WFRxrJ8cQ0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KA8DlYA4; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KA8DlYA4"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3856d6fbcb3so3590373a91.2
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2026 03:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788862906; x=1789467706; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=AhccQlmcLThBoQ55+SHM+25Vzt4uZpvbPRRHG0NdRkk=;
        b=KA8DlYA4/esNHDNGf1FiJy8RJGcRY4cog3Lk/+5S9vwm6D0R+xASbyNb8rvWVvF15w
         n4Bt7bCjrfSIGO+fNr7BqClfOlg6iWLUWppcsBTgZxO8UAcyQZpPEnORKoc0pb9dD7bm
         gYC3LDDG2Z0SzmkKtJfwH2Ri6QFPQoGAvGorJNzdS9132ry2uyB6QkruKHkmiysTK/dy
         i/AkgNqXfrOXoN1hwBTmsCYajRx4KrrbpuzzzO/GRt9r3HWviyJrmz2hjrXuUJTEQ9cT
         tQznO+pMc5GX84EvX60S0JTQhRfOqzNKZIccrTXH3Jy8ii4lR73HP+If884d7Bt/XAkD
         E7NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788862906; x=1789467706;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AhccQlmcLThBoQ55+SHM+25Vzt4uZpvbPRRHG0NdRkk=;
        b=kd1yrbPq/oWZUfBQ8+r8kszoD2SDRnNwThCkyz/RalWKsucvLjgMMKCWb3cw4xRmKG
         096bGvhRlgmOuO/Vu9eRU00aQw75uh5idwwVqEGmAIB2H15v4WoODei+kgfZhfk2s+B9
         wOojlVYlqaeH3c1+y/DSrQ2y6HdBF7pzScozKA4MCBijybfFtoN75E/gUAZpOFJUrghw
         Vj1bi5HmHIS6pwL2czwfq3Zweb2t61RnjJEbprZvrllTotGQHpaPHkOcDiikbw8EjJXy
         2TCv+RY1heWVW6yzws2Ma736tJHB6+trye1nE6Z5HiYFxarn17xHwZNLie6QDcihCCIb
         k+gw==
X-Forwarded-Encrypted: i=1; AKwUvBzMgkOZ/VY7DFAy0Emnezzh3fB5x+lJXHm3xg3MRaSBXjwhGB2wsEYDJ3G/wjv+6b0C91M7iinjRM5OQqY80Q==@vger.kernel.org
X-Gm-Message-State: AFuF++nGSqldB3yCXV7MBvNz46VtaQSSE6ykQZ5bmuxsZ7GCbdQNECgo
	EgV3lvgIxnEaYa65wBJdONUF/++WviYgVSEWoNAQfddIGcKoWbStnOiy9GLpWnVwTco=
X-Gm-Gg: AYBFou1v/NNmlitQFwGkV6j4qerLWQLVRBBMyeeYUUfozTM9+mJy9nMdhTl/XpQR9BD
	9NCo+9PTJ7Xl/GaQTNzaWa0FL7JQ6s2y8ybZg2vPF15tkHtb083DCPU+BWUTdOgzn8B+WjsyjKo
	SRkDlSNctcfJzcsOt9aTlUOdO8/fI18nEJPSovuSQ6uTb65FU2yH0AS6azrZ52vnZAhfZAPckmj
	vOb/7eaz8BMPPRurYoKDPHg6AYbULEhIV7d1R1s7mwSnWGRU75hx4FhBZuIEJlx0nHqdpSQMSl7
	BxuQoBWwzOQlwlx+7KlVADOU2wHIaELrv2eRQU/AD6YbYqaVM0X2S5qOPQl7uKNpUpPrMEee3xy
	vRMIKG7wqVqSk/BGDaAHQo2ZIF5utALKs4Ghrk5NBshhvGDVntHjGvOkV6XXlbi3bFCfdq0H51a
	sudlGyHF2skkZGEhpgGla+E4pYZM2oJav50crCgMtDEJ3qDID7537WsQJOlhm6j/CDGk839N44k
	hHRa9vMkmU9ENdc7NseFakjQafQZXNPLeafx9TJTsmBrNS/RNs=
X-Received: by 2002:a17:90b:3852:b0:38e:9ef9:eb97 with SMTP id 98e67ed59e1d1-39b26272d69mr42956469a91.16.1788862905641;
        Tue, 08 Sep 2026 03:21:45 -0700 (PDT)
Received: from nxpwireless-Inspiron-14-Plus-7440 (114-25-99-144.dynamic-ip.hinet.net. [114.25.99.144])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b260fe843sm25594085a91.10.2026.09.08.03.21.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 03:21:45 -0700 (PDT)
From: Jeff Chen <chunfan.chen@gmail.com>
X-Google-Original-From: Jeff Chen <jeff.chen_1@nxp.com>
Date: Tue, 8 Sep 2026 18:21:39 +0800
To: Linmao Li <lilinmao@kylinos.cn>
Cc: Francesco Dolcini <francesco@dolcini.it>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH wireless-next 2/3] wifi: nxpwifi: free the aggregation
 buffer when the RA list disappears
Message-ID: <ap/hsyBMiYeZqk/C@nxpwireless-Inspiron-14-Plus-7440>
References: <20260813082315.1390321-1-lilinmao@kylinos.cn>
 <20260813082315.1390321-3-lilinmao@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260813082315.1390321-3-lilinmao@kylinos.cn>

On Thu, Aug 13, 2026 at 04:23:14 PM +0800, Linmao Li wrote:
> nxpwifi_11n_aggregate_pkt() drops ra_list_spinlock while it copies each
> subframe, so it rechecks the RA list after taking the lock again.  The
> check inside the aggregation loop returns without releasing the
> skb_aggr it has been filling, leaking one tx_buf_size buffer along with
> the subframes already aggregated into it.
> 

Reviewed-by: Jeff Chen <jeff.chen_1@nxp.com>
