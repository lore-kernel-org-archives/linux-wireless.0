Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dub004-omc2s20.hotmail.com ([157.55.1.159]:64936 "EHLO
	DUB004-OMC2S20.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754531AbaLVLqL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Dec 2014 06:46:11 -0500
Message-ID: <DUB128-W349A3B10344867963C960C9C560@phx.gbl> (sfid-20141222_124619_550350_970E299C)
From: David Binderman <dcb314@hotmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: linux-3.19-rc1 wireless bug report
Date: Mon, 22 Dec 2014 11:41:03 +0000
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello there,

drivers/net/wireless/mac80211_hwsim.c:2152:59: warning: loop exit may only be reached after undefined behavior [-Waggressive-loop-optimizations]

Source code is

        for (i = 0; hwsim_world_regdom_custom[i] != param->regd &&
             i < ARRAY_SIZE(hwsim_world_regdom_custom); i++)
            ;

Suggest sanity check i against ARRAY_SIZE *before* using it to index hwsim_world_regdom_custom

Regards

David Binderman

 		 	   		  