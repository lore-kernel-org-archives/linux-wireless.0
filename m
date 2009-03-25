Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:50399 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbZCYUZu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2009 16:25:50 -0400
Received: by yx-out-2324.google.com with SMTP id 31so205026yxl.1
        for <linux-wireless@vger.kernel.org>; Wed, 25 Mar 2009 13:25:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <e13a36b30903251203v7c53fb20g64bf61e4e433377@mail.gmail.com>
References: <43e72e890903250009hbe7bcfal546dddf731820b8e@mail.gmail.com>
	<200903260337.37783.kel@otaku42.de> <43e72e890903251041r657a5217q9af7b5eb34f2f824@mail.gmail.com>
	<200903260442.36251.kel@otaku42.de> <e13a36b30903251203v7c53fb20g64bf61e4e433377@mail.gmail.com>
Date: Wed, 25 Mar 2009 13:25:32 -0700
Message-ID: <43e72e890903251325k7b435c18v988f9206eb784831@mail.gmail.com> (sfid-20090325_212553_930250_AC84BF28)
Subject: Re: [renamed] Debian crda?
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: debian-devel@lists.debian.org
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 25, 2009 at 12:03 PM, Paul Wise <pabs@debian.org> wrote:
> On Thu, Mar 26, 2009 at 3:42 AM, Kel Modderman <kel@otaku42.de> wrote=
:
>
>> The DFSG seems to suggest that the source code to the regulatory dat=
abase
>> should be modifiable and the derived work distributed under the same=
 license.
>
> It is my understanding that:
>
> Debian probably won't need to build the regdb from source most of the
> time so we can just ship the upstream regulatory.bin file most of the
> time.

Yes, that is the case.

The user who would modify these rules for example would be people
doing experiments, research, or maintaining their own db for some sort
of custom hardware with specifically licensed regulatory information.

> When we do, just adding a second public key to the CRDA =C2=A0pubkeys=
 dir
> and using the corresponding private key (from outside the package)
> during the build process of wireless-regdb would be just fine.

Yes, this is the case.

> This
> would mean the maintainer of crda would also have to be the
> wireless-regdb maintainer.

Actually technically it could be a different person. I maintain crda
upstream and John maintains wireless-regdb upstream, for example. I
just need John's pubkey file which is non-binary. CRDA just reads the
regulatory.bin which wireless-regdb provides.

> I assume the wireless-regdb is
> architecture-independent so this would work because the buildds do no=
t
> build such packages.

This is correct.

You do need a regulatory.bin installed first though so that if crda is
built with the RSA digital signature check part of its build process
is to ensure the signature checks out against the currently installed
regulatory.bin file on your system. But that's just because a sanity
check is part of the default target on the Makefile.

> It is possible for users to add more public keys to the CRDA =C2=A0pu=
bkeys
> dir and build their own wireless-regdb using their own private key.

Affirmative.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
