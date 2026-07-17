Received: from elvis.franken.de (elvis.franken.de [193.175.24.41])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF1AB3E51E4;
	Fri, 17 Jul 2026 11:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.175.24.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784286317; cv=none; b=tdVf6vTxn44nxrJdeObBgwMDKujzRN/ZqdZLmabBxEgGepQ86hRsAtAWbNabN8daEAYEfyWzpmmKjpuDAirAME+k8sfEY5/teq70cnYTCDpUJvtA7DHaMthZOpof2YEIAt5lwrof2oXk8WH8n+bU49O02hAwCiNSWOBlHf5mSv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784286317; c=relaxed/simple;
	bh=E3zagQ1VPPHx9utwGBl41PFwkcodmwi72CHGYgkk19c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s5s3UjQgoG3erKgnwFNrRoX5NGDAqNLtmjRgBwbRmuuJ7Sq9QNMVadK5YfaDq4cX/pxl+ycA2zIXYtFFfXzo9lafgo5KDuv+uxMlrm/R2AlkoJs2UthyhTRk/coZ6i3i+lY5/ZsS5uGHFVsSMNIoSQ0ifxCdesfCnT9PndUQPWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alpha.franken.de; spf=pass smtp.mailfrom=alpha.franken.de; arc=none smtp.client-ip=193.175.24.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=alpha.franken.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alpha.franken.de
Received: from uucp by elvis.franken.de with local-rmail (Exim 3.36 #1)
	id 1wkgNH-0007DR-00; Fri, 17 Jul 2026 13:04:59 +0200
Received: by alpha.franken.de (Postfix, from userid 1000)
	id E4FEDC00E8; Fri, 17 Jul 2026 13:00:57 +0200 (CEST)
Date: Fri, 17 Jul 2026 13:00:57 +0200
From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Michael Buesch <m@bues.ch>, Hauke Mehrtens <hauke@hauke-m.de>,
	Bartosz Golaszewski <brgl@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: Re: [PATCH v2 0/3] MIPS: BCM47XX: convert buttons to software nodes
Message-ID: <aloLacyVuBqP-5TT@alpha.franken.de>
References: <20260713-b4-bcm47xx-swnode-v2-0-2b879f0c193c@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713-b4-bcm47xx-swnode-v2-0-2b879f0c193c@gmail.com>

On Mon, Jul 13, 2026 at 02:58:21PM -0700, Dmitry Torokhov wrote:
> This series converts the legacy gpio-keys platform device on BCM47XX
> boards to use software nodes and static properties.
> 
> To do this properly without relying on legacy name-based matching
> (which is being removed from gpiolib), we introduce and register
> software nodes for the underlying GPIO controllers (BCMA and SSB)
> and reference them in the button properties.
> 
> The first two patches add the software nodes to bcma-gpio and
> ssb-gpio respectively. The third patch performs the conversion
> for the BCM47XX buttons.
> 
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
> As Johannes mentioned on v1 this best should go through MIPS tree.
> 
> Changes in v2:
> - Restrict software node registration to host SoC devices in both ssb
>   and bcma drivers to avoid conflicts when secondary buses (e.g. PCI
>   wireless cards) are present
> - Fix dangling pointer panic in buttons driver by allocating software
>   node references on the heap instead of stack
> - Link to v1: https://patch.msgid.link/20260704-b4-bcm47xx-swnode-v1-0-730d59340237@gmail.com
> 
> ---
> Dmitry Torokhov (3):
>       bcma: gpio: Add and register software node for GPIO controller
>       ssb: gpio: Add and register software node for GPIO controller
>       MIPS: BCM47XX: Convert buttons to software nodes
> 
>  arch/mips/bcm47xx/buttons.c | 442 +++++++++++++++++++++++++-------------------

series applied to mips-next

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessarily a
good idea.                                                [ RFC1925, 2.3 ]
