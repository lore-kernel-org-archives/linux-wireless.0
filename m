Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:36386 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757234AbbE2SjR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 May 2015 14:39:17 -0400
Received: by lagv1 with SMTP id v1so62219195lag.3
        for <linux-wireless@vger.kernel.org>; Fri, 29 May 2015 11:39:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <29091.1432903229@warthog.procyon.org.uk>
References: <20150528154605.1259.42518.stgit@warthog.procyon.org.uk>
 <20150528154834.1259.22434.stgit@warthog.procyon.org.uk> <5567C131.8050005@kernel.org>
 <29091.1432903229@warthog.procyon.org.uk>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 29 May 2015 11:38:54 -0700
Message-ID: <CALCETrUG7utqU7uKeC6q1rchBYL08V7peP1Ont95ZpBTiV7J9A@mail.gmail.com> (sfid-20150529_203926_418626_EC613867)
Subject: Re: [PATCH 16/20] PKCS#7: Add an optional authenticated attribute to
 hold firmware name [ver #5]
To: David Howells <dhowells@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>,
	Luis Rodriguez <mcgrof@suse.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>, keyrings@linux-nfs.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Kyle McMartin <kyle@kernel.org>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Seth Forshee <seth.forshee@canonical.com>,
	LSM List <linux-security-module@vger.kernel.org>,
	Mimi Zohar <zohar@us.ibm.com>,
	David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 29, 2015 at 5:40 AM, David Howells <dhowells@redhat.com> wrote:
> Andy Lutomirski <luto@kernel.org> wrote:
>
>> This is insecure because PKCS#7 authenticated attributes are broken (see
>> RFC2315 section 9.4 note 4).  You need to either require that everything have
>> authenticated attributes or require that nothing have authenticated
>> attributes.   Maybe this insecurity doesn't matter in practice, but I don't
>> wouldn't want to bet on it.
>
> You can also fudge the signature (or a hash) by adding extra data to or
> modifying the data blob and by switching signature values between signature
> blobs.

So there's another design error in PKCS#7?  Great!

>
> PKCS#7 authenticated attributes aren't as broken as you make out.  They are
> added to the signature hash - so an attacker *would* have to fudge things to
> make it work.  Further, we can easily make it so that auth attrs are
> *required*.
>
>> On top of that, this is a ton of code to support something trivial.
>
> I don't think it's as bad as you're making it out to be.
>
>> And it requires an OID to be registered (ick).
>
> That shouldn't be too hard to achieve - at least if we don't mind having RH
> space OIDs.
>
>> Earlier you suggested just appending the signature purpose to the thing being
>> signed.  What's wrong with that?
>
> You can't tell the difference between a corrupted key/signature and a firmware
> blob being loaded for the wrong request.  Firstly, I want to be able to detect
> the difference and secondly, it makes it easier to debug it if something does
> go wrong.
>

This seems only barely useful.  In any event, you could still do it by
appending the purpose as long as the purpose was literally appended to
the payload as opposed to being implicit and only covered by the
signature.

>> P.S.  Or you could stop using PKCS#7 if possible.
>
> We've discussed this before.  We have to have a PKCS#7 parser in the kernel
> anyway if we're going to support signed PE files for kexec.

If you neuter the PKCS#7 parser to requre authenticated attributes,
will this use case still work?

Honestly, it still might be less code in the end if you used PKCS#7
solely for kexec.

--Andy
