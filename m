Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3637175A79;
	Tue, 11 Aug 2026 02:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786415683; cv=none; b=as82wwAYAjBDfGIY3fttDmD5EqvNwRBfMlXet4OKiKeNKoNJ8uxlbGx0Kxb/YUE9Gq15F6Mf++rqQROFeoC5wjvd3vMIWpxg1PVXMRFKYJ8DctM0HOnmWnqV06BjHp/AZrLlJLup+FlwDOKmFZ/fO8x/bJ2pCd3uTHSsohE+JAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786415683; c=relaxed/simple;
	bh=aWyV2FnHDJavuYErbHaMuaIa/tiySy+8YqclFmp54U4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OA/pP4xGWoaUp1/DFja1FYZ/dLYxJ5q9gY9XvmYGqwQLVz3T9PRO+bG4m0nf4c5CD4MBcWkcvLpXyNyLd4cS50MpWBpWMTghqinIcCM7bTMJ+/WzwkmRPaYuX4wt6UqoJ+6fBB9oEKcvORu5vc/cbObkIOa4daNEARqhVGfvvbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NO75fREq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NO75fREq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1DFD1F000E9;
	Tue, 11 Aug 2026 02:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786415682;
	bh=kuVD3KhiNgnMsMP2P5VGmm14tXhx+bv0yRgM/9OQHk8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NO75fREq6bkOZ3evraLjlrjJ+E6VzSjMSKVJPmafTg7FqcTD93c2KW1ITOv2JJEgz
	 JnqzSVItFt6YfFZBvpmMYP5BV3o5oBa7yjT5hNSP0pjMrn0+3jLpNf8840/dxHUrbu
	 4rGzmpKcZ5K2zK7pk3kw6iADoM8Ae4Ocerv6A2vE=
Date: Tue, 11 Aug 2026 11:33:10 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Daniel Golle <daniel@makrotopia.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>, driver-core@lists.linux.dev,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
	Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	linux-wireless@vger.kernel.org,
	Marcel Holtmann <marcel@holtmann.org>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	linux-bluetooth@vger.kernel.org,
	Hans de Goede <johannes.goede@oss.qualcomm.com>
Subject: Re: [RFC PATCH 0/4] device_schedule_reprobe(): core helper and
 conversions
Message-ID: <2026081139-strenuous-greasily-f4e5@gregkh>
References: <anpxFdwNxk0XwPjQ@makrotopia.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anpxFdwNxk0XwPjQ@makrotopia.org>

On Tue, Aug 11, 2026 at 01:47:17AM +0100, Daniel Golle wrote:
> Three in-tree drivers (iwlwifi, hci_h5, btintel_pcie) schedule a
> deferred re-probe of their own device from a work item in module
> text.

That's a mess, why?  Why not fix that up to not do that?  Thousands of
other kernel drivers do not do that, what makes these so special?

> The hand-rolled copies share two bug classes: the work function
> ends with module_put(THIS_MODULE),

That's broken as-is.  a module should NEVER be calling
module_get(THIS_MODULE) either.

> racing a concurrent rmmod freeing
> the module text (the race module_put_and_kthread_exit() exists to
> close for kthreads), and nothing synchronizes the deferred detach
> against device_shutdown() or an administrative unbind.

yeah, that's a mess, don't do that.

Fix up the original drivers please, let's not encourage others to copy
this broken scheme.

Also, your patches were not threaded properly :(

thanks,

greg k-h
