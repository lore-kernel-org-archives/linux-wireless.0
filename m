Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54531 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755472Ab0KPRQf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 12:16:35 -0500
Received: by pwi9 with SMTP id 9so220560pwi.19
        for <linux-wireless@vger.kernel.org>; Tue, 16 Nov 2010 09:16:35 -0800 (PST)
Message-ID: <4CE2BC64.4050302@lwfinger.net>
Date: Tue, 16 Nov 2010 11:16:20 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: James Womack <james.c.womack@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: r8187se panic
References: <slrnidp3ae.79c.rb-oss-3@mal.justgohome.co.uk> <4CDC9FA5.10002@lwfinger.net> <slrnidq7u0.9ic.rb-oss-3@mal.justgohome.co.uk> <4CDD3BC4.7070102@lwfinger.net> <slrnidqorp.dlr.rb-oss-3@mal.justgohome.co.uk> <4CDD66C4.10603@lwfinger.net> <slrnidqsld.dlr.rb-oss-3@mal.justgohome.co.uk> <4CDD7945.70005@lwfinger.net> <slrnidqv0k.g21.rb-oss-3@mal.justgohome.co.uk> <loom.20101113T191727-421@post.gmane.org> <4CDEDC74.3040902@lwfinger.net> <ibmosc$4au$1@dough.gmane.org> <4CDEEEE4.80801@lwfinger.net> <ibokag$481$1@dough.gmane.org> <4CE00BEE.8060100@lwfinger.net> <ibpauk$v12$1@dough.gmane.org> <4CE0455A.50709@lwfinger.net> <ibs7c3$3dn$1@dough.gmane.org> <4CE1C5F7.90607@lwfinger.net> <ibtkeo$efc$1@dough.gmane.org> <4CE29413.5090103@lwfinger.net> <ibu5eh$15d$1@dough.gmane.org> <4CE29C7E.6000200@lwfinger.net> <4CE2B78D.1010202@gmail.com>
In-Reply-To: <4CE2B78D.1010202@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/16/2010 10:55 AM, James Womack wrote:
> On 16/11/10 15:00, Larry Finger wrote:
>> On 11/16/2010 08:46 AM, James Womack wrote:
>>
>>> This should be sufficient, hopefully!
>>
>> Perfect.
>>
>> Larry
> 
> Good. Thanks for fixing this issue. Do you have any idea when we could
> expect to see this fix incorporated into a mainstream kernel?

The fix to change the panic into a simple warning has been pushed upstream. If
GregKH, the staging maintainer, thinks it can go into 2.6.37, then the
backporting to stable will happen fairly quickly. If he decides it is too
invasive (not likely), then the patch will wait for ~2 months for 2.6.38. Once
in mainline, there will be some delay as the patch for 2.6.37 does not apply to
your kernel (2.6.32 as I recall), thus I will have to supply a revised version.
Once it is in 2.6.32.Y, then your disto will have to pick up the changes and
create an updated kernel. The wheels of change turn slowly - kernel stability is
extremely important.

My estimate would be 6 weeks at a minimum. Note that I still do not have a real
fix for the warning. That could take a long time to find, particularly as I
cannot duplicate the condition on my box. Long-range debugging is a very slow
process.

One other thing to note. I have a mac80211 version of the rtl8187se driver that
almost works. It is able to receive and transmit short packets. When a packet
longer than about 64 bytes is sent, the firmware locks up. I sent my source to
Realtek to see if they could see what I'm doing wrong. Their report is that the
driver is now working, but not stable. Once that driver is finished, it wil;l;
be submitted to mainline, and the version in staging will be dropped.

Larry
