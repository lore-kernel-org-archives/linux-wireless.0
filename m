Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43006 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411AbbC3R7E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 13:59:04 -0400
Message-ID: <55198EA4.1010101@codeaurora.org> (sfid-20150330_195910_134063_B935384D)
Date: Mon, 30 Mar 2015 10:57:56 -0700
From: Peter Oh <poh@codeaurora.org>
MIME-Version: 1.0
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>,
	Peter Oh <poh@qca.qualcomm.com>, ath10k@lists.infradead.org
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath: use PRI value given by spec for fixed PRI
References: <1427475590-2198-1-git-send-email-poh@qca.qualcomm.com> <55191D89.2000300@neratec.com>
In-Reply-To: <55191D89.2000300@neratec.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 03/30/2015 02:55 AM, Zefir Kurtisi wrote:
> On 03/27/2015 05:59 PM, Peter Oh wrote:
>> PRI value is used as divider when DFS detector analyzes candidate
>> radar pulses.
>> If PRI deviation is big from its origin PRI, DFS detector could miss
>> valid radar reports since HW often misses detecting radar pulses and
>> causes long interval value of pulses.
>>
>> For instance from practical results, if runtime PRI is calculated as
>> 1431 for fixed PRI value of 1428 and delta timestamp logs 15719,
>> the modular remainder will be 1409 and the delta between the remainder
>> and runtime PRI is 22 that is bigger than PRI tolerance which is 16.
>> As a result this radar report will be ignored even though it's valid.
>>
>> By using spec defined PRI for fixed PRI, we can correct this error.
>>
> Hm, not sure if this is a generic solution or 10k specific.
This concept is generic, but applies to 9k and 10k only since these 2 
drivers are only using the DFS detector.
> As stated in the source code
> /*
>   * tolerated deviation of radar time stamp in usecs on both sides
>   * TODO: this might need to be HW-dependent
>   */
> #define PRI_TOLERANCE	16
>
> the pri tolerance is assumed to be potentially dependent on used HW. The
> comment
> in fact was noted when the detector was written to become generally usable
> by any
> HW out there, before it became Atheros specific.
>
>  From my measurements, the ath9k is far within the given pri tolerance,
> i.e. if you
> continuously feed ETSI pattern 0 over a signal generator, it reports PRIs
> very
> accurately at 1428us (or multiples thereof). Even under heavy load the
> jitter of
> those reported values is within +/- 3us. With that, the ath9k (9580 more
> specifically) is already more accurate than the given tolerance -
> increasing it
> further would harm its operability.
as you addressed, current PRI_TOLERANCE value 16 is big enough to cover 
both of 9k and 10k.
the biggest offset of PRI on 10k so far I observed is 9us.
Here I'm not increasing PRI tolerance, but using more accurate PRI.
> The pri tolerance does not only help fine-tuning detection performance,
> but also
> heavily defines whether DFS channels are usable or not (afair, it is the
> most
> significant parameter to reduce false positives).
the calculated PRI(ps.pri) at pseq_handler_create_sequences() is used to 
filter candidate radar pulses in pde_get_multiple() and
to get total pulse duration.
This change gives more reliable results in filtering candidate radar 
pulses and does not give defect on calculating total pulse duration
since we already add 2* max_pri_tolerance on it.
Let me know if I miss something here.
> That's why I believe we
> need to
> be very cautious when changing it to fix / improve minor issues.
This patch is not for minor fix.
Current DFS detector fails on Japan W53 band which requires at least 50% 
of data traffic during DFS certificate.
So this patch should apply to both of 9k and 10k.
> Therefore, if your measurements with 10k reveal that it needs a higher
> tolerance,
> it should be made HW dependent and defined individually for 9k and 10k.
The patch is not to use higher PRI tolerance, but to use more accurate PRI.
>> Signed-off-by: Peter Oh <poh@qca.qualcomm.com>
>> ---
>>   drivers/net/wireless/ath/dfs_pri_detector.c | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/ath/dfs_pri_detector.c
> b/drivers/net/wireless/ath/dfs_pri_detector.c
>> index 1b5ad19..fef459a 100644
>> --- a/drivers/net/wireless/ath/dfs_pri_detector.c
>> +++ b/drivers/net/wireless/ath/dfs_pri_detector.c
>> @@ -25,6 +25,8 @@ struct ath_dfs_pool_stats global_dfs_pool_stats = {};
>>   
>>   #define DFS_POOL_STAT_INC(c) (global_dfs_pool_stats.c++)
>>   #define DFS_POOL_STAT_DEC(c) (global_dfs_pool_stats.c--)
>> +#define GET_PRI_TO_USE(MIN, MAX, RUNTIME) \
>> +	(MIN + 16 == MAX - 16 ? MIN + 16 : RUNTIME)
>>   
> /* in case of single PRI patterns, take nominal PRI */
> #define GET_PRI_TO_USE(MIN, MAX, RUNTIME) \
> 	((MAX - MIN) == 2 * PRI_TOLERANCE) ? MIN + PRI_TOLERANCE :
> RUNTIME)
>
>
> If timestamp jitter is an issue for 10k, you might also want to consider
> adjusting
> the assumed PRI with every pulse you add to a series. Initially I had it
> implemented that way that the PRI was re-calculated continuously to
> minimize the
> variance between nominal and measured pattern. But for the 9k and its
> accurate
> timestamping that turned out to be a lot of calculation for almost no gain
> and was
> dropped.
I also have looked up tsf offset for the issue, but since tsf offset is 
applies both of current and previous with similar value,
it didn't help to solve this issue.
>
> Cheers,
> Zefir
>
>
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k
Regards,
Peter
