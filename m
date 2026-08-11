Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285533B14BE
	for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 15:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786462995; cv=none; b=cVvcQtwVxDHO0O8JPMJUhEvXXEqNWaw8DA3+aH4+rJWEc7C17yBrBCDrO3JfXhTjrrRY0Cq0In3vuRmeWWiomyjbYj267MBfSwKTrHHBL+j4PUGZf5omLvP8lsBc8WYRJaXGQC1zrIDmzNZKgR6gnz9oOju+7PlwOK0JTHFCOmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786462995; c=relaxed/simple;
	bh=eSAq20z8805Yh76JJlZ6DkEBY+vki1uUpquKwflHv8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dHhJhr2APFZ5BfiWlGXU9TiAimcG/V8whjYRiqmz6XLmOp2qmPXDUu9t+HD1koV40/b6hCW7ofSKv1ARqAy7wFxTRyw+yUl4YXqRZWYnz44H+QWULnFNX7wZfCmIZrsfH3UyV0nlB2eX/HDCobvDTGmIx1fhn7XHwe3cCQujCFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DuzvlNXy; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DuzvlNXy"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-49552f516beso801425e9.1
        for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 08:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786462992; x=1787067792; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eSAq20z8805Yh76JJlZ6DkEBY+vki1uUpquKwflHv8E=;
        b=DuzvlNXy7PqyVIwsSInUdlTu2P0B6Bp1c1bACuS7Okv2Hr+sBD5Yfzp7AR3IJA3DyA
         3PnIUMwJqmYkhej/WKa9/+F/h9TTL+F0lZwiduH0Z0dBZZX+TyMffr29LpQHTNCqyosz
         crdIzQzwxJMmFUdsQW0OVwWYuiCF2+ZKO0nP3l7DPOTiZW9wuKLX6RopCa0MjRYp7DXG
         zG/oPdfmYgEnOT55MO8o1X2/X8JbTo/yrG+hmvS/+ZaPtqtBpOC6hdwQBw8ZPWzRinHd
         //S5WbQRI52IhxSb48cticSX0T+MTyMC2kcFTu+9qi4Zx68CY8zyqvHUpYl0TNaxJ0Ig
         yElg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786462992; x=1787067792;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=eSAq20z8805Yh76JJlZ6DkEBY+vki1uUpquKwflHv8E=;
        b=lXXwF+ci9klfpLGl3f+oOmARCmsg1+9VNFQFIkgZ0/sB3sslV2OT0S7kB0VzBATv8v
         wmM0f0ws8ZtB8fJP7Nw8T9O8nvG+O2jk5tUvuz6vzmYt8McmxgutsXqiDvKZEjdOkTFZ
         7HcDYiSnEn4CxyF08fuFOXlj/IilSY6+Br7nKNmBMzeAno0X1/+sY+wf+08DIpW3LJqf
         0o7yYMkJvqPuWMTqwRZZ2VwZKBqOBZvLk6DJ9lfz9hhAjDT0vZIbTkty5dexJ/6mugKB
         RjNJ7uugPB8zVcBewGA8tMo7HSJYJ6luKmT32Fh1LyZEY3qvEhz5euFpq/rtDK8rKenH
         wzyQ==
X-Forwarded-Encrypted: i=1; AHgh+RqrK8psIdBYqMEfzhiW/NOfWwyEDx1QuTv0ZHVgtyUC3ZBs5fMrxb9u28YGfecIQQlKYayypx25GkQsQIoBwQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwrPCUMbrVk4ADlaCdQDMoq1wS1gd/VifkGOCljEUbBBvdoM0PK
	OqSXXbEaxhdCAtlgv2SdpMY2zkoUSGT8vPFxt3bYH8Xrch//1Zk5oPUl
X-Gm-Gg: AR+sD10/a6x07XPYmY/7OZQLTyzHSC8m/IDRgu1CHeK/JDOZBc3uy7zW9yFFflZobhe
	R3lnwuTYD/lwxEDJHzeRY4u5tQGRgnYlLSTwy5wj42mQNSFRVcLQehCyjjXbT5rgfXQbMO1gdpc
	mSdG2DUcRfcs/9Cw4f2E2Y0NJ5JmFtkxtVYJgGA5yUWM1pad4fbCt3lkOatQTxetYPuKDPOGBwK
	viPjjVYh7tT8z6FPA4Uwp5S8JWKzQ0jPt6m4HYm90+cgKuq3cF+eBUN2ghyf5r0z8ttFY3BwnRk
	cLVdBYbVG7a3Licujs83aiuKCPw0YJJGfECNE/AExGmu37StsDGmxuAqynj8Dk0F6XQmD0vuf6I
	5FJsM9wXGL9HXoG/ww8DpQPEINMsEqmqA8kls2/zm95ayMRA8pKESF75YrAp5s+qF9hmvGj+adz
	RysYen4DPusncXF+39oQY34jWHZV12jFVl6goflukaHdHngiLwLKH0iVcFo9I0pqfYwsZfkq4g2
	gJP2Hf/f3rF4ivM3SdHv8yGld3xViVGR4lsEU7QhQ5WU1DJc1kE3/g=
X-Received: by 2002:a05:600c:4fc5:b0:498:8e6:d463 with SMTP id 5b1f17b1804b1-4997840a0acmr34015455e9.1.1786462992105;
        Tue, 11 Aug 2026 08:43:12 -0700 (PDT)
Received: from m715q (host-79-35-51-177.retail.telecomitalia.it. [79.35.51.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4997aa3ebe0sm2546385e9.0.2026.08.11.08.43.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 08:43:11 -0700 (PDT)
From: Andrea Covelli <andcov23@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Andrea Covelli <andcov23@gmail.com>,
	linux-wireless@vger.kernel.org,
	Kavita Kavita <kavita.kavita@oss.qualcomm.com>,
	Sai Pratyusha Magam <sai.magam@oss.qualcomm.com>
Subject: Re: [PATCH] wifi: mac80211: defer AP-side FT key upload until association
Date: Tue, 11 Aug 2026 17:42:49 +0200
Message-ID: <20260811154254.1968104-1-andcov23@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260803223020.1370646-1-andcov23@gmail.com>
References: <20260730161531.3535100-1-andcov23@gmail.com> <1dceded216618b1d7bb7b79846f15712161f2cc8.camel@sipsolutions.net> <CAOEJtZHV8HLxe70B7Rugkh2o34Sy9cr26BXji5LWB7b74JTL1A@mail.gmail.com> <cfcb2f3748aa51b7001ee41c6dd4d578b0cdca28.camel@sipsolutions.net> <20260803223020.1370646-1-andcov23@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Johannes,

Just a gentle ping on my August 4 reply when you have a chance. Is
driver-side handling of the early key the direction you would prefer me to
investigate first?

Thanks,
Andrea
