Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dub0-omc2-s6.dub0.hotmail.com ([157.55.1.145]:16236 "EHLO
	dub0-omc2-s6.dub0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753211Ab3KUJe1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Nov 2013 04:34:27 -0500
Message-ID: <DUB118-W52CD728E9F8C6348DB80219CE10@phx.gbl> (sfid-20131121_103433_309346_75E01EB9)
From: David Binderman <dcb314@hotmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: rtlwifi/rtl8188ee/dm.c:1081: possible bad if test ?
Date: Thu, 21 Nov 2013 09:28:14 +0000
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello there,

I just ran the static analyser "cppcheck" over the source code of linux-3.12

It said

[linux-3.12/drivers/net/wireless/rtlwifi/rtl8188ee/dm.c:1081] -> [linux-3.12/drivers/net/wireless/rtlwifi/rtl8188ee/dm.c:1081]: (style) Same expression on both sides of '!='.

Source code is

            if (rtldm->swing_idx_cck != rtldm->swing_idx_cck) {
                rtldm->swing_idx_cck_cur = rtldm->swing_idx_cck;
                rtldm->swing_flag_cck = true;
            }

Suggest code rework. Maybe something like

            if (rtldm->swing_idx_cck_cur != rtldm->swing_idx_cck) {
                rtldm->swing_idx_cck_cur = rtldm->swing_idx_cck;
                rtldm->swing_flag_cck = true;
            }

might be suitable.

Regards

David Binderman 		 	   		  