Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web52904.mail.re2.yahoo.com ([206.190.49.14]:34912 "HELO
	web52904.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754469AbXLJDU2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Dec 2007 22:20:28 -0500
Date: Mon, 10 Dec 2007 03:20:26 +0000 (GMT)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: [2.6.23.9] hostap_plx locks up PC when reading PCI I/O memory
To: Arjan van de Ven <arjan@infradead.org>
Cc: Dan Williams <dcbw@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <20071209143237.1e608d9f@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Message-ID: <39522.31806.qm@web52904.mail.re2.yahoo.com> (sfid-20071210_032055_607058_6B94952B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- Arjan van de Ven <arjan@infradead.org> wrote:
> the memory you feed to readl() and co isnt the actual PCI resource;
> you need to use ioremap() on the PCI resource to get a pointer that you can then feed to
> readl()....

I gathered that much, and there is indeed a call to ioremap() in the code. So are you suggesting
that  I try replacing that ioremap() call with ioremap_nocache()?

Cheers,
Chris


      ___________________________________________________________
Support the World Aids Awareness campaign this month with Yahoo! For Good http://uk.promotions.yahoo.com/forgood/
