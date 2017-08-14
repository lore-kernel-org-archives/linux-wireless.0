Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:37933 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751000AbdHNTKw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Aug 2017 15:10:52 -0400
Received: by mail-wm0-f50.google.com with SMTP id f15so336807wmg.1
        for <linux-wireless@vger.kernel.org>; Mon, 14 Aug 2017 12:10:52 -0700 (PDT)
Subject: Re: [PATCH 05/11] rsi: handle station connection in AP mode
To: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: Amitkumar Karwar <amitkarwar@gmail.com>,
        linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
References: <1502458889-9690-1-git-send-email-amitkarwar@gmail.com>
 <1502458889-9690-6-git-send-email-amitkarwar@gmail.com>
 <87k226da0d.fsf@kamboji.qca.qualcomm.com>
 <CAC_mnDkiUkMK6utKnZjDXR6=B-=n9G10xHvWfodb9XEZrY9xKw@mail.gmail.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <416d9508-0cd2-24d5-420d-7002c1882202@broadcom.com> (sfid-20170814_211057_419085_28590D53)
Date: Mon, 14 Aug 2017 21:10:50 +0200
MIME-Version: 1.0
In-Reply-To: <CAC_mnDkiUkMK6utKnZjDXR6=B-=n9G10xHvWfodb9XEZrY9xKw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14-08-17 08:53, Prameela Rani Garnepudi wrote:
> Hi Kalle,
> 
> I will change the debug level and send the updated patches again.
> 
> Thanks,
> Prameela

Please do not top-post.

> On Mon, Aug 14, 2017 at 10:24 AM, Kalle Valo <kvalo@codeaurora.org> wrote:
>> Amitkumar Karwar <amitkarwar@gmail.com> writes:
>>
>>> From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>>>
>>> Station structures are maintained in driver with required
>>> fields. When mac80211 callback sta_add is called, driver
>>> iterates through list of connected stations to check available
>>> index and assigns station id which is important for further
>>> communication to that station. Then peer notify frame is send
>>> to firmware to inform the firmware about new station connection.
>>>
>>> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>>> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
>>
>> [...]
>>
>>> @@ -1157,18 +1159,81 @@ static int rsi_mac80211_sta_add(struct ieee80211_hw *hw,
>>>   {
>>>        struct rsi_hw *adapter = hw->priv;
>>>        struct rsi_common *common = adapter->priv;
>>> +     bool sta_exist = false;
>>> +     struct rsi_sta *rsta;
>>> +
>>> +     print_hex_dump(KERN_INFO, "Station add: ", DUMP_PREFIX_OFFSET,
>>> +                    16, 1, sta->addr, ETH_ALEN, 0);
>>
>> The driver should not spam the logs every time a client connects, so
>> this should be a debug message.

I am wondering why print_hex_dump() is used for printing the station mac 
address. Just use: pr_debug("Station add: %pM\n", sta->addr);

Regards,
Arend
