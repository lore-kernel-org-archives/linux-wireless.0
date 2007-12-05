Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:53743 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752172AbXLEXFp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2007 18:05:45 -0500
Date: Wed, 5 Dec 2007 15:05:07 -0800
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC] fixing the ap_scan and hidden SSID mess
Message-ID: <20071205230507.GA28902@bougret.hpl.hp.com> (sfid-20071205_230550_198796_A60538EB)
Reply-To: jt@hpl.hp.com
References: <20071205221119.GA28457@bougret.hpl.hp.com> <1196894672.14901.5.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1196894672.14901.5.camel@localhost.localdomain>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 05, 2007 at 05:44:32PM -0500, Dan Williams wrote:
> 
> > > The problem is that there isn't a nice, generic capabilities field in
> > > WEXT.  So we have to abuse an existing one, and I picked enc_capa.
> > 
> > 	Please don't do that. It's fairly trivial to add a new field
> > in iwrange. And it's not like the sky will fall down if we add a field
> > in iwrange. If you want to do it, please do it right.
> 
> Well, the problem I had with this is that it's less likely to get
> backported because it potentially breaks binary compatibility for
> distros.  There are 3 options here:
> 
> 1) overload enc_capa
> 
> 2) add a field and start doing comparisons of the size of the iw_range
> structure to figure out what is available and what's not
> 
> 3) Bump the WEXT version
> 
> #3 is a non-starter because it is a much larger, more invasive change
> and requires more breakage of ABI and such.

	Hu ? Please tell me what will break. We can bump the WEXT
version pretty much any time we want, no userspace will fail. THe
worse you may see is an anoying warning message.

> I guess #2 is acceptable.

	Option 4 : use two flags (as described below), that way you
know if iwrange implement the feature or not.

> > 	Note that there is one gotcha because of the state of
> > userspace, so if you want I can produce a kernel patch that will work
> > properly, and I'll add the usespace support for it as well.
> 
> Could you describe that more?

	The iwrange in userspace has a few more stuff defined, so you
need to make sure to include padding to not add your field on an
already existing field. Check the wireless.21.h file.
	Note that if you sign the usual suspects on that change, I'll
do the patch for you.

> > 	That won't work. You have a tri-state, and with only a single
> > bit you can encode only two state. You basically have :
> > 	o driver that support ap_scan=1
> > 	o driver that do not support ap_scan=1
> > 	o driver that have not been updated or reside in old kernels
> 
> Well, to be fair, the patch posted handles this perfectly well, because
> older kernels with drivers that don't have the capability just dont'
> advertise it.  Therefore everything works fine.
> 
> > 	So, at the minimum, you'd want :
> > -------------------------------------
> > +#define IW_ENC_CAPA_SPECIFIC_SSID_SCAN	0x00000010
> > +#define IW_ENC_CAPA_ANY_SSID_SCAN	0x00000020
> > -------------------------------------
> 
> I'm not sure why we'd want ANY_SSID_SCAN?

	To distinguish driver that have not been updated or driver in
order kernel from drivers that do not support ap_scan=1. You may want
to do things slightly differently between those two.
	It just act as : yes this driver has been audited and fixed to
export proper scanning capability support.

> > 	Another option would be for SIOCSIWSCAN to fail if a specific
> > SSID is set and it does not support it, instead of just ignoring it.
> 
> Again, that won't work because it requires changing _all_ drivers.

	And ? In some case it's preferable to fix all driver rather
than to mess us the API. In many instances we fix all drivers.

>  We
> need to fix this by ensuring that the change only affects those drivers
> that support the capability, not requiring drivers that dont' have it to
> change.  Extending range would work here.
> 
> Dan

	Have fun,

	Jean
