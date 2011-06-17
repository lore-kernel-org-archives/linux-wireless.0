Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:12746 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932201Ab1FQOqV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jun 2011 10:46:21 -0400
Message-ID: <4DFB68BB.5070902@gnu.org> (sfid-20110617_164624_771340_163FB158)
Date: Fri, 17 Jun 2011 10:46:19 -0400
From: Pavel Roskin <proski@gnu.org>
MIME-Version: 1.0
To: George Chriss <GChriss@openvideo.pro>
CC: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
Subject: Re: libertas on ETRAX FS / Elphel 353?
References: <40525.74.64.51.206.1308265716.squirrel@openvideo.pro>
In-Reply-To: <40525.74.64.51.206.1308265716.squirrel@openvideo.pro>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/16/2011 07:08 PM, George Chriss wrote:

> Is libertas support for this embedded system feasible?  I attempted to
> build compat-wireless against the Elphel kernel sources and successfully
> generated a long list of errors with 'make --keep-going' after commenting
> out unnecessary parts of the Makefile.  The build log may be found at [4].

If it's a one-off effort for one driver, I think it should be possible. 
  MadWifi (current snapshots) supports kernels from 2.4.22 to 3.0, and 
the compatibility layer is not very thick.

Many errors in that log come from the compatibility code you are not 
going to need, such as MSI support.

INIT_WORK changes are tricky, but it should be easier to backport the 
code than it was to forward port it.  MadWifi could be used as a reference.

You probably don't want mesh support.  Try disabling as all the code 
that can be disabled.

I don't know how intrusive USB changes have been.  Basically, until you 
try, there is no way to tell how hard it might be.

compat-wireless didn't go to older kernels because it needs to be 
constantly maintained and because it supports multiple drivers.

-- 
Regards,
Pavel Roskin
