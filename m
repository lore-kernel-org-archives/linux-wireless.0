Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:50366 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756116Ab3JRPxF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Oct 2013 11:53:05 -0400
Received: by mail-pd0-f177.google.com with SMTP id p10so2506969pdj.22
        for <linux-wireless@vger.kernel.org>; Fri, 18 Oct 2013 08:53:04 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 18 Oct 2013 17:53:04 +0200
Message-ID: <CAA2SeNJRSPB=Hus8y1bYJ-O1Hgkd=gvNhUKnF9atqwuhd2m0aA@mail.gmail.com> (sfid-20131018_175309_515717_CA129EC3)
Subject: Active scanning on DFS channels
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

According to regdb.txt, DFS channels are not marked with passive scan flag:

country US: DFS-FCC
        (2402 - 2472 @ 40), (3, 27)
        (5170 - 5250 @ 80), (3, 17)
        (5250 - 5330 @ 80), (3, 20), DFS
        (5490 - 5600 @ 80), (3, 20), DFS
        (5650 - 5710 @ 40), (3, 20), DFS
        (5735 - 5835 @ 80), (3, 30)

Therefore STA device will perform active scanning on DFS channels even
if the channel is not CAC checked and available yet. Should we perform
passive scan on radar channel setting new state to SCAN_DECISION and
not to SCAN_SEND_PROBE in ieee80211_scan_state_set_channel()?

Regards,
Lorenzo

-- 
UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
umount; make clean; sleep
