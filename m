Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:44511 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966469AbeFSPuY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Jun 2018 11:50:24 -0400
Received: by mail-lf0-f67.google.com with SMTP id p23-v6so213436lfh.11
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jun 2018 08:50:23 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH V3 0/2] brcmfmac: initial work for adding monitor mode
Date: Tue, 19 Jun 2018 17:48:07 +0200
Message-Id: <20180619154809.25698-1-zajec5@gmail.com> (sfid-20180619_175028_836024_B1925369)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

After a bit long discussions in various e-mail threads I'm coming with
this simple & small patchset. It isn't complete support for monitor mode
but just a pair of preparing patches that should be clear & well
discussed by now to make them acceptable.

The main missing bit is code setting MONITOR_FMT_RADIOTAP which I expect
Arend to handle soon, as he already has a patch using "sta_monitor"
iovar for that. Then we have to discuss a flag for marking firmwares
which are capable for tagging monitor frames.

While still incomplete, I believe that with my previous patches, we can
agree this is a good direction.

Arend: if you find these 2 patches OK, could you ack them, to make it
clear for Kalle if they look OK now (or not yet)? I'd be great if you
could sent your "sta_monitor" work on top of this.

Rafał Miłecki (2):
  brcmfmac: detect firmware support for monitor interface
  brcmfmac: handle monitor mode marked msgbuf packets

 .../wireless/broadcom/brcm80211/brcmfmac/core.c    | 25 +++++++++++++++++++++
 .../wireless/broadcom/brcm80211/brcmfmac/core.h    |  2 ++
 .../wireless/broadcom/brcm80211/brcmfmac/feature.c | 26 ++++++++++++++++++++++
 .../wireless/broadcom/brcm80211/brcmfmac/feature.h |  6 ++++-
 .../wireless/broadcom/brcm80211/brcmfmac/fwil.h    |  2 ++
 .../wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  | 17 ++++++++++++++
 6 files changed, 77 insertions(+), 1 deletion(-)

-- 
2.13.7
