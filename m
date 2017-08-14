Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:36718 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751125AbdHNGxI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Aug 2017 02:53:08 -0400
Received: by mail-qk0-f193.google.com with SMTP id d136so8609335qkg.3
        for <linux-wireless@vger.kernel.org>; Sun, 13 Aug 2017 23:53:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87k226da0d.fsf@kamboji.qca.qualcomm.com>
References: <1502458889-9690-1-git-send-email-amitkarwar@gmail.com>
 <1502458889-9690-6-git-send-email-amitkarwar@gmail.com> <87k226da0d.fsf@kamboji.qca.qualcomm.com>
From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Date: Mon, 14 Aug 2017 12:23:07 +0530
Message-ID: <CAC_mnDkiUkMK6utKnZjDXR6=B-=n9G10xHvWfodb9XEZrY9xKw@mail.gmail.com> (sfid-20170814_085312_871310_D664D3F5)
Subject: Re: [PATCH 05/11] rsi: handle station connection in AP mode
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Amitkumar Karwar <amitkarwar@gmail.com>,
        linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

I will change the debug level and send the updated patches again.

Thanks,
Prameela

On Mon, Aug 14, 2017 at 10:24 AM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Amitkumar Karwar <amitkarwar@gmail.com> writes:
>
>> From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>>
>> Station structures are maintained in driver with required
>> fields. When mac80211 callback sta_add is called, driver
>> iterates through list of connected stations to check available
>> index and assigns station id which is important for further
>> communication to that station. Then peer notify frame is send
>> to firmware to inform the firmware about new station connection.
>>
>> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
>
> [...]
>
>> @@ -1157,18 +1159,81 @@ static int rsi_mac80211_sta_add(struct ieee80211_hw *hw,
>>  {
>>       struct rsi_hw *adapter = hw->priv;
>>       struct rsi_common *common = adapter->priv;
>> +     bool sta_exist = false;
>> +     struct rsi_sta *rsta;
>> +
>> +     print_hex_dump(KERN_INFO, "Station add: ", DUMP_PREFIX_OFFSET,
>> +                    16, 1, sta->addr, ETH_ALEN, 0);
>
> The driver should not spam the logs every time a client connects, so
> this should be a debug message.
>
> --
> Kalle Valo



-- 
G. Prameela Rani (M.Tech,CSE)
