Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f170.google.com ([74.125.82.170]:53803 "EHLO
        mail-ot0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755342AbdKJBaH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Nov 2017 20:30:07 -0500
Received: by mail-ot0-f170.google.com with SMTP id n19so6613814ote.10
        for <linux-wireless@vger.kernel.org>; Thu, 09 Nov 2017 17:30:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171103095112.GA14915@jouni.qca.qualcomm.com>
References: <CAD8Lp47N8ENCPp0ELd5_H8efEna9FGemM-vvi0kf7=coG5tNXA@mail.gmail.com>
 <20171103095112.GA14915@jouni.qca.qualcomm.com>
From: Daniel Drake <drake@endlessm.com>
Date: Fri, 10 Nov 2017 09:30:05 +0800
Message-ID: <CAD8Lp4422+RK+=JQeBv78ibv2onOaxpd7bcHjObR0DvYaNNZ8A@mail.gmail.com> (sfid-20171110_023010_993441_3ECBD574)
Subject: Re: ath9k disconnects in 4.13 with reason=4 locally_generated=1
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        ath9k-devel <ath9k-devel@qca.qualcomm.com>,
        Linux Upstreaming Team <linux@endlessm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 3, 2017 at 5:51 PM, Jouni Malinen <jouni@qca.qualcomm.com> wrote:
> On Fri, Nov 03, 2017 at 10:57:11AM +0800, Daniel Drake wrote:
>> Endless OS recently upgraded from Linux 4.11 to Linux 4.13, and we now
>> have a few reports of issues with ath9k wireless becoming unusable.
>>
>> In the logs we can see that it authenticates, associates and completes
>> the WPA 4 way handshake, before then being disconnected with:
>>
>>  wlp2s0: CTRL-EVENT-DISCONNECTED bssid=74:26:ac:68:2f:c0 reason=4
>> locally_generated=1
>
> reason=4 is WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY. I'd expect the most
> likely source of this to be one of the mac80211 code paths in mlme.c
> where disconnection is triggered if the current AP become unreachable.
> Getting a debug log from mac80211 might help in figuring out what is
> causing this (there seem to be number of mlme_dbg() calls before most,
> but not necessarily all, places where
> WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY is used).

We got the log, it is coming from ieee80211_sta_work()

        else if (ieee80211_hw_check(&local->hw, REPORTS_TX_ACK_STATUS)) {
            sdata_info(sdata,t
                 "Failed to send nullfunc to AP %pM after %dms,
disconnecting\n",
                 bssid, probe_wait_ms);
            ieee80211_sta_connection_lost(sdata, bssid,
                WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY, false);

I looked again at changes between 4.12 and 4.13 and still no idea how
4.13 causes this problem :(

Daniel
