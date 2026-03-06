Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45EE534A3C9;
	Fri,  6 Mar 2026 09:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772790609; cv=none; b=DzE8aBK6san+CDBkDYeD/ounMalc+IT0zTXCcdCZs4Soxz+TXfRJWWuYk3+BulJKrdvvm62FelGND41qReCZzEVFndVrxgwMbshRxSsVIxEXqiXdicG+LR6/XfSkrHECg93A3v3h2jMdLzNLPUGDcsl3gS12uL3usBQbiWG7v+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772790609; c=relaxed/simple;
	bh=2+XQx6K9fjkYiGPIvDseXYf8N4vu8hFRNw4vtK+LEsg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y9KlLxCbf5VVa/D+z4AZO6KrUwMUgQrGmzbtxakaBdOR1Z2weB9S1f7MYqGHFENANrPFclgER0L1nLnus5IU6hbhpbAlFtyACCUttdBSBkeZd5VsfERgKlxl2nH8lLipvXZhcF1Li7arHcCtN5mWkPsJt5wC+zaeYVqvsUZiByM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=paHDKUPx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="paHDKUPx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 383B1C4CEF7;
	Fri,  6 Mar 2026 09:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772790608;
	bh=2+XQx6K9fjkYiGPIvDseXYf8N4vu8hFRNw4vtK+LEsg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=paHDKUPxxb/BUe7EOpv31quLmjVO9eZjooPBZVnOsqnHCew0LGxq/6eLxD48poDTn
	 r1U7jNbjRnPWCHYBcANwBonNLMEZIpzfsP8e7ZkEP5DdoBsNMVu9yyZKT6Ew7L9E37
	 e4mEZW9df4zXzYNwpsDZaOxjk2Z/iK6aO6gtaGsY=
Date: Fri, 6 Mar 2026 10:49:54 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Johan Hovold <johan@kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
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
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/13] wifi: drop redundant USB device references
Message-ID: <2026030625-wrongness-preorder-4e1e@gregkh>
References: <20260305110713.17725-1-johan@kernel.org>
 <0c75afbbe7bb419cab648f94191fe47f@realtek.com>
 <aaqL0RdwEjWWjECk@hovoldconsulting.com>
 <81935da1c67a493c8313d906244dd577@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81935da1c67a493c8313d906244dd577@realtek.com>

On Fri, Mar 06, 2026 at 09:04:22AM +0000, Ping-Ke Shih wrote:
> Johan Hovold <johan@kernel.org> wrote:
> > On Fri, Mar 06, 2026 at 01:40:31AM +0000, Ping-Ke Shih wrote:
> > > // +Cc Greg
> > >
> > > Hi Johan,
> > >
> > > Johan Hovold <johan@kernel.org> wrote:
> > >
> > > [...]
> > >
> > > >  drivers/net/wireless/realtek/rtl818x/rtl8187/dev.c |  4 ----
> > > >  drivers/net/wireless/realtek/rtl8xxxu/core.c       | 11 +++--------
> > > >  drivers/net/wireless/realtek/rtlwifi/usb.c         |  4 ----
> > >
> > > Acked to changes of these Realtek WiFi drivers. But I'd like to know why
> > > rtw88/rtw89 aren't included in this patchset?
> > 
> > I used a more specific grep pattern to catch driver releasing references
> > in disconnect() and therefore missed a few that dropped the reference in
> > helper functions (or used non-standard names for their disconnect
> > function such as ath10k, I see now).
> > 
> > > Greg sent a patch [1] to
> > > correct error path of USB probe for rtw88. In the discussion, he also
> > > mentioned the simplest way is to drop usb_get_dev()/usb_put_dev() like
> > > this patchset does. Will you share patches for rtw88/rtw89? I so, I'd
> > > drop Greg's patch and apply yours.
> > >
> > > [1] https://lore.kernel.org/linux-wireless/2026022333-periscope-unusual-f0a0@gregkh/
> > 
> > Sure, I can include rtw88 (and ath10k and ath6kl) in a v2.
> 
> Can you please also include rtw89? (I saw you have sent v2 though)
> 
> > 
> > Do you really prefer replacing Greg's fix or shall I send an incremental
> > patch on top?
> 
> No. I'd drop Gerg's fix from my tree.

I have no objection for my changes being dropped, thanks for making
these changes.

greg k-h
