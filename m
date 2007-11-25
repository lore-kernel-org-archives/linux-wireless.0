Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:44336 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497AbXKYKDA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Nov 2007 05:03:00 -0500
Received: by nf-out-0910.google.com with SMTP id g13so326426nfb
        for <linux-wireless@vger.kernel.org>; Sun, 25 Nov 2007 02:02:58 -0800 (PST)
Message-ID: <47494851.4070504@gmail.com> (sfid-20071125_100320_807388_F83CC956)
Date: Sun, 25 Nov 2007 11:02:57 +0100
From: drago01 <drago01@gmail.com>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
CC: Dan Williams <dcbw@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Jouni Malinen <j@w1.fi>,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	Zhu Yi <yi.zhu@intel.com>
Subject: mac80211 / iwl3945 + dynamic wep (again)
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
First  sorry for the late report, the patches from the old thread fixed 
the privacy mismatch issue and now I can connect to a dynamic wep 
network. But the connection is not very stable because I get tons of wep 
decrypt errors in dmesg (while the connection is working but slow).
The same network works fine with ipw3945. Also iwl3945 works fine with 
static wep. I tryed the hwcrypt engine (hwcrypt=1) but it did not change 
anything.
While connectiong with wpa_supplicant I saw that mac80211 does not 
support the IW_AUTH_DROP_UNENCRYPTED ioctl while ipw3945 (ieee80211 
based) does.
Could this be related? ie. mac80211 tryes to decrypt unencrypted frames 
instead of dropping them?
If not any other ideas what could cause it? Or what kind of info is needed?
Second problem is that ssid is hidden. I was able to connect to it using 
iwl3945 (even with hw_scan) but only with ap_scan=1 (while ap_scan=2 
should be used for hidden ssid and thats what nm uses). Non mac80211 
based drivers do not work with ap_scan=1 but with ap_scan=2. So this 
needs to be fixed somehow so that nm can support both wireless stacks.

