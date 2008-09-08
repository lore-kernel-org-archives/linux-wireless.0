Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:58789 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750986AbYIHQwG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 12:52:06 -0400
Date: Mon, 8 Sep 2008 09:45:45 -0700
To: Pavel Roskin <proski@gnu.org>
Cc: Dan Williams <dcbw@redhat.com>, kilroyd@googlemail.com,
	linux-wireless@vger.kernel.org,
	orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@gmail.com>
Subject: Re: [PATCH 01/19] orinoco: Add ESSID specific scanning for Agere fw
Message-ID: <20080908164545.GB5090@bougret.hpl.hp.com> (sfid-20080908_185210_679695_A57531F4)
Reply-To: jt@hpl.hp.com
References: <1217672073-7094-1-git-send-email-kilroyd@gmail.com> <1217672073-7094-2-git-send-email-kilroyd@gmail.com> <1217825304.10989.20.camel@dv> <1217864060.3139.10.camel@localhost.localdomain> <20080805162238.GA6294@bougret.hpl.hp.com> <20080902230621.GA28885@bougret.hpl.hp.com> <1220878110.2369.3.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1220878110.2369.3.camel@dv>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 08, 2008 at 08:48:30AM -0400, Pavel Roskin wrote:
> On Tue, 2008-09-02 at 16:06 -0700, Jean Tourrilhes wrote:
> 
> > 	By the way, the breakage of iwlist scan in Wireless Tools 30
> > on 64 bits should be fixed in 30.pre7.
> 
> No, it's still not fixed on x86_64.

	I was talking about the other breakages you were
seeing. Anyway.

>  scanflags in print_scanning_info()
> in iwlist.c is 2, but srq->flags is 0 in orinoco_ioctl_setscan() in
> orinoco.c.
> 
> On i386,  srq->flags is 2 as expected and the scan results are correctly
> influenced by the ESSID.

	Hmm... My gut reaction would be that fs/compat_ioctl.c would
be wrong, but it seems to have the proper define. I'll try to check.

> Regards,
> Pavel Roskin

	Thanks...

	Jean
