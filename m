Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:50275 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932306AbdKPToT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Nov 2017 14:44:19 -0500
Received: from guenther.localnet ([84.157.55.145]) by mrelayeu.kundenserver.de
 (mreue102 [212.227.15.183]) with ESMTPSA (Nemesis) id
 0MD8M0-1ePIWD0Wqa-00GdRb for <linux-wireless@vger.kernel.org>; Thu, 16 Nov
 2017 20:44:17 +0100
From: Florian Hercher <mail@florian-hercher.de>
To: linux-wireless@vger.kernel.org
Subject: ath9k: Question regarding adaptivity and ETSI compliance
Date: Thu, 16 Nov 2017 20:44:16 +0100
Message-ID: <3024089.ZRiPOxTNka@guenther> (sfid-20171116_204424_616517_23F62A66)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

ETSI EN-300-328 in version 2.1.1 (2016-11) requires an "adaptive" behaviour of 
Wi-Fi Access Points, see clause 4.3.2.6.1 and annex B.7. As far as I 
understand this adaptive behavior requires the Wi-Fi card to stop transmitting 
whenever an (non Wi-Fi) interference signal with a power level of more than 
-70dBm/Mhz is present.

Does ath9k comply with this requirement? Or more specifically: Does ath9k 
running on a AR9331 (MAC version: AR9330, MAC revision: 1) comply?

Right now I'm trying to understand the "clear channel assessment" (CCA) 
related settings in the driver and I would like to ask for some clarification:

The CCA related definitions in ar9003_phy.h e.g. 
"AR_PHY_CCA_MAX_GOOD_VAL_9300_2GHZ" - are they part of the "higher" CCA 
function, where still decodable Wi-FI signals are handled?
Where is the energy detection threshold defined, is it "thres62" in "struct 
ar9300_eeprom"?

I'm quite confused about this and any help is highly appreciated!

best regards
Florian

---
http://www.etsi.org/deliver/etsi_en/300300_300399/300328/02.01.01_60/
en_300328v020101p.pdf
