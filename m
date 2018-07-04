Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:51840 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753300AbeGDKsF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jul 2018 06:48:05 -0400
Subject: Re: [PATCH v8] ath10k: fix crash in recent 3.5.3 9984 firmware due
 wrong handling of peer_bw_rxnss_override parameter
To: Sven Eckelmann <sven.eckelmann@openmesh.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        kvalo@codeaurora.org
References: <20180704092953.32572-1-s.gottschall@dd-wrt.com>
 <5630152.jDWN9V3RzB@bentobox>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <0cff058a-3c4b-6617-a034-3df706ba3a32@dd-wrt.com> (sfid-20180704_124809_796977_F9E3DB75)
Date: Wed, 4 Jul 2018 12:48:06 +0200
MIME-Version: 1.0
In-Reply-To: <5630152.jDWN9V3RzB@bentobox>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Am 04.07.2018 um 12:40 schrieb Sven Eckelmann:
> On Mittwoch, 4. Juli 2018 11:29:53 CEST s.gottschall@dd-wrt.com wrote:
>> +/* Values defined to set 160 MHz Bandwidth NSS Mapping into FW*/
>> +#define BW_NSS_FWCONF_160(x)           (BW_NSS_FWCONF_MAP_ENABLE | \
>> +                                       (((x - 1) << BW_NSS_FWCONF_MAP_160MHZ_S) \
>> +                                       & BW_NSS_FWCONF_MAP_160MHZ_M))
>> +#define BW_NSS_FWCONF_80_80(x)         (BW_NSS_FWCONF_MAP_ENABLE | \
>> +                                       (((x - 1) << BW_NSS_FWCONF_MAP_80_80MHZ_S) \
>> +                                       & BW_NSS_FWCONF_MAP_80_80MHZ_M))
> Please check the shift and mask macros in core.h
>
>
> #define BW_NSS_FWCONF_MAP_160MHZ_LSB           0
> #define BW_NSS_FWCONF_MAP_160MHZ_MASK          0x00000007
> #define BW_NSS_FWCONF_MAP_80_80MHZ_LSB         3
> #define BW_NSS_FWCONF_MAP_80_80MHZ_MASK        0x00000038
> #define BW_NSS_FWCONF_MAP_MASK                 0x0000003F
>
> #define GET_BW_NSS_FWCONF_160(x)     (MS((x), BW_NSS_FWCONF_MAP_160MHZ) + 1)
> #define GET_BW_NSS_FWCONF_80_80(x)   (MS((x), BW_NSS_FWCONF_MAP_80_80MHZ_M) + 1)
>
> /* Values defined to set 160 MHz Bandwidth NSS Mapping into FW*/
> #define BW_NSS_FWCONF_160(x)         (BW_NSS_FWCONF_MAP_ENABLE | \
>                                        (SM((x) - 1, BW_NSS_FWCONF_MAP_160MHZ))
> #define BW_NSS_FWCONF_80_80(x)       (BW_NSS_FWCONF_MAP_ENABLE | \
>                                        (SM((x) - 1, BW_NSS_FWCONF_MAP_80_80MHZ))
>
> (these snippets were not yet tested and most likely need further adjustments)
>
>
> Kind regards,
> 	Sven
can you explain your request? the macros are unchanged and just 
reformated for maximum line length restriction. the values have been 
taken from QCA's wmi header

Sebastian
