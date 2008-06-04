Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41972 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712AbYFDPug (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2008 11:50:36 -0400
Subject: Re: [PATCH] wireless.h: improve userland include-ability
From: David Woodhouse <dwmw2@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	kirill@shutemov.name
In-Reply-To: <20080604.084757.236655460.davem@davemloft.net>
References: <1212587529.32207.82.camel@pmac.infradead.org>
	 <20080604.080237.66646394.davem@davemloft.net>
	 <1212593172.32207.114.camel@pmac.infradead.org>
	 <20080604.084757.236655460.davem@davemloft.net>
Content-Type: text/plain
Date: Wed, 04 Jun 2008 16:50:32 +0100
Message-Id: <1212594632.32207.122.camel@pmac.infradead.org> (sfid-20080604_175039_574191_A0AF1284)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-06-04 at 08:47 -0700, David Miller wrote:
> From: David Woodhouse <dwmw2@infradead.org>
> Date: Wed, 04 Jun 2008 16:26:12 +0100
> 
> > -#ifndef __KERNEL_STRICT_NAMES
> > +#if defined(__KERNEL__) || defined(_LOOSE_KERNEL_NAMES)
> 
> This reminds me that I noticed recently that unifdef doesn't
> handle multiple conditions in an #if test involving
> __KERNEL__ properly.  So, for example, for something else
> in wireless.h I was working on I had to use:
> 
> #ifdef __KERNEL__
> #ifdef CONFIG_COMPAT
> 
> instead of the more usual:
> 
> #if defined(__KERNEL__) && defined(CONFIG_COMPAT)
> 
> otherwise I'd get check headers errors during the build.

Yeah; that's one of the main reasons it hasn't been done yet.

-- 
dwmw2

