Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:58960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988AbXLEWxz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2007 17:53:55 -0500
Subject: Re: [RFC] fixing the ap_scan and hidden SSID mess
From: Dan Williams <dcbw@redhat.com>
To: jt@hpl.hp.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20071205221119.GA28457@bougret.hpl.hp.com>
References: <20071205221119.GA28457@bougret.hpl.hp.com>
Content-Type: text/plain
Date: Wed, 05 Dec 2007 17:44:32 -0500
Message-Id: <1196894672.14901.5.camel@localhost.localdomain> (sfid-20071205_225401_654761_D47BD536)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-12-05 at 14:11 -0800, Jean Tourrilhes wrote:
> Dan Williams wrote :
> > 
> > Hidden SSID is a mess right now.  Here's why, and here's a proposal for
> > fixing it.
> 
> 	If you want my participation, it's usually wise to cc me.

Unintentional omission, sorry...  I was thinking of it more as a driver
issue but you're right.

> > The problem is that there isn't a nice, generic capabilities field in
> > WEXT.  So we have to abuse an existing one, and I picked enc_capa.
> 
> 	Please don't do that. It's fairly trivial to add a new field
> in iwrange. And it's not like the sky will fall down if we add a field
> in iwrange. If you want to do it, please do it right.

Well, the problem I had with this is that it's less likely to get
backported because it potentially breaks binary compatibility for
distros.  There are 3 options here:

1) overload enc_capa

2) add a field and start doing comparisons of the size of the iw_range
structure to figure out what is available and what's not

3) Bump the WEXT version

#3 is a non-starter because it is a much larger, more invasive change
and requires more breakage of ABI and such.

I guess #2 is acceptable.

> 	Note that there is one gotcha because of the state of
> userspace, so if you want I can produce a kernel patch that will work
> properly, and I'll add the usespace support for it as well.

Could you describe that more?

> > +#define IW_ENC_CAPA_SPECIFIC_SSID_SCAN	0x00000010
> 
> 	That won't work. You have a tri-state, and with only a single
> bit you can encode only two state. You basically have :
> 	o driver that support ap_scan=1
> 	o driver that do not support ap_scan=1
> 	o driver that have not been updated or reside in old kernels

Well, to be fair, the patch posted handles this perfectly well, because
older kernels with drivers that don't have the capability just dont'
advertise it.  Therefore everything works fine.

> 	So, at the minimum, you'd want :
> -------------------------------------
> +#define IW_ENC_CAPA_SPECIFIC_SSID_SCAN	0x00000010
> +#define IW_ENC_CAPA_ANY_SSID_SCAN	0x00000020
> -------------------------------------

I'm not sure why we'd want ANY_SSID_SCAN?  It's already assumed that all
drivers support scanning.  Drivers that don't support scanning and are
already in the tree have so few users and are so old that we just don't
care.  New drivers will get a HUGE NAK if they don't have scanning
support, so I don't really see this as necessary.

> > However, userspace is f*cked because it can't figure out which one to
> > use, and trying both is not an option because you get unacceptable
> > latency for the user when trying to associate.
> 
> 	Another option would be for SIOCSIWSCAN to fail if a specific
> SSID is set and it does not support it, instead of just ignoring it.

Again, that won't work because it requires changing _all_ drivers.  We
need to fix this by ensuring that the change only affects those drivers
that support the capability, not requiring drivers that dont' have it to
change.  Extending range would work here.

Dan


