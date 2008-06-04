Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43924
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755714AbYFDPr6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2008 11:47:58 -0400
Date: Wed, 04 Jun 2008 08:47:57 -0700 (PDT)
Message-Id: <20080604.084757.236655460.davem@davemloft.net> (sfid-20080604_174801_830334_128C2AA3)
To: dwmw2@infradead.org
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	kirill@shutemov.name
Subject: Re: [PATCH] wireless.h: improve userland include-ability
From: David Miller <davem@davemloft.net>
In-Reply-To: <1212593172.32207.114.camel@pmac.infradead.org>
References: <1212587529.32207.82.camel@pmac.infradead.org>
	<20080604.080237.66646394.davem@davemloft.net>
	<1212593172.32207.114.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Woodhouse <dwmw2@infradead.org>
Date: Wed, 04 Jun 2008 16:26:12 +0100

> -#ifndef __KERNEL_STRICT_NAMES
> +#if defined(__KERNEL__) || defined(_LOOSE_KERNEL_NAMES)

This reminds me that I noticed recently that unifdef doesn't
handle multiple conditions in an #if test involving
__KERNEL__ properly.  So, for example, for something else
in wireless.h I was working on I had to use:

#ifdef __KERNEL__
#ifdef CONFIG_COMPAT

instead of the more usual:

#if defined(__KERNEL__) && defined(CONFIG_COMPAT)

otherwise I'd get check headers errors during the build.
