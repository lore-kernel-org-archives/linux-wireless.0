Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:65404 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373Ab3KUPPV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Nov 2013 10:15:21 -0500
Received: by mail-wg0-f49.google.com with SMTP id x12so914608wgg.16
        for <linux-wireless@vger.kernel.org>; Thu, 21 Nov 2013 07:15:19 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 21 Nov 2013 10:15:19 -0500
Message-ID: <CAJt7DwxmhhofxMHRKrsF-esPWF_7uF7r1AG=p4cY2Rnd+BNrPg@mail.gmail.com> (sfid-20131121_161525_243707_B37F614D)
Subject: Long Authentication Times
From: Michael McElroy <mikem388@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Let me start out with I have no prior experience with wifi before
starting this project. I have worked months trying to resolve this
problem and finally asking for help.
I have a Ralink 3070 usb doggle on an embedded ARM device. The device
is using the 2.6.29 kernel. I have used the backport.org release to
backport the driver and related networking pieces from 3.9. I am using
version 2.0 of the wpa_supplicant. Everything works fine in steady
state mode. My problem is when using wpa2 eap-peap I have trouble
authenticating, The system sometimes takes 10-20 minutes to
authenticate. I also cherry-picked commit
6211dd12da609bc6893b9c3182630b494737ec4b for mlme.c but it didn't help
the authentication problem.

Thanks in advance for taking the time to look at this.

Regards,
Mike

wlan0: authenticate with 00:19:92:06:8e:82
wlan0: direct probe to 00:19:92:06:8e:82 (try 1/3)
cfg80211: Calling CRDA to update world regulatory domain
wlan0: send auth to 00:19:92:06:8e:82 (try 2/3)
wlan0: authenticated
wlan0: authenticate with 00:19:92:07:95:22
wlan0: send auth to 00:19:92:07:95:22 (try 1/3)
wlan0: authenticated
wlan0: associate with 00:19:92:07:95:22 (try 1/3)
wlan0: RX AssocResp from 00:19:92:07:95:22 (capab=0x431 status=0 aid=2)
wlan0: associated
wlan0: deauthenticated from 00:19:92:07:95:22 (Reason: 2)
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with 00:19:92:06:8e:82
wlan0: send auth to 00:19:92:06:8e:82 (try 1/3)
wlan0: authenticated
wlan0: associate with 00:19:92:06:8e:82 (try 1/3)
wlan0: RX AssocResp from 00:19:92:06:8e:82 (capab=0x431 status=0 aid=3)
wlan0: associated
wlan0: deauthenticated from 00:19:92:06:8e:82 (Reason: 2)
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with 00:19:92:07:78:c2
wlan0: send auth to 00:19:92:07:78:c2 (try 1/3)
wlan0: authenticated
wlan0: associate with 00:19:92:07:78:c2 (try 1/3)
wlan0: RX AssocResp from 00:19:92:07:78:c2 (capab=0x431 status=0 aid=2)
wlan0: associated
wlan0: deauthenticated from 00:19:92:07:78:c2 (Reason: 1)
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with 00:19:92:07:95:22
wlan0: send auth to 00:19:92:07:95:22 (try 1/3)
wlan0: authenticated
wlan0: associate with 00:19:92:07:95:22 (try 1/3)
wlan0: RX AssocResp from 00:19:92:07:95:22 (capab=0x431 status=0 aid=2)
wlan0: associated
wlan0: deauthenticated from 00:19:92:07:95:22 (Reason: 2)
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with 00:19:92:06:8e:82
wlan0: send auth to 00:19:92:06:8e:82 (try 1/3)
wlan0: send auth to 00:19:92:06:8e:82 (try 2/3)
wlan0: authenticated
wlan0: associate with 00:19:92:06:8e:82 (try 1/3)
wlan0: RX AssocResp from 00:19:92:06:8e:82 (capab=0x431 status=0 aid=5)
wlan0: associated
wlan0: deauthenticated from 00:19:92:06:8e:82 (Reason: 6)
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with 00:19:92:07:95:22
wlan0: send auth to 00:19:92:07:95:22 (try 1/3)
wlan0: authenticated
wlan0: associate with 00:19:92:07:95:22 (try 1/3)
wlan0: RX AssocResp from 00:19:92:07:95:22 (capab=0x431 status=0 aid=2)
wlan0: associated
wlan0: deauthenticated from 00:19:92:07:95:22 (Reason: 2)
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with 00:19:92:07:78:c2
wlan0: send auth to 00:19:92:07:78:c2 (try 1/3)
wlan0: authenticated
wlan0: associate with 00:19:92:07:78:c2 (try 1/3)
wlan0: RX AssocResp from 00:19:92:07:78:c2 (capab=0x431 status=0 aid=2)
wlan0: associated
wlan0: deauthenticating from 00:19:92:07:78:c2 by local choice (reason=3)
cfg80211: Calling CRDA to update world regulatory domain
wlan0: authenticate with 00:19:92:06:8e:82
wlan0: send auth to 00:19:92:06:8e:82 (try 1/3)
wlan0: authenticated
wlan0: associate with 00:19:92:06:8e:82 (try 1/3)
wlan0: RX AssocResp from 00:19:92:06:8e:82 (capab=0x431 status=0 aid=8)
wlan0: associated
wlan0: deauthenticated from 00:19:92:06:8e:82 (Reason: 2)
