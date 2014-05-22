Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:58629 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbaEVTqx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 15:46:53 -0400
Message-ID: <537E542C.7000802@candelatech.com> (sfid-20140522_214656_549306_4F117531)
Date: Thu, 22 May 2014 12:46:52 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Question on regulatory settings.
References: <537E2ABB.6030302@candelatech.com> <537E36E3.6040205@candelatech.com> <20140522183007.GE12779@tuxdriver.com>
In-Reply-To: <20140522183007.GE12779@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/22/2014 11:30 AM, John W. Linville wrote:
> On Thu, May 22, 2014 at 10:41:55AM -0700, Ben Greear wrote:
>> On 05/22/2014 09:50 AM, Ben Greear wrote:
>>> Hello!
>>>
>>> I'm having issues where when we add several ath10k NICs to a system,
>>> the regulatory domain goes quite restricted..  There is an ath9k NIC
>>> with eeprom over-ride hack, and user-space sets regdomain to 'US'.
>>>
>>> Later, when registering ath10k, at least one of those NICs registeres
>>> as 'TW'.  The ending domain looks like this:
>>>
>>> [root@lf1011-13060017 ~]# iw reg get
>>> country 98: DFS-UNSET
>>> 	(2402 - 2472 @ 40), (N/A, 30)
>>> 	(5270 - 5330 @ 40), (N/A, 17), DFS
>>> 	(5735 - 5835 @ 80), (N/A, 30)
>>>
>>>
>>> I tried adding a hack to ath10k to zero out the ar->ath_common.regulatory.current_rd,
>>> but in fact it seems to be reported as zero to begin with.
>>>
>>> I am obviously missing something.  Either my hacks to ath10k are not
>>> sufficient, or possibly the system is getting regulatory info from
>>> somewhere else?
>>>
>>> Any ideas where else it might be getting the idea it should be in TW
>>> domain?  Can it get this from beacons from other systems?
> 
> FWIW, yes it can get this information from beacons.
> 
>> Ahh, sneaky nasty code....it was being set based on the timezone
>> of all things!
> 
> You're welcome... ;-)
> 
>> Looks like you can override this behaviour with the command
>> below if you are of a mind to do so:
>>
>> echo COUNTRY=US > /etc/sysconfig/regdomain
> 
> I don't know any better way to set a reasonable default for the
> regulatory domain.  If you have other suggestions, I'd be interested
> in hearing them.

It would be nice to have something in the logs detailing the source/reason
of the configuration setting.  I mostly got lucky when searching for
the problem...even with adding a WARN_ON(1) in the kernel to catch
it, you only see that 'iw' made the change...hard to know what called iw.

I don't have a better suggestion for default config, except that maybe
if it were manually set with 'iw' already then you would not set it
again based on the timezone.  That probably wouldn't have helped me
anyway since the automated thing will be faster than any normal user,
though.

Thanks,
Ben



-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

