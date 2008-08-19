Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from toronto053.server4you.de ([62.75.220.53]:53318 "EHLO
	toronto053.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754360AbYHSMFc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Aug 2008 08:05:32 -0400
Message-ID: <48AAB70A.4090402@monom.org> (sfid-20080819_140554_098124_B40935FB)
Date: Tue, 19 Aug 2008 14:05:30 +0200
From: Daniel Wagner <wagi@monom.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: QoS and DSCP
References: <48AA887D.5090307@monom.org> <ee101a74bd16a9467853b5ac049c5da4.squirrel@secure.sipsolutions.net> <48AA8E2C.4060303@monom.org> <48AAAD30.2080207@monom.org>
In-Reply-To: <48AAAD30.2080207@monom.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Together with some printks I see that the code in wme.c classify_1d does
> exactly the thing which it should. It returns the dscp value correctly.
> Using --set-dscp 0x18 classify_1d returns 3 and with --set-dscp-class 
> EF, classify_1d returns 5. 

Crap, that's not correct. I think I found the problem:

static unsigned int classify_1d(struct sk_buff *skb)
{
        ...

	if (dscp & 0x1c)
		return 0;

	return dscp >> 5;
}

--set-dscp 0x28 (precendence level 5) classify_1d returns the correct
value 5. 

Setting with --set-dscp-class EF the TOS field it will have value 0xb8 (10111000b)
which maps to 
Bit 7-2: DSCP
Bit 1-0: ECN (expliliciet congestion notifaction)

So the question is what the 'if' is for? 

stay tuned!

daniel
