Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:38091 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab3AAW25 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jan 2013 17:28:57 -0500
Received: by mail-pa0-f47.google.com with SMTP id fa10so7640580pad.34
        for <linux-wireless@vger.kernel.org>; Tue, 01 Jan 2013 14:28:56 -0800 (PST)
Message-ID: <50E36325.3090502@lwfinger.net> (sfid-20130101_232901_088474_E2E0DA89)
Date: Tue, 01 Jan 2013 16:28:53 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Julian Wollrath <jwollrath@web.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: WARNING: at net/wireless/mlme.c:517
References: <20130101154507.351dfb03@ilfaris> <50E325B5.205@lwfinger.net> <20130101231544.430cf1fe@ilfaris>
In-Reply-To: <20130101231544.430cf1fe@ilfaris>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/01/2013 04:15 PM, Julian Wollrath wrote:
>> This one indicates that there was a call to disassociate when the
>> device was not associated. It might have been informative to have
>> seen the logged messages earlier than 436.155474 seconds.
> Some of the earlier messages can be found below together with the trace
> with hopefully not mest up formatting like in my first mail. Basically
> the device tries all the time to connect to the AP and it fails in most
> cases to connect, a problem, which sounds very similar to what Borislav
> Petkov mentioned in the "dire state of rtl driver in 3.7". By the way,
> if you have a suggestion how to investigate connection problems (in my
> case: often not possible to connect to the AP, even if the signal is
> not very weak and when finally connected and the pings sometimes take
> time in the order of 10^2 and the sometimes time in the order of 10^4
> or even 10^5) which are there with both the vendor driver and the
> native kernel driver, I would appreciate it.

As you have probably seen, I cannot duplicate the problems that Borislav sees, 
nor do I ever see the ones you state here.

If this condition is easy to replicate, please unload rtl8192ce, and reload with 
the command 'sudo modprobe -v rtl8192ce debug=4'. That will generate a lot of 
logging, thus you probably do not want to let it run too long.

Larry


