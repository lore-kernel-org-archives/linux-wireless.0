Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot1-f52.google.com ([209.85.210.52]:42311 "EHLO
        mail-ot1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731777AbeISSOP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 14:14:15 -0400
Received: by mail-ot1-f52.google.com with SMTP id h26-v6so5559148otl.9
        for <linux-wireless@vger.kernel.org>; Wed, 19 Sep 2018 05:36:30 -0700 (PDT)
MIME-Version: 1.0
From: Mathy Vanhoef <vanhoefm@gmail.com>
Date: Wed, 19 Sep 2018 14:36:20 +0200
Message-ID: <CAFXAJYzsmhAzSFXjmB0biTBFnU7OSWF6tdqspSqgabvx4x1stg@mail.gmail.com> (sfid-20180919_143906_441176_FD2420D5)
Subject: SAE authentication frames in client mode
To: linux-wireless <linux-wireless@vger.kernel.org>,
        Jouni Malinen <j@w1.fi>,
        Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

It seems that in client mode, the Linux kernel only accepts an
authentication frame after sending one itself. Is this interpretation
correct?

If that is the case, this would conflict with the SAE handshake as
defined in the 802.11-2016 standard. That's because when the AP
receives a Commit frame, the AP is allowed to send both a Commit and
Confirm frame (see 12.4.8.6.3). So according to the standard, the
client must accept a SAE Confirm authentication frame, even if it
hasn't yet transmitted its own Confirm frame. So this appears to be a
bug. Thoughts?

Cheers,
Mathy
