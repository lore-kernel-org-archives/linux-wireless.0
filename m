Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f171.google.com ([209.85.223.171]:36050 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869Ab3FPB7T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Jun 2013 21:59:19 -0400
Received: by mail-ie0-f171.google.com with SMTP id qd12so4345045ieb.2
        for <linux-wireless@vger.kernel.org>; Sat, 15 Jun 2013 18:59:19 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 15 Jun 2013 18:59:18 -0700
Message-ID: <CAG=xfvMhPPYvDC92vHEFqeR+wZAUghuMximcTr0HCvng7h1idQ@mail.gmail.com> (sfid-20130616_035922_595216_C91D0C94)
Subject: Lose connection on changing AP channel width
From: Zhe Wen <zhewen08@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Developers!

I am trying to change channel type/width (HT20/HT40+) on the both STA
and AP side in a simple system consists of only 1 STA and the AP.

AP is started using hostapd under HT20 and STA thereafter connects to
it using also HT20. But when AP changes its channel type to HT40+
using ieee80211_set_channel_type() and ath9k_hw_set_channel_regs(), it
will lose connection to STA. The way I do channel type change
coordination is: STA sends an action frame to AP, AP sends back ACK
frame and changes its channel type; STA changes its channel type on
receiving the ACK.

I read about this solution
(http://eznemegy.blog.hu/2008/12/14/using_rt2x00_wireless_driver_with_hostapd/fullcommentlist/1)
of hacking into hostapd, which didn't work...

It would be great if you more experienced would love to help me with
this problem!

Thanks in advance!!
Zhe

--
Zhe Wen
