Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:44092 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbYGESgQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Jul 2008 14:36:16 -0400
Received: by nf-out-0910.google.com with SMTP id d3so479967nfc.21
        for <linux-wireless@vger.kernel.org>; Sat, 05 Jul 2008 11:36:15 -0700 (PDT)
To: Bryan Batten <BryanBatten@sbcglobal.net>
Subject: Re: [Rt2400-devel] [PATCH] rt2x00: Fix NULL pointer error =?iso-8859-1?q?in=09adhoc/master?= mode
Date: Sat, 5 Jul 2008 20:42:46 +0200
Cc: linville@tuxdriver.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
References: <200807051511.57995.IvDoorn@gmail.com> <486FBE75.5040100@sbcglobal.net>
In-Reply-To: <486FBE75.5040100@sbcglobal.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200807052042.47008.IvDoorn@gmail.com> (sfid-20080705_203620_594861_13D70D58)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 05 July 2008, Bryan Batten wrote:
> Ivo van Doorn wrote:
> ...
> > Note that the "raise beacondone interrupts without a beacon" is
> > also a bug, and will be addressed later.
> ...
> 
> FWIW, I've never been able to figure out a way to shut it off in the 
> legacy drivers. Unless there's some mechanism I've missed, I would 
> consider this a bug, but its a hardware bug because - in the rt2500 
> driver at least - even disabling it in the interrupt mask register has 
> no effect.

That is interesting, have you tried controlling CSR14 and more specifically
the TBCN or BeaconGen fields?

> I think it would be more accurately termed a target beacon 
> transmission time interrupt. The rt61 driver's ISR simply does not 
> test for the condition. The rt2400 and rt2500 drivers do nothing if 
> not in adhoc mode. If in adhoc mode, they both assume a beacon frame 
> is ready to go and send it. This relies on a canned frame that is set 
> up during initialization.

Hmm, in that case I have to fix something in the beacondone handler
to prevent it requesting a beacon when mac80211 hasn't supplied anything
yet..

Thanks for the notice. :)

Ivo
