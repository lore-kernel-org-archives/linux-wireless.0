Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:59268 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220Ab2JaN7z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Oct 2012 09:59:55 -0400
Message-ID: <50912ED6.2060201@neratec.com> (sfid-20121031_145959_557231_CF89A422)
Date: Wed, 31 Oct 2012 14:59:50 +0100
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Hauke Mehrtens <hauke@hauke-m.de>
CC: linville@tuxdriver.com, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org, rodrigue@qca.qualcomm.com
Subject: Re: [PATCH] ath9k: [DFS] add pulse width tolerance for ETSI
References: <1351682581-30683-1-git-send-email-zefir.kurtisi@neratec.com> <5091287C.9030408@hauke-m.de>
In-Reply-To: <5091287C.9030408@hauke-m.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/31/2012 02:32 PM, Hauke Mehrtens wrote:
> On 10/31/2012 12:23 PM, Zefir Kurtisi wrote:
>> Add 5% width tolerance for radar patterns defined by ETSI.
>>
>> Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
>> ---
>>  .../net/wireless/ath/ath9k/dfs_pattern_detector.c  |    7 ++++++-
>>  1 files changed, 6 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.c b/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.c
>> index 3b12914..24877b0 100644
>> --- a/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.c
>> +++ b/drivers/net/wireless/ath/ath9k/dfs_pattern_detector.c
>> @@ -42,10 +42,15 @@ struct radar_types {
>>  #define MIN_PPB_THRESH	50
>>  #define PPB_THRESH(PPB) ((PPB * MIN_PPB_THRESH + 50) / 100)
>>  #define PRF2PRI(PRF) ((1000000 + PRF / 2) / PRF)
>> +/* percentage of pulse width tolerance */
>> +#define WIDTH_TOLERANCE 5
>> +#define WIDTH_LOWER(X) ((X*(100-WIDTH_TOLERANCE)+50)/100)
>> +#define WIDTH_UPPER(X) ((X*(100+WIDTH_TOLERANCE)+50)/100)
>                                                    ^^^
> Why are you adding 50 there? If you want to just add 5% tolerance, then
> the +50 is wrong there, but I do not know anything about radar patterns
> defined by ETSI.
> 
> Hauke
> 
Hi Hauke,

the 50 you are referring to are not the 5% defined by ETSI but used for
proper rounding in the percentage domain within that macros.

Take pattern 4 with a maximum pulse width of 30us, WIDTH_UPPER(30) then
calculates to 32. Since the HW's pulse width resolution is 1us, there is
no need to move to the nsec domain.


