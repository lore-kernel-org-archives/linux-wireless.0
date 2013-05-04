Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:58400 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753766Ab3EDGus (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 May 2013 02:50:48 -0400
Received: from mailout-de.gmx.net ([10.1.76.29]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0MQbf1-1V0JVD2k7J-00U6RX for
 <linux-wireless@vger.kernel.org>; Sat, 04 May 2013 08:50:46 +0200
Message-ID: <5184AFC2.8060101@rempel-privat.de> (sfid-20130504_085102_488714_1272B4B4)
Date: Sat, 04 May 2013 08:50:42 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: Felix Fietkau <nbd@openwrt.org>, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] [PATCH 1/2] ath9k_htc: add STBC TX support
References: <1367482308-9882-1-git-send-email-linux@rempel-privat.de> <1367482308-9882-2-git-send-email-linux@rempel-privat.de> <CAJ-Vmo=rZrHmXD0Os-Mb40jSEywbO-7GHSqL=7iMbkzAfS=+UQ@mail.gmail.com> <5182A341.8050704@rempel-privat.de> <5182A9DC.6030203@openwrt.org> <CAJ-Vmo=XYK=Jkc40U_vJO03n+tiA_LDpw8e1QKYRX6-+E9o4fA@mail.gmail.com>
In-Reply-To: <CAJ-Vmo=XYK=Jkc40U_vJO03n+tiA_LDpw8e1QKYRX6-+E9o4fA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 02.05.2013 22:15, schrieb Adrian Chadd:
> Well, let's dig into the firmware a bit more and tidy up how STBC is handled.

Does it mean, i should change this patch and provide a patch for 
firmware too?
I still do not think, changing peer caps i a good idea in any case.
I mena this part of patch:
+               if (sta->ht_cap.cap & IEEE80211_HT_CAP_TX_STBC)
+                       caps |= WLAN_RC_TX_STBC_FLAG;


Behaviour with this patch will be fallowing:
- peer provide caps, even if it is RX-STBC12
- we pass this information to firmware and ratecontroller of FW, do 
right decision based on hardware it has.

You suggestion, if i understand it correctly, is to filter caps:
- if peer provide more than we can, we should tell firmware the value 
what we can. So, if peer say it can RX-STBC12, we should tell firmware 
that peer is RX-STBC1.
In my opinion, this kind of filter is a source for hidden errors.
-- 
Regards,
Oleksij
