Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:54886 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751188AbXLIWKd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Dec 2007 17:10:33 -0500
Date: Sun, 9 Dec 2007 23:06:52 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Chris Rankin <rankincj@yahoo.com>
Cc: Dan Williams <dcbw@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [2.6.23.9] hostap_plx locks up PC when reading PCI I/O memory
Message-ID: <20071209230652.7156fe17@morte> (sfid-20071209_221036_827776_D4747045)
In-Reply-To: <587622.50680.qm@web52902.mail.re2.yahoo.com>
References: <1193657365.19938.17.camel@localhost.localdomain>
	<587622.50680.qm@web52902.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 9 Dec 2007 19:41:58 +0000 (GMT)
Chris Rankin <rankincj@yahoo.com> wrote:

> Hi,
> 
> I've recently been having trouble loading the hostap_plx 802.11b wireless
> networking driver, and this evening I managed to narrow the problem down
> to these lines of code by copying code from hostap_plx into a "test
> driver" until the test driver also locked the PC up:
> 
>         /* read CIS; it is in even offsets in the beginning of attr_mem */
>         for (i = 0; i < CIS_MAX_LEN; i++)
>                 cis[i] = readb(attr_mem + 2 * i);

Not a fix, but if you load the module with ignore_cis = 1, it should work.


-- 
Ciao
Stefano
