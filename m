Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nsmtp.uni-koblenz.de ([141.26.64.14]:59406 "EHLO
        nsmtp.uni-koblenz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751826AbdIVKJj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Sep 2017 06:09:39 -0400
Subject: Re: [PATCH v2 2/2] wireless: return correct mandatory rates
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <20170907154744.28357-2-rschuetz@uni-koblenz.de>
 <20170908160712.8765-1-rschuetz@uni-koblenz.de>
 <1506001926.2048.5.camel@sipsolutions.net>
From: =?UTF-8?Q?Richard_Sch=c3=bctz?= <rschuetz@uni-koblenz.de>
Message-ID: <63eebfc4-2622-87b1-699e-58a222715900@uni-koblenz.de> (sfid-20170922_120943_402229_2B9D5678)
Date: Fri, 22 Sep 2017 12:09:37 +0200
MIME-Version: 1.0
In-Reply-To: <1506001926.2048.5.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 21.09.2017 um 15:52 schrieb Johannes Berg:
> On Fri, 2017-09-08 at 18:07 +0200, Richard Schütz wrote:
>> Use IEEE80211_RATE_MANDATORY_G instead of IEEE80211_RATE_MANDATORY_B
>> to get
>> all mandatory rates in 2.4 GHz band. It is safe to do so because ERP
>> mandatory rates are a superset of HR/DSSS mandatory rates. Also limit
>> to
>> OFDM rates for 10 MHz and 5 MHz channels as originally intended by
>> commit
>> 74608aca4d82e.
> 
> I don't understand this. Why should all ERP (Clause 18, 11g) rates be
> mandatory for the users of this?
> 
> The way I see it, this would make us assume that all 2.4 GHz clients
> support ERP in IBSS, which may not be true?

I disagree. On a HR/DSSS PHY this would still only return HR/DSSS rates 
because there should not by any ERP rates present in sband->bitrates in 
the first place.

The reason for suggesting this change is that the basic rate set for a 
mesh STA is initialized with this function if not explicitly configured 
beforehand.

IEEE Std 802.11-2016 (10.7.4 Basic rate set, basic HT-MCS set, and basic 
VHT-MCS and NSS set for mesh STA) states: A mesh STA shall not establish 
a mesh peering with a mesh STA using a different BSSBasicRateSet (see 
14.2.7 and 14.2.8). The SME of a Mesh STA should use the mandatory PHY 
rates as the default BSSBasicRateSet in the MLME-START.request primitive 
to reduce the risk that a candidate peer mesh STA utilizes a different 
BSSBasicRateSet.

Selecting only HR/DSSS mandatory rates for a mesh STA default basic rate 
set on an ERP PHY violates this requirement in my opinion. 
wpa_supplicant explicitly configures all ERP mandatory rates for ERP 
mesh points in its default configuration, whereas iw relies on the 
kernel to do the selection. This currently leaves us with the 
unfortunate situation that you can not join such a mesh BSS created by 
wpa_supplicant using iw without further configuration and the other way 
round.

-- 
Richard
