Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:44578 "EHLO
        mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750817AbeCFKLX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Mar 2018 05:11:23 -0500
Received: by mail-lf0-f49.google.com with SMTP id v9so27533158lfa.11
        for <linux-wireless@vger.kernel.org>; Tue, 06 Mar 2018 02:11:22 -0800 (PST)
MIME-Version: 1.0
From: Cevahir Turgut <cevahirturgut@gmail.com>
Date: Tue, 6 Mar 2018 11:11:20 +0100
Message-ID: <CAPk3KPrdiA1XmYCy3r63YXFUeUfmiW5SP-NmL=TMMWG2bmbZEg@mail.gmail.com> (sfid-20180306_111127_652088_2B7DFBE9)
Subject: ath9k: Resting due to beacon stuck at 5GHz at clean environment
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k is continuously resting because of beacon stuck at 5GHz.
I am working on a board with AR9462 module.
I checked the environment noise levels, my test environment is clean
and there is no interference.

While checking solution for the issue, I found that if comment the
last part of =E2=80=9Cint ath9k_hw_loadnf(struct ath_hw *ah, struct
ath9k_channel *chan)=E2=80=9D which is given below, then driver works prope=
rly
also. But if I remove this part, I expect that driver should not able
to perform noise floor calibration properly. I found a related patch,
https://patchwork.kernel.org/patch/8215351/, but it is already applied
to driver.

Also if I increase the minimum CCA power threshold values from the
initvals (in ar9462_2p0_initvals.h), driver works properly. But these
values are above the allowed values considering ETSI compliance:
https://www.spinics.net/lists/linux-wireless/msg118665.html

Many thanks in advance for any help.

       /*
        * Restore maxCCAPower register parameter again so that we're not ca=
pped
        * by the median we just loaded.  This will be initial (and max) val=
ue
        * of next noise floor calibration the baseband does.
        */
       ENABLE_REG_RMW_BUFFER(ah);
       for (i =3D 0; i < NUM_NF_READINGS; i++) {
              if (chainmask & (1 << i)) {
                     if ((i >=3D AR5416_MAX_CHAINS) && !IS_CHAN_HT40(chan))
                            continue;

                     REG_RMW(ah, ah->nf_regs[i],
                                   (((u32) (-50) << 1) & 0x1ff), 0x1ff);
              }
       }
       REG_RMW_BUFFER_FLUSH(ah);

Regards,
Cevahir
