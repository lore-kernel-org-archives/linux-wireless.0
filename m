Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F0533A5430;
	Tue, 24 Mar 2026 08:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774341088; cv=none; b=m+acnRnHkq5uv9imr78xO4NCxQSgp4xSsd3gUXA5oprFWX5fD3i3MfB0BuiEbZt/gTMevUO404gD8pUg8xSnKjtAB6zwJ9G7U+qpnzgsLsyO4azBgTZyL60+qbnE2S8tvakYblRNE0eY2W//vaDjBCm23rFlvVrLMf9dHtarZUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774341088; c=relaxed/simple;
	bh=xXumeJlB9aNv1E9GsfBcg21xWBKkLqmoeCmXIIHuIw0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z/6rHzvFfx02m+EvkdvrDhrexeiIUHAfWLnUmqBPvimC2CtcypsXrM49o2R0+GzC52D3MDOjQRxP+YGRtyKhtoRtk55pYIZp5fR9G98x007Ht2ZjhoDj9JkQA6KFJzU5tZbRzFGuoW6yqnqrvzrftR1JDq9A1k5dJS+CVGGl/Og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lDdSxM5O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lDdSxM5O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91323C19424;
	Tue, 24 Mar 2026 08:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774341087;
	bh=xXumeJlB9aNv1E9GsfBcg21xWBKkLqmoeCmXIIHuIw0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lDdSxM5OSQnej4bSSALyt54AZVwAT0TMI06ik+i3IMcklrrp5oNy1V6+NGGVUpXiP
	 cZbkh2ahpwtggLX7STzF8QS0mjaps9PzhvXhtzLOtaekBNyTSJq0vGVi5R4+1T3LAj
	 8cY6jSmB/hJJlW/cKruwqjjNzwQyN/VL7IAWIdkZrcmIo0gdZB7Z1ihUfvrImm5jug
	 tSx7GL42MnQ63hg/DScOSd+2sOG4v/YBdVAD0kGPthDLodGeVr5Vuoeo6dn+8UT7/r
	 /x7XtZJfFWmPGc/AadVNxBtcyA2REgEpheRWeh7Lz1ISbfl1ExcbHmP0ZhZJXTtM0y
	 I/0gvkq2YFQ7Q==
Received: from johan by xi.lan with local (Exim 4.98.2)
	(envelope-from <johan@kernel.org>)
	id 1w4xAb-00000003md2-0XCb;
	Tue, 24 Mar 2026 09:31:25 +0100
Date: Tue, 24 Mar 2026 09:31:25 +0100
From: Johan Hovold <johan@kernel.org>
To: linux-wireless@vger.kernel.org
Cc: Jeff Johnson <jjohnson@kernel.org>,
	Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Brian Norris <briannorris@chromium.org>,
	Francesco Dolcini <francesco@dolcini.it>,
	Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Jakub Kicinski <kuba@kernel.org>, Stanislaw Gruszka <stf_xl@wp.pl>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	Jes Sorensen <Jes.Sorensen@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	libertas-dev@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/18] wifi: drop redundant USB device references
Message-ID: <acJL3c5J6sT59sjx@hovoldconsulting.com>
References: <20260306085144.12064-1-johan@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306085144.12064-1-johan@kernel.org>

On Fri, Mar 06, 2026 at 09:51:26AM +0100, Johan Hovold wrote:
> Driver core holds a reference to the USB interface and its parent USB
> device while the interface is bound to a driver and there is no need to
> take additional references unless the structures are needed after
> disconnect.
> 
> Drop redundant device references to reduce cargo culting, make it easier
> to spot drivers where an extra reference is needed, and reduce the risk
> of memory leaks when drivers fail to release them.

> Johan Hovold (18):

>   wifi: mt76: drop redundant device reference
>   wifi: mt76x0u: drop redundant device reference
>   wifi: mt76x2u: drop redundant device reference
>   wifi: mt76: mt792xu: drop redundant device reference
>   wifi: mt7601u: drop redundant device reference

All of these are now in linux-next except for the five Mediatek fixes.

Could someone pick them up as well? Not sure which tree they'd usually
go through.

Johan
