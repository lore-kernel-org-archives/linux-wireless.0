Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:40932 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752051AbYDTIlH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Apr 2008 04:41:07 -0400
Date: Sun, 20 Apr 2008 10:41:01 +0200
From: Sebastian Siewior <liber+tas@ml.breakpoint.cc>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: David Woodhouse <dwmw2@infradead.org>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	libertas-dev@lists.infradead.org
Subject: Re: [PATCH] libertas: Fix ethtool statistics
Message-ID: <20080420084101.GB7685@Chamillionaire.breakpoint.cc> (sfid-20080420_094124_019962_D1B94B69)
References: <1208448814.9212.270.camel@pmac.infradead.org> <200804181149.41838.hs4233@mail.mn-solutions.de> <1208517302.9212.324.camel@pmac.infradead.org> <200804181510.53412.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
In-Reply-To: <200804181510.53412.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Holger Schurig | 2008-04-18 15:10:53 [+0200]:

>> > I wrote "if (ret) return ret", not "if (ret) return;".
>>
>> I know you did, but I don't know why. The
>> lbs_ethtool_get_stats() function returns void. Sebastian's
>> patch which memsets it to zero makes sense, but it can't
>> return an error.
>
>Ahh, I stand corrected.
The function before lbs_ethtool_get_stats() (in net code that
determinate the number of elements, dunno the name right now) is able to
return an error. This one could check if the firmware has mesh support.

>> They're separate problems, really. With or without the patch I
>> first posted, you're getting crap back when you ask for
>> statistics on a non-mesh device. The second patch fixes that,
>> and stands alone.

Do I understand this correct: If the firmware has support for mesh
devices than we have ethX and mshX and only mshX should return the
statistics?

>Yes, this is separate. That's why I wrote "The ultimate patch 
>would be".
>
>BTW, I like your two patches combined more than Sebastians memset 
>approach. Because with Sebastians patch on on ethX we would get 
>zeroed nonsense instead of uninitialized nonsense.
returning uninitialized nonsense is leaking kernel memory.

>The memset should possible there anyway in the case of a firmware 
>that can mshX, but not CMD_ACT_MESH_GET_STATS or which would 
>return some error for another reason.
What about changing lbs_ethtool_get_stats() from void to int? All other
drivers are reading memory to get this data, we have to go through
usb/cs/sdio layer and all of them may fail.

I will try to form a patch around Monday that fixes Dan's comments (if
nobody else is going to).

Sebastian
