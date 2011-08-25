Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:38463 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750827Ab1HYJ24 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 05:28:56 -0400
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, chunkeey@googlemail.com
Subject: car9170: undefined reference to `__udivdi3'
From: Kalle Valo <kvalo@adurom.com>
Date: Thu, 25 Aug 2011 12:28:51 +0300
Message-ID: <87aaaxon58.fsf@purkki.adurom.net> (sfid-20110825_112904_469947_F18AC5BA)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

carl9170 fails to compile on wireless-testing when I compile a 32 bit
kernel:

drivers/built-in.o: In function `carl9170_collect_tally':
/home/kvalo/ath6kl/ath6kl/drivers/net/wireless/ath/carl9170/cmd.c:191:
undefined reference to `__udivdi3'
/home/kvalo/ath6kl/ath6kl/drivers/net/wireless/ath/carl9170/cmd.c:192:
undefined reference to `__udivdi3'
/home/kvalo/ath6kl/ath6kl/drivers/net/wireless/ath/carl9170/cmd.c:193:
undefined reference to `__udivdi3'

Reverting this patch fixes the issue:

commit acf1771221f2877ab5d36487930cd6a2ecaa73e6
Author: Christian Lamparter <chunkeey@googlemail.com>
Date:   Mon Aug 15 19:50:48 2011 +0200

    carl9170: improve site survey

-- 
Kalle Valo
