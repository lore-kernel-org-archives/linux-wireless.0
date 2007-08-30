Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.230]:65361 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758808AbXH3UUZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2007 16:20:25 -0400
Received: by wx-out-0506.google.com with SMTP id h31so589942wxd
        for <linux-wireless@vger.kernel.org>; Thu, 30 Aug 2007 13:20:24 -0700 (PDT)
Message-ID: <9a8748490708301320o49d8e794vc5c37ffc938006f1@mail.gmail.com>
Date: Thu, 30 Aug 2007 22:20:23 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Daniel Drake" <dsd@gentoo.org>
Subject: Re: [PATCH 13/30] net: Don't do pointless kmalloc return value casts in zd1211 driver
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
	netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	"Ulrich Kunitz" <kune@deine-taler.de>,
	linux-wireless@vger.kernel.org
In-Reply-To: <46D70467.1040109@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1554af80879a7ef2f78a4d654f23c248203500d9.1187912217.git.jesper.juhl@gmail.com>
	 <d551047daed1cb4d9de1eff956268a468c9837f6.1187912217.git.jesper.juhl@gmail.com>
	 <46D70467.1040109@gentoo.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 30/08/2007, Daniel Drake <dsd@gentoo.org> wrote:
> Jesper Juhl wrote:
> > Since kmalloc() returns a void pointer there is no reason to cast
> > its return value.
> > This patch also removes a pointless initialization of a variable.
>
> NAK: adds a sparse warning
> zd_chip.c:116:15: warning: implicit cast to nocast type
>
Ok, I must admit I didn't check with sparse since it seemed pointless
- we usually never cast void pointers to other pointer types,
specifically because the C language nicely guarantees that the right
thing will happen without the cast.  Sometimes we have to cast them to
integer types, su sure we need the cast there.   But what on earth
makes a "zd_addr_t *" so special that we have to explicitly cast a
"void *" to that type?

I see it's defined as
  typedef u32 __nocast zd_addr_t;
in drivers/net/wireless/zd1211rw/zd_types.h , but why the __nocast ?

What would be wrong in applying my patch that removes the cast of the
kmalloc() return value and then also remove the "__nocast" here?


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
