Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:33053 "EHLO
        mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751942AbdH2OSF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Aug 2017 10:18:05 -0400
Received: by mail-oi0-f50.google.com with SMTP id r203so28473703oih.0
        for <linux-wireless@vger.kernel.org>; Tue, 29 Aug 2017 07:18:05 -0700 (PDT)
Subject: Re: rtlwifi handling of sequence numbers with aggregation
To: Jes Sorensen <jes.sorensen@gmail.com>
References: <17ea196f-2f77-5110-8f33-4a25765ad34e@gmail.com>
 <a258b2fa-c960-88db-5934-af4c0f4b6435@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <a1d2f17d-dca5-d6c1-f489-74f69e0f146b@lwfinger.net> (sfid-20170829_161809_338087_E3FC2B09)
Date: Tue, 29 Aug 2017 09:18:03 -0500
MIME-Version: 1.0
In-Reply-To: <a258b2fa-c960-88db-5934-af4c0f4b6435@lwfinger.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/25/2017 09:15 PM, Larry Finger wrote:
> On 08/25/2017 12:51 PM, Jes Sorensen wrote:
>> Hi,
>>
>> Looking at some bits in rtlwifi I came across a discrepancy between the
>> PCI and USB code.
>>
>> Consider the following code:
>>
>> In rtl_pci_tx():
>>     if (ieee80211_is_data_qos(fc)) {
>>         tid = rtl_get_tid(skb);
>>         if (sta) {
>>             sta_entry = (struct rtl_sta_info *)sta->drv_priv;
>>             seq_number = (le16_to_cpu(hdr->seq_ctrl) &
>>                       IEEE80211_SCTL_SEQ) >> 4;
>>             seq_number += 1;
>>
>>             if (!ieee80211_has_morefrags(hdr->frame_control))
>>                 sta_entry->tids[tid].seq_number = seq_number;
>>         }
>>
>> In _rtl_usb_tx_preprocess():
>>     if (ieee80211_is_data_qos(fc)) {
>>         qc = ieee80211_get_qos_ctl(hdr);
>>         tid = qc[0] & IEEE80211_QOS_CTL_TID_MASK;
>>         seq_number = (le16_to_cpu(hdr->seq_ctrl) &
>>                  IEEE80211_SCTL_SEQ) >> 4;
>>         seq_number += 1;
>>         seq_number <<= 4;
>>     }
>> [snip]
>>     if (!ieee80211_has_morefrags(hdr->frame_control)) {
>>         if (qc)
>>             mac->tids[tid].seq_number = seq_number;
>>     }
>>
>> The seq_number is picked up from ieee80211_ops->ampdu_action()
>> which calls into rtl_tx_agg_start():
>>     tid_data = &sta_entry->tids[tid];
>>
>>     RT_TRACE(rtlpriv, COMP_SEND, DBG_DMESG,
>>          "on ra = %pM tid = %d seq:%d\n", sta->addr, tid,
>>          tid_data->seq_number);
>>
>>     *ssn = tid_data->seq_number;
>>
>> My question here is why does the USB code shift seq_number << 4 while
>> the PCI code doesn't? I assume one of these is wrong, but which one?
> 
> Based on my prejudices, I would suspect the USB driver before that of the PCI 
> version. I have BCc'd my contact at Realtek to see what he has to say on the issue.

My contact at Realtek replies that the PCI code is correct. He further states 
that "Since mac80211 uses ieee80211_tx_next_seq() to store next sequence number 
in sta->tid_seq[tid] and fill the sequence number in AMPDU parameters, I think 
driver doesn't need to maintain the seq_number anymore. So, let's remove 'u16 
seq_number' from 'struct rtl_tid_data', please refer to attachment." I have not 
had a chance to test his patch, but I trust his analysis.

Larry
