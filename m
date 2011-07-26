Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:4294 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753532Ab1GZQeE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jul 2011 12:34:04 -0400
Subject: Re: [PATCH 13/29] staging: brcm80211: revisited END_FOREACH_BSS
 macro
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <error27@gmail.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	devel@linuxdriverproject.org, gregkh@suse.de,
	linux-wireless@vger.kernel.org
In-Reply-To: <20110726082658.GD3824@shale.localdomain>
References: <1311361036-3175-1-git-send-email-arend@broadcom.com>
	 <1311361036-3175-14-git-send-email-arend@broadcom.com>
	 <20110726082658.GD3824@shale.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Jul 2011 09:34:01 -0700
Message-ID: <1311698041.15386.5.camel@Joe-Laptop> (sfid-20110726_183409_146007_80C9E1B9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-07-26 at 11:26 +0300, Dan Carpenter wrote: 
> On Fri, Jul 22, 2011 at 08:57:00PM +0200, Arend van Spriel wrote:
> > @@ -3345,7 +3345,7 @@ void brcms_c_init(struct brcms_c_info *wlc)
> >  	FOREACH_BSS(wlc, i, bsscfg)
> >  		brcms_c_set_mac(bsscfg);
> >  		brcms_c_set_bssid(bsscfg);
> > -	END_FOREACH_BSS
> > +	END_FOREACH_BSS()
> These would look nicer with a semicolon on the end.
> 	END_FOREACH_BSS();
> That looks like c.
> I quite liked my way with the extra { } chars.
> 	FOREACH_BSS(wlc, i, bsscfg) {
> 		brcms_c_set_mac(bsscfg);
> 		brcms_c_set_bssid(bsscfg);
> 	} END_FOREACH_BSS();
> Emacs gets the indenting wrong without the braces.  We use that
> style of for each loop in the Sparse project.

I too think it's better with braces and it's not
just emacs.  Anything that looks at indentation gets
this wrong without the braces.

> But I'm fairly sick of this macro so at this point, I'm fine with
> whatever.  :P

I'm with Dan, but I'm not sick like he is...

