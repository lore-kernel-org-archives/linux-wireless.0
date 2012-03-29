Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:60027 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759474Ab2C2VTc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Mar 2012 17:19:32 -0400
Date: Thu, 29 Mar 2012 14:19:31 -0700
From: Marc MERLIN <marc@merlins.org>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: 3.2.8/amd64 full interrupt hangs and deadlocks under big network copies (page allocation failure)
Message-ID: <20120329211931.GH29342@merlins.org> (sfid-20120329_231936_865871_8FC69D67)
References: <20120329163800.GH24933@merlins.org> <1333044575.2656.1.camel@bwh-desktop.uk.solarflarecom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1333044575.2656.1.camel@bwh-desktop.uk.solarflarecom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 29, 2012 at 07:09:35PM +0100, Ben Hutchings wrote:
> On Thu, 2012-03-29 at 09:38 -0700, Marc MERLIN wrote:
> [...]
> > Below are some sysreq dumps I took (syslog to local disk was still
> > working fine). I know I have Tainted 'G', and I have no idea where that
> > came from, sorry :-/
> [...]
> 
> 'G' isn't a taint flag, but the following 'O' is; it means you have one
> or more out-of-tree modules loaded.  Care to tell us what they are?

All I can think of is virtualbox, but I'm almost certain I did not have
virtualbox loaded (i.e. modules disabled so they wouldn't load) for my first
test with wired ethernet (yes, I know that virtualbox modules are known 
for causing problems).

Ah, yes, I had another out of tree module:
http://www.thinkwiki.org/wiki/Tp_smapi
(on thinkpad W500)

Module                  Size  Used by
hdaps                  13616  1 
tp_smapi               23531  0 
thinkpad_ec            12857  2 hdaps,tp_smapi

So, I suppose the next step is to reproduce without those modules loaded,
which I'll do next.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
