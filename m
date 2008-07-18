Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:55511 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754572AbYGRXto (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2008 19:49:44 -0400
Date: Fri, 18 Jul 2008 19:38:58 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: Pavel Roskin <proski@gnu.org>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH v2] ath5k: don't enable MSI, we cannot handle it yet
Message-ID: <20080718233858.GB13390@phobos.i.cabal.ca> (sfid-20080719_014948_677990_796E80E5)
References: <20080718162855.22182.97573.stgit@dv.roinet.com> <1216399487.18320.16.camel@dv> <200807181849.25320.mb@bu3sch.de> <1216400219.18320.26.camel@dv> <40f31dec0807181057y65738617m8bcfa9c6c9f71671@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <40f31dec0807181057y65738617m8bcfa9c6c9f71671@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 18, 2008 at 08:57:39PM +0300, Nick Kossifidis wrote:
> > MSI is a nice thing, but we cannot enable it without changing the
> > interrupt handler.  If we do it, we break MSI capable hardware,
> > specifically AR5006 chipset.
> >
> > Signed-off-by: Pavel Roskin <proski@gnu.org>
> 
> This is needed for all pci-e devices since enabling msi results no interrupts...
> 
> Acked-by: Nick Kossifidis <mickflemm@gmail.com>
> 

This is likely caused by a bug being discussed on linux-pci right now.
Basically the way we're masking MSI can result in INTn interrupts
getting turned back on, with no handler attached.

http://marc.info/?t=121430463700001&r=1&w=2

regards, Kyle
