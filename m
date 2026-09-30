Received: from mail-lf2-f13.google.com (mail-lf2-f13.google.com [74.125.229.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E0146AF10
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 13:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.229.205
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790775824; cv=pass; b=GHHhypAmStQ5Wl0zPgS82aaV9O+CHo4Ns+33BKtpBW4KkpCV+mqITURSBLSykaBSPoL8c1ehfV6fkHY1w0Xg9a9RPLO0Hjba5Ae3ZJtJD4DZIlC1Ng0iPJsoZDrkDuws51GlvkWk6TMIlTyvq8igGOIJSlYgfFMPHRDfBJwFwdo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790775824; c=relaxed/simple;
	bh=cCtGCKJIdKETCLLrblWPIJiV47ko5Aowu8J0xSZcZvA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Xbagyv1Tz+Lx6Lki67Aliy2v3COQzfHwh0AWbBS3mNYrf4picEXkHcrFSV6oxOlWSEEoBlTtloqQz8vRBUWQmF9yF4/KeBYyTJ2DbV/XkMo+GsAnRmTAAnN0ibSYnHBKFaXj1WBxKpTacxaBFDNgpBfHM444TUIw7VMclxbUpks=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Abwb83fs; arc=pass smtp.client-ip=74.125.229.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Abwb83fs"
Received: by mail-lf2-f13.google.com with SMTP id 2adb3069b0e04-5b8cbb7b9cfso4305447e87.0
        for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 06:43:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790775811; cv=none;
        d=google.com; s=arc-20260327;
        b=hClNZ5z4nVKGnSFHegdspf5meNhLp4AdYf9US/qoGWGJE5gs1N6YbDFolyMGyGXNXn
         9IujUNthBqv4DjuwjUfnfVpwy4wqaRBj2hJn6rEIMTOrJhqEhMsrPiOtWhlJVl7uMB6a
         2JB7TUArogS7I85uhSAG7yv/aUXV/R7TZvJPwwTRiuRwyLVcXYHt/0o8iTRoSWGBHmbf
         zEUrkrOc7uV8iPkUF2cUG2EzAdQnhjH0GTzl00jWdrJ4L6r48QIkReBWO4chAtyl31Ma
         f7ZOXjIodQ57oXUn7LBMO2m6H2wZJdArAPqeseclOimRvEilFoRrtzodOJQwzSfjwk6I
         3l6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cCtGCKJIdKETCLLrblWPIJiV47ko5Aowu8J0xSZcZvA=;
        fh=g5wmEE+4RR9JztPWWtWCr0njR6MADTocjnFcnwZ7uco=;
        b=T/0JrBrKjQJUi5CAka1xmlG7E581hOJ+JjEQQ+COEeIm1fM6QVl9ytS94UnjWuKChm
         KqNE98YNN1gZ73XQo29jpMFOUUWrafG5Q1PzRm/K0jQWHG/RGzJjwBMkogi/uCmr78H2
         i+GzG5sAiYzDD8j6dz1gZseVyCcE4p3vRiinZ1JONJb6n6LpZnDsUSZzi5wSjwWNSoqu
         gzvGxOVSV63UxucnamKdc+LAEzeE3bUA63Kan4boYDJ8AVbhBHDQky9yGk9EkY1cyBDG
         okgrFHZUZcjLYrW+4VSEh6WYnqOD9YhoHXvrZYIPlPMW7Lymqq/lU5+I4rDf9knfGAVx
         7hwg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790775811; x=1791380611; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cCtGCKJIdKETCLLrblWPIJiV47ko5Aowu8J0xSZcZvA=;
        b=Abwb83fsHbVpFom07AyBbpD8lFlxcGjmykARrOKp1fEkZ5oFgOMcOil6oA+XBjIA4u
         VpHxhpr99eY0XrjQ0fH6vQj2WGP4SaUUkQbPZkV6eL0+Eh2K7xGmReydj100JWDeaA2m
         Ejoy0YYjPwnLLA8Qva95dPsyhbZy/LE7x2OPGuRAf8bSsFJfjKIMEzixk/DfeL/Fv3RF
         4QI1Yh3RBlRp2YPpWQI0aph0AsUN5ZcrBCMzRRZkvqgau45sRl92pAOYYeW6f+yjnCHQ
         sWuLaMYhVV1MBs8lB3BGRT3u97pMMllnj4pmMtDtq19bRWSxI1U8dgz459H0yoRTlXuq
         Tpug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790775811; x=1791380611;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cCtGCKJIdKETCLLrblWPIJiV47ko5Aowu8J0xSZcZvA=;
        b=PQ2YeDtBuYdBCEEbvIeK0RszI9voeuNa/BNiy8p+ECoR6HNKdrMp3j37jU6LEYQrqq
         MNF0jQFF/naLBJMmIRQtZ7jurS40ArJjkQBsHfewmgZ0K058pev1M6ak3B6lMf5+6PLY
         khxKVeh/UDkYTg+UP4ZRNBqxtwoop5evWKWaD8mO8YuXWsBOApGXAiL5nEFQqC3acJna
         NyNWr3HzXTWd457PXkarlhcjj4TNfY4sVh3K9ghXbSvtFyub8jpmPxDcauQMrGtsa/DS
         Aovxw0mJz5mDeb7PCIyugKXIRPCZE0LofTMQVrnzMqhTy0jMmc7ZR+rW52AbpXEbrC5+
         10HA==
X-Forwarded-Encrypted: i=1; AKwUvBzTrHhnmCZ2eFzRFpZgxGYQuXsKuQL1Tuf5WIrPWv1pnsY2R70pIUb1jc/st8uynLGAJkrK7Sp0r2e989nclg==@vger.kernel.org
X-Gm-Message-State: AFq9FYJWpYloXWY8GvHgGd6h+27lM1GMbZ2gG0x5pqDwVHx4G3E/c0Kv
	7SNExI9XJKIJ93hntPuFx18anwSgq6t2fvzo7Lel9fwlb2nqKlOVTZww/UTP3QpDFwnfd/H/K34
	rHnbAzWca7Qc2ZzLYbWZjih4AyoBMYak=
X-Gm-Gg: AYBFou2qkRHjiPg5DjJSAuInEHXo/1YS+NAhT99KgroaK2xmt/zllq9w7o1kQSb9+av
	Mi8PfK5lyTSfbCys1wbOIIb7Q9cY1TgrW0GhtA5lvnAaqT+EMSnky4kSwN/ZpJtmWAjUNnLRE/P
	hf/iHF1wL+0SC1wn4yphaNOyRDN5cuJZAziw71OM7drZQL10y7/C4fdXhhczTWFHMuz0J5xJ5nb
	/eGIPjT0/co7kQRaoTtJS4/idRkrJKVOdmWuD/uMGPrFgioQjYqXlvx3a0W57ZqmQeqztY7F6ep
	a9X72W0+kbkG+QTIa7rQF9Wvae40T/XtaOoJfqGX2MTwAH2bImBy4FdUYmf2ts/TPOS4iu+eNd3
	uKvCt6Qsjctuo+zV/txCXgi0b2y11lRJQ90oI/lG8FXf8
X-Received: by 2002:a05:6512:3ca2:b0:5b8:f83b:30bf with SMTP id
 2adb3069b0e04-5ba405f9b82mr609416e87.65.1790775810584; Wed, 30 Sep 2026
 06:43:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260930112842.21323-1-sigefriedhyy@gmail.com>
 <20260930112842.21323-3-sigefriedhyy@gmail.com> <235a33c2-7138-4815-820d-793568757d95@6wind.com>
In-Reply-To: <235a33c2-7138-4815-820d-793568757d95@6wind.com>
From: Yuyang Huang <sigefriedhyy@gmail.com>
Date: Wed, 30 Sep 2026 22:43:26 +0900
X-Gm-Features: AclHuK-5JDzwUkEH5VWEa1bCvpw7pms_UcYcspNYWPTwaPuJPPDlw6Pn3dQKWJk
Message-ID: <CA+7S2v+VaVYksOpuUKzo+DoWZ97M_XKvnMr8cCcgwTkrOxsvEw@mail.gmail.com>
Subject: Re: [PATCH net-next v9 2/6] net: change netdev_hw_addr_list count
 through helpers
To: nicolas.dichtel@6wind.com
Cc: Ajay Singh <ajay.kathat@microchip.com>, 
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	Claudiu Beznea <claudiu.beznea@tuxon.dev>, "David S. Miller" <davem@davemloft.net>, 
	David Ahern <dsahern@kernel.org>, Donald Hunter <donald.hunter@gmail.com>, 
	Eric Dumazet <edumazet@google.com>, Ido Schimmel <idosch@nvidia.com>, 
	Jacob Keller <jacob.e.keller@intel.com>, Jakub Kicinski <kuba@kernel.org>, 
	Johannes Berg <johannes@sipsolutions.net>, Kees Cook <kees@kernel.org>, 
	Kory Maincent <kory.maincent@bootlin.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Nikolaos Gkarlis <nickgarlis@gmail.com>, Paolo Abeni <pabeni@redhat.com>, 
	Sabrina Dubroca <sd@queasysnail.net>, Shuah Khan <shuah@kernel.org>, Simon Horman <horms@kernel.org>, 
	Stanislav Fomichev <sdf.kernel@gmail.com>, Vadim Fedorenko <vadim.fedorenko@linux.dev>, 
	Willem de Bruijn <willemb@google.com>, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-wireless@vger.kernel.org, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> If you respin a version, you can use netdev_hw_addr_list_count() in
> __hw_addr_list_snapshot() also.

Thanks, will do if there is a v10.

On Wed, Sep 30, 2026 at 10:03=E2=80=AFPM Nicolas Dichtel
<nicolas.dichtel@6wind.com> wrote:
>
> Le 30/09/2026 =C3=A0 13:28, Yuyang Huang a =C3=A9crit :
> > The count of a netdev_hw_addr_list is changed in several places of
> > dev_addr_lists.c and a few drivers read it directly. The next patch
> > needs to account every change of the count of dev->mc.
> >
> > Add __hw_addr_count_add(), __hw_addr_count_inc(), __hw_addr_count_dec()
> > and __hw_addr_count_reset(), use them for every change of the count
> > and rename the field to _count so that a direct write stands out.
> > Readers keep using netdev_hw_addr_list_count() and the netdev_uc_count(=
)
> > and netdev_mc_count() helpers, the few that read the field directly
> > are converted. No functional change.
> >
> > Signed-off-by: Yuyang Huang <sigefriedhyy@gmail.com>
> Reviewed-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
>
> If you respin a version, you can use netdev_hw_addr_list_count() in
> __hw_addr_list_snapshot() also.
>
> Thanks,
> Nicolas
