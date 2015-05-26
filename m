Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:33589 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbbEZTwt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 15:52:49 -0400
Received: from /spool/local
	by e28smtp08.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-wireless@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
	Wed, 27 May 2015 01:22:46 +0530
Message-ID: <1432669955.2450.269.camel@linux.vnet.ibm.com> (sfid-20150526_215309_465206_91738816)
Subject: Re: [RFD] linux-firmware key arrangement for firmware signing
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Petko Manolov <petkan@mip-labs.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Seth Forshee <seth.forshee@canonical.com>,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	linux-security-module@vger.kernel.org, james.l.morris@oracle.com,
	serge@hallyn.com, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	David Howells <dhowells@redhat.com>,
	Kyle McMartin <kyle@kernel.org>,
	David Woodhouse <david.woodhouse@intel.com>,
	Joey Lee <jlee@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
	mricon@kernel.org
Date: Tue, 26 May 2015 15:52:35 -0400
In-Reply-To: <20150526180813.0ba1b5f5@lxorguk.ukuu.org.uk>
References: <20150519200232.GM23057@wotan.suse.de>
	 <20150520140426.GB126473@ubuntu-hedt>
	 <20150520172446.4dab5399@lxorguk.ukuu.org.uk>
	 <20150520164613.GD10473@localhost>	<20150521044104.GH22632@kroah.com>
	 <20150521054101.GA15037@localhost>	<20150521061453.GC30864@kroah.com>
	 <1432213521.4230.43.camel@linux.vnet.ibm.com>
	 <20150521154508.GA11821@kroah.com>	<20150521155319.GG18164@localhost>
	 <20150526180813.0ba1b5f5@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-05-26 at 18:08 +0100, One Thousand Gnomes wrote:

> IMHO we want the supplier of a given firmware providing signatures on
> the firmware git tree if this is done. A generic linux-firmware owned key
> would be both a horrendously inviting attack target, and a single point of
> failure.
> 
> Git can already do all the needed commit signing bits unless I'm missing
> something here ?

Nice!  I haven't tried signing commits yet.  Assuming the signatures can
be extracted from git, the firmware blob git commit signature could be
stored either as a security xattr or appended (eg. similar to kernel
modules).  The end system owner could then make the decision to load the
associated public key or not.

Mimi

