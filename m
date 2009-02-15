Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:44454 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679AbZBONn1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Feb 2009 08:43:27 -0500
Received: by yx-out-2324.google.com with SMTP id 8so839903yxm.1
        for <linux-wireless@vger.kernel.org>; Sun, 15 Feb 2009 05:43:25 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 15 Feb 2009 15:43:25 +0200
Message-ID: <55c333c0902150543m6bc92789n3d299cf26e65236@mail.gmail.com> (sfid-20090215_144331_648583_009E8672)
Subject: cfg80211_wext_siwmode() strange behaviour
From: Kevin Wilson <wkevils@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I had tried to set an rt73usb-based nic to work in secondary mode
(NL80211_IFTYPE_AP_VLAN)
by "iwconfig wlan3 mode secondary". (according to "man iwconfig", this
operation is supported).

I get:

Error for wireless request "Set Mode" (8B06) :
    SET failed on device wlan3 ; Invalid argument.

I traced the problem to cfg80211_wext_siwmode() method; (wext-compat.c)
I see that when IW_MODE_SECOND is passed, it returns -EINVAL;
according to this, you cannot set up a nic to IW_MODE_SECOND
(NL80211_IFTYPE_AP_VLAN).

Nevertheless, in 		
		

		cfg80211_wext_giwmode() there is
		...
		case NL80211_IFTYPE_AP_VLAN:
			*mode = IW_MODE_SECOND;		/* FIXME */

So, maybe this should be removed at all ? or is there a different way to set
a nic to work in NL80211_IFTYPE_AP_VLAN mode ?
So, is there something wrong here? Or am I missing something ?

(I had tested it with latest wireless-testing git tree).

Regards,
Kevin
