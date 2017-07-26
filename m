Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44356 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751585AbdGZVDX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Jul 2017 17:03:23 -0400
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: russianneuromancer@ya.ru, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        Igor Nikolic <nikolic.igor@gmail.com>
From: Hans de Goede <hdegoede@redhat.com>
Subject: brcmfmac4356-pcie 4.13 regression (frequent kernel panics) not fixed
 by recent 4.13 regression fix
Message-ID: <b3b9dd19-a20d-ac4e-70f1-6059e7ec7d20@redhat.com> (sfid-20170726_230327_508256_0ACDC375)
Date: Wed, 26 Jul 2017 23:03:19 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I've been seeing frequent kernel panics on wifi activity
(scp-ing a lot of files) with 4.13 on 2 different systems
which both use a brcmfmac4356-pcie wifi chip.

This is with this fix:
https://www.spinics.net/lists/linux-wireless/msg164178.html
already applied.

Here is a picture of the panic:

https://fedorapeople.org/~jwrdegoede/brcmfmac4356-pcie-4.13-panic.jpg

Reverting commit 270a6c1f65fe ("brcmfmac: rework headroom check in .start_xmit()"):
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit?id=270a6c1f65fe68a28a5d39cd405592c550b496c7

seems to fix this (I can no longer quickly reproduce the panic
by scp-ing a large amount of files).

Note I've first reverted the:
https://www.spinics.net/lists/linux-wireless/msg164178.html
fix so that I could cleanly revert commit 270a6c1f65fe.

Given that no code seems to use the statics commit 270a6c1f65fe
offers and it has been the cause of 2 different regressions now,
it might be best to just revert 270a6c1f65fe for 4.13.

Regards,

Hans
