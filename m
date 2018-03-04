Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:46329 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751427AbeCDR0f (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 4 Mar 2018 12:26:35 -0500
Date: Sun, 4 Mar 2018 18:26:20 +0100 (CET)
From: Stefan Wahren <stefan.wahren@i2se.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
Message-ID: <56656292.178955.1520184380348@email.1und1.de> (sfid-20180304_183027_935622_3114F197)
Subject: [Regression] brcmfmac: brcmf_cfg80211_reg_notifier: not an ISO3166
 code
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

the commit "regulatory: add NUL to request alpha2" in linux-next-20180302 causes a regression with brcmfmac (Platform: Raspberry Pi 3 B). During driver probe i will get this error:

brcmfmac: brcmf_cfg80211_reg_notifier: not an ISO3166 code (0x44 0x45)

But 0x44 0x45 ( = DE ) is a valid ISO3166 code.

The reason for this behavior is that the function checks the complete array, not just the first 2 elements.

IMO at least the functions brcmf_cfg80211_reg_notifier() and brcmf_translate_country_code() should be fixed.

Regards
Stefan
