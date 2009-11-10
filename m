Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18003 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017AbZKJGdN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2009 01:33:13 -0500
Subject: Re: [PATCH 50/75] libertas: declare MODULE_FIRMWARE
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <holgerschurig@googlemail.com>
Cc: Ben Hutchings <ben@decadent.org.uk>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	libertas-dev@lists.infradead.org
In-Reply-To: <m37hu09l4h.wl%holgerschurig@gmail.com>
References: <1257631203.15927.462.camel@localhost>
	 <m37hu09l4h.wl%holgerschurig@gmail.com>
Content-Type: text/plain
Date: Mon, 09 Nov 2009 22:32:54 -0800
Message-Id: <1257834774.15493.34.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-11-09 at 09:07 +0100, Holger Schurig wrote:
> At Sat, 07 Nov 2009 22:00:03 +0000,
> Ben Hutchings wrote:
> > diff --git a/drivers/net/wireless/libertas/if_cs.c b/drivers/net/wireless/libertas/if_cs.c
> > index 9127d2a..9834e3f 100644
> > --- a/drivers/net/wireless/libertas/if_cs.c
> > +++ b/drivers/net/wireless/libertas/if_cs.c
> > @@ -48,6 +48,7 @@
> >  MODULE_AUTHOR("Holger Schurig <hs4233@mail.mn-solutions.de>");
> >  MODULE_DESCRIPTION("Driver for Marvell 83xx compact flash WLAN cards");
> >  MODULE_LICENSE("GPL");
> > +MODULE_FIRMWARE("libertas_cs_helper.fw");
> 
> Do you intentionally only define specify the helper firmware? The
> device won't be working without loading "libertas_cs.fw" as well.
> 
> Do you have any pointer for me to what MDOULE_FIRMWARE does?  What
> user-space tool does it it for what purpose?

It's nice information to know from 'modinfo' or other uses so that we
might be able to find the firmware automatically.  Right now actually
PackageKit will figure out  missing firmware from udev when udev can't
find the right firmware, but having it in 'modinfo' is useful too.

Honestly I think we should actually reorganize the firmware and put it
in /lib/firmware/libertas or something.

Dan


