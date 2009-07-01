Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:40312 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755298AbZGARWg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2009 13:22:36 -0400
Subject: Re: [PATCH] Add prism 2/3 usb adaptor firmware for use with
 staging/wlan-ng driver.
From: Pavel Roskin <proski@gnu.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Karl Relton <karllinuxtest.relton@ntlworld.com>,
	dwmw2@infradead.org, linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890907011014v300bcf64u3c7b259173d93588@mail.gmail.com>
References: <1246388712.4949.52.camel@localhost>
	 <43e72e890906301217m2dec7bfaqea0472907531d21d@mail.gmail.com>
	 <1246396179.4949.76.camel@localhost>
	 <43e72e890906301458y197c5411yfb93ea0089ed49f3@mail.gmail.com>
	 <1246464991.4331.18.camel@localhost>
	 <43e72e890907011014v300bcf64u3c7b259173d93588@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 01 Jul 2009 13:22:37 -0400
Message-Id: <1246468957.15757.20.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-07-01 at 10:14 -0700, Luis R. Rodriguez wrote:

> Can you elaborate on this a little. Does the driver currently take the
> srec file, append/prepend some data onto it and then run it on the
> target CPU?

Some data in the srec file is replaced by the data read from the card
(so called plug data area, or PDA).  "Plugging" refers to that process.

> > , so pre-compilation would have meant
> > inventing both a compiler tool and an intermediate format for the driver
> > to read and process.
> 
> The srec->binary conversion just needs to be done once, and not sure
> what the "extra" stuff is that you mention is required, but if its
> always the same can't that just be put into a final binary file?

We can use the same format as Spectrum firmware used in spectrum_cs, and
reuse its parser/plugger.  Spectrum and Prism chipsets are related and
use the same idea of plugging, but Prism firmware is distributed as srec
files, whereas Spectrum firmware is cut from binary drivers as a binary.

-- 
Regards,
Pavel Roskin
