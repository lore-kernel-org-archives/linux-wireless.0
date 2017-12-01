Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:1253 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750914AbdLAPok (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Dec 2017 10:44:40 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: "akolli@codeaurora.org" <akolli@codeaurora.org>
CC: "mbizon@freebox.fr" <mbizon@freebox.fr>,
        "linux-wireless-owner@vger.kernel.org"
        <linux-wireless-owner@vger.kernel.org>,
        Anilkumar Kolli <akolli@qti.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH 2/2] ath10k: add per peer tx stats support for 10.2.4
Date: Fri, 1 Dec 2017 15:44:33 +0000
Message-ID: <87374uxxjy.fsf@kamboji.qca.qualcomm.com> (sfid-20171201_164443_961430_828F6275)
References: <1512046701-14435-1-git-send-email-akolli@qti.qualcomm.com>
        <1512046701-14435-3-git-send-email-akolli@qti.qualcomm.com>
        <1512125137.38490.70.camel@sakura.staff.proxad.net>
        <7792e2fb2c546d8745c65e48945f2535@codeaurora.org>
In-Reply-To: <7792e2fb2c546d8745c65e48945f2535@codeaurora.org>
        (akolli@codeaurora.org's message of "Fri, 01 Dec 2017 19:18:00 +0530")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

akolli@codeaurora.org writes:

>>> Parse peer stats from pktlog packets and update the tx rate
>>> information
>>> per STA. This way user space can query about transmit rate with iw:
>>
>> everything works ok, ath10k_update_per_peer_tx_stats() is called and
>> ath10k_sta fields are updated correctly
>>
>> but tx bitrate is still 6 MBit/s in station dump
>>
> Hope CONFIG_MAC80211_DEBUGFS is enabled in your build.
> Please Run ping traffic and see and 'station dump'

This feature should not depend on debugfs. Why is it needed? In patch 1
you already moved pktlog_filter to struct ath10k, does it need something
else as well?

--=20
Kalle Valo=
