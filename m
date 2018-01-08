Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:49063 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755465AbeAHGem (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Jan 2018 01:34:42 -0500
Received: from mail-wm0-f71.google.com ([74.125.82.71])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <chia-lin.kao@canonical.com>)
        id 1eYR17-0002Sc-88
        for linux-wireless@vger.kernel.org; Mon, 08 Jan 2018 06:34:41 +0000
Received: by mail-wm0-f71.google.com with SMTP id v184so5245503wmf.1
        for <linux-wireless@vger.kernel.org>; Sun, 07 Jan 2018 22:34:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAFv23Qmb3myLgexGJ+9-yx2P+3ku-A5pSyrCxA-mU1HCGbuBsQ@mail.gmail.com>
References: <CAFv23Qmb3myLgexGJ+9-yx2P+3ku-A5pSyrCxA-mU1HCGbuBsQ@mail.gmail.com>
From: AceLan Kao <acelan.kao@canonical.com>
Date: Mon, 8 Jan 2018 14:34:39 +0800
Message-ID: <CAFv23Qm-VLgfdKPrxCS6rA_kJZD0PJAOc01qvAaKU7VTuAJ+Xw@mail.gmail.com> (sfid-20180108_073447_618771_635C409D)
Subject: Re: Poor performance on 5G network with Intel 9000 series cards
To: linux-wireless@vger.kernel.org
Cc: Emily Chien <emily.chien@canonical.com>,
        William Kao <william.kao@canonical.com>,
        Anthony Wong <anthony.wong@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

Forgot to append the device info, here it is.

02:00.0 Network controller [0280]: Intel Corporation Device [8086:2526] (rev 29)
        Subsystem: Intel Corporation Device [8086:4010]

Best regards,
AceLan Kao.

2018-01-08 14:25 GMT+08:00 AceLan Kao <acelan.kao@canonical.com>:
> Hi all,
>
> We found that Intel 9000 series wifi cards have tx performance issue
> on 5G network.
> Here are the test result.
>
> Client(10.101.46.25) is the platform with 9260 wifi card on 5G
> network, and server(10.101.46.219) is another machine with ethernet
> network.
>
> kernel v4.15-rc5 with firmware API 33
>
> acelan@u-Kabylake-Client-platform ~ % iperf -c 10.101.46.219 -er
> ------------------------------------------------------------
> Server listening on TCP port 5001 with pid 2248
> Read buffer size: 1.44 KByte
> TCP window size: 85.3 KByte (default)
> ------------------------------------------------------------
> ------------------------------------------------------------
> Client connecting to 10.101.46.219, TCP port 5001 with pid 2248
> Write buffer size: 128 KByte
> TCP window size: 85.0 KByte (default)
> ------------------------------------------------------------
> [ 5] local 10.101.46.25 port 54308 connected with 10.101.46.219 port 5001
> [ ID] Interval Transfer Bandwidth Write/Err Rtry Cwnd/RTT
> [ 5] 0.00-11.06 sec 7.75 MBytes 5.88 Mbits/sec 1/0 77 7K/165143 us
> [ 4] local 10.101.46.25 port 5001 connected with 10.101.46.219 port 38816
> [ ID] Interval Transfer Bandwidth Reads Dist(bin=0.2K)
> [ 4] 0.00-10.31 sec 77.0 MBytes 62.7 Mbits/sec 55729
> 49:23:176:59:1140:294:168:53820
>
> ------------------------------------------------------------
>
> With firmware API 34, no luck
>
> acelan@u-Kabylake-Client-platform ~ % iperf -c 10.101.46.219 -er
> ------------------------------------------------------------
> Server listening on TCP port 5001 with pid 2138
> Read buffer size: 1.44 KByte
> TCP window size: 85.3 KByte (default)
> ------------------------------------------------------------
> ------------------------------------------------------------
> Client connecting to 10.101.46.219, TCP port 5001 with pid 2138
> Write buffer size: 128 KByte
> TCP window size: 187 KByte (default)
> ------------------------------------------------------------
> [ 5] local 10.101.46.25 port 43560 connected with 10.101.46.219 port 5001
> [ ID] Interval Transfer Bandwidth Write/Err Rtry Cwnd/RTT
> [ 5] 0.00-10.01 sec 896 KBytes 733 Kbits/sec 1/0 58 7K/140474 us
> [ 4] local 10.101.46.25 port 5001 connected with 10.101.46.219 port 38844
> [ ID] Interval Transfer Bandwidth Reads Dist(bin=0.2K)
> [ 4] 0.00-10.11 sec 79.8 MBytes 66.2 Mbits/sec 57744
> 37:6:191:52:1236:413:143:55666
>
> Any ideas?
>
> Best regards,
> AceLan Kao.
