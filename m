Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:51056 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbYGEVNJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Jul 2008 17:13:09 -0400
Received: by nf-out-0910.google.com with SMTP id d3so489426nfc.21
        for <linux-wireless@vger.kernel.org>; Sat, 05 Jul 2008 14:13:07 -0700 (PDT)
To: Bryan Batten <BryanBatten@sbcglobal.net>
Subject: Re: [Rt2400-devel] [PATCH] rt2x00: Fix NULL pointer error in adhoc/master mode
Date: Sat, 5 Jul 2008 23:19:39 +0200
Cc: linville@tuxdriver.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
References: <200807051511.57995.IvDoorn@gmail.com> <200807052042.47008.IvDoorn@gmail.com> <486FD8AF.5050001@sbcglobal.net>
In-Reply-To: <486FD8AF.5050001@sbcglobal.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200807052319.40115.IvDoorn@gmail.com> (sfid-20080705_231312_609872_5C29EE2D)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 05 July 2008, Bryan Batten wrote:
> Ivo van Doorn wrote:
> ...
> > That is interesting, have you tried controlling CSR14 and more
> > specifically the TBCN or BeaconGen fields?
> 
> No. It turns out that if I set the RT2500's CSR14 to zero (the default 
> power on state according to the data sheet) at driver initialization, 
> there are no beacon interrupts until enabled in AsicEnableIbssSync(). 
> I deem this a bug, the fix for which in now in CVS.

Heh, that will bring down the number of raised interrupts in the legacy driver. :)
You might want to add it to rt2400 as well, I expect the same behavior for that. ;)

I'll put the initialization into rt2x00 as well, since it doesn't set it to 0 by default either.

Ivo
