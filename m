Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:51008 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751251AbeDDOzY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Apr 2018 10:55:24 -0400
MIME-Version: 1.0
In-Reply-To: <CA+A7VXX+z8FrDhzW2BQ6AGMJ=_j_53wkUL_YNgkreEbWSh+jCw@mail.gmail.com>
References: <CA+A7VXX+z8FrDhzW2BQ6AGMJ=_j_53wkUL_YNgkreEbWSh+jCw@mail.gmail.com>
From: Steve deRosier <derosier@gmail.com>
Date: Wed, 4 Apr 2018 07:54:42 -0700
Message-ID: <CALLGbRJqE_ZGbT5w-K39FRHDzBHrH_SfJH-3mPjdZFje5AENYw@mail.gmail.com> (sfid-20180404_165542_386559_4340C201)
Subject: Re: RTL8723BE performance regression
To: =?UTF-8?Q?Jo=C3=A3o_Paulo_Rechi_Vita?= <jprvita@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
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
        Linux Upstreaming Team <linux@endlessm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 3, 2018 at 6:51 PM, Jo=C3=A3o Paulo Rechi Vita <jprvita@gmail.c=
om> wrote:
>
> This are the results (testing with speedtest.net) I got at some key point=
s:
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

I recommend doing throughput testing in a closed system using iperf.
speedtest.net is potentially useful for testing your ISP's bandwidth
at some particular point in time, but little else as it exposes you to
too many variables. I wouldn't take those numbers to mean much and the
inconclusive results you're getting could be explained by external
network loading and having little to do with your bisect effort. I can
get that spread in numbers from speedtest.net without making any
changes other than the time of day I do the test.

Here's how to do it. Install iperf2 (you could use iperf3, personal
choice) on two machines, one being your device under test (DUT). Setup
a network configuration that looks similar to this:

server <=3D=3Dhardwire=3D=3D> AP <--wireless link--> DUT

Be sure your hardwire is more bandwidth than your wireless link is
capable of, or set it up where the server is the AP. What you're
looking for here is environmental consistency, not maximum throughput
numbers.

On the computer hardwired to the network, start the server, we'll
assume it has an ip of 192.168.33.18:

    iperf -s

On your DUT:

    iperf -c 192.168.33.18

That's the most basic setup, check the man page for more options.

You will get best results if you can exclude other computers from your
test network and other wireless devices from your airspace.

- Steve

--
Steve deRosier
Cal-Sierra Consulting LLC
https://www.cal-sierra.com/
