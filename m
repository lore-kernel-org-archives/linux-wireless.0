Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:13073 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857Ab2DBCfE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Apr 2012 22:35:04 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20345.4134.204942.124914@gargle.gargle.HOWL> (sfid-20120402_043546_307028_E7FAF52A)
Date: Mon, 2 Apr 2012 08:04:14 +0530
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Kernel Panics from ath9k
In-Reply-To: <4F789C57.2090903@lwfinger.net>
References: <4F789C57.2090903@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:
> A few weeks ago, I was trying to help an inexperienced user on the openSUSE 
> Wireless Forum who was having "crashes" caused by his AR9285 device. The crash 
> turned out to be a kernel panic. As expected, I was not able to help him, and I 
> ordered one of these cards through E-bay. It just arrived, and I am able to 
> duplicate the panics. For me, they occur when changing from a WPA2-encrypted AP 
> to one with WPA encryption. When switching from WPA2 to WEP, the NULL 
> dereference does not occur; however, the connection fails.
> 
> I captured enough info from the debugging console to know that the panic results 
> from "BUG: unable to handle kernel NULL pointer dereference at (null)" that 
> originates at ath_tx_start+0x2c0/0x4b0. The kernel is x86_64 and I am currently 
> testing kernel v3.4-rc1-214-g1ac7a92 from Linus's tree. I have not yet tested 
> the wireless-testing tree, but I do not see any commits there that appear to 
> address this issue.

Should be fixed by this patch: http://marc.info/?l=linux-wireless&m=133282325727326&w=2

Sujith
