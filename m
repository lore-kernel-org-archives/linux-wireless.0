Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:40476 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbaHSJoM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Aug 2014 05:44:12 -0400
Received: by mail-wi0-f170.google.com with SMTP id f8so4902199wiw.1
        for <linux-wireless@vger.kernel.org>; Tue, 19 Aug 2014 02:44:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+BoTQmubLrvB1LHquFDNf8W06vePvEk6K3aNV9ngCAAXemY6w@mail.gmail.com>
References: <20140819082038.16842.46876.stgit@potku.adurom.net>
	<20140819082300.16842.40769.stgit@potku.adurom.net>
	<CA+BoTQmubLrvB1LHquFDNf8W06vePvEk6K3aNV9ngCAAXemY6w@mail.gmail.com>
Date: Tue, 19 Aug 2014 11:44:11 +0200
Message-ID: <CA+BoTQ=UduqFY6G=sXJR43hQWk-4v09uYvYJYKO7EGuea7L-Xg@mail.gmail.com> (sfid-20140819_114415_423543_27C8542F)
Subject: Re: [PATCH v7 3/8] ath10k: save firmware debug log messages
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19 August 2014 11:39, Michal Kazior <michal.kazior@tieto.com> wrote:

I miss-clicked, sorry for the noise.


> On 19 August 2014 10:23, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> They may be dumped through the firmware dump debugfs
>> file.
>>
>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
>> ---
>>  drivers/net/wireless/ath/ath10k/wmi.c |   10 ++++++++++
>>  1 file changed, 10 insertions(+)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
>> index 23acbadeb8fa..eafc565240f1 100644
>> --- a/drivers/net/wireless/ath/ath10k/wmi.c
>> +++ b/drivers/net/wireless/ath/ath10k/wmi.c
>> @@ -1290,6 +1290,16 @@ static int ath10k_wmi_event_debug_mesg(struct ath10k *ar, struct sk_buff *skb)
>>
>>         trace_ath10k_wmi_dbglog(skb->data, skb->len);
>>
>> +       spin_lock_bh(&ar->data_lock);
>> +
>> +       /* First 4 bytes are a messages-dropped-due-to-overflow counter,
>> +        * and should not be recorded in the dbglog buffer, so we skip
>> +        * them.
>> +        */
>> +       ath10k_debug_dbglog_add(ar, skb->data + 4, skb->len - 4);

Can't we just:

struct wmi_dbg_msg {
  __le32 num_dropped_due_to_overflow;
  u8 payload[0]; // is this an array of u8 or __le32 actually?
};


Michał
