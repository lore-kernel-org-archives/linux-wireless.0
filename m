Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9589411FA1
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 21:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789420537; cv=none; b=DA1mmfPLPS8OJsFohKIvh/fCpSx5IaeU9/xKxUjMMWw85oTaAM2TI4kNQI7r5PQHsPgEFZGiL8iTipVz99H5bEMphruN0N+ldvos65uVGskYgp1zth5V6FYsAZ5SiaZR3tlam48bb7DbBkvlDk4zoLc+Qq26STY5RqZrz7fgnvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789420537; c=relaxed/simple;
	bh=bFgdgeID/Ne6jUxyfD1OKQlY0Yi3oEhR74YsVLKphVg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mm+1ESQ3x7hnBWbAoFlA8oQOux9vUkoUPklI6J9ochwBi8IVNilzls3XYWB3mojzQJG/ZC9jOF90kkR1h3N4Rvf3gm65CFj0c6GB1R42mxZr93Mxh3tz9h0zHcxCqU7ZtODTLDaVp/3RO+WeCx+Ay0gWXOqsehgvM77Oc06eDbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nZ3svjAW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nZ3svjAW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE7151F008A3
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 21:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789420535;
	bh=NevuUkbIbY8Xir1EiuknrCzVePMTrnsw9qsLi8W12R0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=nZ3svjAWFX3+xqUFjVpIL9dgPp8tQFeM5gg5QoY7Pu7qXBjj4Xt4sf+78cNwfD5Y3
	 gVAngk7ti3CFZ92sivt3gMZFqY2SYum3QAw2RronjZ8MTENStKYof7+tNtUAFp9zFW
	 51SM5bXydhxNXEQOy87BV8o3tqVL75/Y3pFuku/MJl/IR/oUUNdWZj+fQO5d1OmSxS
	 2+N/aeuRXGkaHbyOqCleTd55yqKAnO3VXOEgHsmKKhvoY/bhz23CuGFHm1Wtw706L3
	 w7ZPkrmlkJd8Yy8r6N0rWzr0l3nJdogRCztyFnYBBmfphr7Q+79HaU2FyG9C0BDZHz
	 xb2iaQxsriXZg==
Received: by mail-lf2-f13.google.com with SMTP id 2adb3069b0e04-5b89a0e69dfso2700672e87.3
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 14:15:35 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBy0K3r8vnyRPG8zqkD4SZKCXE19WN/FJgbRDk5/Kow7wUi7ajofI45qhXsAAE/YrhSTvyCoknw8JJtBWBqLjA==@vger.kernel.org
X-Gm-Message-State: AFuF++mqSPVMVtvz/GGf8Wjgt9QE03/E1WpyIfzYlPOr5yXXj3qYx4pW
	RY+AniRGIpWOPzWWr/88mzTfpFNrU+gjsuZPD8WS4JvCoQFvK3kl9wBqBYF8A489+1SKLzune32
	3xmuUQx+/t/V2nBuSo0U1RlptqSMe0SA=
X-Received: by 2002:a05:6512:3f0e:b0:5b6:183b:d214 with SMTP id
 2adb3069b0e04-5b8ae6a6fbbmr1185441e87.59.1789420534106; Mon, 14 Sep 2026
 14:15:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260914155645.112508-2-krzysztof.kozlowski@oss.qualcomm.com>
In-Reply-To: <20260914155645.112508-2-krzysztof.kozlowski@oss.qualcomm.com>
From: Linus Walleij <linusw@kernel.org>
Date: Mon, 14 Sep 2026 23:15:20 +0200
X-Gmail-Original-Message-ID: <CAD++jLmu2vovxXa9jqX+pq32KV6ONQ-=Yoo3fKF-49oMFVv3GA@mail.gmail.com>
X-Gm-Features: AcwNN1W41lYuox0pw4JKzbuFr7Ojh_AWjTCNy5TnXF9BlZMG2RX-71m9k3IWIl8
Message-ID: <CAD++jLmu2vovxXa9jqX+pq32KV6ONQ-=Yoo3fKF-49oMFVv3GA@mail.gmail.com>
Subject: Re: [PATCH v2 net-next] dt-bindings: net: Use consistent indentation
 in the example
To: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Cc: Justin Chen <justin.chen@broadcom.com>, 
	Florian Fainelli <florian.fainelli@broadcom.com>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Hans Ulli Kroll <ulli.kroll@googlemail.com>, =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>, 
	Vladimir Oltean <olteanv@gmail.com>, Heiner Kallweit <hkallweit1@gmail.com>, 
	Russell King <linux@armlinux.org.uk>, Kunihiko Hayashi <hayashi.kunihiko@socionext.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Felix Fietkau <nbd@nbd.name>, 
	Lorenzo Bianconi <lorenzo@kernel.org>, Ryder Lee <ryder.lee@mediatek.com>, 
	Shayne Chen <shayne.chen@mediatek.com>, Sean Wang <sean.wang@mediatek.com>, 
	Johannes Berg <johannes@sipsolutions.net>, Matthias Brugger <matthias.bgg@gmail.com>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
	Jeff Johnson <jjohnson@kernel.org>, Richard Cochran <richardcochran@gmail.com>, 
	Geert Uytterhoeven <geert+renesas@glider.be>, Magnus Damm <magnus.damm@gmail.com>, 
	"G. Jaya Kumaran" <vineetha.g.jaya.kumaran@intel.com>, Claudiu Manoil <claudiu.manoil@nxp.com>, 
	Alexandre Belloni <alexandre.belloni@bootlin.com>, Alex Elder <elder@kernel.org>, 
	Siddharth Vadapalli <s-vadapalli@ti.com>, Roger Quadros <rogerq@kernel.org>, 
	bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-renesas-soc@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-wireless@vger.kernel.org, 
	linux-mediatek@lists.infradead.org, ath10k@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 14, 2026 at 5:57=E2=80=AFPM Krzysztof Kozlowski
<krzysztof.kozlowski@oss.qualcomm.com> wrote:

> Correct indentation in the examples to consistent 2- or 4-spaces
> indentation to fix dt-check-style warnings ("example 0
> [indent-consistent] indent mismatch ...").  Preferred is 4-spaces, but
> re-indenting entire example just for that is too much churn.
>
> In cortina,gemini-ethernet.yaml also drop the wrongly indented mdio bus,
> because it is not necessary for the example.
>
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

Reviewed-by: Linus Walleij <linusw@kernel.org>

Yours,
Linus Walleij
