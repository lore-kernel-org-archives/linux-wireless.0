Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:52228 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266AbaGUIxS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2014 04:53:18 -0400
Received: by mail-lb0-f169.google.com with SMTP id s7so4520351lbd.14
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jul 2014 01:53:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87pph225mq.fsf@kamboji.qca.qualcomm.com>
References: <1405342041-7114-1-git-send-email-janusz.dziedzic@tieto.com>
	<87pph225mq.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 21 Jul 2014 10:53:16 +0200
Message-ID: <CALhHN=q2XcvPiLpeDgw_DksU1xzQLvJtxjzk8iZte-VMd+viLg@mail.gmail.com> (sfid-20140721_105322_579854_E217AC30)
Subject: Re: [PATCH] ath10k: handle attention flags correctly when A-MSDU
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18 July 2014 14:50, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:
>
>> In case of A-MSDU RX we should check flags for all
>> MSDU subframes to be sure we have correct FCS status.
>>
>> Before we check attention flags only for first frame
>> where we didn't have correct info about FCS status in
>> case of A-MSDU. Next didn't mark RX_FLAG_FAILED_FCS_CRC
>> for skb. As a side efect we see big TP drop when TCP used.
>> This was easy to reproduce when AP interface was used
>> and added monitor interface run in promiscuous mode.
>>
>> Reported-by: Denton Gentry <denton.gentry@gmail.com>
>> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
>
> I'm having a hard time to understand the commit log. I think it would
> make it easier to read if you first clearly describe the bug you are
> fixing and then, in a separate paragraph, tell how you fix it.
>
Will change that.

> So what is the bug Denton reported? "we see big TP drop when TCP used"
> implies that this happens with all TCP traffic, but that can't be right.
> Or did it happen with one of the reorder patches?
>
TP drop is seen with/without reordering patches when TCP STA --> AP and:
- used ath10k STA
- I force to use AMSDU (7 frames) on STA
- not using cables and other traffic on the channel (often FCS errors)
- monitor iface used on AP

Without a patch we report AMSDU packets with wrong FCS as a correct to
the stack, next there is a lot of DUP ACK packets from AP --> STA.
TP drop depends on FCS errors for AMSDU.


This is example what I see without patch (without reordering patch):

echo "1 64" > htt_max_amsdu_ampdu
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0- 5.0 sec  56.6 MBytes  95.0 Mbits/sec
[  3]  5.0-10.0 sec  60.4 MBytes   101 Mbits/sec
[  3] 10.0-15.0 sec  60.2 MBytes   101 Mbits/sec
[  3] 15.0-20.0 sec  60.2 MBytes   101 Mbits/sec
[  3] 20.0-25.0 sec  63.8 MBytes   107 Mbits/sec
[  3] 25.0-30.0 sec  64.9 MBytes   109 Mbits/sec

echo "7 64" > htt_max_amsdu_ampdu  // lot of DUP ACK from AP --> STA seen
[  3] 30.0-35.0 sec  40.0 MBytes  67.1 Mbits/sec
[  3] 35.0-40.0 sec  35.9 MBytes  60.2 Mbits/sec
[  3] 40.0-45.0 sec  36.9 MBytes  61.9 Mbits/sec
[  3] 45.0-50.0 sec  37.9 MBytes  63.5 Mbits/sec
[  3] 50.0-55.0 sec  34.5 MBytes  57.9 Mbits/sec
[  3] 55.0-60.0 sec  25.4 MBytes  42.6 Mbits/sec
[  3] 60.0-65.0 sec  48.2 MBytes  81.0 Mbits/sec
[  3] 65.0-70.0 sec  28.8 MBytes  48.2 Mbits/sec
[  3] 70.0-75.0 sec  29.2 MBytes  49.1 Mbits/sec
[  3] 75.0-80.0 sec  22.9 MBytes  38.4 Mbits/sec
[  3] 80.0-85.0 sec  26.4 MBytes  44.2 Mbits/sec
[  3] 85.0-90.0 sec  31.5 MBytes  52.8 Mbits/sec


With patch:

echo "1 64" > htt_max_amsdu_ampdu
[  3] local 192.168.12.2 port 57512 connected with 192.168.12.1 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0- 5.0 sec  60.8 MBytes   102 Mbits/sec
[  3]  5.0-10.0 sec  62.2 MBytes   104 Mbits/sec
[  3] 10.0-15.0 sec  60.9 MBytes   102 Mbits/sec

echo "7 64" > htt_max_amsdu_ampdu  // none DUP ACK form AP --> STA seen
[  3] 15.0-20.0 sec  68.1 MBytes   114 Mbits/sec
[  3] 20.0-25.0 sec  80.5 MBytes   135 Mbits/sec
[  3] 25.0-30.0 sec  83.0 MBytes   139 Mbits/sec
[  3] 30.0-35.0 sec  79.1 MBytes   133 Mbits/sec
[  3] 35.0-40.0 sec  77.1 MBytes   129 Mbits/sec
[  3] 40.0-45.0 sec  77.4 MBytes   130 Mbits/sec


BR
Janusz
