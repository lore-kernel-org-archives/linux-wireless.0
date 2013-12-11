Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:41638 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab3LKPIF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Dec 2013 10:08:05 -0500
Message-ID: <52A87FBD.4000901@candelatech.com> (sfid-20131211_160809_550133_AC3957F1)
Date: Wed, 11 Dec 2013 07:07:41 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Question on software-crypt mode.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

I am trying to implement software-crypt for ath10k so that it can do crypt
with multiple stations connected to same AP.

I tried using ath9k's approach and just not setting keys, but that does not work at all
(no stations can communicate).

If I basically leave code as is, then secondary stations can associate but never
get DHCP.  I see FCS and hw-crypt errored packets being received from the
ath10k firmware/chip.  This is probably because the chip/firmware decodes the
secondary station's packets with the first station's keys.
Transmitted packets (as sniffed from the AP) do appear fine.

I was thinking to just take all fcs and/or crypt-errored packets in
the receive path and somehow send them up the stack for the software-crypt
layer to (re)decrypt.  I think I have managed to get ath10k to send them
up, but still DHCP does not complete.

Does anyone have any suggestions for things to try or code to look at in
detail?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

