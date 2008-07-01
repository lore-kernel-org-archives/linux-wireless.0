Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:12421 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbYGALLO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 07:11:14 -0400
Received: by nf-out-0910.google.com with SMTP id d3so572113nfc.21
        for <linux-wireless@vger.kernel.org>; Tue, 01 Jul 2008 04:11:13 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: rt61 and TSF reporting?
Date: Tue, 1 Jul 2008 13:15:09 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <1214907990.7763.40.camel@johannes.berg> <200807011305.18802.IvDoorn@gmail.com> <1214910405.29181.0.camel@johannes.berg>
In-Reply-To: <1214910405.29181.0.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200807011315.09296.IvDoorn@gmail.com> (sfid-20080701_131117_060737_561C9415)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 01 July 2008, Johannes Berg wrote:
> 
> > > > Note that these undocumented fields only are present in rt2500pci and rt61pci.
> > > 
> > > Ok cool, I'll play with that, I should be able to make a patch myself,
> > > thanks.
> > 
> > Oh wait, just found a reference about those RXD words:
> > 
> >  * The following fields are for DMA block and HOST usage only.
> >  * Can't be touched by ASIC MAC block.
> > 
> > In other words, they are for driver usage only. :S
> 
> The only ones that are ever non-zero are 0, 1, 4 and 5. Guess not then.

4 contains data?
2 and 3 I understand since HW crypto is disabled in wireless-testing,
but that should mean that 4 should also be 0 unless my estimation about
it being the ICV field is wrong...

What data is in there?

Ivo
