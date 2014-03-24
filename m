Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:7186 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaCXIW2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2014 04:22:28 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: fix the peer mac address in getting stats
References: <1395380076-4306-1-git-send-email-yeohchunyeow@gmail.com>
	<CA+BoTQmLfdkyN8yC8m-i_yXbhQ3UYVj1kPrdFmYSyLONCC=Kig@mail.gmail.com>
Date: Mon, 24 Mar 2014 10:22:22 +0200
In-Reply-To: <CA+BoTQmLfdkyN8yC8m-i_yXbhQ3UYVj1kPrdFmYSyLONCC=Kig@mail.gmail.com>
	(Michal Kazior's message of "Fri, 21 Mar 2014 07:51:22 +0100")
Message-ID: <87d2hc80qp.fsf@kamboji.qca.qualcomm.com> (sfid-20140324_092233_819646_2AD97C05)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 21 March 2014 06:34, Chun-Yeow Yeoh <yeohchunyeow@gmail.com> wrote:
>> Using the macro to convert the MAC address from WMI word
>> format to char array has lead to the wrong peer mac
>> address printed out while retrieving the peer stats from
>> FW. Fix this.
>>
>> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
>> ---
>>  drivers/net/wireless/ath/ath10k/debug.c |    4 ++--
>>  drivers/net/wireless/ath/ath10k/wmi.h   |   10 ----------
>>  2 files changed, 2 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
>> index 6debd28..f95defa 100644
>> --- a/drivers/net/wireless/ath/ath10k/debug.c
>> +++ b/drivers/net/wireless/ath/ath10k/debug.c
>> @@ -252,8 +252,8 @@ void ath10k_debug_read_target_stats(struct ath10k *ar,
>>                         peer_stats = (struct wmi_peer_stats *)tmp;
>>                         s = &stats->peer_stat[i];
>>
>> -                       WMI_MAC_ADDR_TO_CHAR_ARRAY(&peer_stats->peer_macaddr,
>> -                                                  s->peer_macaddr);
>> +                       memcpy(s->peer_macaddr, &peer_stats->peer_macaddr.addr,
>> +                              ETH_ALEN);
>
> I noticed checkpatch started suggesting to prefer ether_addr_copy()
> over memcpy(). Not a big deal though.

Yeah, especially that I haven't updated my checkpatch for few months and
I don't see this warning yet :) (I'll try to keep ath10k checkpatch
clean whenever possible.)

We need to switch ath10k to use ether_addr_copy() everywhere in a
separate patch anyway.

> Other than that the patch looks good.
>
> Reviewed-By: Michał Kazior <michal.kazior@tieto.com>

Thanks, I added this to the patch.

Let's just hope that the l with the extra line doesn't cause any charset
problems :) BTW, what is the name of the character? Never seen that
before.

-- 
Kalle Valo
