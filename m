Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:34692 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753598AbZFBPUn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2009 11:20:43 -0400
From: Michael Buesch <mb@bu3sch.de>
To: matthieu castet <castet.matthieu@free.fr>
Subject: Re: b43 : unaligned access on mips
Date: Tue, 2 Jun 2009 17:20:38 +0200
Cc: linux-wireless@vger.kernel.org
References: <4A244E19.7090501@free.fr> <4A244F6C.3000509@free.fr>
In-Reply-To: <4A244F6C.3000509@free.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200906021720.39080.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 02 June 2009 00:00:12 matthieu castet wrote:
> matthieu castet wrote:
> > Hi,
> > 
> > b43_generate_plcp_hdr generate unaligned access on mips with gcc [1] 
> > from openwrt.
> > 
> > A small testcase [2] show that &plcp->data is access as a 32 bit aligned 
> > variable (see the "lw      $2,0($4)" and "sw      $2,0($4)").
> > I don't know enough mips to know if it is a gcc bug (ignoring the packed 
> > attribute) or something missing in b43 code.
> For example using "plcp->data" instead "*data" produce the correct code.

Uhm, I'm not sure. This code has been in the driver as-is forever and I don't
see any unaligned access issues on mips (I checked a month or so ago).
The plcp data structure is also __attribute__((packed)), so there can't be any
unaligned accesses, as gcc is required to _expect_ unaligned accesses on structures
with packed attribute. So it is required to do byte accesses on architectures where
alignment matters.
So I don't think there's an issue in the code.

-- 
Greetings, Michael.
