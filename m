Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07722ECEBC;
	Mon,  2 Feb 2026 20:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.67.10.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770064155; cv=none; b=WSYU4oGuRGn11iGYPlD9ftT/VIHPAEO1Z7bvQHABoI57ZjtZRK3xrDLnKc2QUikNd/bd8cPyJiUc7c7Z8k5dUAcdVPGfzmNKMTbLhB0jcBB590ZUkQBqHlGLou0dmqV2EiURgiZSEQYWv4pIteJP9Z6Ey6fxArQWf4xAFTcL5W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770064155; c=relaxed/simple;
	bh=wndgnXwC+3NQLCSYu73XT7gvmQ7XHvuQXoXMLyUwj+w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yg6DcITCnzGU90fG2d0ZvOoloIW/eWwXZId7AmqPTOyhRWw9zbTYRN8UzO+PPKbJRekh+DNgQ46eBevuq0Z5rSKJROc6VK35OxsYpX8nQ1LQw9ZZEE+I/MHcAzoBTuQl3NwUSTboTDigT4nIDe5aOEeTtap08W+ppfZpP81w9aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch; spf=pass smtp.mailfrom=lunn.ch; dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b=mHmTPRmR; arc=none smtp.client-ip=156.67.10.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lunn.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lunn.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lunn.ch header.i=@lunn.ch header.b="mHmTPRmR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=ci2PbKa2nNxEDukBqxUSNkI6L2yFMqmuuqGwITavS34=; b=mHmTPRmR6gmpO21VjfHb31nk37
	TvjHbls/wIHtHdk5SD6SZrTEyhLOwjAURyDHK22R8gM/D8LAMf1SHdFPqdMINb7Dq0t70KKywR+En
	nDUyPTKsQJPZSnPcKlWgwi+KJV2mo+yL9iZ61h+uHH+l95M5ieD+/fShkns0YjA3DPrI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1vn0Xj-005roo-SG; Mon, 02 Feb 2026 21:29:07 +0100
Date: Mon, 2 Feb 2026 21:29:07 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Cc: netdev@vger.kernel.org, linux-can@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Vincent Mailhol <mailhol@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>,
	Sridhar Samudrala <sridhar.samudrala@intel.com>,
	Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Thomas =?iso-8859-1?Q?M=FChlbacher?= <tmuehlbacher@posteo.net>,
	Oliver Hartkopp <socketcan@hartkopp.net>
Subject: Re: [PATCH net-next] net: remove unnecessary module_init/exit
 functions
Message-ID: <66924451-2b19-4a3b-ba99-16437dc79011@lunn.ch>
References: <20260131004327.18112-1-enelsonmoore@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260131004327.18112-1-enelsonmoore@gmail.com>

On Fri, Jan 30, 2026 at 04:42:56PM -0800, Ethan Nelson-Moore wrote:
> Many network drivers have unnecessary empty module_init and module_exit
> functions. Remove them (including some that just print a message). Note
> that if a module_init function exists, a module_exit function must also
> exist; otherwise, the module cannot be unloaded.

I could be missing it, but which module does not have an module_exit
function?

I ask, because maybe the author does not want to allow the module to
be unloaded. We should look at the history of that module.

   Andrew
