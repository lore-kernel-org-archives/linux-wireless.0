Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:41173 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291AbaCYQKS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2014 12:10:18 -0400
Message-ID: <5331AA34.7060700@candelatech.com> (sfid-20140325_171024_854487_D81B1370)
Date: Tue, 25 Mar 2014 09:09:24 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>
CC: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@qca.qualcomm.com>
Subject: Re: [PATCH] ath10k: fix printing of peer stats in non-AP firmware
References: <1395734146-10907-1-git-send-email-yeohchunyeow@gmail.com> <CA+BoTQmVw1fiDU_Pu_fowRfFdme-AZ1-qLmxhCHuxFPSK831rw@mail.gmail.com>
In-Reply-To: <CA+BoTQmVw1fiDU_Pu_fowRfFdme-AZ1-qLmxhCHuxFPSK831rw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/25/2014 01:11 AM, Michal Kazior wrote:
> On 25 March 2014 08:55, Chun-Yeow Yeoh <yeohchunyeow@gmail.com> wrote:
>> This patch is intended to fix the problem if we use the
>> firmware 999.999.0.636 to get peer stats when the number
>> of peer is more than 3. The WMI_UPDATE_STATS_EVENTID may
>> trigger more than 1 time if the number of peers is more
>> than 3. So this patch allows us to do the checking on this
>> and make sure that we print the peer stats correctly.
>>
>> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
>> ---
>>  drivers/net/wireless/ath/ath10k/debug.c |    9 ++++++++-
>>  1 file changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
>> index 7be284c..4a4072e 100644
>> --- a/drivers/net/wireless/ath/ath10k/debug.c
>> +++ b/drivers/net/wireless/ath/ath10k/debug.c
>> @@ -245,10 +245,17 @@ void ath10k_debug_read_target_stats(struct ath10k *ar,
>>         if (num_peer_stats) {
>>                 struct wmi_peer_stats_10x *peer_stats;
>>                 struct ath10k_peer_stat *s;
>> +               int j = 0;
>> +
>> +               if (!test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features) &&
>> +                   !num_pdev_stats) {
>> +                       j = 3;
>> +                       num_peer_stats += 3;
>> +               }
>>
>>                 stats->peers = num_peer_stats;
>>
>> -               for (i = 0; i < num_peer_stats; i++) {
>> +               for (i = j; i < num_peer_stats; i++) {
>>                         peer_stats = (struct wmi_peer_stats_10x *)tmp;
>>                         s = &stats->peer_stat[i];
> 
> I suppose there's a limit how much peer entries firmware is able to
> pack up into a single event. The second event you handle here is still
> going to have some sort of a limit and you'll end up dropping results
> again. The same probably goes with vdev stats (which aren't handled
> yet, but hey).

At least in my 10.x 389 firmware, the limit is 11 peers.  There is some
round-robin logic that means next request of stats gets the next set of peer
stats, so calling get-stats multiple times would get the entire list of peers.

I'm not sure how to deal with this in the driver.  In my case, my multiple
stations mostly connect to the same AP, so peer-mac is often the same.
This makes it difficult for me to know if the round-robin logic is working
properly, but I think we might as well assume it does until proven otherwise.
I may try to poke a station identifier into the 16 unused bits of the mac-addr
struct eventually, but unless upstream firmware does the same, that doesn't
help any general issue...

Thanks,
Ben



-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

