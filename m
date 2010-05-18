Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3125 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754188Ab0ERFO5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 May 2010 01:14:57 -0400
Subject: RE: [RFC] Libertas: Added 11d support using cfg80211
From: Dan Williams <dcbw@redhat.com>
To: Kiran Divekar <dkiran@marvell.com>
Cc: "holgerschurig@gmail.com" <holgerschurig@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>
In-Reply-To: <25B60CDC2F704E4E9D88FFD52780CB4C04D62738EA@SC-VEXCH1.marvell.com>
References: <25B60CDC2F704E4E9D88FFD52780CB4C04D62738EA@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 May 2010 22:14:55 -0700
Message-ID: <1274159695.15008.26.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-05-17 at 22:01 -0700, Kiran Divekar wrote:
> > On Thu, 2010-05-13 at 04:00 -0700, Kiran Divekar wrote:
> > > Added 11d support for libertas driver using cfg80211. This is based on
> > Holger Shurig's initial work to add cfg80211 support libertas.
> > > (https://patchwork.kernel.org/patch/64286/)
> > >
> > > Please let us know, if there are any improvements comments.
> > >
> > > Code is added to send 11d enable command to firmware while
> > > initialisation and pass 11d specific information to firmware
> > > when notifier handler is called by cfg80211.
> > 
> > Looks OK, though I'd prefer making 11D_DOMAIN_INFO a direct command
> > instead.  But if you don't want to do that right now, that's fine, just
> > send the final patch and I'll ack it.
> 
> 
> Hi Dan, Holger,
>   This patch is based on Holger's work to add cfg80211 support to libertas. We have tested original patch by rebasing to latest wireless-testing tree. We will send the re-based patch as well as this patch again.

Sounds good.  Lets get the cfg80211 stuff in then I guess.

Dan

> Please let us know, if there are any other thoughts.
> 
> Thanks,
> - Kiran
> 
> 
> 
> > Acked-by: Dan Williams <dcbw@redhat.com>
> > 
> > > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> > > Signed-off-by: Kiran Divekar <dkiran@marvell.com>
> > > ---
> > >  drivers/net/wireless/libertas/cfg.c     |  110
> > +++++++++++++++++++++++++++++++
> > >  drivers/net/wireless/libertas/cfg.h     |    5 ++
> > >  drivers/net/wireless/libertas/cmd.c     |   65 ++++++++++++++++++
> > >  drivers/net/wireless/libertas/cmdresp.c |   50 ++++++++++++++
> > >  drivers/net/wireless/libertas/decl.h    |    5 ++
> > >  drivers/net/wireless/libertas/dev.h     |    3 +
> > >  drivers/net/wireless/libertas/host.h    |   28 ++++++++-
> > >  drivers/net/wireless/libertas/main.c    |    3 +
> > >  8 files changed, 268 insertions(+), 1 deletions(-)
> > >


