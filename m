Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix.slamd64.com ([217.10.145.2]:60907 "EHLO
	phoenix.slamd64.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbYIPTSg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2008 15:18:36 -0400
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: Regression in 2.6.27-rcX caused by commit bc19d6e0b74ef03a3baf035412c95192b54dfc6f
Date: Tue, 16 Sep 2008 20:18:27 +0100
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Michael Buesch <mb@bu3sch.de>,
	Adel Gadllah <adel.gadllah@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	wireless <linux-wireless@vger.kernel.org>
References: <48CFC03A.8020708@lwfinger.net> <200809161742.15527.mb@bu3sch.de> <48CFE820.7010305@lwfinger.net>
In-Reply-To: <48CFE820.7010305@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809162018.28548.carlos@strangeworlds.co.uk> (sfid-20080916_211841_179284_3997B526)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 16 September 2008 18:08:48 Larry Finger wrote:
> I agree with Michael. From what I know, the only possible reason for
> having [RFKILL_STATE_HARD_BLOCKED] would be if user space could
> somehow affect the state of the hardware switch.

When I disable the b43 device in my laptop via acer-wmi (which in turn, calls 
into the laptops firmware), b43 physically cannot re-enable it (a not 
uncommon case on a lot of laptops). In which case, as far as b43 is 
concerned, the wireless radio is then in RFKILL_STATE_HARD_BLOCKED, since b43 
is unable to re-enable the radio on the hardware.

So yes, it is quite possible for b43 to be in RFKILL_STATE_HARD_BLOCKED.

-Carlos
-- 
E-Mail: carlos@strangeworlds.co.uk
Web: strangeworlds.co.uk
GPG Key ID: 0x23EE722D
