Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:52993 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbaFKOPp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 10:15:45 -0400
Message-ID: <53986490.40702@candelatech.com> (sfid-20140611_161549_287567_1264E2D6)
Date: Wed, 11 Jun 2014 07:15:44 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: More confusion with regulatory issues.
References: <53979E9A.5010308@candelatech.com> <CAB=NE6VDr8C=2XZZhnyFKeowDMA-K05_ySw=jDS5gz4+7xs3NA@mail.gmail.com>
In-Reply-To: <CAB=NE6VDr8C=2XZZhnyFKeowDMA-K05_ySw=jDS5gz4+7xs3NA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/11/2014 02:10 AM, Luis R. Rodriguez wrote:
> On Tue, Jun 10, 2014 at 5:11 PM, Ben Greear <greearb@candelatech.com> wrote:
>> I have a Fedora 19 system with two ath10k NICs in them.  I'm not sure
>> they have any regulatory info in them at all, based on logs
>> and some poking at what firmware reports.
>>
>> I have /etc/sysconfig/regdomain set to:
>>
>> COUNTRY=US
> 
> I don't know who thought adding a sysconfig / default file with
> regdomain with a value specified would be a good idea but users should
> then just be aware that user regulatory settings *help* compliance
> further, specially with cards that have regulatory stuff designed into
> it, like ath5k, ath9k and ath10k.

Otherwise, the OS tries to use time-zone, so one way or another
it's getting user-configurables off of the disk.

My ath10k cards are pre FCC approved (beta-ish NICs), so maybe
that is why they have no regulatory info in them.

And, I'm making test gear...I'm not just trying to use my
laptop at a coffee shop.  I understand why regulatory stuff
exists, I just need to set up a specific test to try to
debug some ath10k firmware problems.

> There is one caveat too -- Atheros sells 802.11 cards to manufacturers
> and for some time and maybe still today they set the regulatory domain
> to 0x0 and override the regulatory setting in software since this is
> economically cheaper than overriding it through changing the EEPROM /
> OTP / whatever. This is actually not allowed in certain countries like
> the US and JP, and what makes this worse is that the 0x0 regulatory
> domain maps to the US on the ath module given that that is what is
> designed by Atheros for STAs so that is what we do for ath. AP
> manufacturers have the regulatory onus on them though -- so Atheros
> cannot control what they do -- they can only provide EEPROM tools,
> etc, and if folk are doing stupid things in software or using software
> to do sloppy things -- Atheros needs to educate customers that that is
> not a feature that is supported, and actually issue a bulletin on it,
> otherwise boneheads that have been doing it for a long time will not
> change.
> 
> In short don't use the userspace stuff to set the regulatory domain
> and use the OTP / EEPROM tools to set it. Setting it in software is
> not allowed explicitly at least by the US and JP. It may be allowed in
> other countries and if your country has that option you can look at
> the ath module for some kconfig options I added before leaving Atheros
> that enables some of this functionality for those countries.
> 
> Apart from all this -- the fact that you get an intersection for all
> reg hints going for US seems rather odd and should not be happening,
> specially since if a regdomain was set to US then -EALREADY should be
> issued and that regulatory domain should just be used to set onto the
> cards (if the cards had an EEPROM / OTP thing with US). Even if the
> user sets US twice, -EALREADY and the implications of it should
> happen.

I'll try the patch Janusz suggested, maybe that will fix the problem.

For what it's worth, I added a wrapper to replace /sbin/regdb and printed
out the value of COUNTRY before calling the original regdb.  On the troubled
system, it was:  00, US, US, US, US

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

