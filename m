Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:29904 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780Ab1JJRsE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 13:48:04 -0400
Date: Mon, 10 Oct 2011 20:45:06 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Franky Lin <frankyl@broadcom.com>, devel@linuxdriverproject.org,
	gregkh@suse.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 04/20] staging: brcm80211: various __iomem additions to
 softmac.
Message-ID: <20111010174506.GA18470@longonot.mountain> (sfid-20111010_194808_535681_4D91A69D)
References: <1317575685-3156-1-git-send-email-frankyl@broadcom.com>
 <1317575685-3156-5-git-send-email-frankyl@broadcom.com>
 <CACna6rzFQZqed3ZfRxcd_WCvOsjKgeDd=T8EgtgpJttmTO3+cg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CACna6rzFQZqed3ZfRxcd_WCvOsjKgeDd=T8EgtgpJttmTO3+cg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 10, 2011 at 04:23:28PM +0200, Rafał Miłecki wrote:
> > -#define CCREGS_FAST(si) (((char *)((si)->curmap) + PCI_16KB0_CCREGS_OFFSET))
> > +#define CCREGS_FAST(si) (((char __iomem *)((si)->curmap) + \
> > +                         PCI_16KB0_CCREGS_OFFSET))
> 
> I've a question (not to just you), should we prefer u8/u16/u32 types in code?
> If so, you could think to changing this since you already touch this code.
> 

The char is just so that the addition works, the caller will have to
cast it again.  It's up to the author to decide.

If you're going to be doing bitwise operations then you can run into
signedness bugs using char.

	printf("0x%x\n", (int) 0 | (char) -1);       /* 0xffffffff */
	printf("0x%x\n", (int) 0 | (unsigned char) -1);    /* 0xff */

Also if you are going to save hex digits to it, then it should be u8.
You occasionally see bugs like this:

	char x = 0xff;

	if (x == 0xff)
		printf("dead code here.\n");
	else
		printf("signed chars only reach up to 0x7f\n");

regards,
dan carpenter
