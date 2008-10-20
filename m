Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.238]:40540 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704AbYJTUg2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 16:36:28 -0400
Received: by rv-out-0506.google.com with SMTP id k40so2041630rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2008 13:36:27 -0700 (PDT)
Message-ID: <2da21fe50810201336r29ed4e83g18d57e6d01b97349@mail.gmail.com> (sfid-20081020_223633_166710_101C93B2)
Date: Mon, 20 Oct 2008 22:36:27 +0200
From: "Davide Pesavento" <davidepesa@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: crda packaging
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Tim Gardner" <tim.gardner@canonical.com>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <43e72e890810191828x44624d4fsa8d56170d2ba4f46@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <2da21fe50810190857j4dacb612u3a2bba4ab3baa7fd@mail.gmail.com>
	 <43e72e890810191828x44624d4fsa8d56170d2ba4f46@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/10/20 Luis R. Rodriguez <mcgrof@gmail.com>:
> On Sun, Oct 19, 2008 at 8:57 AM, Davide Pesavento <davidepesa@gmail.com> wrote:
>> 2008/9/28 Luis R. Rodriguez <mcgrof@gmail.com>:
>>> The regulatory.bin and the rsa public key will soon be posted on some
>>> place on John Linville's web space somewhere, so that'll change soon I
>>> hope.
>>
>> Do you think the regulatory database should be split from the package
>> that contains the crda daemon? If so, regulatory.bin should be
>> versioned as well...
>
> Yes, absolutely, the idea is to split db.txt into a separate git tree
> too actually so that should help with keeping track of changes
> separately and thinking of them separately.
>

Great!

> We just need to get this git tree created. What crda will need though
> is to wget the RSA public key so it can be built with support for new
> arbitrary updates to the binary db. Give us a few days, we'll get this
> setup.
>

I'm not sure I can follow you here. This is what I understood so far:

(1) Someone (e.g. John Linville) creates a RSA key pair and puts the
public key in a public place (e.g. linuxwireless.org website).
(2) John "compiles" db.txt into its binary form (regulatory.bin),
signs it with his private key and makes it publicly available
somewhere (e.g. again linuxwireless.org).
(3) Packagers create a package for the crda daemon alone, and a
package containing regulatory.bin and the public part of the key pair
used to sign it.
(4) When the regulatory database is updated, John releases a new
version by "compiling" and signing it again.

Thanks,
Davide
