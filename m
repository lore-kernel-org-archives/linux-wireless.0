Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.182]:17321 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758614AbYJ3SPo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 14:15:44 -0400
Received: by ik-out-1112.google.com with SMTP id c29so588386ika.5
        for <linux-wireless@vger.kernel.org>; Thu, 30 Oct 2008 11:15:35 -0700 (PDT)
Message-ID: <4909F9BC.3050306@gmail.com> (sfid-20081030_191554_787086_E4F060E0)
Date: Thu, 30 Oct 2008 18:15:24 +0000
MIME-Version: 1.0
To: Dave <kilroyd@googlemail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	linux-pcmcia@lists.infradead.org,
	orinoco-devel@lists.sourceforge.net,
	linux-wireless@vger.kernel.org,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: [Orinoco-devel] 2.6.28-rc2: new PCMCIA device instance after
 resume - orinoco can't download firmware
References: <200810282219.51492.arvidjaar@mail.ru> <200810291819.20848.arvidjaar@mail.ru> <4908B03C.400@gmail.com> <200810292143.06027.rjw@sisk.pl> <4908CD44.8070503@gmail.com> <20081029215142.GA29780@flint.arm.linux.org.uk>
In-Reply-To: <20081029215142.GA29780@flint.arm.linux.org.uk>
Content-Type: text/plain; charset=us-ascii
From: Dave <kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Russell King wrote:
> On Wed, Oct 29, 2008 at 08:53:24PM +0000, Dave wrote:
>> Looking at the pcmcia code it looks like ds_event is getting a
>> CS_EVENT_CARD_INSERTION event. Should we be processing that event ?
> 
> You can get that on resume if PCMCIA thinks the card has changed -
> and it determines that by comparing its cache of the CIS with what
> is in the card on resume.  If the cache doesn't match the CIS, it
> assumes the card has changed, and does a remove-insert cycle instead
> of resume.
> 
> So the question to ask is: why is the card's CIS changing on resume?
> 
> Try putting some debug in verify_cis_cache() in drivers/pcmcia/cistpl.c.

After much faffing about, I managed to bisect this. In retrospect the
above hint (thanks Russell) and a code inspection ought to have made the
bug obvious. The offending commit is:

commit 1168386aa7d850ead2ae135d5a7949a592c6e9a0
pcmcia: deprecate CS_OUT_OF_RESOURCE

in which the following change is made (among others):

@@ -352,7 +352,9 @@ int verify_cis_cache(struct pcmcia_socket *s)

        buf = kmalloc(256, GFP_KERNEL);
        if (buf == NULL)
-               return -1;
+               dev_printk(KERN_WARNING, &s->dev,
+                          "no memory for verifying CIS\n");
+               return -ENOMEM;
        list_for_each_entry(cis, &s->cis_cache, node) {
                int len = cis->len;


The attached patch should fix things.

Regards,

Dave.
---
pcmcia: Actually verify against the cached CIS

Commit 1168386aa7d850ead2ae135d5a7949a592c6e9a0 introduced a printk into
a single line if without adding braces, resulting in PCMCIA devices
being added as new on resume.

Add the necessary braces.

Reported by: Andrey Borzenkov <arvidjaar@mail.ru>
Signed-off by: David Kilroy <kilroyd@gmail.com>
---
diff --git a/drivers/pcmcia/cistpl.c b/drivers/pcmcia/cistpl.c
index 8d37768..91a00ec 100644
--- a/drivers/pcmcia/cistpl.c
+++ b/drivers/pcmcia/cistpl.c
@@ -351,10 +351,12 @@ int verify_cis_cache(struct pcmcia_socket *s)
        char *buf;

        buf = kmalloc(256, GFP_KERNEL);
-       if (buf == NULL)
+       if (buf == NULL) {
                dev_printk(KERN_WARNING, &s->dev,
                           "no memory for verifying CIS\n");
                return -ENOMEM;
+       }
+
        list_for_each_entry(cis, &s->cis_cache, node) {
                int len = cis->len;



