Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:64296 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755414AbZAXUiY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2009 15:38:24 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sat, 24 Jan 2009 12:38:24 -0800
Date: Sat, 24 Jan 2009 12:37:46 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wireless-regdb: add example spec file
Message-ID: <20090124203746.GB22475@tesla> (sfid-20090124_213827_932939_69495892)
References: <1232752577-24011-1-git-send-email-lrodriguez@atheros.com> <200901241227.48939.helmut.schaa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <200901241227.48939.helmut.schaa@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 24, 2009 at 03:27:48AM -0800, Helmut Schaa wrote:
> Am Samstag, 24. Januar 2009 schrieb Luis R. Rodriguez:
> > This is a simple example spec file which can be used
> > by RPM distributions. Note that the man page isn't yet
> > installed as it has not yet been commited.
> >
> > Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> > ---
> 
> [...]
> 
> > +%install
> > +install -m 755 -d %buildroot/%crda_lib
> > +install -m 644 regulatory.bin %buildroot/%{crda_lib}/regulatory.bin
> 
> Why not make use of "make DESTDIR=%buildroot install" here?

Since its in the spec file you have direct control over that, what would
be best is to get wireless-regdb makefile to use DESTDIR and then just
have the spec file call make install. I sent the patch for the first part
already, so the spec file can be changed once that goes in.

  Luis
