Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51743 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427Ab1ALIIJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jan 2011 03:08:09 -0500
Received: by wwa36 with SMTP id 36so325208wwa.1
        for <linux-wireless@vger.kernel.org>; Wed, 12 Jan 2011 00:08:07 -0800 (PST)
MIME-Version: 1.0
From: Joe Hershberger <joe.hershberger@gmail.com>
Date: Wed, 12 Jan 2011 02:07:47 -0600
Message-ID: <AANLkTimcx+BvmhbuwhyTabgsDA=WiGY3V_Yk8uGdQ2aR@mail.gmail.com>
Subject: Regulatory Domain: User hint + Driver hint
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

>From reading http://wireless.kernel.org/en/developers/Regulatory/processing_rules
I am under the impression that the Driver hint gives the driver an
opportunity to "lock" the card to a specific regdom based on its
EEPROM.  Then any regdom set as a User hint (via "iw reg set ??" or
wpa_supplicant) would be the intersection of the Driver hint and the
User hint.

What I'm seeing from the cfg80211 dbg prints is that the User hint
simply overrides the Driver hint ("cfg80211: Regulatory domain changed
to country").  I also don't see what looks like an intersection when
comparing the resulting rules... it looks like a replacement.

Looking at the code in net/wireless/reg.c in the ignore_request
function, only if (last_request->initiator ==
NL80211_REGDOM_SET_BY_COUNTRY_IE) return REG_INTERSECT;  This seems to
disagree with the document.  Am I simply misinterpreting the code or
is it broken as is?

Any enlightenment would be greatly appreciated.

I'm using Kernel.org 2.6.35 with ath5k 802.11 PCI card.

Thanks,
-Joe
