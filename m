Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:40364 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbeHMHjU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Aug 2018 03:39:20 -0400
MIME-Version: 1.0
References: <20180812145207.11395-1-kristian.evensen@gmail.com>
 <871sb3zc3v.fsf@kamboji.qca.qualcomm.com> <5B708025.4090906@broadcom.com>
In-Reply-To: <5B708025.4090906@broadcom.com>
From: Kristian Evensen <kristian.evensen@gmail.com>
Date: Mon, 13 Aug 2018 06:58:35 +0200
Message-ID: <CAKfDRXg=u_mZ_ZZsA2_A=+E5cPDXsWYB2RVXBJpXHp62zvDoHQ@mail.gmail.com> (sfid-20180813_065903_685857_037BE22C)
Subject: Re: [PATCH] mt76: Enable NL80211_EXT_FEATURE_CQM_RSSI_LIST
To: arend.vanspriel@broadcom.com
Cc: kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle & Arnd,
On Sun, Aug 12, 2018 at 8:44 PM Arend van Spriel
<arend.vanspriel@broadcom.com> wrote:
> > So have you tested this and with what devices? For example, does it work
> > with recently added USB devices?
>
> I was looking into this as it looks suspicious to me. From reading the
> description of this ext_feature flag it seems this is an extention of CQM:

Thank you very much for your feedback. My commit message should have
been more detailed, sorry about that. I have checked that the flag
works as intended with mt7602-, mt7603- and mt7612-based wifi cards. I
have not had the opportunity to test with any of the recently added
USB devices, as I don't have access to any of those.

In order to test the flag, I wrote a small program which subscribes to
the CQM-multicast group, passes an RSSI threshold-list to the kernel
and logs the received CQM-events. I then disconnected and connected
the wifi-antennas of the different cards. My threshold list was {-70,
-60, -50, -40} and while unscrewing the antenna I received multiple
below-events. When I attached the antenna again, I received multiple
above-events. As an example, here is the log when I tested with mt7612
(singal level when starting was ~-48 dBm):

Requested nl80211 generic netlink id
nl80211 has generic netlink id: 23
mlme ID is 5
Added socket to mlme group
Sent NL80211_CMD_SET_CQM
No error
Wifi (idx 18) went below threshold. RSSI -52
Wifi (idx 18) went above threshold. RSSI -49
Wifi (idx 18) went below threshold. RSSI -52
Wifi (idx 18) went below threshold. RSSI -62
Wifi (idx 18) went above threshold. RSSI -59
Wifi (idx 18) went above threshold. RSSI -49

Based on how I interpret the output and my understanding of how CQM +
RSSI_LIST works, this output shows that mt76 works fine with
NL80211_EXT_FEATURE_CQM_RSSI_LIST (at least for my cards). The list
was interpreted and handled correctly, as I received events when the
RSSI passed different thresholds in my list (-50, -60).

BR,
Kristian
