Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:54591 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812AbcABPMg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jan 2016 10:12:36 -0500
Subject: net-rsi: Reconsider usage of variable "vap_id" in rsi_send_mgmt_pkt()
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Kalle Valo <kvalo@codeaurora.org>
References: <566ABCD9.1060404@users.sourceforge.net>
 <5687E169.4070704@users.sourceforge.net>
 <5687E203.1070404@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <5687E8DB.3080706@users.sourceforge.net> (sfid-20160102_161257_489832_072E8800)
Date: Sat, 2 Jan 2016 16:12:27 +0100
MIME-Version: 1.0
In-Reply-To: <5687E203.1070404@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I have taken another look at the implementation of the function "rsi_send_mgmt_pkt".
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/drivers/net/wireless/rsi/rsi_91x_pkt.c?id=e8c58e7a5a106c3d557fccd01cd4d1128f9bab38#n114

I find the following statement combination interesting there.

…
	u8 vap_id = 0;
…
	msg[7] |= cpu_to_le16(vap_id << 8);
…

I would appreciate a further clarification.
Does a shift operation for a variable which contains zero indicate an open issue?

Regards,
Markus
