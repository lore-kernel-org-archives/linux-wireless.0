Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9204A361DB1;
	Wed, 29 Apr 2026 08:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777450184; cv=none; b=dl5ih0XcN0EIbVZunz1PDm3JqgeNC7CrmlZrSwdkHStxnrwiTt8hx5adB95CEfY/acnEWcgNHm4rdo+Z4B3KCIWw6qyhjIFDdLO6CgosDzc5v9CIaSvQQ5PtZgdbnhWyAASuK6g5zxZ6WJ5aAjGNcUIle44kj5nc45cj2bW4jfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777450184; c=relaxed/simple;
	bh=IJydhL1axxTXSlTxCoIegXCkSMgeg1JDgUkvERsnBmc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JUL/mdOPW479cOM6KUMMJ44EwYRK2Rl2NjbvBBaUixgAPnb/xGe79USxTfWirkiQ4jXYGa7NzAH5mqGJaVV5I2OiVwB4Y87d5GvqNsQmebZUCX7vstTNkY52Qv6eqru2tUWd2sLWbjbD3xmI6uZCU4AZHllAJAjLZKckfGPO82s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=PNer4CuX; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="PNer4CuX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=PBSLS81Hg9wDkJCyNVNhBa0+o0mO+VoVZYB9LUUukSc=;
	t=1777450182; x=1778659782; b=PNer4CuXRRSEoxJVQlDYrK4+Jm/4J/FkQueKxeI49hlc1tb
	8ze9h56+TBaGYkP+fFirelpTAQ8wzp14SFQ4e+kfUuH+lQEgHV59p89RjhaCZqRF2Lq0xSBk7nnVZ
	2/DfTKu3KFriaR02J5X7ZYScqQiYMowLsWPgJQUQFWusWx3EspEd08N3BuX/hh+Tuw4FS6/v0jwiW
	TohzAn6exiJGKj0ho38HkzeqY3BkBk/v8e4VQal/1Vl617YZgCzeK0ckjoElPdvwHL31CSDExpK25
	l+6Qq482CdjIcP79vDTuxEeyCsz5OQWWuAnpSEvb2orI98pJxjTaBRQywi/7UR6A==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wHzz8-00000002BBN-0V2e;
	Wed, 29 Apr 2026 10:09:30 +0200
Message-ID: <373571e47fd174777531005a99ef43aa37a0b504.camel@sipsolutions.net>
Subject: Re: [PATCH v3 3/3] p54spi: convert to devicetree
From: Johannes Berg <johannes@sipsolutions.net>
To: Arnd Bergmann <arnd@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Aaro Koskinen <aaro.koskinen@iki.fi>, 
 Andreas Kemnade <andreas@kemnade.info>, Bartosz Golaszewski
 <brgl@kernel.org>, =?ISO-8859-1?Q?Beno=EEt?= Cousson	
 <bcousson@baylibre.com>, "David S. Miller" <davem@davemloft.net>, Dmitry
 Torokhov <dmitry.torokhov@gmail.com>, Eric Dumazet <edumazet@google.com>,
 Felipe Balbi	 <balbi@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Kevin
 Hilman	 <khilman@baylibre.com>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Linus Walleij	 <linusw@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Rob
 Herring	 <robh+dt@kernel.org>, Roger Quadros <rogerq@kernel.org>, Tony
 Lindgren	 <tony@atomide.com>, linux-wireless@vger.kernel.org,
 netdev@vger.kernel.org, 	devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, 	linux-arm-kernel@lists.infradead.org,
 linux-gpio@vger.kernel.org, 	linux-omap@vger.kernel.org, Christian
 Lamparter <chunkeey@gmail.com>
Date: Wed, 29 Apr 2026 10:09:28 +0200
In-Reply-To: <20260427142355.2532714-4-arnd@kernel.org>
References: <20260427142355.2532714-1-arnd@kernel.org>
	 <20260427142355.2532714-4-arnd@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

Since you got comments anyway...


>  	}
> =20
> -	irq_set_irq_type(gpio_to_irq(p54spi_gpio_irq), IRQ_TYPE_EDGE_RISING);
> =20
>  	INIT_WORK(&priv->work, p54spi_work);

This leaves two adjacent blank lines.

johannes
