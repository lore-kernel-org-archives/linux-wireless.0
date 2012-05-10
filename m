Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53059 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab2EJQy4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 12:54:56 -0400
Received: by pbbrp8 with SMTP id rp8so2128765pbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 09:54:56 -0700 (PDT)
Date: Thu, 10 May 2012 09:54:51 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-wireless@vger.kernel.org,
	florian.c.schilhabel@googlemail.com, ali@internetdog.org,
	netdev@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 0/3] staging: delete duplicated files/functionality in
 rtl8712
Message-ID: <20120510165451.GA12958@kroah.com> (sfid-20120510_185505_360966_032CE7D4)
References: <1336621641-15467-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1336621641-15467-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 09, 2012 at 11:47:18PM -0400, Paul Gortmaker wrote:
> A git grep happened to lead me into this dir, and once there I couldn't
> simply leave and pretend I didn't see the stuff that I saw.
> 
> There were duplicated basic networking headers like if_ether.h and
> ip.h (of course, some ancient versions, too).  And a whole whack of
> boilerplate endian handling functionality duplicated too.
> 
> I forced myself to stop looking after that.

Yes, it's a mess, thanks for working on cleaning it up, even a little
bit, it all helps.

> Anyway, a trivial redirection onto mainline's networking headers
> in the proper include dir, and a deletion of any references to
> the endian headers and the thing still happily builds on x86_64
> and ppc even after shitcanning seven useless files.
> 
> These three commits are against May 8th's linux-next tree.  I've
> used "-D" to hide the line-by-line content of the deletions.

Can you regenerate these with the full deletion content?  There have
been some spelling fixes in these files, and your patches do not apply
due to them.  I can hand-edit the patches if you regenerate it.

Or if you rebase on the last linux-next tree, that will pick those
changes up and then I can apply these properly.

thanks,

greg k-h
