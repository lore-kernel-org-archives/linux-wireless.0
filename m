Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f178.google.com ([74.125.82.178]:44722 "EHLO
        mail-ot0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752750AbeDDC2j (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Apr 2018 22:28:39 -0400
Subject: Re: RTL8723BE performance regression
To: =?UTF-8?Q?Jo=c3=a3o_Paulo_Rechi_Vita?= <jprvita@gmail.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>,
        Steven Ting <steventing@realtek.com>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Drake <drake@endlessm.com>,
        =?UTF-8?Q?Jo=c3=a3o_Paulo_Rechi_Vita?= <jprvita@endlessm.com>,
        linux@endlessm.com
References: <CA+A7VXX+z8FrDhzW2BQ6AGMJ=_j_53wkUL_YNgkreEbWSh+jCw@mail.gmail.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <afdf0498-c0a9-936c-0c9b-1b6da6eb5957@lwfinger.net> (sfid-20180404_042855_186870_26B4955B)
Date: Tue, 3 Apr 2018 21:28:36 -0500
MIME-Version: 1.0
In-Reply-To: <CA+A7VXX+z8FrDhzW2BQ6AGMJ=_j_53wkUL_YNgkreEbWSh+jCw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/03/2018 08:51 PM, João Paulo Rechi Vita wrote:
> Hello,
> 
> I've been trying to track a performance regression on the RTL8723BE
> WiFi adapter, which mainly affects the upload bandwidth (although we
> can see a decreased download performance as well, the effect on upload
> is more drastic). This was first reported by users after upgrading
> from our 4.11-based kernel to our 4.13-based kernel, but also
> confirmed to affect our development branch (4.15-based kernel) and
> wireless-drivers-next at the
> wireless-drivers-next-for-davem-2018-03-29 tag. This is happening on
> an HP laptop that needs rtl8723be.ant_sel=1 (and all the following
> tests have been made with that param).
> 
> My first bisect attempt pointed me to the following commit:
> 
> bcd37f4a0831 rtlwifi: btcoex: 23b 2ant: let bt transmit when hw
> initialisation done
> 
> Which I later found to be already fixed by
> 
> a33fcba6ec01 rtlwifi: btcoexist: Fix breakage of ant_sel for rtl8723be.
> 
> That fix is already included in v4.15 though (and our dev branch as
> well), so I did a second bisect, now cherry-picking a33fcba6ec01 at
> every step, and it pointed me to the following commit:
> 
> 7937f02d1953 rtlwifi: btcoex: hook external functions for newer chips
> 
> Reverting that commit on top of our development branch fixes the
> problem, but on top of v4.15 I get mixed results: a few times getting
> a good upload performance (~5-6Mbps) but most of the time just getting
> ~1-1.5Mpbs (which is still better than the 0.0 then test failure I've
> gotten on most bad points of the bisect).
> 
> Bisecting the downstream patches we carry on top of v4.15 (we base our
> kernel on Ubuntu's, so there are quite a few downstream changes) did
> not bring any clarity, as at all bisect points (plus reverting
> 7937f02d1953) the performance was good, so probably there was some
> other difference in the resulting kernels from my initial revert of
> that patch on top of v4.15 and each step during the bisect. I've
> experimented a bit with fwlps=0, but it did not bring any conclusive
> results either. I'll try to look at other things that may have changed
> (configuration perhaps?), but I don't have a clear plan yet.
> 
> Have you seen anything similar, or have any other ideas or suggestions
> to track this problem? Even without crystal clear results, it looks
> like 7937f02d1953 is having a negative impact on the RTL8723BE
> performance, so perhaps it is worth reverting it and reworking it a
> later point?
> 
> This are the results (testing with speedtest.net) I got at some key points:
> 
> Version        Commit        Ping        Down        Up
> 
> v4.11            a351e9b        12        25.44        5.99
> v4.11            a351e9b        131      17.02        5.89
> 
> v4.13            569dbb8        174      14.08        0.00
> v4.13            569dbb8        261      8.41          0.00
> 
> v4.15+revert d8a5b80        19        23.86        1.41
> v4.15+revert d8a5b80        189      18.69        1.39
> 

As the antenna selection code changes affected your first bisection, do you have 
one of those HP laptops with only one antenna and the incorrect coding in the 
FUSE? If so, please make sure that you still have the same signal strength for 
good and bad cases. I have tried to keep the driver and the btcoex code in sync, 
but there may be some combinations of antenna configuration and FUSE contents 
that cause the code to fail.

Larry
