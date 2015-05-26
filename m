Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36888 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751603AbbEZXHU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 19:07:20 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20150526180813.0ba1b5f5@lxorguk.ukuu.org.uk>
References: <20150526180813.0ba1b5f5@lxorguk.ukuu.org.uk> <20150519200232.GM23057@wotan.suse.de> <20150520140426.GB126473@ubuntu-hedt> <20150520172446.4dab5399@lxorguk.ukuu.org.uk> <20150520164613.GD10473@localhost> <20150521044104.GH22632@kroah.com> <20150521054101.GA15037@localhost> <20150521061453.GC30864@kroah.com> <1432213521.4230.43.camel@linux.vnet.ibm.com> <20150521154508.GA11821@kroah.com> <20150521155319.GG18164@localhost>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: dhowells@redhat.com, Petko Manolov <petkan@mip-labs.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Mimi Zohar <zohar@linux.vnet.ibm.com>,
	Seth Forshee <seth.forshee@canonical.com>,
	"Luis R. Rodriguez" <mcgrof@suse.com>,
	linux-security-module@vger.kernel.org, james.l.morris@oracle.com,
	serge@hallyn.com, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, Kyle McMartin <kyle@kernel.org>,
	David Woodhouse <david.woodhouse@intel.com>,
	Joey Lee <jlee@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
	mricon@kernel.org
Subject: Re: [RFD] linux-firmware key arrangement for firmware signing
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Date: Wed, 27 May 2015 00:06:36 +0100
Message-ID: <5032.1432681596@warthog.procyon.org.uk> (sfid-20150527_010726_461573_EE80A1E6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk> wrote:

> Ie you need to sign something more than the firmware, such as (firmware,
> modinfo), so it's signed for "firmware X on PCI:8086,1114 or "firmware Y
> on ACPI:0A1D"

I'm suggesting that we use the name string passed to request_firmware().

> IMHO we want the supplier of a given firmware providing signatures on
> the firmware git tree if this is done. A generic linux-firmware owned key
> would be both a horrendously inviting attack target, and a single point of
> failure.
> 
> Git can already do all the needed commit signing bits unless I'm missing
> something here ?

How does this help the kernel check that it's been given the right firmware
blob for its request?  Unless you compile into the kernel a list of hashes
compiled from the linux-firmware git head (or representative root hash) - in
which case we're back to Andy's hash list/hash tree approach with the problems
that that entails.

David
