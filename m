Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:45053 "EHLO
        mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750743AbeEAWls (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 May 2018 18:41:48 -0400
MIME-Version: 1.0
In-Reply-To: <059b40f0-b8e2-b55f-92d5-a859ba4204a4@lwfinger.net>
References: <CA+A7VXX+z8FrDhzW2BQ6AGMJ=_j_53wkUL_YNgkreEbWSh+jCw@mail.gmail.com>
 <afdf0498-c0a9-936c-0c9b-1b6da6eb5957@lwfinger.net> <CA+A7VXWjWaSSUiX3h_rpFXrSwtUkynKR9tpvnsSe=DZrC+mF-Q@mail.gmail.com>
 <059b40f0-b8e2-b55f-92d5-a859ba4204a4@lwfinger.net>
From: =?UTF-8?Q?Jo=C3=A3o_Paulo_Rechi_Vita?= <jprvita@gmail.com>
Date: Tue, 1 May 2018 15:41:07 -0700
Message-ID: <CA+A7VXUUsZHD2gr9TBcV6jZBOPGZv7_vK-wWZ0MvGgiCnAiUgQ@mail.gmail.com> (sfid-20180502_004307_767436_C47A5D65)
Subject: Re: RTL8723BE performance regression
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Steve deRosier <derosier@gmail.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>,
        Steven Ting <steventing@realtek.com>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Drake <drake@endlessm.com>,
        =?UTF-8?Q?Jo=C3=A3o_Paulo_Rechi_Vita?= <jprvita@endlessm.com>,
        linux@endlessm.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 3, 2018 at 7:51 PM, Larry Finger <Larry.Finger@lwfinger.net> wr=
ote:
> On 04/03/2018 09:37 PM, Jo=C3=A3o Paulo Rechi Vita wrote:
>>
>> On Tue, Apr 3, 2018 at 7:28 PM, Larry Finger <Larry.Finger@lwfinger.net>
>> wrote:
>>
>> (...)
>>
>>> As the antenna selection code changes affected your first bisection, do
>>> you
>>> have one of those HP laptops with only one antenna and the incorrect
>>> coding
>>> in the FUSE?
>>
>>
>> Yes, that is why I've been passing ant_sel=3D1 during my tests -- this
>> was needed to achieve a good performance in the past, before this
>> regression. I've also opened the laptop chassis and confirmed the
>> antenna cable is plugged to the connector labeled with "1" on the
>> card.
>>
>>> If so, please make sure that you still have the same signal
>>> strength for good and bad cases. I have tried to keep the driver and th=
e
>>> btcoex code in sync, but there may be some combinations of antenna
>>> configuration and FUSE contents that cause the code to fail.
>>>
>>
>> What is the recommended way to monitor the signal strength?
>
>
> The btcoex code is developed for multiple platforms by a different group
> than the Linux driver. I think they made a change that caused ant_sel to
> switch from 1 to 2. At least numerous comments at
> github.com/lwfinger/rtlwifi_new claimed they needed to make that change.
>
> Mhy recommended method is to verify the wifi device name with "iw dev". T=
hen
> using that device
>
> sudo iw dev <dev_name> scan | egrep "SSID|signal"
>

I have confirmed that the performance regression is indeed tied to
signal strength: on the good cases signal was between -16 and -8 dBm,
whereas in bad cases signal was always between -50 to - 40 dBm. I've
also switched to testing bandwidth in controlled LAN environment using
iperf3, as suggested by Steve deRosier, with the DUT being the only
machine connected to the 2.4 GHz radio and the machine running the
iperf3 server connected via ethernet.

Using those two tests (iperf3 and signal strength) I've dug deeper
into the culprit I had found previously, commit 7937f02d1953,
reverting it partially and testing the resulting driver, to isolate
which change was causing the problem. Besides "hooking up external
functions for newer ICs", as described by the commit message, that
commit also added code to decided whether ex_btc8723b1ant_*() or
ex_btc8723b2ant_*() functions should be used in halbtcoutsrc.c,
depending on the value of board_info.btdm_ant_num, whereas before that
commit ex_btc8723b2ant_*() were always used. Reverting to always using
ex_btc8723b2ant_*() functions fixes the regression on v4.15.

I've also tried to bisect between v4.15..v4.16 to find what else was
causing problems there, as the changes mentioned above on top of v4.16
did not solve the problem. The bisect pointed to "874e837d67d0
rtlwifi: fill FW version and subversion", only but reverting it plus
the changes mentioned above also didn't yield good results. That's
when I decided to get a bit creative: starting on v4.16 I first
applied the changes to have ex_btc8723b2ant_*() always being used, as
mentioned above, then reverted every commit between v4.15..v4.16
affecting drivers/net/wireless/realtek/rtlwifi/, and verified the
resulting kernel had a good performance. Then I started trimming down
the history and testing along the way, to reduce to the minimum set of
changes that had to be reverted in order to restore the good
performance. In addition to the ex_btc8723b2ant_*() changes and
reverting "874e837d67d0 rtlwifi: fill FW version and subversion", I've
also had to remove the following lines from
drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c, which
were introduced by "40d9dd4f1c5d rtlwifi: btcoex: Remove global
variables from btcoex", in order to restore the upload performance and
signal strength.

        /* set default antenna position to main  port */
        btcoexist->board_info.btdm_ant_pos =3D BTC_ANTENNA_AT_MAIN_PORT;

These are the results I've got on v4.16 (similarly on
wireless-drivers-next-for-davem-2018-03-29 or v4.15):

     $ sudo iw dev wlp2s0 scan | grep -B3 JJ | grep signal
            signal: -42.00 dBm
     $ iperf3 -c 192.168.1.254
     Connecting to host 192.168.1.254, port 5201
     [  4] local 192.168.1.253 port 39678 connected to 192.168.1.254 port 5=
201
     [ ID] Interval           Transfer     Bandwidth       Retr  Cwnd
     [  4]   0.00-1.00   sec   735 KBytes  6.02 Mbits/sec    1   1.41 KByte=
s
     [  4]   1.00-2.00   sec   274 KBytes  2.25 Mbits/sec    1   1.41 KByte=
s
     [  4]   2.00-3.00   sec  0.00 Bytes  0.00 bits/sec    0   1.41 KBytes
     [  4]   3.00-4.00   sec  0.00 Bytes  0.00 bits/sec    0   1.41 KBytes
     [  4]   4.00-5.00   sec  0.00 Bytes  0.00 bits/sec    1   28.3 KBytes
     [  4]   5.00-6.00   sec   423 KBytes  3.47 Mbits/sec    3   41.0 KByte=
s
     [  4]   6.00-7.00   sec   840 KBytes  6.88 Mbits/sec    0   58.0 KByte=
s
     [  4]   7.00-8.00   sec   830 KBytes  6.79 Mbits/sec    1   1.41 KByte=
s
     [  4]   8.00-9.00   sec  0.00 Bytes  0.00 bits/sec    0   1.41 KBytes
     [  4]   9.00-10.00  sec  0.00 Bytes  0.00 bits/sec    0   1.41 KBytes
     - - - - - - - - - - - - - - - - - - - - - - - - -
     [ ID] Interval           Transfer     Bandwidth       Retr
     [  4]   0.00-10.00  sec  3.03 MBytes  2.54 Mbits/sec    7
    sender
     [  4]   0.00-10.00  sec  2.88 MBytes  2.41 Mbits/sec
    receiver

     iperf Done.

And these are the results on v4.16 with all the changes mentioned on
the previous paragraph, and similar results were obtained when
applying the same changes on the current wireless-drivers-next master
branch (f56324baf329):

     $ sudo iw dev wlp2s0 scan | grep -B3 JJ | grep signal
            signal: -14.00 dBm
     $ iperf3 -c 192.168.1.254
     Connecting to host 192.168.1.254, port 5201
     [  4] local 192.168.1.253 port 59380 connected to 192.168.1.254 port 5=
201
     [ ID] Interval           Transfer     Bandwidth       Retr  Cwnd
     [  4]   0.00-1.00   sec  4.63 MBytes  38.8 Mbits/sec    0    194 KByte=
s
     [  4]   1.00-2.00   sec  4.58 MBytes  38.4 Mbits/sec    0    273 KByte=
s
     [  4]   2.00-3.00   sec  5.05 MBytes  42.3 Mbits/sec    0    332 KByte=
s
     [  4]   3.00-4.00   sec  4.98 MBytes  41.8 Mbits/sec    0    393 KByte=
s
     [  4]   4.00-5.00   sec  4.76 MBytes  39.9 Mbits/sec    0    434 KByte=
s
     [  4]   5.00-6.00   sec  4.85 MBytes  40.7 Mbits/sec    0    434 KByte=
s
     [  4]   6.00-7.00   sec  3.96 MBytes  33.2 Mbits/sec    0    464 KByte=
s
     [  4]   7.00-8.00   sec  4.74 MBytes  39.8 Mbits/sec    0    481 KByte=
s
     [  4]   8.00-9.00   sec  4.22 MBytes  35.4 Mbits/sec    0    508 KByte=
s
     [  4]   9.00-10.00  sec  4.09 MBytes  34.3 Mbits/sec    0    564 KByte=
s
     - - - - - - - - - - - - - - - - - - - - - - - - -
     [ ID] Interval           Transfer     Bandwidth       Retr
     [  4]   0.00-10.00  sec  45.9 MBytes  38.5 Mbits/sec    0
    sender
     [  4]   0.00-10.00  sec  45.0 MBytes  37.7 Mbits/sec
    receiver

     iperf Done.

I'll send an RFC patchset with the changes that I mentioned above.
Please advise whether those changes themselves should be merged, or if
you suggest a different approach.
