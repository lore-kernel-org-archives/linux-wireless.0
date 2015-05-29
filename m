Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:42024 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754516AbbE2Ba2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2015 21:30:28 -0400
Message-ID: <5567C131.8050005@kernel.org> (sfid-20150529_033052_752841_41E4385E)
Date: Thu, 28 May 2015 18:30:25 -0700
From: Andy Lutomirski <luto@kernel.org>
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>,
	Luis Rodriguez <mcgrof@suse.com>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, keyrings@linux-nfs.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Kyle McMartin <kyle@kernel.org>,
	linux-wireless@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Seth Forshee <seth.forshee@canonical.com>,
	LSM List <linux-security-module@vger.kernel.org>,
	Mimi Zohar <zohar@us.ibm.com>,
	David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 16/20] PKCS#7: Add an optional authenticated attribute
 to hold firmware name [ver #5]
References: <20150528154605.1259.42518.stgit@warthog.procyon.org.uk> <20150528154834.1259.22434.stgit@warthog.procyon.org.uk>
In-Reply-To: <20150528154834.1259.22434.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[resending with further gmane screwups fixed]

On 05/28/2015 08:48 AM, David Howells wrote:
> Modify the sign-file program to take a "-F <firmware name>" parameter.  The
> name is a utf8 string that, if given, is inserted in a PKCS#7 authenticated
> attribute from where it can be extracted by the kernel.  Authenticated
> attributes are added to the signature digest.
>
> If the attribute is present, the signature would be assumed to be for
> firmware and would not be permitted with module signing or kexec.  The name
> associated with the attribute would be compared to the name passed to
> request_firmware() and the load request would be denied if they didn't
> match.

This is insecure because PKCS#7 authenticated attributes are broken (see 
RFC2315 section 9.4 note 4).  You need to either require that everything 
have authenticated attributes or require that nothing have authenticated 
attributes.   Maybe this insecurity doesn't matter in practice, but I 
don't wouldn't want to bet on it.

On top of that, this is a ton of code to support something trivial.  And 
it requires an OID to be registered (ick).

Earlier you suggested just appending the signature purpose to the thing 
being signed.  What's wrong with that?  It's probably much less code, it 
doesn't require reviewing details of the godawful PKCS#7 spec, and it 
will continue working if and when someone adds a more sensible signature 
format.  And you could tear out PKCS#7 authenticated attribute support 
on top of it.

P.S.  Or you could stop using PKCS#7 if possible.  Holy crap, maybe it's 
a standard, but it's a standard that we don't actually have to follow 
and it *has trivial collisions by construction*.

For Pete's sake, there are already 1262 lines of code just implementing 
PKCS#7.  In contrast, the *entire* tweetnacl library, which uses better 
crypto and is actually correct (no built-in collisions) fits a complete 
signature implementation and the underlying crypto in barely half that 
many lines.  This is actually unfair to tweetnacl, as tweetnacl also 
includes an AEAD, which could be removed to shorten it by a decent amount.

--Andy
