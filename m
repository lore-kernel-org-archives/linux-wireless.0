Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:49680 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758147AbXLMRYg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 12:24:36 -0500
Message-ID: <47616AD2.8070108@lwfinger.net> (sfid-20071213_172442_604604_A8DAF9FB)
Date: Thu, 13 Dec 2007 09:24:34 -0800
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43: Fix rfkill radio LED
References: <4760c3db.qCB1sy2b6EqODHqS%Larry.Finger@lwfinger.net> <200712131211.47867.mb@bu3sch.de>
In-Reply-To: <200712131211.47867.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Thursday 13 December 2007 06:32:11 Larry Finger wrote:
>> logic in the request_module("rfkill-input") section. Now, the code is
> 
> Ehm, no. Wait.
> There was a
> #ifdef CONFIG_RFKILL_INPUT_MODULE
> That is only defined if rfkill-input is a module, right?

Correct and CONFIG_RFKILL_INPUT is defined if the code is built_in. The "most correct" logic for 
this section would be:

if (built_in)
	all is OK.

if (module)
	load it.

If (!built_in && !module)
	warn that the LED will not work.

In the version I sent you, the logic is:

if (!built_in) {
	load module
	if (err)
		print message that it will not work
}

To my thinking, the second version is close enough. the only extra step it does is to try to load 
the module even when it has not been built, but it does end up with the warning being printed.

Larry
