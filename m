Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:46900 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753161AbYILRh2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2008 13:37:28 -0400
Message-ID: <48CAA8D6.1030605@lwfinger.net> (sfid-20080912_193732_617417_711F79A6)
Date: Fri, 12 Sep 2008 12:37:26 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: The new regulatory code kills my wireless
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After pulling the latest git from wireless-testing, my wireless 
failed. I bisected this to be commit 
544ec9a11fdef5142a76a8eb4b186a80a272c035, "cfg80211: Add new wireless 
regulatory infrastructure". I have not yet implemented CRDA, thus I 
selected the CONFIG_WIRELESS_OLD_REGULATORY option.

The symptoms are that my devices (b43 and p54usb) receive no scan 
information.

The pertinent dmesg output follows:

cfg80211: Using old static regulatory domain:
cfg80211: Regulatory domain: US
         (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
         (239200 KHz - 248200 KHz @ 4000 KHz), (600 mBi, 2700 mBm)
         (516000 KHz - 520000 KHz @ 4000 KHz), (600 mBi, 2300 mBm)
         (518000 KHz - 522000 KHz @ 4000 KHz), (600 mBi, 2300 mBm)
         (520000 KHz - 524000 KHz @ 4000 KHz), (600 mBi, 2300 mBm)
         (522000 KHz - 534000 KHz @ 4000 KHz), (600 mBi, 2300 mBm)
         (572500 KHz - 584500 KHz @ 4000 KHz), (600 mBi, 3000 mBm)
cfg80211: Calling CRDA for country: US

Thanks,

Larry
