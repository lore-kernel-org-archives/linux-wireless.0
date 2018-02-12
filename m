Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:41968 "EHLO
        mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935792AbeBLOE2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Feb 2018 09:04:28 -0500
Received: by mail-oi0-f53.google.com with SMTP id m83so11214252oik.8
        for <linux-wireless@vger.kernel.org>; Mon, 12 Feb 2018 06:04:28 -0800 (PST)
MIME-Version: 1.0
From: Daniel Drake <drake@endlessm.com>
Date: Mon, 12 Feb 2018 17:04:26 +0300
Message-ID: <CAD8Lp47D5sGCpxSiFYQviu0a62W4aj-5Sgs6sjE7E2cZWwsUwg@mail.gmail.com> (sfid-20180212_150434_512304_514131C0)
Subject: Make brcmfmac repeat authentication requests
To: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        wright.feng@cypress.com
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        Linux Upstreaming Team <linux@endlessm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

We are working with the Weibu F3C MiniPC which includes BCM43455 SDIO
wifi chip 0x004345(17221) rev 0x000006

Testing Linux 4.15, this wifi adapter is unable to authenticate with
the MF928 MiFi Access Point which is common in Africa. The STA sends
the authentication request, which is ACKed by the AP, but then the
conversation ends there (a timeout later bubbles up to userspace).
Windows 10 with broadcom driver version 1.605.1.0 is also unable to
connect.

My laptop with ath10k can authenticate and connect fine. There the
conversation is:

1. STA sends authentication request
2. AP sends ACK
3. After 0.1s timeout, STA sends another auth request
4. AP sends ACK
5. AP sends authentication response
6. etc.

Also confirmed the same pattern on a couple of smartphones, where the
delay seems to be 0.3s before repeating the authentication request.

Clearly this AP is not behaving correctly; the authentication request
should not have to be repeated. However of all the devices to hand,
unfortunately only this broadcom device is unable to connect.

Is there a way to adjust the driver/firmware to repeat the
authentication requests when they are not responded to? This would
match the behaviour of other devices and work around this issue.

Thanks
Daniel
