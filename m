Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:48489 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757538Ab2CFVra convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 16:47:30 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFxdnfGREML3u+eoGf89Jci8qBuW7WBmPk3w=wRWMvRvfg@mail.gmail.com>
References: <20120228010511.GA8453@kroah.com> <20120228010434.412979550@linuxfoundation.org>
 <87hay4dqjr.fsf@turtle.gmx.de> <201203050143.24541.s.L-H@gmx.de>
 <CA+55aFxZsVxkxifR+EUZi=RsUGKfs5vYXX3nN_M_Az1BY5yyaw@mail.gmail.com>
 <alpine.LFD.2.02.1203060927190.2742@ionos> <alpine.LFD.2.02.1203060957140.2742@ionos>
 <alpine.LFD.2.02.1203062019340.2742@ionos> <8762eh1p7d.fsf@turtle.gmx.de>
 <alpine.LFD.2.02.1203062101040.2742@ionos> <CA+55aFxdnfGREML3u+eoGf89Jci8qBuW7WBmPk3w=wRWMvRvfg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 6 Mar 2012 13:47:09 -0800
Message-ID: <CA+55aFzqF0C1eiidR=ycJ0DhV3MiWJRkOmi-GEcgT7J6Dm+a5g@mail.gmail.com> (sfid-20120306_224736_753588_F68D31FE)
Subject: Re: [ 57/72] genirq: Unmask oneshot irqs when thread was not woken
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Sven Joachim <svenjoac@gmx.de>,
	Stefan Lippers-Hollmann <s.L-H@gmx.de>,
	Greg KH <gregkh@linuxfoundation.org>,
	LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Jonathan Nieder <jrnieder@gmail.com>,
	linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 6, 2012 at 1:40 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> (*) "1 << ffz(a)" can be written as
>
>   a = ~a;        /* Turn the zero bits into 1 bits */
>   a &= -a;      /* .. and find the first one. */
>
> without ever doing any insane bit scanning.

Alternatively, wite it directly as "(a+1) &~a", which is the same
expression just written differently (due to "-a == ~a+1")

Yeah, I've been playing too much with the bitwise optimizations of the
dentry cache name comparisons lately.

                   Linus
