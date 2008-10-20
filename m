Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:16877 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753172AbYJTVEo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 17:04:44 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2008 14:04:44 -0700
Date: Mon, 20 Oct 2008 07:04:38 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Davide Pesavento <davidepesa@gmail.com>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Tim Gardner <tim.gardner@canonical.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: crda packaging
Message-ID: <20081020140438.GD9035@tesla> (sfid-20081020_230449_018648_157AFEFC)
References: <2da21fe50810190857j4dacb612u3a2bba4ab3baa7fd@mail.gmail.com> <43e72e890810191828x44624d4fsa8d56170d2ba4f46@mail.gmail.com> <2da21fe50810201336r29ed4e83g18d57e6d01b97349@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <2da21fe50810201336r29ed4e83g18d57e6d01b97349@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 20, 2008 at 01:36:27PM -0700, Davide Pesavento wrote:
> 2008/10/20 Luis R. Rodriguez <mcgrof@gmail.com>:
> > We just need to get this git tree created. What crda will need though
> > is to wget the RSA public key so it can be built with support for new
> > arbitrary updates to the binary db. Give us a few days, we'll get this
> > setup.
> >
> 
> I'm not sure I can follow you here. This is what I understood so far:
> 
> (1) Someone (e.g. John Linville) creates a RSA key pair and puts the
> public key in a public place (e.g. linuxwireless.org website).

Sure, although I'd use "wireless.kernel.org" from here on as we have no
control over linuxwireless.org and the domain owner didn't want to give us
ownership of it so we cannot be sure it'll always be updated.

> (2) John "compiles" db.txt into its binary form (regulatory.bin),
> signs it with his private key and makes it publicly available
> somewhere (e.g. again linuxwireless.org).

ACK

> (3) Packagers create a package for the crda daemon alone, and a
> package containing regulatory.bin and the public part of the key pair
> used to sign it.

The public key will need to be wget'd to build crda binary as the public
key is built in as part of the binary.

> (4) When the regulatory database is updated, John releases a new
> version by "compiling" and signing it again.

ACK

  Luis
