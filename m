Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50832248861;
	Fri,  6 Mar 2026 08:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772784596; cv=none; b=BBGYM16kUf2uy/Pa3+3A0V+PMj9+jX0FYboGV5CeaEftHtVIX8jTW5j5fBdCEN2Yzx23dJZmIWO5L1/QPXRUcPGjYbCpqAPNeOJecnIIYdaJMZgBGEsjBHTsLjROu3KmOKKTvsWLnD3moDC+QIDP/+AioBUFXZiFgmixTXA+L4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772784596; c=relaxed/simple;
	bh=7NxsDfsuUwNiSa+LOeVnlo/grQUWXwOwpB+OFYuuFuY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YKyJyYwV0qR4I1ZIdg0pcBLz2HWosLxUc323ys/m3p3omcU3aozQ5HeD0Y7+ebuBL2QGUYyJAg4xWemdceE7unA2w3iMG5cVFxvOgBHoz/jr9WwV5sUEwBx3mPJZcvZUhjqq8KzKic1oQxrfR2rmJ8OdF9RyQftlrb9YdAXuwOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fvl6EEes; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fvl6EEes"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28B60C4CEF7;
	Fri,  6 Mar 2026 08:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772784596;
	bh=7NxsDfsuUwNiSa+LOeVnlo/grQUWXwOwpB+OFYuuFuY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Fvl6EEesAQfTI61TJFKx+BU9fT1i6qOC7AoMNItjTASkOiDVx3t2em5kctpX3qZ02
	 hGq9nE3h6bmCnLcHHe31i6rD2JA4HY9BYBkdJwbi6ZRl3XL3hp5HsTL+Rr6dxYrPjE
	 tDYrlSeVtrrVUHPz6DSj8Dz6u46uBtAaaHjDivFpBN8vEo+sFF3EV42KODAbvgVD2u
	 NKp6XMxVy0Drw/je3t43B3Q5XhhYOtPsECy6evTZ8xByWzTXIWktvy7q0Wb96VPJyN
	 fMMjEXy+CDiqtXBGBORYoNO/TUObaiR3zRi3S/eTBCw6ztDlpkFf143JqROhx9X67X
	 CgCRWLT/6kV9A==
Received: from johan by xi.lan with local (Exim 4.98.2)
	(envelope-from <johan@kernel.org>)
	id 1vyQFt-000000008IG-1bsd;
	Fri, 06 Mar 2026 09:09:53 +0100
Date: Fri, 6 Mar 2026 09:09:53 +0100
From: Johan Hovold <johan@kernel.org>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Brian Norris <briannorris@chromium.org>,
	Francesco Dolcini <francesco@dolcini.it>,
	Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Jakub Kicinski <kuba@kernel.org>, Stanislaw Gruszka <stf_xl@wp.pl>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	Jes Sorensen <Jes.Sorensen@gmail.com>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	"libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 00/13] wifi: drop redundant USB device references
Message-ID: <aaqL0RdwEjWWjECk@hovoldconsulting.com>
References: <20260305110713.17725-1-johan@kernel.org>
 <0c75afbbe7bb419cab648f94191fe47f@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c75afbbe7bb419cab648f94191fe47f@realtek.com>

On Fri, Mar 06, 2026 at 01:40:31AM +0000, Ping-Ke Shih wrote:
> // +Cc Greg
> 
> Hi Johan,
> 
> Johan Hovold <johan@kernel.org> wrote:
> 
> [...]
> 
> >  drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c |  4 ----
> >  drivers/net/wireless/realtek/rtl8xxxu/core.c       | 11 +++--------
> >  drivers/net/wireless/realtek/rtlwifi/usb.c         |  4 ----
> 
> Acked to changes of these Realtek WiFi drivers. But I'd like to know why
> rtw88/rtw89 aren't included in this patchset?

I used a more specific grep pattern to catch driver releasing references
in disconnect() and therefore missed a few that dropped the reference in
helper functions (or used non-standard names for their disconnect
function such as ath10k, I see now).

> Greg sent a patch [1] to
> correct error path of USB probe for rtw88. In the discussion, he also
> mentioned the simplest way is to drop usb_get_dev()/usb_put_dev() like
> this patchset does. Will you share patches for rtw88/rtw89? I so, I'd
> drop Greg's patch and apply yours.
> 
> [1] https://lore.kernel.org/linux-wireless/2026022333-periscope-unusual-f0a0@gregkh/

Sure, I can include rtw88 (and ath10k and ath6kl) in a v2.

Do you really prefer replacing Greg's fix or shall I send an incremental
patch on top?

Johan
