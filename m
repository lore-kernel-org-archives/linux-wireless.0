Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:57935 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932365Ab3LaBYy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Dec 2013 20:24:54 -0500
Message-ID: <52C21CE3.3020402@lwfinger.net> (sfid-20131231_022522_365399_BE5A7F2B)
Date: Mon, 30 Dec 2013 19:24:51 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Question on compiler warning
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In his regular article entitled Build regressions/improvements in v3.13-rc6" 
(http://lkml.indiana.edu/hypermail/linux/kernel/1312.3/01550.html), Geert 
Uytterhoeven reports the following warning regression:

+ /scratch/kisskb/src/drivers/net/wireless/b43/phy_n.c: warning: 'val_addr' may 
be used uninitialized in this function [-Wuninitialized]: => 178:21

This warning does not show up on any of my compilers, and it should not as the 
initialization and usage of that variable both take place in conditional 
branches that are testing exactly the same pointer.

Despite the fact that the warning is bogus, should a patch be submitted to clear 
it? I lean toward "no" as an answer because that would mask the warning if there 
were some future change that screwed up the flow; however, I wanted to check 
with the community.

Larry
