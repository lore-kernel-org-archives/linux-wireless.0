Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from netsys.kaist.ac.kr ([143.248.239.50]:47705 "EHLO
	netsys.kaist.ac.kr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197AbZITQeL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Sep 2009 12:34:11 -0400
Received: from JinsungLeePC (netsys30.kaist.ac.kr [143.248.239.70])
	by netsys.kaist.ac.kr (8.13.1/8.13.1) with ESMTP id n8KGW82J021751
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2009 01:32:08 +0900
From: "Jinsung Lee" <ljs@netsys.kaist.ac.kr>
To: <linux-wireless@vger.kernel.org>
Subject: FW: Question about carrier sensing
Date: Mon, 21 Sep 2009 01:34:14 +0900
Message-ID: <0ef401ca3a10$30dc6b80$92954280$@kaist.ac.kr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear all,

Actually, I realized that the CW value must be assigned in a power of 2,
minus 1, e.g., 1,3,7,...,1023.
So, CW=0 seems to be equal to CW=1 in the chipset. 
I tested with above cases and observed the same performance. Am I correct?
If so, the below phenomenon is resolved easily.
Please give your knowledge to me.
Thanks.


--
Regards,
Jinsung Lee
--


-----Original Message-----
From: linux-wireless-owner@vger.kernel.org
[mailto:linux-wireless-owner@vger.kernel.org] On Behalf Of Jinsung Lee
Sent: Sunday, September 20, 2009 1:43 PM
To: linux-wireless@vger.kernel.org
Subject: Question about carrier sensing

Hi, all.


I'm experimenting using MadWifi driver and Wistron CM6/CM9 cards, which all
use the Atheros chipset.
But, I found that there is some strange phenomenon on carrier sensing, which
doesn't follow the standard.
I let the two nearby transmitters just transmit the packets: one transmitter
has zero cw value and the other has positive cw values: 10, 100, 1000 where
cw is the maximum contention window size, thus the device selects the
backoff counter randomly from [0, cw].
If the carrier sensing really works, we would observe that the transmitter
with zero cw value takes all while the other don't at all, right?
Interestingly, the experimental result shows that the transmitter with
positive value has very infrequent but chances to transmit once in a while
during the whole experiment, and further the larger cw value, the much less
chance the transmitter has to transmit. So, it seems to work though.
Do you have any idea or similar experience?
Thanks.


--
Regards,
Jinsung Lee
--



--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

