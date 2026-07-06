Received: from mail.schwarzvogel.de (skade.schwarzvogel.de [157.90.210.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554D130676E;
	Mon,  6 Jul 2026 08:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=157.90.210.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783325979; cv=none; b=NkYY+EAF83fXEM8qcbe8ZE3KJGoat4ywxRV2gny65AA+9NUS5DsVWlyWpwyICHVjPDrJwln/UqS40WHj1sKay85rEnFUjtfGOhm87L1IpVVQK6+znN/lOsFZ4UMm4oY7RUHUSKuvotYtNxKYY5dd1K9GDsxuhgW3E87ZvKda5n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783325979; c=relaxed/simple;
	bh=D9Skio9x3dM41ArZdBd5705/QiNYOtxzP4tQnVmBpgM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TsGQFdU3P+lNITmkHWuyOfuWWQ4DOUi0uctWrUVWKHAjeaZikEJEH5LN5N+8NxJitJPx9YXTwg2STSyaOKTV58K7THDUXyXHZs4P6vTBPZWK+MnGDxij4uS6qAmqtmz0J7QikFOr9sCHu7H7ClDJ2kfpcLMaCHobX2cm9AzVlCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=schwarzvogel.de; spf=pass smtp.mailfrom=schwarzvogel.de; dkim=pass (2048-bit key) header.d=schwarzvogel.de header.i=@schwarzvogel.de header.b=JXBskQTw; arc=none smtp.client-ip=157.90.210.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=schwarzvogel.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=schwarzvogel.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=schwarzvogel.de header.i=@schwarzvogel.de header.b="JXBskQTw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=schwarzvogel.de; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:
	Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date;
	bh=eKAddAQnV4Mof49a5ZigeyhJcCiP49LYRA419jtb8sc=; b=JXBskQTw5CCzHgaZB+4VudI7mV
	68KcNcOXo9HHXyeRzple9XTDPxezjcRRiMisayRHEwz61yknMfqcDDHGxeQFR6L5tYp1QhihKgG3y
	4A0YzbYnkja529pgVOL2Wofr/hjV7S1dSQX9hU0MSBPvoElTgWWG+qZmte46uNwFDidJuaHUt9csb
	MKpWvzpSeHhUT02Mel+DgnQMWFbdfeEJnL6iUrfT5reNqLGof9H+6Vc5gAziPgX7fS5OdZGGYecw+
	hbwfhKr8FbJi4AWk7t6NND1ezyZG7mMFK5ww3sQmP5EdbsdDV5b5xMC9uWbwBJ7izR3If94qeSC3e
	LHJOewDw==;
Received: from klausman by mail.schwarzvogel.de with local (Exim 4.99.4)
	(envelope-from <klausman@schwarzvogel.de>)
	id 1wgeXu-00000000l0g-3HM8;
	Mon, 06 Jul 2026 10:19:18 +0200
Date: Mon, 6 Jul 2026 10:19:18 +0200
From: Tobias Klausmann <klausman@schwarzvogel.de>
To: Thorsten Leemhuis <regressions@leemhuis.info>
Cc: Rosen Penev <rosenp@gmail.com>, linux-wireless@vger.kernel.org,
	Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	"open list:ARM/Mediatek SoC support" <linux-kernel@vger.kernel.org>,
	"moderated list:ARM/Mediatek SoC support" <linux-arm-kernel@lists.infradead.org>,
	"moderated list:ARM/Mediatek SoC support" <linux-mediatek@lists.infradead.org>,
	Linux kernel regressions list <regressions@lists.linux.dev>,
	Klara Modin <klarasmodin@gmail.com>
Subject: Re: [PATCH wireless-next] wifi: mt76: fix MAC address for non OF
 pcie cards
Message-ID: <58c4dee3-5b13-4faf-8803-3d52f59eba51@skade.local>
Mail-Followup-To: Thorsten Leemhuis <regressions@leemhuis.info>,
	Rosen Penev <rosenp@gmail.com>, linux-wireless@vger.kernel.org,
	Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	"open list:ARM/Mediatek SoC support" <linux-kernel@vger.kernel.org>,
	"moderated list:ARM/Mediatek SoC support" <linux-arm-kernel@lists.infradead.org>,
	"moderated list:ARM/Mediatek SoC support" <linux-mediatek@lists.infradead.org>,
	Linux kernel regressions list <regressions@lists.linux.dev>,
	Klara Modin <klarasmodin@gmail.com>
References: <20260630210215.400379-1-rosenp@gmail.com>
 <036cc81d-115a-4c0e-9542-71ed2ee04e9b@leemhuis.info>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <036cc81d-115a-4c0e-9542-71ed2ee04e9b@leemhuis.info>

Hi! 

On Mon, 06 Jul 2026, Thorsten Leemhuis wrote:
> On 6/30/26 23:02, Rosen Penev wrote:
> > If seems the check for err is wrong as the proper macaddr gets written
> > to from the EEPROM itself. Meaning checking err from of_get_mac_address is
> > wrong as the proper macaddr has been written by this point.
> 
> By our submission guidelines and requests from Linus this afaics should
> also contain:
> 
> Reported-by: Klara Modin <klarasmodin@gmail.com>
> Closes: https://lore.kernel.org/all/ajRmlyx_AEGybykL@soda.int.kasm.eu/
> Reported-by: Tobias Klausmann <klausman@schwarzvogel.de>
> Closes:
> https://lore.kernel.org/linux-wireless/30a90714-02d8-45f2-a7f1-4cfe0627d50b@skade.local/
> 
> Both of them now CCed, too, to give them a chance to provide a "Tested-by:".
> 
> > Fixes: 31ee1582717e ("wifi: mt76: fix of_get_mac_address error handling")

Indeed:

Tested-by: Tobias Klausmann <klausman@schwarzvogel.de>

I've been running 7.2.0-rc1+the revert for a few days now with zero
issues (not that I expected any).

Best,
Tobias
