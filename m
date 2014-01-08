Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:33950 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbaAHSgz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jan 2014 13:36:55 -0500
Message-ID: <52CD9AAF.1040407@candelatech.com> (sfid-20140108_193658_955410_CA0D38CD)
Date: Wed, 08 Jan 2014 10:36:31 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: ath10k@lists.infradead.org
Subject: How to make software re-calc received frames with bad FCS?
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm back to trying to get multiple stations working to same AP
with WPA2 on ath10k.

I tried  doing 'nohwcrypt', but I had no luck with that.  I think
the firmware would require a fair bit of changes to make that happen.

So, a second plan is to just tell the firmware to use hardware crypt
for the VIFs.  This would have a good benefit of offloading the tx
path, at least.

This seems to work for transmit, but on receive, the hardware hash
collides since 2+ stations have same peer (ie, the AP).

I do receive packets, but they are flagged with FCS errors (and I think
there is no re-assembly of ampdu, but I'm not sure how much that matters).

My thought is to somehow flag these packets as needing to be decrypted
by software instead, similar to how the normal nohwcrypt logic works.

Any suggestions for how to go about attempting this?   Maybe
just force remove the CRC failure bit from the status before
passing up the stack?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

