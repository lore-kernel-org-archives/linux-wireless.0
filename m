Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37786 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754594AbbE2Mkh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 May 2015 08:40:37 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <5567C131.8050005@kernel.org>
References: <5567C131.8050005@kernel.org> <20150528154605.1259.42518.stgit@warthog.procyon.org.uk> <20150528154834.1259.22434.stgit@warthog.procyon.org.uk>
To: Andy Lutomirski <luto@kernel.org>
Cc: dhowells@redhat.com, Luis Rodriguez <mcgrof@suse.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>, keyrings@linux-nfs.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Kyle McMartin <kyle@kernel.org>,
	linux-wireless@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Seth Forshee <seth.forshee@canonical.com>,
	LSM List <linux-security-module@vger.kernel.org>,
	Mimi Zohar <zohar@us.ibm.com>,
	David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 16/20] PKCS#7: Add an optional authenticated attribute to hold firmware name [ver #5]
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Date: Fri, 29 May 2015 13:40:29 +0100
Message-ID: <29091.1432903229@warthog.procyon.org.uk> (sfid-20150529_144044_759324_A1AAC59F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andy Lutomirski <luto@kernel.org> wrote:

> This is insecure because PKCS#7 authenticated attributes are broken (see
> RFC2315 section 9.4 note 4).  You need to either require that everything have
> authenticated attributes or require that nothing have authenticated
> attributes.   Maybe this insecurity doesn't matter in practice, but I don't
> wouldn't want to bet on it.

You can also fudge the signature (or a hash) by adding extra data to or
modifying the data blob and by switching signature values between signature
blobs.

PKCS#7 authenticated attributes aren't as broken as you make out.  They are
added to the signature hash - so an attacker *would* have to fudge things to
make it work.  Further, we can easily make it so that auth attrs are
*required*.

> On top of that, this is a ton of code to support something trivial.

I don't think it's as bad as you're making it out to be.

> And it requires an OID to be registered (ick).

That shouldn't be too hard to achieve - at least if we don't mind having RH
space OIDs.

> Earlier you suggested just appending the signature purpose to the thing being
> signed.  What's wrong with that?

You can't tell the difference between a corrupted key/signature and a firmware
blob being loaded for the wrong request.  Firstly, I want to be able to detect
the difference and secondly, it makes it easier to debug it if something does
go wrong.

> P.S.  Or you could stop using PKCS#7 if possible.

We've discussed this before.  We have to have a PKCS#7 parser in the kernel
anyway if we're going to support signed PE files for kexec.

David
