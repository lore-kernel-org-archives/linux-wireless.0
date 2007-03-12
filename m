Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:38467 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751967AbXCLSss (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2007 14:48:48 -0400
Message-ID: <45F5A081.1060800@lwfinger.net>
Date: Mon, 12 Mar 2007 13:48:33 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Joseph Jezak <josejx@gentoo.org>
CC: David Woodhouse <dwmw2@infradead.org>,
	linux-wireless@vger.kernel.org, Michael Buesch <mb@bu3sch.de>,
	Bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] bcm43xx: Fix typo in B5PHY init specifications
References: <45e85f2b.Dp1dM05tvZFFROmc%Larry.Finger@lwfinger.net> <1173685989.3584.2.camel@shinybook.infradead.org> <45F55452.3000704@gentoo.org>
In-Reply-To: <45F55452.3000704@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe,

Joseph Jezak wrote:
> David Woodhouse wrote:
>> On Fri, 2007-03-02 at 11:30 -0600, Larry Finger wrote:
>>> There was an error in the B5PHY init specifications.
>> This patch doesn't fix the machine check in bcm43xx_phy_initb5 which
>> Pavel Roskin and I reported a couple of weeks ago. To get rid of that
>> crash, I still have to revert an earlier 'spec update' patch
>> (740ac4fb08866d702be90f167665d03759bd27d0).
>>
> 
> Yeah, the issue is that the Rev1 cards have to be init'd with g mode
> off.  I'm not sure anyone has picked up this fix yet. The relevant
> spec fix is here: http://bcm-v4.sipsolutions.net/802.11/PHY/calinit

I think the bug may be even deeper. In bcm43xx_phy_connect, the G Mode Enable bit of TM State Low is
only written for phy->rev >= 5. I have not found any other place where that bit is set. From what I
read in the specs, that bit should exist and be set for all G PHY's. Is that correct? I think I'm
beginning to understand the confusion between phy->connected in the code and gmode in the specs.

Larry

