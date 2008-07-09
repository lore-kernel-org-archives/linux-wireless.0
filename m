Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.178]:45298 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbYGISUW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 14:20:22 -0400
Received: by ik-out-1112.google.com with SMTP id c28so1439923ika.5
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jul 2008 11:20:20 -0700 (PDT)
To: Bryan Batten <BryanBatten@sbcglobal.net>
Subject: Re: [Rt2400-devel] [PATCH] rt2x00: Fix NULL pointer error in adhoc/master mode
Date: Wed, 9 Jul 2008 20:29:09 +0200
Cc: linville@tuxdriver.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
References: <200807051511.57995.IvDoorn@gmail.com> <200807052042.47008.IvDoorn@gmail.com> <4874FC95.3050904@sbcglobal.net>
In-Reply-To: <4874FC95.3050904@sbcglobal.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200807092029.10007.IvDoorn@gmail.com> (sfid-20080709_202025_913572_6F09E47D)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 09 July 2008, Bryan Batten wrote:
> Ivo van Doorn wrote:
> > On Saturday 05 July 2008, Bryan Batten wrote:
> >> Ivo van Doorn wrote:
> ...
> >>> Note that the "raise beacondone interrupts without a beacon" is
> >>>  also a bug, and will be addressed later.
> ...
> >> FWIW, I've never been able to figure out a way to shut it off in 
> >> the legacy drivers. Unless there's some mechanism I've missed, I 
> >> would consider this a bug, but its a hardware bug because - in 
> >> the rt2500 driver at least - even disabling it in the interrupt 
> >> mask register has no effect.
> 
> Looking thru the RT2400 and RT2500 datasheets, I notice that on pp. 12
> of the 2400 datasheet, CSR8 bits 0 and 1 are described. On the same
> page of the RT2500 datasheet, CSR8 bits 0 and 1 are not described. If
> that is not a typo, that means to me that on the RT2400 you can
> mask off beacon timer and wakeup timer interrupts with CSR8, but on
> the RT2500 you cannot.

Yes, but if you look again you see that the legacy driver does define it,
and even includes the description of bits 9 -> 19
And the legacy driver source code has always been more reliable then
the datasheet, so I would put my money on the code. ;)

> Would it be possible to verify with Ralink that this is not a typo in
> the RT2500 datasheet?

I'll see what I can find out.

Ivo
