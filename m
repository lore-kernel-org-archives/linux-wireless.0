Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nsmtp.uni-koblenz.de ([141.26.64.14]:49012 "EHLO
        nsmtp.uni-koblenz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754141AbdIHKK1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Sep 2017 06:10:27 -0400
Subject: Re: [PATCH 2/2] wireless: return correct mandatory rates
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc: Simon Wunderlich <sw@simonwunderlich.de>
References: <20170907154744.28357-1-rschuetz@uni-koblenz.de>
 <20170907154744.28357-2-rschuetz@uni-koblenz.de>
 <1504853740.6177.10.camel@sipsolutions.net>
 <5aed0ea0-f127-bd1e-ca06-db7edbf56680@uni-koblenz.de>
 <1504861413.6177.16.camel@sipsolutions.net>
From: =?UTF-8?Q?Richard_Sch=c3=bctz?= <rschuetz@uni-koblenz.de>
Message-ID: <f9e34cbf-e0e1-3faa-39dd-58ad6968d276@uni-koblenz.de> (sfid-20170908_121033_618006_271E3B06)
Date: Fri, 8 Sep 2017 12:10:23 +0200
MIME-Version: 1.0
In-Reply-To: <1504861413.6177.16.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 08.09.2017 um 11:03 schrieb Johannes Berg:
> On Fri, 2017-09-08 at 10:43 +0200, Richard Schütz wrote:
>> Am 08.09.2017 um 08:55 schrieb Johannes Berg:
>>> On Thu, 2017-09-07 at 17:47 +0200, Richard Schütz wrote:
>>>> Use IEEE80211_RATE_MANDATORY_G instead of
>>>> IEEE80211_RATE_MANDATORY_B
>>>> for comparison to get all mandatory rates in 2.4 GHz band. It is
>>>> safe
>>>> to do so because ERP mandatory rates are a superset of HR/DSSS
>>>> mandatory rates.
>>>
>>> This I don't understand - what "comparison" are you talking about?
>>
>> Sorry, I meant the condition that checks for the presence of
>> mandatory_flag at the bottom of the function.
> 
> Ah, sorry, I got confused with the other patch.
> 
>> Do we actually allow 10 MHz and 5 MHz operation in the 2.4 GHz band?
>> As  far as I can tell that has only been specified for OFDM PHYs,
>> which use the 5 GHz band and are covered by
>> IEEE80211_RATE_MANDATORY_A, but I am not a hundred per cent sure
>> about that. Cc'ing Simon Wunderlich who originally implemented
>> checking of scan_width here.
> 
> Clearly we do allow that, since the existing check is:
> 
>          if (sband->band == NL80211_BAND_2GHZ) {
>                  if (scan_width == NL80211_BSS_CHAN_WIDTH_5 ||
>                      scan_width == NL80211_BSS_CHAN_WIDTH_10)
>                          mandatory_flag = IEEE80211_RATE_MANDATORY_G;
> 
> That wouldn't make any sense if we didn't have 5/10 MHz on 2.4 GHz.
> 
>> The main intention of this patch series is to fix mandatory rates
>> returned for normal operation in 2.4 GHz band. Currently only 1 Mb/s
>> is returned here, which is wrong for both HR/DSSS and ERP PHYs.
> 
> The patch is still wrong wrt. 5/10 MHz though.
> 
> I think what you really wanted to do is the following:
> 
>   * rename RATE_MANDATORY_B to RATE_MANDATORY_HR_DSSS
>   * combine RATE_MANDATORY_G/_A to RATE_MANDATORY_OFDM
> 
> Then, what you need to do, is change the checks in
> ieee80211_mandatory_rates() to be
> 
>          if (sband->band == NL80211_BAND_2GHZ) {
>                  if (scan_width == NL80211_BSS_CHAN_WIDTH_5 ||
>                      scan_width == NL80211_BSS_CHAN_WIDTH_10)
>                          mandatory_flag = IEEE80211_RATE_MANDATORY_OFDM;
>                  else
>                          mandatory_flag = IEEE80211_RATE_MANDATORY_HR_DSSS;

This would leave us with 1, 2, 5.5 and 11 Mb/s for ERP PHYs again when 
it really should be 1, 2, 5.5, 6, 11, 12 and 24 Mb/s.

>          } else {
>                  mandatory_flag = IEEE80211_RATE_MANDATORY_OFDM;
>          }
> 
> That would actually fix a bug in a way because right now the code
> treats HR/DSSS rates (1, 2, 5.5, 11) for 2.4 GHz narrow-band operation
> as mandatory, which seems wrong.

-- 
Richard
