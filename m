Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:41767 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754044AbYKDWbf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2008 17:31:35 -0500
Message-ID: <4910CD42.4010402@lwfinger.net> (sfid-20081104_233138_181183_BC23FB20)
Date: Tue, 04 Nov 2008 14:31:30 -0800
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
CC: linux-wireless@vger.kernel.org,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>,
	Andrea Merello <andrea.merello@gmail.com>
Subject: Re: [RFC/RFT PATCH v2 2/2] rtl8187: feedback transmitted packets
 using tx close descriptor for 8187B
References: <1225806649-10050-1-git-send-email-herton@mandriva.com.br> <1225806649-10050-3-git-send-email-herton@mandriva.com.br>
In-Reply-To: <1225806649-10050-3-git-send-email-herton@mandriva.com.br>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Herton Ronaldo Krzesinski wrote:
> Realtek 8187B has a receive command queue to feedback beacon interrupt
> and transmitted packet status. Use it to feedback mac80211 about status
> of transmitted packets. Unfortunately in the course of testing I found
> that the sequence number reported by hardware includes entire sequence
> control in a 12 bit only field, so a workaround is done to check only
> lowest bits.
> 
> Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>

Tested-by: Larry Finger <Larry.Finger@lwfinger.net>


Quilt shows the following warning:

Warning: trailing whitespace in lines 438,468 of drivers/net/wireless/rtl8187_dev.c

scripts/checkpatch shows the following:

WARNING: line over 80 characters
#138: FILE: drivers/net/wireless/rtl8187_dev.c:475:
+                       if ((le16_to_cpu(ieee80211hdr->seq_ctrl) & 0xFFF) == seq_no)

total: 0 errors, 1 warnings, 173 lines checked

Larry
