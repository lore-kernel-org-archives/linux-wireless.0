Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.74]:45559 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751060AbeCIMun (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Mar 2018 07:50:43 -0500
Date: Fri, 9 Mar 2018 13:50:30 +0100 (CET)
From: Stefan Wahren <stefan.wahren@i2se.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Wright Feng <wright.feng@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list@cypress.com,
        brcm80211-dev-list.pdl@broadcom.com
Message-ID: <1161963306.292851.1520599830277@email.1und1.de> (sfid-20180309_135047_943203_EA0F2074)
In-Reply-To: <56656292.178955.1520184380348@email.1und1.de>
References: <56656292.178955.1520184380348@email.1und1.de>
Subject: Re: [Regression] brcmfmac: brcmf_cfg80211_reg_notifier: not an
 ISO3166 code
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> Stefan Wahren <stefan.wahren@i2se.com> hat am 4. März 2018 um 18:26 geschrieben:
> 
> 
> Hi,
> 
> the commit "regulatory: add NUL to request alpha2" in linux-next-20180302 causes a regression with brcmfmac (Platform: Raspberry Pi 3 B). During driver probe i will get this error:
> 
> brcmfmac: brcmf_cfg80211_reg_notifier: not an ISO3166 code (0x44 0x45)
> 
> But 0x44 0x45 ( = DE ) is a valid ISO3166 code.
> 
> The reason for this behavior is that the function checks the complete array, not just the first 2 elements.
> 
> IMO at least the functions brcmf_cfg80211_reg_notifier() and brcmf_translate_country_code() should be fixed.

would it be okay to fix the regression like this [1]?

[1] - https://github.com/lategoodbye/rpi-zero/commit/5986aa583b1a8ac4dd5242b0aa489826c74fcb81

Regards
Stefan

> 
> Regards
> Stefan
