Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f171.google.com ([209.85.216.171]:33568 "EHLO
        mail-qt0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752059AbdHHSVC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Aug 2017 14:21:02 -0400
Received: by mail-qt0-f171.google.com with SMTP id a18so24441808qta.0
        for <linux-wireless@vger.kernel.org>; Tue, 08 Aug 2017 11:21:02 -0700 (PDT)
MIME-Version: 1.0
From: Jacobo Pantoja <jacobopantoja@gmail.com>
Date: Tue, 8 Aug 2017 20:20:40 +0200
Message-ID: <CAO18KQjGKEf5wn2B5MLptyZN12+XpKxfHfL9Q1Jz-3pMpTgU+Q@mail.gmail.com> (sfid-20170808_202106_773323_84FA72FC)
Subject: RTS threshold not being obeyed
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm having a hard time to figure out why RTS/CTS are happening in my network.
In a nutshell, I'm using two identical OpenWRT routers to stablish a
WDS link (4address mode) in 5GHz, with no other client nor AP in 5GHz.
The problem is, a great amount of bandwidth is being consumed by
RTS/CTSs.

The point is, I'm pretty sure RTS threshold is disabled (set to -1);
I've checked in hostapd configuration, as well as in the debugfs of
the phy itself, being reported as -1.

The device in question is TPLINK WDR4300, radio device AR9582
(168c:0033, subsystem 168c:a120), using driver ath9k. I'm using
current LEDE 17.01.2, r3435-65eec8bd5f, kernel 4.4.71.

I'm able to see RTS/CTS over the air (using Wireshark in a third
device), but i can as well see an increasing number in
/sys/kernel/debug/ieee80211/phy1/statistics/dot11RTSSuccessCount
If I set RTS threshold (using iw, checking its value in debugfs) to a
very low number (e.g. 50) I can see the counter increasing quite
faster.

I'm not sure if this is the expected behaviour (e.g. the underlying
hardware is deciding by its own to do some RTS/CTS) or it is a bug.

Can I make some further testing to clarify this?

Thanks!
JPantoja
