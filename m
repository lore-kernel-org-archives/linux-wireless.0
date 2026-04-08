Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396483876CA;
	Wed,  8 Apr 2026 14:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775659168; cv=none; b=F6rw1rsaiJEDCPGJ2oV/ViwEa0gG9V53BnecgjfSwZWrTqBhXYKM28FTJb5J0y6NZ8GA/C80Dy8swJq8JDwQOp2n/bsys+1NaJcHPNrPzfxt5rBkJtxmGvZu8ov/cjEWtqQMmHRIhjI5qZYkfxESPm1b7Yo538APgVilTKhXItk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775659168; c=relaxed/simple;
	bh=WDVQUSJZJti5I83uQQI0nyEhlm5REOmLdet9XTkvQCU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e0ZaVDvwM+7YhvrL2mZpHcqd9iwtYG6zQxXQYXuEpB86m4oHZ0a6Dl0IPk/hpWTo1wBMoR95c2YZnf6mr5rtmGzjpHa78dqkWw75iJ+xxV02Eu3NDzirgDTsSgZM/DHj569lvrvH/QZR68K9vLfVxl6JVcaEltSNHVTISKNpiDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hHpi+jex; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hHpi+jex"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D09BEC19421;
	Wed,  8 Apr 2026 14:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775659167;
	bh=WDVQUSJZJti5I83uQQI0nyEhlm5REOmLdet9XTkvQCU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hHpi+jexiL4h2pCgODqOxk+UWVGUc0bqDHGxK6L3q8r0YxV9Dkn6qTHmars9/PuD5
	 YfNeoCWn+pIrfPkNRPM8mV7suXdzGboJ+Q6RwGBU0DgZUF7WFdEMbol+US8lVR8Fv+
	 fXaWksS6qNIng0tX7bfyR3LGtt4NZIp3E/DQcbfRqOuDSJMO0CbCg9hnuqA37HTV0a
	 M/PIO+mNPYw9Drj1KnhJPCaHcgf68pqWpPdIUq7iOzLs8NyIQdESDPCIy0WtKjo+Xs
	 n+ruhQ0g1BPosh8enVXXDRa2vMx/19SJEBLN2/mBLgoTkNGlIoQlNN6orbTEp2GQZ4
	 KsFWA3CE4REKw==
Received: from johan by xi.lan with local (Exim 4.98.2)
	(envelope-from <johan@kernel.org>)
	id 1wAU3x-00000000obw-0W8c;
	Wed, 08 Apr 2026 16:39:25 +0200
Date: Wed, 8 Apr 2026 16:39:25 +0200
From: Johan Hovold <johan@kernel.org>
To: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Felix Fietkau <nbd@nbd.name>
Cc: Jeff Johnson <jjohnson@kernel.org>,
	Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Brian Norris <briannorris@chromium.org>,
	Francesco Dolcini <francesco@dolcini.it>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
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
Message-ID: <adZonQ10NQqRI4_V@hovoldconsulting.com>
References: <20260306085144.12064-1-johan@kernel.org>
 <acJL3c5J6sT59sjx@hovoldconsulting.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acJL3c5J6sT59sjx@hovoldconsulting.com>

On Tue, Mar 24, 2026 at 09:31:25AM +0100, Johan Hovold wrote:
> On Fri, Mar 06, 2026 at 09:51:26AM +0100, Johan Hovold wrote:
> > Driver core holds a reference to the USB interface and its parent USB
> > device while the interface is bound to a driver and there is no need to
> > take additional references unless the structures are needed after
> > disconnect.
> > 
> > Drop redundant device references to reduce cargo culting, make it easier
> > to spot drivers where an extra reference is needed, and reduce the risk
> > of memory leaks when drivers fail to release them.
> 
> > Johan Hovold (18):
> 
> >   wifi: mt76: drop redundant device reference
> >   wifi: mt76x0u: drop redundant device reference
> >   wifi: mt76x2u: drop redundant device reference
> >   wifi: mt76: mt792xu: drop redundant device reference
> >   wifi: mt7601u: drop redundant device reference
> 
> All of these are now in linux-next except for the five Mediatek fixes.
> 
> Could someone pick them up as well? Not sure which tree they'd usually
> go through.

It's been two more weeks (and these haven't shown up in linux-next) so
sending another reminder.

Can someone please pick these up for 7.1?

Johan
