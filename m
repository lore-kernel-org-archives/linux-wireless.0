Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35176 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753109AbdHOHU1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Aug 2017 03:20:27 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: Re: [PATCH 05/11] rsi: handle station connection in AP mode
References: <1502458889-9690-1-git-send-email-amitkarwar@gmail.com>
        <1502458889-9690-6-git-send-email-amitkarwar@gmail.com>
        <87k226da0d.fsf@kamboji.qca.qualcomm.com>
        <CAC_mnDkiUkMK6utKnZjDXR6=B-=n9G10xHvWfodb9XEZrY9xKw@mail.gmail.com>
        <416d9508-0cd2-24d5-420d-7002c1882202@broadcom.com>
Date: Tue, 15 Aug 2017 10:20:19 +0300
In-Reply-To: <416d9508-0cd2-24d5-420d-7002c1882202@broadcom.com> (Arend van
        Spriel's message of "Mon, 14 Aug 2017 21:10:50 +0200")
Message-ID: <871sodb8lo.fsf@kamboji.qca.qualcomm.com> (sfid-20170815_092030_927435_389AF2BC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

>>>> @@ -1157,18 +1159,81 @@ static int rsi_mac80211_sta_add(struct ieee80211_hw *hw,
>>>>   {
>>>>        struct rsi_hw *adapter = hw->priv;
>>>>        struct rsi_common *common = adapter->priv;
>>>> +     bool sta_exist = false;
>>>> +     struct rsi_sta *rsta;
>>>> +
>>>> +     print_hex_dump(KERN_INFO, "Station add: ", DUMP_PREFIX_OFFSET,
>>>> +                    16, 1, sta->addr, ETH_ALEN, 0);
>>>
>>> The driver should not spam the logs every time a client connects, so
>>> this should be a debug message.
>
> I am wondering why print_hex_dump() is used for printing the station
> mac address. Just use: pr_debug("Station add: %pM\n", sta->addr);

Good point. Except that IIRC rsi has it's own debugging macros and you
can use those, you don't need to use pr_debug() (unless you want to).

-- 
Kalle Valo
