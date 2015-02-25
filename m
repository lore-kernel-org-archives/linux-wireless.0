Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:55729 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189AbbBYSve (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2015 13:51:34 -0500
Received: from [192.168.100.236] (unknown [50.251.239.81])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by mail2.candelatech.com (Postfix) with ESMTPSA id 536A540A959
	for <linux-wireless@vger.kernel.org>; Wed, 25 Feb 2015 10:51:34 -0800 (PST)
Message-ID: <54EE19B5.9040807@candelatech.com> (sfid-20150225_195138_688914_DE56C6F2)
Date: Wed, 25 Feb 2015 10:51:33 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Question on tx-power and number of chains.
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Suppose a NIC wants to decrease TX power for certain rates based on the
number of chains (ie, subtract amount A from requested rate for 2 chains,
and B for 3 chains).

I assume the NIC wants to do this is because if the pkt is transmitted out each antenna,
then there is ~3x the power put onto the air.

Now, the question is, should this power-decrease be per rate,
and perhaps different for each rate, or can all rates use all
tx-chains (and so tx-power should be decreased the same maximum amount
based on the hardware's number of chains for each rate).

I am thinking that CCK rates can only ever be transmitted by a single
chain, so in that case those rates would not need their power decreased
from the requested?

And if that is so, what about the /a/g/ rates, and lower-speed HT/VHT
rates as well?

Is there a table somewhere that explains how many chains are used by each
rate?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

