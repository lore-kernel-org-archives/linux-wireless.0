Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8011E3A6400;
	Mon,  9 Mar 2026 11:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.145.95.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773057176; cv=none; b=lwr1taS744xCdBLXSmoRvoTAMtKs49AtJi0OOtvhLq7GZ+yLe7MJO91TW6mFlm6Ta4vM5WuiXOi7H54RXg2SlJZ7+5VTO2RGfuNmlsdJy9zKOTw7hY8JF/EgGXVNKHUF9ZnozxUG2DsYFLjNhK2qaHNhx1qhfHip9UuBGQhsakk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773057176; c=relaxed/simple;
	bh=AM7ELKcJDJIhFyraEh/BToyqtgVoSWHLICxIYRU/4Og=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=VTeKUQOw7hGiP/vVy4d567ZBypz/QnHsmCkFFJzQQU0kbKDF8Y2PXUwlLj6dmw4Xtqye+xlWwquJb764LhyMB6egMNlJD2StvP6pBJa/BlXOM0VYpnobblEFbWNfph00Vans67mygblUP2WWD8D2t/geRajHtcjoKTAGL5W21IE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=toke.dk; spf=pass smtp.mailfrom=toke.dk; dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b=UXMp/+xd; arc=none smtp.client-ip=45.145.95.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=toke.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toke.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="UXMp/+xd"
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
	t=1773056713; bh=AM7ELKcJDJIhFyraEh/BToyqtgVoSWHLICxIYRU/4Og=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=UXMp/+xdyi0VT88Iv33Mof3HBa0EqC0BLFmXVeVXUbgiC+vheYYcGO4aUOsFFXYSg
	 bI8+ZKDv7NRxVUG2cmhR46PxP/Ih0zxNAd9//7JnMrqZE4Dv+bdhbGHvG3HoTz9Vei
	 qfWeFA1oYmllFWn6WX3zlfi6cQf1DSGKPKPkJ38nraM2j40LQHppBGfVggctZEH4zD
	 rB6Gu8ve2AyqUgvJv3KtxlvKfkNCLeuq51dzCmyjtVHVaC+dokl3jtZ5DJYCkh+Ar8
	 6Z/HGqsv15KjU/iYpAx3Vbs4FEWnX71XGMC65Dy1wb/uevYDT2zqhJO8AR4TFSejFb
	 cffEGcP7LAeug==
To: Johan Hovold <johan@kernel.org>, linux-wireless@vger.kernel.org
Cc: Jeff Johnson <jjohnson@kernel.org>, Brian Norris
 <briannorris@chromium.org>, Francesco Dolcini <francesco@dolcini.it>,
 Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>, Ryder
 Lee <ryder.lee@mediatek.com>, Shayne Chen <shayne.chen@mediatek.com>, Sean
 Wang <sean.wang@mediatek.com>, Jakub Kicinski <kuba@kernel.org>, Stanislaw
 Gruszka <stf_xl@wp.pl>, Hin-Tak Leung <hintak.leung@gmail.com>, Jes
 Sorensen <Jes.Sorensen@gmail.com>, Ping-Ke Shih <pkshih@realtek.com>,
 Nicolas Ferre <nicolas.ferre@microchip.com>, Alexandre Belloni
 <alexandre.belloni@bootlin.com>, Claudiu Beznea
 <claudiu.beznea@tuxon.dev>, Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>,
 libertas-dev@lists.infradead.org, linux-kernel@vger.kernel.org, Johan
 Hovold <johan@kernel.org>
Subject: Re: [PATCH v2 03/18] wifi: ath9k: drop redundant device reference
In-Reply-To: <20260306085144.12064-4-johan@kernel.org>
References: <20260306085144.12064-1-johan@kernel.org>
 <20260306085144.12064-4-johan@kernel.org>
Date: Mon, 09 Mar 2026 12:45:13 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87o6kxp6pi.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Johan Hovold <johan@kernel.org> writes:

> Driver core holds a reference to the USB interface and its parent USB
> device while the interface is bound to a driver and there is no need to
> take additional references unless the structures are needed after
> disconnect.
>
> Drop the redundant device reference to reduce cargo culting, make it
> easier to spot drivers where an extra reference is needed, and reduce
> the risk of memory leaks when drivers fail to release it.
>
> Signed-off-by: Johan Hovold <johan@kernel.org>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
