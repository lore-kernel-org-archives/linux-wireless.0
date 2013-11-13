Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:6363 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652Ab3KMLMV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 06:12:21 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: TCP TSQ regression affecting ath10k throughput
Date: Wed, 13 Nov 2013 13:12:15 +0200
Message-ID: <87ob5o7dyo.fsf@kamboji.qca.qualcomm.com> (sfid-20131113_121231_823583_24C816E9)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Sujith reported a regression in TCP which caused a major decrease in
ath9k and ath10k throughput:

http://thread.gmane.org/gmane.linux.network/290269

The commit which broke this is c9eeec26e32e ("tcp: TSQ can use a dynamic
limit") and this patch seems to fix it:

http://patchwork.ozlabs.org/patch/290672/

I have cherry picked the fix to ath.git master branch to make it easier
for ath10k developers.

-- 
Kalle Valo
