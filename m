Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33965 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753990AbcKORbS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Nov 2016 12:31:18 -0500
Received: by mail-wm0-f67.google.com with SMTP id g23so2220212wme.1
        for <linux-wireless@vger.kernel.org>; Tue, 15 Nov 2016 09:31:18 -0800 (PST)
Subject: Re: [RFC 02/12] ath10k: htc: rx trailer lookahead support
To: Michal Kazior <michal.kazior@tieto.com>
References: <1479141222-8493-1-git-send-email-erik.stromdahl@gmail.com>
 <1479141222-8493-3-git-send-email-erik.stromdahl@gmail.com>
 <CA+BoTQkJqv28=Mg1ncmyznRo-CLh6Y_OW-mJ+YTyqaREaqp39Q@mail.gmail.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
From: Erik Stromdahl <erik.stromdahl@gmail.com>
Message-ID: <ac58b3f6-4432-b0b6-8b50-c733f898eded@gmail.com> (sfid-20161115_183123_062153_8F93B996)
Date: Tue, 15 Nov 2016 18:31:15 +0100
MIME-Version: 1.0
In-Reply-To: <CA+BoTQkJqv28=Mg1ncmyznRo-CLh6Y_OW-mJ+YTyqaREaqp39Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 11/15/2016 10:57 AM, Michal Kazior wrote:
> On 14 November 2016 at 17:33, Erik Stromdahl <erik.stromdahl@gmail.com> wrote:
>> The RX trailer parsing is now capable of parsing lookahead reports.
>> This is needed by SDIO/mbox.
> 
> It'd be useful to know what exactly lookahead will be used for. What
> payload does it carry.
> 
It carries the 4 first bytes of the next RX message, i.e. the first 4
bytes of an HTC header.

It is used by the sdio interrupt handler to know if the next packet is a
part of an RX bundle, which endpoint it belongs to and how long it is
(so we know how many bytes to allocate).

> 
>> Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
>> ---
>>  drivers/net/wireless/ath/ath10k/htc.c |   91 ++++++++++++++++++++++++++++++++-
>>  drivers/net/wireless/ath/ath10k/htc.h |   30 +++++++++--
>>  2 files changed, 116 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
>> index 26b1e15..e3f7bf4 100644
>> --- a/drivers/net/wireless/ath/ath10k/htc.c
>> +++ b/drivers/net/wireless/ath/ath10k/htc.c
>> @@ -228,10 +228,74 @@ void ath10k_htc_tx_completion_handler(struct ath10k *ar, struct sk_buff *skb)
>>         spin_unlock_bh(&htc->tx_lock);
>>  }
>>
>> +static int
>> +ath10k_htc_process_lookahead(struct ath10k_htc *htc,
>> +                            const struct ath10k_htc_lookahead_report *report,
>> +                            int len,
>> +                            enum ath10k_htc_ep_id eid,
>> +                            u32 *next_lk_ahds,
> 
> next_lk_ahds should be u8 or void. From what I understand by glancing
> through the code it is an agnostic buffer that carries payload which
> is later interpreted either as eid or htc header, right? void is
> probably most suitable in this case for passing around and u8 for
> inline-based storage.
> 
Sounds reasonable, I'll change to void pointer.

> I'd also avoid silly abbreviations. Probably "lookahead" alone is enough.
> 
Ok, this abbreviation was actually taken from the ath6kl code. I think
the intention was to reduce line lengths.

>> +                            int *next_lk_ahds_len)
>> +{
>> +       struct ath10k *ar = htc->ar;
>> +
>> +       if (report->pre_valid != ((~report->post_valid) & 0xFF))
>> +               /* Invalid lookahead flags are actually transmitted by
>> +                * the target in the HTC control message.
>> +                * Since this will happen at every boot we silently ignore
>> +                * the lookahead in this case
>> +                */
> 
> I'd put this comment before the if().

Ok
> 
> 
>> +               return 0;
>> +
>> +       if (next_lk_ahds && next_lk_ahds_len) {
>> +               ath10k_dbg(ar, ATH10K_DBG_HTC,
>> +                          "htc rx lk_ahd found pre_valid 0x%x post_valid 0x%x\n",
>> +                          report->pre_valid, report->post_valid);
>> +
>> +               /* look ahead bytes are valid, copy them over */
>> +               memcpy((u8 *)&next_lk_ahds[0], report->lk_ahd, 4);
>> +
>> +               *next_lk_ahds_len = 1;
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +static int
>> +ath10k_htc_process_lookahead_bundle(struct ath10k_htc *htc,
>> +                                   const struct ath10k_htc_lookahead_report_bundle *report,
>> +                                   int len,
>> +                                   enum ath10k_htc_ep_id eid,
>> +                                   u32 *next_lk_ahds,
> 
> Ditto. void.
> 
> 
>> +                                   int *next_lk_ahds_len)
>> +{
>> +       int bundle_cnt = len / sizeof(*report);
>> +
>> +       if (!bundle_cnt || (bundle_cnt > HTC_HOST_MAX_MSG_PER_BUNDLE)) {
>> +               WARN_ON(1);
> 
> This should be ath10k_warn() instead. This isn't internal driver flow
> assertion. It is possible firmware bug or revision misalignment
> instead.
> 
Ok

> 
>> +               return -EINVAL;
>> +       }
>> +
>> +       if (next_lk_ahds && next_lk_ahds_len) {
>> +               int i;
>> +
>> +               for (i = 0; i < bundle_cnt; i++) {
>> +                       memcpy((u8 *)&next_lk_ahds[i], report->lk_ahd,
>> +                              sizeof(u32));
> 
> You'll need to re-adjust the &x[i] to maintain proper offset with void pointer.
> 
> 
> Michał
> 
