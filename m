Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:38005 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932088AbbKMA70 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2015 19:59:26 -0500
Received: from [192.168.100.149] (firewall.candelatech.com [50.251.239.81])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by mail2.candelatech.com (Postfix) with ESMTPSA id C6D2840A5CB
	for <linux-wireless@vger.kernel.org>; Thu, 12 Nov 2015 16:59:25 -0800 (PST)
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Subject: Does mac80211 guarantee no data frames are sent to driver until
 encryption is setup?
Message-ID: <564535ED.6080703@candelatech.com> (sfid-20151113_015949_741022_F03FFCE6)
Date: Thu, 12 Nov 2015 16:59:25 -0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A certain firmware tries to do EAPOL inspection and only allow data pkts
to be sent after the 4-way M4 has been sent, for instance.

This was breaking .11r because in that case you don't do the 4-way after
roaming, so the firmware was waiting forever for an M4 to be sent and
thus all tx data was hung.

I managed to get this working by just removing all of the EAPOL inspection from the firmware,
but I am thinking that if the stack will send data packets to the driver
before 4-way auth is completed and keys are set, then maybe I would
be opening up a race where un-encrypted frames could hit the air.

Any idea what protections, if any, the mac80211 stack provides
for this case?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

