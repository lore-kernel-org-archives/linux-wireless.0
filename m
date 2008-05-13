Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3091 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756317AbYEMA7I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2008 20:59:08 -0400
Date: Mon, 12 May 2008 20:43:45 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Pavel Roskin <proski@gnu.org>
Cc: Mathieu Chouquet-Stringer <mchouque@free.fr>, j@w1.fi,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] hostap: procfs fix for hostap_fw.c
Message-ID: <20080513004345.GB26418@tuxdriver.com> (sfid-20080513_025912_485418_7BA72B57)
References: <20080506152354.GA3680@mobydick> <1210592626.3372.6.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1210592626.3372.6.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 12, 2008 at 07:43:46AM -0400, Pavel Roskin wrote:
> On Tue, 2008-05-06 at 17:23 +0200, Mathieu Chouquet-Stringer wrote:
> 
> > Problem is local->proc has now been overwritten by hostap_init_proc
> > meaning "registers" isn't removed.  When you reload the module you get
> > an error telling you "registers" already exists (and you then get
> > duplicate "registers" files in /proc).
> 
> I've seen it many times.  Thanks for tracking it down!  I've tested the
> patch with PCI and PCMCIA devices, and everything appears to be
> correct.  /proc/registers is not created, "registers" is created
> under /proc/net/hostap/wlan0/, no more warnings.
> 
> > Signed-off-by: Mathieu Chouquet-Stringer <mchouque@free.fr>
> 
> Acked-off-by: Pavel Roskin <proski@gnu.org>
> 
> If a more concise description needs to be written, I can do it.

If you don't mind, I would appreciate a more concise description.
I appreciate the full description of the bug, but I think it is a
bit much for the changelog as-is.

Thanks!

John
-- 
John W. Linville
linville@tuxdriver.com
