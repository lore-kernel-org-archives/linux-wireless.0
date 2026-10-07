Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 395B84657CD;
	Wed,  7 Oct 2026 10:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791367579; cv=none; b=ii9s1fZowQVK++Ln42Em3+/Z3mX7xOFNrlLuDp5wICDY6Y3S4vJ6Gio2ahqdJaqEHQVugH5/MBbuWe5YqSipKdjiXsLVeGL3Bl6YftcKUXg7/KPYaxQHs2FGa7QFygNs4KrXoq5hlpkp+FBaJhygPSgHebHjbynQ+MLYUsIY+cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791367579; c=relaxed/simple;
	bh=ThrzCWIksPL20Ok+TRrv8CFsYflsE4O/YtD/49PYevw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YThcqO8zWXtdWN2Mmn7YedgREDjL5+bBbIs0q5Kexgue74cyk0hQ/O83PM5nABkW84WsLZ6nxkL/p0/hWaAGSzewSIH8nipheWlUwutiT614BUWIxjF5elNOQSBamLsIC0BxcKOAZUzZUdEzBHR9OL7pjOBIQ6fh4CITK7p8Ihc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JrKC435N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JrKC435N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70BA81F0089B;
	Wed,  7 Oct 2026 10:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791367570;
	bh=gcbMhU19QSnXMHHjLFPjXFMjKZxKIL/KJWHABvvuKeY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JrKC435Nrkfanim9zp5IovDQbp6gGrXufUUSBbfXOf3xfwBDFij0pen4rWBZ8gQfn
	 gxKOGbtSoIGpY2sqi+lHlLsdbqlCl53geJIXTpqj2LB3GkQm5rWdCLtu9t7obBndsT
	 X5bcdIfRTwrNVdxbdraLIL0svkSQcMdh1c/vchww=
Date: Wed, 7 Oct 2026 12:06:06 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Luka Gejak <luka.gejak@linux.dev>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: Re: [PATCH rtw-next v8 5/7] wifi: rtw88: 8723b: add the RTL8723B
 chip driver
Message-ID: <2026100746-delicate-carless-a04c@gregkh>
References: <20261006130701.120460-1-luka.gejak@linux.dev>
 <20261006130701.120460-6-luka.gejak@linux.dev>
 <3db085e6c3c14545ac9fd4221e0715ed@realtek.com>
 <df4a73de51784e35c15a39e85e4dae9629ba1132@linux.dev>
 <e983dedfeb9341ad9d8cf159656395c6@realtek.com>
 <df8313a72bdef1dc8859a4ac018370b24b606766@linux.dev>
 <d403e88ca53841fba87190764e2a45cc@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d403e88ca53841fba87190764e2a45cc@realtek.com>

On Wed, Oct 07, 2026 at 08:54:03AM +0000, Ping-Ke Shih wrote:
> + Greg to staging rtl8723bs driver question
> 
> Hi Greg,
> 
> Luka Gejak <luka.gejak@linux.dev> wrote:
> > October 7, 2026 at 10:32, "Ping-Ke Shih" <pkshih@realtek.com
> > mailto:pkshih@realtek.com?to=%22Ping-Ke%20Shih%22%20%3Cpkshih%40realtek.com%3E > wrote:
> > 
> > 
> > >
> > > Luka Gejak <luka.gejak@linux.dev> wrote:
> > >
> > > >
> > > > October 7, 2026 at 04:57, "Ping-Ke Shih" <pkshih@realtek.com
> > > >  mailto:pkshih@realtek.com?to=%22Ping-Ke%20Shih%22%20%3Cpkshih%40realtek.com%3E > wrote:
> > > >
> > > >
> > > >
> > > >  Luka Gejak <luka.gejak@linux.dev> wrote:
> > > >
> > > >  >
> > > >  > Add the Realtek RTL8723B 802.11n chip driver: the chip operations, the
> > > >  > power sequences, the efuse layout, the RF and IQ calibration, and the
> > > >  > chip specific coexistence handling.
> > > >  >
> > > >  > The RTL8723B chip support is based on the initial work by
> > > >  > Michael Straube <straube.linux@gmail.com>.
> > > >  > Link: https://github.com/mistraube/rtw88/tree/rtl8723bs
> > > >  >
> > > >  > Co-developed-by: Michael Straube <straube.linux@gmail.com>
> > > >  > Signed-off-by: Michael Straube <straube.linux@gmail.com>
> > > >  > Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
> > > >  > Reviewed-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
> > > >  >
> > > >  Acked-by: Ping-Ke Shih <pkshih@realtek.com>
> > > >
> > > >
> > > >  Hi Ping-Ke,
> > > >
> > > >  Thanks for helping and reviewing the series throughout this
> > > >  upstreaming process. Just one question, when is the series planned to
> > > >  be applied to rtw-next? I am planning to send a patch to staging to
> > > >  remove staging rtl8723bs and I need to have information when is it
> > > >  landing.
> > > >
> > > I'll merge this patchset and send pull-request tomorrow, but I think you
> > > should remove staging rtl8723bs until this patchset drains to upstream.
> > >
> > > Ping-Ke
> > >
> > 
> > Ok. Thanks for information. However, by the time this series reaches
> > upstream, won't the merge window be closed? Therefore 2 drivers for
> > the same chip will exist for one kernel version, and Greg previously
> > said that when a driver is merged we should remove staging so there
> > are no two drivers for the same chip.
> 
> Luka did rewrite RTL8723BS vendor driver (i.e. staging rtl8723bs) into
> upstream rtw88 driver, and I plan to merge this patchset and send
> pull-request to wireless maintainer tomorrow. However, the two drivers
> are existing at this moment. 
> 
> My question is that can Luka send a patch to remove staging rtl8723bs,
> and goes via my tree? Then you don't need to wait for my pull-request
> being upstream. Can it work to you? 

That's fine with me, delete away!

thanks,

greg k-h
