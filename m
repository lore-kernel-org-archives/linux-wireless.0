Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f170.google.com ([209.85.216.170]:35214 "EHLO
        mail-qt0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031110AbeCAOU3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 09:20:29 -0500
Received: by mail-qt0-f170.google.com with SMTP id z14so7696070qti.2
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2018 06:20:28 -0800 (PST)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Subject: [PATCH 00/52] ath: Synchronize regd mappings with qcacld-2.0 4.0.11.181
Date: Thu,  1 Mar 2018 15:18:10 +0100
Message-Id: <20180301141902.24824-1-sven.eckelmann@openmesh.com> (sfid-20180301_152034_654861_334205CF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The mappings from ath was not synced with the QCA driver since 2009. Only
two minor fixes were integrated in 2011. Since then, a lot of regd changes
were integrated in the close source QCA driver which are now used but not
supported by the Open Source driver. This either prevents the use of the
OSS driver on such devices or the wrong conformance test limits (CTLs) may
be used.

To get the integrated we would first get access to the closed source QCA
driver and a special OSS-NDA with QCA. This doesn't seem to be possible at
the moment and thus other sources for the changes have to be found. One of
them is the qcacld-2.0 source repository [1] which contains the QCA
regdomain.h and regdomain_common.h which was relicensed by QCA as ISC. It
isn't the newest version from the QCA driver but at least received some
updates which are not present in ath's regd.

This repository [1] (commit 48f9ab5d5c161549be098997fa0e3602c1547213 to be
more precise) was now used to find differences and ad some missing
mappings.

The title of the mappings describe what exactly was changed. The "Add
regulatory mapping for" patches introduce new country codes/mappings and
thus don't change old mappings. The "Add regulatory mapping for" patches
are similar but for regulatory code mappings instead of country code
mappings.

More interesting might be the "Map XXXX to YYYY" patches because they
modify already existing mappings. The result are following changes to the
selected CTLs:

* CTRY_ALBANIA:             5GHz: NO_CTL -> ETSI
* CTRY_ALGERIA:             5GHz: NO_CTL -> ETSI
* CTRY_BANGLADESH:          5GHz: NO_CTL -> FCC
* CTRY_BRUNEI_DARUSSALAM:   5GHz: FCC -> ETSI
* CTRY_HONDURAS:            5GHz: NO_CTL -> FCC
* CTRY_INDONESIA:           5GHz: NO_CTL -> FCC
* CTRY_ISRAEL:              5GHz: NO_CTL -> ETSI
* CTRY_KOREA_NORTH:       2.4GHz: ETSI -> MKK
* CTRY_KOREA_ROC:         2.4GHz: ETSI -> MKK
* CTRY_KOREA_ROC3:        2.4GHz: ETSI -> MKK
* CTRY_LEBANON:             5GHz: NO_CTL -> FCC
* CTRY_MACEDONIA:           5GHz: NO_CTL -> ETSI
* CTRY_MALAYSIA:            5GHz: ETSI -> FCC
* CTRY_MEXICO:            2.4GHz: FCC-> ETSI
* CTRY_PAKISTAN:            5GHz: NO_CTL -> FCC
* CTRY_ROMANIA:             5GHz: NO_CTL -> ETSI
* CTRY_RUSSIA:              5GHz: NO_CTL -> ETSI
* CTRY_SAUDI_ARABIA:        5GHz: NO_CTL -> FCC
* CTRY_SINGAPORE:           5GHz: ETSI -> FCC
* CTRY_UKRAINE:             5GHz: NO_CTL -> ETSI
* CTRY_UAE:                 5GHz: NO_CTL -> ETSI
* CTRY_VIET_NAM:            5GHz: NO_CTL -> ETSI
* CTRY_ZIMBABWE:            5GHz: NO_CTL -> ETSI


Btw. I have not removed CTRY_SERBIA_MONTENEGRO, CTRY_KOREA_ROC2 or
APL2_APLD because this might break devices which have these programmed in
the EEPROM. And I have not added APL11_FCCA, APL12_WORLD and CTRY_MALDIVES
because only the code was in the qcacld-2.0 source code but not the actual
mapping.

I am relative confident that QCA also has following extra countries:

* Afghanistan
* American Samoa
* Anguilla
* Bhutan
* Burkina Faso
* Cayman Islands
* Central Africa Republic
* Chad
* Christmas Islands
* Dominica
* Ethiopia
* French Guiana
* French Polynesia
* Ghana
* Guadeloupe
* Guyana
* Cote d'Ivoire
* Lesotho
* Malawi
* Maldives
* Marshall Islands
* Martinique
* Mauitania
* Mayotte
* Micronesia
* Moldova
* Mongolia
* Namibia
* Nigeria
* Northern Mariana Islands
* Palau
* Reunion
* St Barthelemy
* St Kitts Nevis
* St Lucia
* St Martin
* St Pierre Miquelon
* St Vincent Grenadiens
* Samoa
* Senegal
* Suriname
* Togo
* Turks Caicos
* Vanuatu
* Virgin Islands
* Wallis Futuna

+ a lot of extra regdomain codes (0x15, 0x16, 0x17, 0x18, 0x19, 0x3c, 0x4f,
0x51, 0x57, 0x59) and the corresponding mappings.

There might be even a lot more. But we will miss out on them unless QCA
somehow opensources their current:

* regdomain_common.h or at least:

  - enum EnumRd
  - ahCmnRegDomainPairs
  - ahCmnAllCountries
  - ahCmnRegDomains

* regdomain.h or at least:

  - enum CountryCode

Kind regards,
	Sven

[1] https://source.codeaurora.org/quic/la/platform/vendor/qcom-opensource/wlan/qcacld-2.0

Sven Eckelmann (52):
  ath: Add regulatory mapping for Bahamas
  ath: Add regulatory mapping for Bermuda
  ath: Add regulatory mapping for Japan (J56)
  ath: Add regulatory mapping for Japan KDDI
  ath: Add regulatory mapping for Kenya
  ath: Add regulatory mapping for Mauritius
  ath: Add regulatory mapping for Montenegro
  ath: Add regulatory mapping for Nicaragua
  ath: Add regulatory mapping for Paraguya
  ath: Add regulatory mapping for Rwanda
  ath: Add regulatory mapping for Serbia
  ath: Add regulatory mapping for Tanzania
  ath: Add regulatory mapping for Uganda
  ath: Add regulatory mapping for United States for AP
  ath: Add regulatory mapping for APL2_FCCA
  ath: Add regulatory mapping for APL10_MKKC
  ath: Add regulatory mapping for APL13_WORLD
  ath: Add regulatory mapping for ETSI8_WORLD
  ath: Add regulatory mapping for ETSI9_WORLD
  ath: Add regulatory mapping for FCC3_ETSIC
  ath: Switch APL9_WORLD to 2.4GHz MKK CTL
  ath: Map Albania to ETSI1_WORLD
  ath: Map Algeria to APL13_WORLD
  ath: Map Australia to FCC3_WORLD
  ath: Map Bangladesh to APL1_WORLD
  ath: Map Brunei Darussalam to APL6_WORLD
  ath: Map Bulgaria to ETSI1_WORLD
  ath: Map Colombia to FCC1_FCCA
  ath: Map Czech to ETSI1_WORLD
  ath: Map Honduras to FCC3_WORLD
  ath: Map Indonesia to APL2_WORLD
  ath: Map Isreal to ETSI3_WORLD
  ath: Map Japan to MKK5_MKKA2
  ath: Map South Korea to APL10_MKKC
  ath: Map Lebanon to APL1_WORLD
  ath: Map Macedonia to ETSI1_WORLD
  ath: Map Malasia to FCC1_WORLD
  ath: Map Mexico to FCC1_WORLD
  ath: Map New Zealand to FCC3_ETSIC
  ath: Map Pakistan to APL1_WORLD
  ath: Map Peru to APL1_WORLD
  ath: Map Philippines to FCC3_WORLD
  ath: Map Romania to ETSI1_WORLD
  ath: Map Russia to ETSI8_WORLD
  ath: Map Saudi Arabia to FCC2_WORLD
  ath: Map Singapore to FCC3_WORLD
  ath: Map Taiwan to APL7_FCCA
  ath: Map Ukraine to ETSI9_WORLD
  ath: Map U.A.E. to ETSI1_WORLD
  ath: Map Venezuela to FCC1_WORLD
  ath: Map Vietnam to ETSI3_WORLD
  ath: Map Zimbabwe to ETSI1_WORLD

 drivers/net/wireless/ath/regd.h        | 10 ++++
 drivers/net/wireless/ath/regd_common.h | 98 ++++++++++++++++++++++------------
 2 files changed, 73 insertions(+), 35 deletions(-)

-- 
2.11.0
