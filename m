Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:41635 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754748AbZFPPQz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2009 11:16:55 -0400
Date: Tue, 16 Jun 2009 18:12:58 +0300
From: Jouni Malinen <j@w1.fi>
To: Bob Copeland <me@bobcopeland.com>
Cc: Jouni Malinen <jouni.malinen@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] ath9k: Fix PCI FATAL interrupts by restoring
	RETRY_TIMEOUT disabling
Message-ID: <20090616151258.GA22849@jm.kir.nu>
References: <20090616085922.GA10176@jm.kir.nu> <b6c5339f0906160733l2ec28563h60145254855c3472@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <b6c5339f0906160733l2ec28563h60145254855c3472@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 16, 2009 at 10:33:29AM -0400, Bob Copeland wrote:
> > An earlier commit, b572b24c578ab1be9d1fcb11d2d8244878757a66, removed
> > code that was documented to disable RETRY_TIMEOUT register (PCI reg
> > 0x41) since it was claimed to be a no-op.
> 
> Jouni, can you confirm that e23a9014... also needs reverting?
> (In this case only affects resume path).

I wish I could, but I can only guess that it probably should be
reverted.

> I seem to remember the provenance of this code was copy-paste from
> an intel driver, so while it does "something," the comment may not
> match the code, 0x41 being vendor-defined.

The exact story behind this has been a bit more than trivial task to
figure out ;-). I would assume this comment is referring to a madwifi
changeset: http://madwifi-project.org/changeset/584

I've yet to find documentation that would explain the exact meaning of
PCI register 0x41 in case of ath9k/ath5k-supported devices, but maybe I
will some day ;-). Or well, I've seen documentation for said register,
but that does not match with the comment (but seems to indicate that 0
is a reasonable value to write there).

At this point, I can really only say that I can now easily reproduce
this with ath9k and AR5416 and zeroing the 0x41 value does make the
problem disappear. Since that code has been in use for five years, I do
not expect problems with it and we can just eventually fix the comment
if somebody actually find out what that register is supposed to control
;-).
 
-- 
Jouni Malinen                                            PGP id EFC895FA
