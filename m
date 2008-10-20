Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.232]:40194 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbYJTVsC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 17:48:02 -0400
Received: by rv-out-0506.google.com with SMTP id k40so2069470rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2008 14:48:02 -0700 (PDT)
Message-ID: <2da21fe50810201448y6f05770at1d611d5a9ddc7e5b@mail.gmail.com> (sfid-20081020_234816_893608_392C6D98)
Date: Mon, 20 Oct 2008 23:48:02 +0200
From: "Davide Pesavento" <davidepesa@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: crda packaging
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Tim Gardner" <tim.gardner@canonical.com>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20081020140438.GD9035@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <2da21fe50810190857j4dacb612u3a2bba4ab3baa7fd@mail.gmail.com>
	 <43e72e890810191828x44624d4fsa8d56170d2ba4f46@mail.gmail.com>
	 <2da21fe50810201336r29ed4e83g18d57e6d01b97349@mail.gmail.com>
	 <20081020140438.GD9035@tesla>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/10/20 Luis R. Rodriguez <lrodriguez@atheros.com>:
> On Mon, Oct 20, 2008 at 01:36:27PM -0700, Davide Pesavento wrote:
>> 2008/10/20 Luis R. Rodriguez <mcgrof@gmail.com>:
>> > We just need to get this git tree created. What crda will need though
>> > is to wget the RSA public key so it can be built with support for new
>> > arbitrary updates to the binary db. Give us a few days, we'll get this
>> > setup.
>> >
>>
>> I'm not sure I can follow you here. This is what I understood so far:
>>
>> (1) Someone (e.g. John Linville) creates a RSA key pair and puts the
>> public key in a public place (e.g. linuxwireless.org website).
>
> Sure, although I'd use "wireless.kernel.org" from here on as we have no
> control over linuxwireless.org and the domain owner didn't want to give us
> ownership of it so we cannot be sure it'll always be updated.
>

Ok.

>> (2) John "compiles" db.txt into its binary form (regulatory.bin),
>> signs it with his private key and makes it publicly available
>> somewhere (e.g. again linuxwireless.org).
>
> ACK
>
>> (3) Packagers create a package for the crda daemon alone, and a
>> package containing regulatory.bin and the public part of the key pair
>> used to sign it.
>
> The public key will need to be wget'd to build crda binary as the public
> key is built in as part of the binary.
>

Ah, right. This is the point I forgot, thanks for your explanation.
This is not a problem for Gentoo ebuilds; I guess it isn't for other
distros as well.

>> (4) When the regulatory database is updated, John releases a new
>> version by "compiling" and signing it again.
>
> ACK
>
>  Luis
>

Regards,
Davide
