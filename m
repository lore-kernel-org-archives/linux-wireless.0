Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relais.videotron.ca ([24.201.245.36]:57738 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761562Ab0HFQxt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Aug 2010 12:53:49 -0400
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Fri, 06 Aug 2010 12:53:47 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Ohad Ben-Cohen <ohad@wizery.com>,
	Linus Walleij <linus.ml.walleij@gmail.com>,
	Vitaly Wool <vitalywool@gmail.com>,
	Kalle Valo <kalle.valo@iki.fi>,
	Pandita Vikram <vikram.pandita@ti.com>,
	Tony Lindgren <tony@atomide.com>,
	linux-wireless@vger.kernel.org,
	Roger Quadros <roger.quadros@nokia.com>,
	linux-mmc@vger.kernel.org, San Mehat <san@google.com>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	Luciano Coelho <luciano.coelho@nokia.com>,
	linux-omap@vger.kernel.org, akpm@linux-foundation.org,
	linux-arm-kernel@lists.infradead.org, Ido Yariv <ido@wizery.com>
Subject: Re: [PATCH v2 03/20] mmc: support embedded data field in mmc_host
In-reply-to: <20100806144605.GA21015@n2100.arm.linux.org.uk>
Message-id: <alpine.LFD.2.00.1008061251040.28809@xanadu.home>
References: <AANLkTi=BUX59heXAW2Uf4wZo2dSS19Je54dkQ5u2YGAW@mail.gmail.com>
 <AANLkTimZQKj7H_GeE=+O9cwxEMTR+LhfFbt=AyXGzN3d@mail.gmail.com>
 <AANLkTikfRja-h9mz7uyRXCZNZjKdU_yB8e58XQucUzrn@mail.gmail.com>
 <AANLkTi=vhWV1RNyemtfppfjvLYAbzd3aRjFOVgLLpG3Z@mail.gmail.com>
 <AANLkTin4m8gJR50zwMB2b0jRMHdNA6CQToKBTAhOL9wF@mail.gmail.com>
 <AANLkTinu2S19r8fueM-jVkc35XL2G0Z16BddE92Ci9KB@mail.gmail.com>
 <20100804114147.GB6852@n2100.arm.linux.org.uk>
 <AANLkTi=Dqs_qg=BsoNBTjvJbG+ub+zMv8ctbrJSGPJJJ@mail.gmail.com>
 <AANLkTimrb5P9cVo30y_udoi4+vu3cM4YzfpDaYCfwGEA@mail.gmail.com>
 <AANLkTim6Yuor4CAEmQPs3zPVz1svEbckzO0HHeFWGmjy@mail.gmail.com>
 <20100806144605.GA21015@n2100.arm.linux.org.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 6 Aug 2010, Russell King - ARM Linux wrote:

> On Fri, Aug 06, 2010 at 01:02:24PM +0300, Ohad Ben-Cohen wrote:
> > We have Russell's suggestion which is nice and simple, but it has the
> > 1 device limitation.
> 
> You could make it generic by doing something like this:
> 
> #define set_device_data(name, type, index, data)			\
>  ({									\
>     extern void __set_device_data(const char *, int, void *, size_t);	\
>     BUILD_BUG_ON(!__same_type(type, *data));				\
>     __set_device_data(name ":" #type, index, data, sizeof(type));	\
>  })
> 
> #define get_device_data(name, type, index) ({				\
>   extern void *__get_device_data(const char *, int);			\
>   type *__ptr = __get_device_data(name ":" #type, index);		\
>   __ptr; })
> 
> And now we have something that takes a string and index to use as a lookup
> key in some kind of list - and it's typesafe (because the lookup key is
> dependent on the stringified type.)
> 
> But... at this point I feel that we're getting too complicated, and will
> get shouted at to use something like DT which already solves this problem.

DT is not generally available yet.  A simple interim solution would 
still be worth it.


Nicolas
