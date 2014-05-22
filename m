Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:56546 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbaEVQuE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2014 12:50:04 -0400
Received: from [192.168.100.236] (firewall.candelatech.com [70.89.124.249])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by mail2.candelatech.com (Postfix) with ESMTPSA id 06E2540B146
	for <linux-wireless@vger.kernel.org>; Thu, 22 May 2014 09:50:03 -0700 (PDT)
Message-ID: <537E2ABB.6030302@candelatech.com> (sfid-20140522_185013_712352_393A10EC)
Date: Thu, 22 May 2014 09:50:03 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Question on regulatory settings.
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

I'm having issues where when we add several ath10k NICs to a system,
the regulatory domain goes quite restricted..  There is an ath9k NIC
with eeprom over-ride hack, and user-space sets regdomain to 'US'.

Later, when registering ath10k, at least one of those NICs registeres
as 'TW'.  The ending domain looks like this:

[root@lf1011-13060017 ~]# iw reg get
country 98: DFS-UNSET
	(2402 - 2472 @ 40), (N/A, 30)
	(5270 - 5330 @ 40), (N/A, 17), DFS
	(5735 - 5835 @ 80), (N/A, 30)


I tried adding a hack to ath10k to zero out the ar->ath_common.regulatory.current_rd,
but in fact it seems to be reported as zero to begin with.

I am obviously missing something.  Either my hacks to ath10k are not
sufficient, or possibly the system is getting regulatory info from
somewhere else?

Any ideas where else it might be getting the idea it should be in TW
domain?  Can it get this from beacons from other systems?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

