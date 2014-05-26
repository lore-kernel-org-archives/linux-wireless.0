Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:60339 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbaEZJnM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2014 05:43:12 -0400
Received: by mail-wi0-f170.google.com with SMTP id bs8so4024248wib.5
        for <linux-wireless@vger.kernel.org>; Mon, 26 May 2014 02:43:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87y4xoswsa.fsf@kamboji.qca.qualcomm.com>
References: <1399637749-13489-1-git-send-email-michal.kazior@tieto.com>
	<1400143324-14911-1-git-send-email-michal.kazior@tieto.com>
	<1400143324-14911-4-git-send-email-michal.kazior@tieto.com>
	<87y4xoswsa.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 26 May 2014 11:43:07 +0200
Message-ID: <CA+BoTQm+HMaYa4hXaR-Y+YcJDoUXat_E+sUF3_-p5ZmccFwRXg@mail.gmail.com> (sfid-20140526_114315_323280_B7CBA6B7)
Subject: Re: [PATCH v2 3/5] ath10k: drain tx before restarting hw
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26 May 2014 11:40, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> This makes sure no further tx requests are
>> submitted to HTT before driver teardown.
>>
>> This should prevent invalid pointer/NULL
>> dereference on htt tx pool in ath10k_htt_tx() in
>> some cases of heavy traffic.
>>
>> Reported-By: Ben Greear <greearb@candelatech.com>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>> ---
>>  drivers/net/wireless/ath/ath10k/mac.c | 30 ++++++++++++++++++++++++------
>>  1 file changed, 24 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
>> index b5d75b8..577a3a5 100644
>> --- a/drivers/net/wireless/ath/ath10k/mac.c
>> +++ b/drivers/net/wireless/ath/ath10k/mac.c
>> @@ -2289,6 +2289,21 @@ static void ath10k_tx(struct ieee80211_hw *hw,
>>  /*
>>   * Initialize various parameters with default vaules.
>>   */
>> +static void ath10k_drain_tx(struct ath10k *ar)
>> +{
>> +     /* workers can hold conf_mutex -- avoid deadlock */
>> +     WARN_ON(lockdep_is_held(&ar->conf_mutex));
>
> Based on the discussion I modified the function to this now. Are you ok
> with that?
>
> /* Must not be called with conf_mutex held as workers can use that also. */
> static void ath10k_drain_tx(struct ath10k *ar)
> {
>         /* make sure rcu-protected mac80211 tx path itself is drained */
>         synchronize_net();
>
>         ath10k_offchan_tx_purge(ar);
>         ath10k_mgmt_over_wmi_tx_purge(ar);
>
>         cancel_work_sync(&ar->offchan_tx_work);
>         cancel_work_sync(&ar->wmi_mgmt_tx_work);
> }
>
> Full patch:
>
> https://github.com/kvalo/ath/commit/e3c513cd03802e75802a6ce5efbadaa0dbf04b27

Looks good, thanks!


Michał
