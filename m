Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:33883 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753415AbeAJCgf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Jan 2018 21:36:35 -0500
Received: from mail-wr0-f197.google.com ([209.85.128.197])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <chia-lin.kao@canonical.com>)
        id 1eZ6Fm-0007Zl-KC
        for linux-wireless@vger.kernel.org; Wed, 10 Jan 2018 02:36:34 +0000
Received: by mail-wr0-f197.google.com with SMTP id p4so10065525wrf.4
        for <linux-wireless@vger.kernel.org>; Tue, 09 Jan 2018 18:36:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CANUX_P1vZnOdzBvEFw6ayagDg=-eruOdGjM1yWio_==5eUXc5Q@mail.gmail.com>
References: <CAFv23Qmb3myLgexGJ+9-yx2P+3ku-A5pSyrCxA-mU1HCGbuBsQ@mail.gmail.com>
 <CAFv23Qm-VLgfdKPrxCS6rA_kJZD0PJAOc01qvAaKU7VTuAJ+Xw@mail.gmail.com> <CANUX_P1vZnOdzBvEFw6ayagDg=-eruOdGjM1yWio_==5eUXc5Q@mail.gmail.com>
From: AceLan Kao <acelan.kao@canonical.com>
Date: Wed, 10 Jan 2018 10:36:32 +0800
Message-ID: <CAFv23QnStz46D5n4p2v_HtF3Vt8+o6FG1C1LStMODp-+S9EGBQ@mail.gmail.com> (sfid-20180110_033640_285556_2939A684)
Subject: Re: Poor performance on 5G network with Intel 9000 series cards
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Emily Chien <emily.chien@canonical.com>,
        William Kao <william.kao@canonical.com>,
        Anthony Wong <anthony.wong@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yes, I'll update my issue there.
Thanks.

2018-01-10 0:42 GMT+08:00 Emmanuel Grumbach <egrumbach@gmail.com>:
> On Mon, Jan 8, 2018 at 8:34 AM, AceLan Kao <acelan.kao@canonical.com> wrote:
>>
>> Hi all,
>>
>> Forgot to append the device info, here it is.
>>
>> 02:00.0 Network controller [0280]: Intel Corporation Device [8086:2526] (rev 29)
>>         Subsystem: Intel Corporation Device [8086:4010]
>>
>> Best regards,
>> AceLan Kao.
>>
>> 2018-01-08 14:25 GMT+08:00 AceLan Kao <acelan.kao@canonical.com>:
>> > Hi all,
>> >
>> > We found that Intel 9000 series wifi cards have tx performance issue
>> > on 5G network.
>> > Here are the test result.
>> >
>> > Client(10.101.46.25) is the platform with 9260 wifi card on 5G
>> > network, and server(10.101.46.219) is another machine with ethernet
>> > network.
>> >
>
> I think this matches this bug:
> https://bugzilla.kernel.org/show_bug.cgi?id=198351
>
>> > kernel v4.15-rc5 with firmware API 33
>> >
>> > acelan@u-Kabylake-Client-platform ~ % iperf -c 10.101.46.219 -er
>> > ------------------------------------------------------------
>> > Server listening on TCP port 5001 with pid 2248
>> > Read buffer size: 1.44 KByte
>> > TCP window size: 85.3 KByte (default)
>> > ------------------------------------------------------------
>> > ------------------------------------------------------------
>> > Client connecting to 10.101.46.219, TCP port 5001 with pid 2248
>> > Write buffer size: 128 KByte
>> > TCP window size: 85.0 KByte (default)
>> > ------------------------------------------------------------
>> > [ 5] local 10.101.46.25 port 54308 connected with 10.101.46.219 port 5001
>> > [ ID] Interval Transfer Bandwidth Write/Err Rtry Cwnd/RTT
>> > [ 5] 0.00-11.06 sec 7.75 MBytes 5.88 Mbits/sec 1/0 77 7K/165143 us
>> > [ 4] local 10.101.46.25 port 5001 connected with 10.101.46.219 port 38816
>> > [ ID] Interval Transfer Bandwidth Reads Dist(bin=0.2K)
>> > [ 4] 0.00-10.31 sec 77.0 MBytes 62.7 Mbits/sec 55729
>> > 49:23:176:59:1140:294:168:53820
>> >
>> > ------------------------------------------------------------
>> >
>> > With firmware API 34, no luck
>> >
>> > acelan@u-Kabylake-Client-platform ~ % iperf -c 10.101.46.219 -er
>> > ------------------------------------------------------------
>> > Server listening on TCP port 5001 with pid 2138
>> > Read buffer size: 1.44 KByte
>> > TCP window size: 85.3 KByte (default)
>> > ------------------------------------------------------------
>> > ------------------------------------------------------------
>> > Client connecting to 10.101.46.219, TCP port 5001 with pid 2138
>> > Write buffer size: 128 KByte
>> > TCP window size: 187 KByte (default)
>> > ------------------------------------------------------------
>> > [ 5] local 10.101.46.25 port 43560 connected with 10.101.46.219 port 5001
>> > [ ID] Interval Transfer Bandwidth Write/Err Rtry Cwnd/RTT
>> > [ 5] 0.00-10.01 sec 896 KBytes 733 Kbits/sec 1/0 58 7K/140474 us
>> > [ 4] local 10.101.46.25 port 5001 connected with 10.101.46.219 port 38844
>> > [ ID] Interval Transfer Bandwidth Reads Dist(bin=0.2K)
>> > [ 4] 0.00-10.11 sec 79.8 MBytes 66.2 Mbits/sec 57744
>> > 37:6:191:52:1236:413:143:55666
>> >
>> > Any ideas?
>> >
>> > Best regards,
>> > AceLan Kao.
