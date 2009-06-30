Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:6632 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754054AbZF3VJj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2009 17:09:39 -0400
Subject: Re: [PATCH] Add prism 2/3 usb adaptor firmware for use with
 staging/wlan-ng driver.
From: Karl Relton <karllinuxtest.relton@ntlworld.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: dwmw2@infradead.org, linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890906301217m2dec7bfaqea0472907531d21d@mail.gmail.com>
References: <1246388712.4949.52.camel@localhost>
	 <43e72e890906301217m2dec7bfaqea0472907531d21d@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 30 Jun 2009 22:09:39 +0100
Message-Id: <1246396179.4949.76.camel@localhost>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-06-30 at 12:17 -0700, Luis R. Rodriguez wrote:
> On Tue, Jun 30, 2009 at 12:05 PM, Karl
> Relton<karllinuxtest.relton@ntlworld.com> wrote:
> > Signed-Off-By: Karl Relton
> > Signed-Off-By: Mark S. Mathews
> 
> The commit log is empty. Where is this driver? Is it in staging at
> least? If so does this get users of the driver a usable firmware? What
> is the future of the driver BTW?
> 

Oops - put text in wrong part of patch documentation. I can move this up
to the 'commit log' part.

The driver is under 'staging' - maintained by Greg Koah-Hartman

The firmware blob in 'srec' format for prism 2/3 usb adaptors.
The driver will read the srec file using a standard request_firmware()
call, and will convert it into the appropriate binary format and upload to
the adaptor. Note the processing is left to the driver (rather than
pre-compiling) because the driver needs to insert runtime data obtained from
the adaptor into the blob. The appropriate insertion locations are conveyed
by the srec format.

Karl

