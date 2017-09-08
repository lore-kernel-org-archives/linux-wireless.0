Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nsmtp.uni-koblenz.de ([141.26.64.14]:34603 "EHLO
        nsmtp.uni-koblenz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754878AbdIHInw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Sep 2017 04:43:52 -0400
Subject: Re: [PATCH 2/2] wireless: return correct mandatory rates
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <20170907154744.28357-1-rschuetz@uni-koblenz.de>
 <20170907154744.28357-2-rschuetz@uni-koblenz.de>
 <1504853740.6177.10.camel@sipsolutions.net>
From: =?UTF-8?Q?Richard_Sch=c3=bctz?= <rschuetz@uni-koblenz.de>
Cc: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Message-ID: <5aed0ea0-f127-bd1e-ca06-db7edbf56680@uni-koblenz.de> (sfid-20170908_104357_014089_64F40B60)
Date: Fri, 8 Sep 2017 10:43:49 +0200
MIME-Version: 1.0
In-Reply-To: <1504853740.6177.10.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 08.09.2017 um 08:55 schrieb Johannes Berg:
> On Thu, 2017-09-07 at 17:47 +0200, Richard Schütz wrote:
>> Use IEEE80211_RATE_MANDATORY_G instead of IEEE80211_RATE_MANDATORY_B
>> for comparison to get all mandatory rates in 2.4 GHz band. It is safe
>> to do so because ERP mandatory rates are a superset of HR/DSSS
>> mandatory rates.
> This I don't understand - what "comparison" are you talking about?

Sorry, I meant the condition that checks for the presence of 
mandatory_flag at the bottom of the function.

>> Also force IEEE80211_RATE_MANDATORY_A for 10 MHz and 5 MHz channels
>> as they use "half-clocked" respectively "quarter-clocked" operation
>> of the OFDM rates (IEEE Std 802.11-2016, 17.1.1).
> I don't think this is correct - the way the flags are used, anything on
> 2.4 GHz would never bother to check the MANDATORY_A flag.

Do we actually allow 10 MHz and 5 MHz operation in the 2.4 GHz band? As 
far as I can tell that has only been specified for OFDM PHYs, which use 
the 5 GHz band and are covered by IEEE80211_RATE_MANDATORY_A, but I am 
not a hundred per cent sure about that. Cc'ing Simon Wunderlich who 
originally implemented checking of scan_width here.

The main intention of this patch series is to fix mandatory rates 
returned for normal operation in 2.4 GHz band. Currently only 1 Mb/s is 
returned here, which is wrong for both HR/DSSS and ERP PHYs.

-- 
Richard
