Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [199.83.51.51] ([199.83.51.51]:51352 "EHLO mantis.wzyboy.im"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751515AbaGKHOi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jul 2014 03:14:38 -0400
Received: from mail-ie0-f180.google.com (mail-ie0-f180.google.com [209.85.223.180])
	by mantis.wzyboy.im (Postfix) with ESMTPSA id E509188047
	for <linux-wireless@vger.kernel.org>; Fri, 11 Jul 2014 15:06:58 +0800 (CST)
Received: by mail-ie0-f180.google.com with SMTP id at20so579589iec.11
        for <linux-wireless@vger.kernel.org>; Fri, 11 Jul 2014 00:06:57 -0700 (PDT)
MIME-Version: 1.0
From: Sascha Weaver <wzyboy@wzyboy.org>
Date: Fri, 11 Jul 2014 15:06:41 +0800
Message-ID: <CALkVjQbNMNs__LsNG450fCpTNmAR3kfDFn2o7xxrdLjSi1wu=w@mail.gmail.com> (sfid-20140711_091442_936210_1202913D)
Subject: [iwlwifi] Wireless-AC 7260 disconnects every half and hour
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I recently bought an Intel Wireless-AC 7260 (Dual band) to replace my
Intel Wireless-N 7260.

The new wireless card connects to 5 GHz nicely and provides good
performance. However, it disconnects every half and hour. It will
automatically reconnects, but the process takes ten seconds or more,
during which all my network connections are lost (route table is
reset, I think).

My old Wireless-N 7260 does not act like this. Is there something I
can do to speed up the re-association process (which happens half an
hour) and prevent connection lost during the process?


Here is a part of the dmesg. You can see it disconnects every half an hour.

Jul 09 10:45:48 xenien kernel: wlan0: deauthenticated from
c0:7b:bc:1a:85:ff (Reason: 2=PREV_AUTH_NOT_VALID)
Jul 09 10:45:48 xenien kernel: cfg80211: Calling CRDA for country: CN
Jul 09 10:45:52 xenien kernel: wlan0: authenticate with c0:7b:bc:1a:54:bf
Jul 09 10:45:52 xenien kernel: wlan0: send auth to c0:7b:bc:1a:54:bf (try 1/3)
Jul 09 10:45:52 xenien kernel: wlan0: authenticated
Jul 09 10:45:52 xenien kernel: wlan0: associate with c0:7b:bc:1a:54:bf (try 1/3)
Jul 09 10:45:52 xenien kernel: wlan0: RX AssocResp from
c0:7b:bc:1a:54:bf (capab=0x11 status=0 aid=160)
Jul 09 10:45:52 xenien kernel: wlan0: associated
Jul 09 11:16:02 xenien kernel: wlan0: deauthenticated from
c0:7b:bc:1a:54:bf (Reason: 2=PREV_AUTH_NOT_VALID)
Jul 09 11:16:02 xenien kernel: cfg80211: Calling CRDA to update world
regulatory domain
Jul 09 11:16:05 xenien kernel: wlan0: authenticate with 18:9c:5d:97:8d:2f
Jul 09 11:16:05 xenien kernel: wlan0: send auth to 18:9c:5d:97:8d:2f (try 1/3)
Jul 09 11:16:05 xenien kernel: wlan0: authenticated
Jul 09 11:16:05 xenien kernel: wlan0: associate with 18:9c:5d:97:8d:2f (try 1/3)
Jul 09 11:16:05 xenien kernel: wlan0: RX AssocResp from
18:9c:5d:97:8d:2f (capab=0x11 status=0 aid=54)
Jul 09 11:16:05 xenien kernel: wlan0: associated
Jul 09 11:46:15 xenien kernel: wlan0: deauthenticated from
18:9c:5d:97:8d:2f (Reason: 2=PREV_AUTH_NOT_VALID)
Jul 09 11:46:15 xenien kernel: cfg80211: Calling CRDA to update world
regulatory domain
Jul 09 11:46:18 xenien kernel: wlan0: authenticate with c0:7b:bc:1a:75:6f
Jul 09 11:46:18 xenien kernel: wlan0: send auth to c0:7b:bc:1a:75:6f (try 1/3)
Jul 09 11:46:18 xenien kernel: wlan0: authenticated
Jul 09 11:46:18 xenien kernel: wlan0: associate with c0:7b:bc:1a:75:6f (try 1/3)
Jul 09 11:46:18 xenien kernel: wlan0: RX AssocResp from
c0:7b:bc:1a:75:6f (capab=0x11 status=0 aid=86)
Jul 09 11:46:18 xenien kernel: wlan0: associated



-- 
Sascha Weaver
