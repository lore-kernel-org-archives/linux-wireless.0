Received: from mail-lf2-f13.google.com (mail-lf2-f13.google.com [74.125.229.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B6D4476CE8
	for <linux-wireless@vger.kernel.org>; Fri,  2 Oct 2026 10:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.229.205
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790935534; cv=pass; b=YVcMJWP0kMMe6iMC9xZzZ/BtjYY5Cg153Zh+PATIsRFRmx5d5V0XmXOglHi+7vEtxIT85dFGdjw+e8nE/1HD83n0p0rRkGgX2tLY2al+UpoffIB/4CF1CXqY8zsk9OgbeAVZnX3yFenX16lUxNtyZfDYbukzlfC9yDJ2RHwQUcA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790935534; c=relaxed/simple;
	bh=KpRkC7nlG1sV7SwjB4i6DmP6K82SrvV9/kz1iBtQzrM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LLs4LZS9DAwDHOmoBBFjK6NvU1Ey07Qu9Bl26TVAAeBOC1IebVOAw/eU72LroND5LVjbgx0qnomXxnXmMir1fPOlChpP+ZTi0TNZMmwqTwHmJsTSgNElt2212N5XN3j3swBBSTrWXKKkiQy4QVSQjqgNubPSa+EzJQB5c3jqLA4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NwW9ak6U; arc=pass smtp.client-ip=74.125.229.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NwW9ak6U"
Received: by mail-lf2-f13.google.com with SMTP id 2adb3069b0e04-5ba43103cccso1899671e87.1
        for <linux-wireless@vger.kernel.org>; Fri, 02 Oct 2026 03:05:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790935530; cv=none;
        d=google.com; s=arc-20260327;
        b=dtaMrC+6OqVMDvEk/T7U2JLqZqPF1O1PMHw4MxnlqAdhnkc1VBgkJrW/3k7mQjDNGn
         yymlXGnskohEUiHe0tq3agmAVuNmPe251ELrYYxdFv5KArY8BlIxFRS22kQhA+LxS6Ge
         8MK/Yl++tBROJi5K6Frxksh9mjA6DP9H+rPUKfwdlAJCOz4SNLmVOZowvSoiyjNujOUn
         8kXIfguqxH2JBW5P6lc1N87O5H8lCeZrpWIprnCakTju56jc0/4co/FtKoGqb/6MOli8
         jggiiGkI0X1baL21qxntMaFWXlyemUKa5lMzy6FhMNPLJV+WdvpI9996VdAEtjo8Clmj
         cXoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hrEmBqIQ5U75wKjWXMmdbPNpi9eyodu4H+Zn5/tv004=;
        fh=HCKhKCQzXQB/hvtdzHLpXPYiZX4molOXxNCZ+Inxb78=;
        b=dCqwKrUokOeSiaIAJFO+vTDfolZoQWwf7l+7j/3KEEJzKJMlGXpl8i2R8w2rV+CVsD
         8YketV+NunE0sYUBlR294n8tNV3t9POj/1Dw38xGa6UWwPkb4aSQdjDb7wm8mmIJGEO2
         LI9m/Rxqutm88v4Q0jIIhYM2knsoZxMeCcPjzk439H5AuqwEvpEQ/inWxUO1Z5JTMwE3
         bWOWqvYk3O+yTD1Ae45o8RgRhHrD+j3O3Q5Eq51fSe1PM6c+SHJTG/AzNthtDfMytEqd
         M9QGJQaMVpV4GBF7pKnzLHr+vywM778Qsys3VJZkb87xYiOW2x5x2eWJQnr5k3uEGDPK
         m12g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790935530; x=1791540330; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hrEmBqIQ5U75wKjWXMmdbPNpi9eyodu4H+Zn5/tv004=;
        b=NwW9ak6UOQPxpFv/FmQerM5MLjLv+Ncp8wyBfFhNHr7Frmo3D5usdQAcvL/0rroVNY
         k8YRj8mu96jsANBiMFziP+PGFl3rkflsa2oymXeweFfVPAqQRx5ZOzgRo4FOeP433MZb
         2u8noZ13OVp2e1qYqAHlH3EOsvLAw0vGyINgYv9XzZp6b6p8cnAFA5Uqirb4MXUhrGhr
         GaZWoE0JwWsLRbsNKwi9pPN9b47YBDzXIxAhKCOeixsdJ+MgXTFgzAobrZ4MZlnbYlO/
         VsDZg5awe7FQliyPFAyZnpXLZEnmJvKNubOSTzu1ulwni3p9z9gq8GUgBqYXfu1pbv7/
         1XoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790935530; x=1791540330;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hrEmBqIQ5U75wKjWXMmdbPNpi9eyodu4H+Zn5/tv004=;
        b=TUoJZHPSVCobhqRDCvxvljZ6Pw8HF6m8pTfKtBe03pN662dXOw+8QNjQtm4HK4fWI+
         6S6OvEY2ubyccc5vIl3hY6dqnW4uM5ahuOmQ44SmKSGfBPfZ0lPofEckRDfiOQNeNVOh
         hG0e3iNQf/PZlnpwWOm7mj9bV+sDo48zNkvHbQZZG6gC6Ysr0J2++8sBy7I/Sa0l+b9v
         +8Ry0IaHwKaGG9cUsrfSWZlq3ax0hGFJyeYRIAb39V8l5IhUZPWZgxF9MFRzlpdLH02Y
         9JLmQ85C2KAcM3mWSyvukjBajSyvO/f0xEfBIximBi1o4a6Ga5sdUGYEiUp8Ydx+e8qH
         esRg==
X-Forwarded-Encrypted: i=1; AKwUvBxdt6Hvc9Jsoi3SrGi0m+ocwWiFFLZTwFBcPXkZkCJtWwpG7dy5ypWtbDpXhWcQWy4DvsLSGYjsuhyr5TrjoQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYIgdGAQluawLPHdFtx3TKcc292nD5KGkQrmttvGvYLXVAYMRTEo
	QzftoBhRQ/d65UusVsg47FuRRysZ75YhbDJFz4TsVOUo1KmFRJO5zNtH5qmlmWokcZpFK3aHvOQ
	fx8xsHsou4mIFn7k0bemOb8R11pxBk9g=
X-Gm-Gg: AYBFou2MGzlTyxvmEWHBRUoenipnT69Y9i5MjdW93h4x/xnzX7c2VCeM2hO1ytDssKM
	OtAPmooXsIHe06D5YwoOl9zuG+cfi7oQQKtXBJdpwHrWWy0OgF57isFP+Jqc28TBwIxhsnNEe83
	uNvJLC4oW475snWvCzOAcLwDaOCDmxSrPMDqp1TQCyylWHWzPLYeTOqxEL3skVgi586UUNJKGDK
	Mq3fczGUb8gpHipQS22FJEPdXkaWbn44t9NaN/J37UsKwkJT3z2J9+OdnsC1gz3MCMnzLfX8zek
	KE8m6LB4ZTPJvheflwIpL7gsYD9E9XpjejO6BqDzTffUuCoM52UYax/KlEP9EK9nyiwiEeJ8Tq+
	Qf1JiJQ5163Q=
X-Received: by 2002:a05:651c:1442:b0:3a3:42cf:c014 with SMTP id
 38308e7fff4ca-3a88765a8afmr6175741fa.7.1790935530006; Fri, 02 Oct 2026
 03:05:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260930112842.21323-2-sigefriedhyy@gmail.com> <179089747717.434549.10025971158678601177@kernel.org>
In-Reply-To: <179089747717.434549.10025971158678601177@kernel.org>
From: Yuyang Huang <sigefriedhyy@gmail.com>
Date: Fri, 2 Oct 2026 19:05:20 +0900
X-Gm-Features: AclHuK835RXya2QRfyWHcfAV1rz2yv5rXyfDJb6TRXTUTekf2P7RB2gM9v6I-4Y
Message-ID: <CA+7S2vK-rJ7oJ89onostQbPeNq8A7rLgsd_=_D2AZ27Bg3Dizg@mail.gmail.com>
Subject: Re: [PATCH net-next v9 1/6] netlink: specs: rt-addr: fix the type of target-netnsid
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
Content-Transfer-Encoding: quoted-printable

> - [Low] The commit "netlink: specs: rt-addr: fix the type of target-
>   netnsid" fixes a bug in one specific earlier commit, but its message=E2=
=80=A6

The Fixes tag was dropped in v4 on purpose, this is a spec fix for
net-next, not stable material.

> - [Low] This problem wasn't introduced by this patch, but after this
>   commit rt-addr.yaml still lists target-netnsid in no operation's=E2=80=
=A6

Pre-existing and unrelated to multicast dumps, can be fixed separately.
