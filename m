Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61641 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754961Ab1AGBXx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jan 2011 20:23:53 -0500
Received: by wwa36 with SMTP id 36so18034844wwa.1
        for <linux-wireless@vger.kernel.org>; Thu, 06 Jan 2011 17:23:51 -0800 (PST)
Subject: Re: [PATCH 1/3] ath9k: Decrease skb size to fit into one page.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: greearb@candelatech.com, linux-wireless@vger.kernel.org,
	ath9k-devel@venema.h4ckr.net
In-Reply-To: <201101070205.00886.chunkeey@googlemail.com>
References: <1294361165-15308-1-git-send-email-greearb@candelatech.com>
	 <201101070205.00886.chunkeey@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Jan 2011 02:23:47 +0100
Message-ID: <1294363427.2704.23.camel@edumazet-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le vendredi 07 janvier 2011 à 02:04 +0100, Christian Lamparter a écrit :
> On Friday 07 January 2011 01:46:03 greearb@candelatech.com wrote:
> > From: Ben Greear <greearb@candelatech.com>
> > 
> > Patch is from Eric Dumazet, as described here:
> > https://patchwork.kernel.org/patch/104271/
> > 
> > Reported-by: Michael Guntsche <mike@it-loops.com>
> > Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> > Signed-off-by: Ben Greear <greearb@candelatech.com>
> > ---
> > 
> > NOTE:  This needs review by ath9k and/or other informed
> > people.
> 
> Does the hardware support vector-i/o for rx (like for instance iwlagn)?
> Else, this change would break A-MSDU rx - which is a mandatory feature
> (although, not very popular) of 802.11n - 
> 
> See for example 802.11n-2009 9.7c:
> 
> "Support for the reception of an A-MSDU, where [...], is mandatory for
> an HT STA"
> 
> And 7.1.2 "The maximum frame body size is determined by the maximum
> MSDU size (2304 octets) OR the maximum A-MSDU (3839 or 7935 octets,
> depending upon the STA's capability), plus any overhead from security
> encapsulation.

Then, only solution is to mark this broken, and perform a copy of each
received frame, to keep a order-1 buffer(s) allocated for hardware.

Its too easy to have memory allocation failures for high order pages and
freeze the card.

A copy is time consuming, but at least works.



