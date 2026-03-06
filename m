Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E60A3451D7;
	Fri,  6 Mar 2026 09:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772789701; cv=none; b=HMDj567PFvr/elm7i/JpaPHQ61CcDVc5Zq7/0DsFiRNwIM/H9xi28CE8Sw3Na4cC/MI0/lis+sdgfQM+1UZ5t6s7xKRomCGe08BQQgnktMNy3BUwcLkLa2vrV9Nyn472Wyv31NlsNf6pLsmWtPAiV1nvrIVDMBewzNaXqVp0ehQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772789701; c=relaxed/simple;
	bh=EzyHS6EOEbh2zvKtE4e2F56AhfN3GFCnelqFq6zbOSc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D+yiumZ1nOCNK4U6deIU+/SWmPp+LEHTTmaUmlbktYMuYdW4/zhgR8FDJzSFHhuna0BdSvKOqxHbGSB7a3AbOKEcvQpyRbL2rZgHOO18GZcQ5JKmd3kwaMHQq6I+Mm6mlka3cHSE19U6aC6htDHzPODYafLNGUfRoVRk9LbTCbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bpnMpZ3n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bpnMpZ3n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20F9CC4CEF7;
	Fri,  6 Mar 2026 09:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772789701;
	bh=EzyHS6EOEbh2zvKtE4e2F56AhfN3GFCnelqFq6zbOSc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bpnMpZ3nIbu69rTInfEgyxpEZTqACoyEAiTUbdKyJOYnRz4YBQ5QAC4GQ6RCzXR7x
	 OpKXs1692pq9l7TCRa58gvOCcZ8M6RDs+wN551HSFqChwbOo/PuNdJQxKnXM4/BgBf
	 ptguPYXivCPtKIZ1q4VaN3fU6POY1hZlXg4TD2ksA64C5dUh0qGo6a+VaoQbEmpBvI
	 pl7r0AhmCzabKyb/Ioh/14u4KUugttatmfev4r05PFev6Zy4/B9DRzDADvORZK+ItB
	 e8BDZbbqVziLQyA19egmYDcV7UqFOiDnhm4DCWluwJgEUf4Zu6DPeVF5FdVen8ONYi
	 31g8JIbdZTA0g==
Received: from johan by xi.lan with local (Exim 4.98.2)
	(envelope-from <johan@kernel.org>)
	id 1vyRaD-000000005X7-2bqE;
	Fri, 06 Mar 2026 10:34:57 +0100
Date: Fri, 6 Mar 2026 10:34:57 +0100
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
Message-ID: <aaqfwRTJVswShHSW@hovoldconsulting.com>
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

> > Sure, I can include rtw88 (and ath10k and ath6kl) in a v2.
> 
> Can you please also include rtw89? (I saw you have sent v2 though)

Ah, sorry about that. I was sure I had grepped for usb_get_dev in
wireless before sending v2 but apparently I did not.

I just sent a separate follow-up for rtw89 here:

	https://lore.kernel.org/r/20260306093206.21081-1-johan@kernel.org

Johan
