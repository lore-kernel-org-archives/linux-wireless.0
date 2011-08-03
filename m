Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:37655 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691Ab1HCO3o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Aug 2011 10:29:44 -0400
Received: by qyk38 with SMTP id 38so189466qyk.19
        for <linux-wireless@vger.kernel.org>; Wed, 03 Aug 2011 07:29:43 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 3 Aug 2011 16:29:43 +0200
Message-ID: <CANXYrmDKMracGuUKY4HWmAdoc_sa19fGXO8J+EqcNkMs5+k2Fg@mail.gmail.com> (sfid-20110803_162957_497084_B9F5D01E)
Subject: trying to implement the HCF
From: =?ISO-8859-1?Q?Manuel_S=E1ez?= <manuelsaezr@gmail.com>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I am trying to implement the HCF with a AR9280 chip. I already changed
the beacons in order to include the 'CF parameter set' every n DTIM. I
was glad to discover that after this message the AR_NAV register was
automatically updated  with the information of the "CFP duration
remaining" and the driver started to buffer the new outgoing frames. I
was not able to find where this is done in the driver so I guess it is
a hardware thing. Please correct me if I am wrong. The bad news are
that the driver/hardware updates the register in the next beacon (that
is not that bad for me for the moment, I will try to change the
register manually later).

I got to send the first CF-poll just after the DTIM that indicates the
start of a CFP. I just saw the procedure for the CAB traffic and used
the flag IEEE80211_TX_CTL_SEND_AFTER_DTIM. The next step I would like
to try is to prepare the next CF-poll frame in order to send it SIFS
after the answer or PIFS if no answer arrived. I configured the fourth
queue to use it with this kind of traffic. Is is possible to schedule
the transmission of one frame? I tried to have a look at the tx
descriptors in the code and in the web, but I don't understand them
(there is no much information and unfortunately I am far from being a
linux expert). Any advice?

Sorry for my english, the more german I learn, the less english I can :-p.

Thank you in advance
