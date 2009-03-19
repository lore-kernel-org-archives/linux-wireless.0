Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:47783 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434AbZCSULR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2009 16:11:17 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Francesco Gringoli <francesco.gringoli@ing.unibs.it>
Subject: Re: [PATCH] b43: Mask PHY TX error interrupt, if not debugging
Date: Thu, 19 Mar 2009 21:10:08 +0100
Cc: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
References: <200903191927.21868.mb@bu3sch.de> <200903192013.44903.mb@bu3sch.de> <35D36C55-6CB3-443C-A916-D5771B68DD9A@ing.unibs.it>
In-Reply-To: <35D36C55-6CB3-443C-A916-D5771B68DD9A@ing.unibs.it>
MIME-Version: 1.0
Message-Id: <200903192110.08437.mb@bu3sch.de> (sfid-20090319_211126_162775_045D22B6)
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 19 March 2009 20:56:52 Francesco Gringoli wrote:
> I would agree with you, but there is this bizarre issue with PHY  
> errors in monitoring mode that makes me thinking about what we call  
> PHY errors. I would say they are not only due to transmission, they  
> are general PHY errors, could they be? One last test I could try, is  

No the interrupt indicates a PHY TX error.
This name is from the broadcom headers, so we can trust that it's correct.

As I said, I never saw the error with the proprietary firmware in monitor mode.
If you know a way how to trigger them, please tell me.

> to put again the broken minipci to pci adapter in one pci slot and put  
> on the next slot the adapter that does not trigger these errors. If  
> the interference caused by the broken adapter induces the wifi boards  
> on top of it in errors, it should induce the same error on the board  
> mounted on the right adapter.

Well, the question is what can we learn from this test? ;)
What we really need is a way to find out which part of the PHY triggers
this error. We have a dozen of methods to trigger the error. But we _still_
do not know the lowlevel PHY conditions that result in an error.

Probably somebody with lots of time should randomly go through the code
and set various PHY thresholds to big/small values. Maybe that'll point us into
some direction. The problem is that the code basically is undocumented and we
only write blob values to the registers. So from reading the code you won't even
know where these values are written. But the specs give some useful hints. ;)

-- 
Greetings, Michael.
