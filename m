Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50286 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030220AbeEXSni (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 May 2018 14:43:38 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Sven Eckelmann <sven.eckelmann@openmesh.com>
Cc: linux-wireless@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: Re: [PATCH 00/52] ath: Synchronize regd mappings with qcacld-2.0 4.0.11.181
References: <20180301141902.24824-1-sven.eckelmann@openmesh.com>
        <874lixno06.fsf@purkki.adurom.net>
Date: Thu, 24 May 2018 21:43:31 +0300
In-Reply-To: <874lixno06.fsf@purkki.adurom.net> (Kalle Valo's message of "Thu,
        24 May 2018 17:10:01 +0300")
Message-ID: <87k1rsnbcc.fsf@purkki.adurom.net> (sfid-20180524_204352_682503_6BD84B2F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:

> Sven Eckelmann <sven.eckelmann@openmesh.com> writes:
>
>> The mappings from ath was not synced with the QCA driver since 2009. Only
>> two minor fixes were integrated in 2011. Since then, a lot of regd changes
>> were integrated in the close source QCA driver which are now used but not
>> supported by the Open Source driver. This either prevents the use of the
>> OSS driver on such devices or the wrong conformance test limits (CTLs) may
>> be used.
>>
>> To get the integrated we would first get access to the closed source QCA
>> driver and a special OSS-NDA with QCA. This doesn't seem to be possible at
>> the moment and thus other sources for the changes have to be found. One of
>> them is the qcacld-2.0 source repository [1] which contains the QCA
>> regdomain.h and regdomain_common.h which was relicensed by QCA as ISC. It
>> isn't the newest version from the QCA driver but at least received some
>> updates which are not present in ath's regd.
>>
>> This repository [1] (commit 48f9ab5d5c161549be098997fa0e3602c1547213 to be
>> more precise) was now used to find differences and ad some missing
>> mappings.
>>
>> The title of the mappings describe what exactly was changed. The "Add
>> regulatory mapping for" patches introduce new country codes/mappings and
>> thus don't change old mappings. The "Add regulatory mapping for" patches
>> are similar but for regulatory code mappings instead of country code
>> mappings.
>>
>> More interesting might be the "Map XXXX to YYYY" patches because they
>> modify already existing mappings. The result are following changes to the
>> selected CTLs:
>>
>> * CTRY_ALBANIA:             5GHz: NO_CTL -> ETSI
>> * CTRY_ALGERIA:             5GHz: NO_CTL -> ETSI
>> * CTRY_BANGLADESH:          5GHz: NO_CTL -> FCC
>> * CTRY_BRUNEI_DARUSSALAM:   5GHz: FCC -> ETSI
>> * CTRY_HONDURAS:            5GHz: NO_CTL -> FCC
>> * CTRY_INDONESIA:           5GHz: NO_CTL -> FCC
>> * CTRY_ISRAEL:              5GHz: NO_CTL -> ETSI
>> * CTRY_KOREA_NORTH:       2.4GHz: ETSI -> MKK
>> * CTRY_KOREA_ROC:         2.4GHz: ETSI -> MKK
>> * CTRY_KOREA_ROC3:        2.4GHz: ETSI -> MKK
>> * CTRY_LEBANON:             5GHz: NO_CTL -> FCC
>> * CTRY_MACEDONIA:           5GHz: NO_CTL -> ETSI
>> * CTRY_MALAYSIA:            5GHz: ETSI -> FCC
>> * CTRY_MEXICO:            2.4GHz: FCC-> ETSI
>> * CTRY_PAKISTAN:            5GHz: NO_CTL -> FCC
>> * CTRY_ROMANIA:             5GHz: NO_CTL -> ETSI
>> * CTRY_RUSSIA:              5GHz: NO_CTL -> ETSI
>> * CTRY_SAUDI_ARABIA:        5GHz: NO_CTL -> FCC
>> * CTRY_SINGAPORE:           5GHz: ETSI -> FCC
>> * CTRY_UKRAINE:             5GHz: NO_CTL -> ETSI
>> * CTRY_UAE:                 5GHz: NO_CTL -> ETSI
>> * CTRY_VIET_NAM:            5GHz: NO_CTL -> ETSI
>> * CTRY_ZIMBABWE:            5GHz: NO_CTL -> ETSI
>>
>>
>> Btw. I have not removed CTRY_SERBIA_MONTENEGRO, CTRY_KOREA_ROC2 or
>> APL2_APLD because this might break devices which have these programmed in
>> the EEPROM. And I have not added APL11_FCCA, APL12_WORLD and CTRY_MALDIVES
>> because only the code was in the qcacld-2.0 source code but not the actual
>> mapping.
>>
>> I am relative confident that QCA also has following extra countries:
>>
>> * Afghanistan
>> * American Samoa
>> * Anguilla
>> * Bhutan
>> * Burkina Faso
>> * Cayman Islands
>> * Central Africa Republic
>> * Chad
>> * Christmas Islands
>> * Dominica
>> * Ethiopia
>> * French Guiana
>> * French Polynesia
>> * Ghana
>> * Guadeloupe
>> * Guyana
>> * Cote d'Ivoire
>> * Lesotho
>> * Malawi
>> * Maldives
>> * Marshall Islands
>> * Martinique
>> * Mauitania
>> * Mayotte
>> * Micronesia
>> * Moldova
>> * Mongolia
>> * Namibia
>> * Nigeria
>> * Northern Mariana Islands
>> * Palau
>> * Reunion
>> * St Barthelemy
>> * St Kitts Nevis
>> * St Lucia
>> * St Martin
>> * St Pierre Miquelon
>> * St Vincent Grenadiens
>> * Samoa
>> * Senegal
>> * Suriname
>> * Togo
>> * Turks Caicos
>> * Vanuatu
>> * Virgin Islands
>> * Wallis Futuna
>>
>> + a lot of extra regdomain codes (0x15, 0x16, 0x17, 0x18, 0x19, 0x3c, 0x4f,
>> 0x51, 0x57, 0x59) and the corresponding mappings.
>
> I asked about this and indeed qcacld-2.0 has few old mappings. I was
> told these patches are not current so I dropped them for now:
>
> [03/52] ath: Add regulatory mapping for Japan (J56)          2018-03-01
> [04/52] ath: Add regulatory mapping for Japan KDDI           2018-03-01
> [10/52] ath: Add regulatory mapping for Rwanda               2018-03-01
> [14/52] ath: Add regulatory mapping for United States for AP 2018-03-01
> [16/52] ath: Add regulatory mapping for APL10_MKKC           2018-03-01
> [21/52] ath: Switch APL9_WORLD to 2.4GHz MKK CTL             2018-03-01
> [31/52] ath: Map Indonesia to APL2_WORLD                     2018-03-01
> [33/52] ath: Map Japan to MKK5_MKKA2                         2018-03-01
> [34/52] ath: Map South Korea to APL10_MKKC                   2018-03-01
> [35/52] ath: Map Lebanon to APL1_WORLD                       2018-03-01
> [38/52] ath: Map Mexico to FCC1_WORLD                        2018-03-01
> [40/52] ath: Map Pakistan to APL1_WORLD                      2018-03-01
> [45/52] ath: Map Saudi Arabia to FCC2_WORLD                  2018-03-01
> [47/52] ath: Map Taiwan to APL7_FCCA                         2018-03-01
> [49/52] ath: Map U.A.E. to ETSI1_WORLD                       2018-03-01
> [50/52] ath: Map Venezuela to FCC1_WORLD                     2018-03-01
> [51/52] ath: Map Vietnam to ETSI3_WORLD                      2018-03-01
>
> Rest of the patches are now in the pending branch and I'm hoping to
> apply them soon:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/log/?h=pending

Forgot to mention that there was a trivial conflict due to dropping some
of the patches:

Pushing patch "ath-map-russia-to-etsi8_world" ... done (conflict)
Error: 1 merge conflict(s)
       CONFLICT (content): Merge conflict in
       drivers/net/wireless/ath/regd_common.h
Now at patch "ath-map-russia-to-etsi8_world"

I fixed it like this:

diff --cc drivers/net/wireless/ath/regd_common.h
index 3afce206e049,dcb4fe28e76a..000000000000
--- a/drivers/net/wireless/ath/regd_common.h
+++ b/drivers/net/wireless/ath/regd_common.h
@@@ -459,7 -465,8 +459,7 @@@ static struct country_code_to_enum_rd a
        {CTRY_PUERTO_RICO, FCC1_FCCA, "PR"},
        {CTRY_QATAR, APL1_WORLD, "QA"},
        {CTRY_ROMANIA, ETSI1_WORLD, "RO"},
-       {CTRY_RUSSIA, NULL1_WORLD, "RU"},
+       {CTRY_RUSSIA, ETSI8_WORLD, "RU"},
 -      {CTRY_RWANDA, APL1_WORLD, "RW"},
        {CTRY_SAUDI_ARABIA, NULL1_WORLD, "SA"},
        {CTRY_SERBIA, ETSI1_WORLD, "RS"},
        {CTRY_SERBIA_MONTENEGRO, ETSI1_WORLD, "CS"},

-- 
Kalle Valo
