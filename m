Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:49433 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248AbaLOXj1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2014 18:39:27 -0500
Message-ID: <548F7101.7060602@qca.qualcomm.com> (sfid-20141216_003931_102311_5C686327)
Date: Mon, 15 Dec 2014 15:38:41 -0800
From: Peter Oh <poh@qca.qualcomm.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>, <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath: fix incorrect PPB on FCC radar type 5
References: <1418669734-12921-1-git-send-email-poh@qca.qualcomm.com> <548F47D1.8080502@openwrt.org>
In-Reply-To: <548F47D1.8080502@openwrt.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 12/15/2014 12:42 PM, Felix Fietkau wrote:
> On 2014-12-15 19:55, Peter Oh wrote:
>> The minimum number of pulses per burst on FCC radar type 5 is 1.
>> Use this number for correct radar detection.
>>
>> Signed-off-by: Peter Oh <poh@qca.qualcomm.com>
>> ---
>>   drivers/net/wireless/ath/dfs_pattern_detector.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/ath/dfs_pattern_detector.c b/drivers/net/wireless/ath/dfs_pattern_detector.c
>> index cfd0554..3d57f87 100644
>> --- a/drivers/net/wireless/ath/dfs_pattern_detector.c
>> +++ b/drivers/net/wireless/ath/dfs_pattern_detector.c
>> @@ -86,7 +86,7 @@ static const struct radar_detector_specs fcc_radar_ref_types[] = {
>>   	FCC_PATTERN(1, 0, 5, 150, 230, 1, 23),
>>   	FCC_PATTERN(2, 6, 10, 200, 500, 1, 16),
>>   	FCC_PATTERN(3, 11, 20, 200, 500, 1, 12),
>> -	FCC_PATTERN(4, 50, 100, 1000, 2000, 1, 20),
>> +	FCC_PATTERN(4, 50, 100, 1000, 2000, 1, 1),
> Won't that significantly increase the false positive rate?
No. FCC type 5 radar's PPB is in between 1~3 and DFS simulators such as 
VeriWave machine pick one among the number (typically 1), hence to 
detect the type 5 radar we should pick the minimum number which is 1 
unless we won't detect the radar if pulse comes only once.
> Here's the previous change on that pattern:
Actually their assumption (?) on FCC is incorrect.
PPB and PRF was not interchanged, the previous parameters simply picked 
wrong PRF for FCC instead (FCC type 5 radar's PRF is 1).
For Japan those parameters look quite different from what I've seen from 
Japan's Communications Ministry (MIC, 
www.tele.soumu.go.jp/e/sys/equ/tech/5ghz/5ghz.htm), but I couldn't say 
if it's correct or not at this moment since I haven't run DFS on Japan yet.
> commit 562930f8baee7a1cb5b9f382b4338c9b6fbf1139
> Author: Vivek Natarajan <nataraja@qti.qualcomm.com>
> Date:   Mon Nov 24 17:26:22 2014 +0530
>
>      ath: Fix a false radar detection pattern
>      
>      For FCC and JP, in one of the radar patterns, PPB and PRF seems to be
>      interchanged leading to frequent incorrect radar detections.
>      
>      Signed-off-by: Vivek Natarajan <nataraja@qti.qualcomm.com>
>      Signed-off-by: John W. Linville <linville@tuxdriver.com>
>
> diff --git a/drivers/net/wireless/ath/dfs_pattern_detector.c b/drivers/net/wireless/ath/dfs_pattern_detector.c
> index 650be79..cfd0554 100644
> --- a/drivers/net/wireless/ath/dfs_pattern_detector.c
> +++ b/drivers/net/wireless/ath/dfs_pattern_detector.c
> @@ -86,7 +86,7 @@ static const struct radar_detector_specs fcc_radar_ref_types[] = {
>          FCC_PATTERN(1, 0, 5, 150, 230, 1, 23),
>          FCC_PATTERN(2, 6, 10, 200, 500, 1, 16),
>          FCC_PATTERN(3, 11, 20, 200, 500, 1, 12),
> -       FCC_PATTERN(4, 50, 100, 1000, 2000, 20, 1),
> +       FCC_PATTERN(4, 50, 100, 1000, 2000, 1, 20),
>          FCC_PATTERN(5, 0, 1, 333, 333, 1, 9),
>   };
>   
> @@ -105,7 +105,7 @@ static const struct radar_detector_specs jp_radar_ref_types[] = {
>          JP_PATTERN(4, 0, 5, 150, 230, 1, 23),
>          JP_PATTERN(5, 6, 10, 200, 500, 1, 16),
>          JP_PATTERN(6, 11, 20, 200, 500, 1, 12),
> -       JP_PATTERN(7, 50, 100, 1000, 2000, 20, 1),
> +       JP_PATTERN(7, 50, 100, 1000, 2000, 1, 20),
>          JP_PATTERN(5, 0, 1, 333, 333, 1, 9),
>   };

