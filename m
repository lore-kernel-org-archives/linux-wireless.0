Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f41.google.com ([74.125.83.41]:43274 "EHLO
        mail-pg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752550AbeEGVtt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 May 2018 17:49:49 -0400
MIME-Version: 1.0
In-Reply-To: <1525240713.3735.3.camel@realtek.com>
References: <CA+A7VXX+z8FrDhzW2BQ6AGMJ=_j_53wkUL_YNgkreEbWSh+jCw@mail.gmail.com>
 <afdf0498-c0a9-936c-0c9b-1b6da6eb5957@lwfinger.net> <CA+A7VXWjWaSSUiX3h_rpFXrSwtUkynKR9tpvnsSe=DZrC+mF-Q@mail.gmail.com>
 <059b40f0-b8e2-b55f-92d5-a859ba4204a4@lwfinger.net> <CA+A7VXUUsZHD2gr9TBcV6jZBOPGZv7_vK-wWZ0MvGgiCnAiUgQ@mail.gmail.com>
 <5B2DA6FDDF928F4E855344EE0A5C39D13BEC14C0@RTITMBSV07.realtek.com.tw> <1525240713.3735.3.camel@realtek.com>
From: =?UTF-8?Q?Jo=C3=A3o_Paulo_Rechi_Vita?= <jprvita@gmail.com>
Date: Mon, 7 May 2018 14:49:07 -0700
Message-ID: <CA+A7VXWywjTVeb3DTjVMVTUw-vjAjD+3XTuVNk8S=8D7W=MkPQ@mail.gmail.com> (sfid-20180507_235007_621846_FDEF8028)
Subject: Re: RTL8723BE performance regression
To: Pkshih <pkshih@realtek.com>
Cc: "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jprvita@endlessm.com" <jprvita@endlessm.com>,
        Birming Chiu <birming@realtek.com>,
        "drake@endlessm.com" <drake@endlessm.com>,
        Chaoming_Li <chaoming_li@realsil.com.cn>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        =?UTF-8?B?6I6K5b2l5a6j?= <yhchuang@realtek.com>,
        "derosier@gmail.com" <derosier@gmail.com>,
        Steven Ting <steventing@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux@endlessm.com" <linux@endlessm.com>,
        Shaofu <shaofu@realtek.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 1, 2018 at 10:58 PM, Pkshih <pkshih@realtek.com> wrote:
> On Wed, 2018-05-02 at 05:44 +0000, Pkshih wrote:
>>
>> > -----Original Message-----
>> > From: Jo=C3=A3o Paulo Rechi Vita [mailto:jprvita@gmail.com]
>> > Sent: Wednesday, May 02, 2018 6:41 AM
>> > To: Larry Finger
>> > Cc: Steve deRosier; =E8=8E=8A=E5=BD=A5=E5=AE=A3; Pkshih; Birming Chiu;=
 Shaofu; Steven Ting; Chaoming_Li; Kalle Valo;
>> > linux-wireless; Network Development; LKML; Daniel Drake; Jo=C3=A3o Pau=
lo Rechi Vita; linux@endlessm.c
>> om
>> > Subject: Re: RTL8723BE performance regression
>> >
>> > On Tue, Apr 3, 2018 at 7:51 PM, Larry Finger <Larry.Finger@lwfinger.ne=
t> wrote:
>> > > On 04/03/2018 09:37 PM, Jo=C3=A3o Paulo Rechi Vita wrote:
>> > >>
>> > >> On Tue, Apr 3, 2018 at 7:28 PM, Larry Finger <Larry.Finger@lwfinger=
.net>
>> > >> wrote:
>> > >>
>> > >> (...)
>> > >>
>> > >>> As the antenna selection code changes affected your first bisectio=
n, do
>> > >>> you
>> > >>> have one of those HP laptops with only one antenna and the incorre=
ct
>> > >>> coding
>> > >>> in the FUSE?
>> > >>
>> > >>
>> > >> Yes, that is why I've been passing ant_sel=3D1 during my tests -- t=
his
>> > >> was needed to achieve a good performance in the past, before this
>> > >> regression. I've also opened the laptop chassis and confirmed the
>> > >> antenna cable is plugged to the connector labeled with "1" on the
>> > >> card.
>> > >>
>> > >>> If so, please make sure that you still have the same signal
>> > >>> strength for good and bad cases. I have tried to keep the driver a=
nd the
>> > >>> btcoex code in sync, but there may be some combinations of antenna
>> > >>> configuration and FUSE contents that cause the code to fail.
>> > >>>
>> > >>
>> > >> What is the recommended way to monitor the signal strength?
>> > >
>> > >
>> > > The btcoex code is developed for multiple platforms by a different g=
roup
>> > > than the Linux driver. I think they made a change that caused ant_se=
l to
>> > > switch from 1 to 2. At least numerous comments at
>> > > github.com/lwfinger/rtlwifi_new claimed they needed to make that cha=
nge.
>> > >
>> > > Mhy recommended method is to verify the wifi device name with "iw de=
v". Then
>> > > using that device
>> > >
>> > > sudo iw dev <dev_name> scan | egrep "SSID|signal"
>> > >
>> >
>> > I have confirmed that the performance regression is indeed tied to
>> > signal strength: on the good cases signal was between -16 and -8 dBm,
>> > whereas in bad cases signal was always between -50 to - 40 dBm. I've
>> > also switched to testing bandwidth in controlled LAN environment using
>> > iperf3, as suggested by Steve deRosier, with the DUT being the only
>> > machine connected to the 2.4 GHz radio and the machine running the
>> > iperf3 server connected via ethernet.
>> >
>>
>> We have new experimental results in commit af8a41cccf8f46 ("rtlwifi: cle=
anup
>> 8723be ant_sel definition"). You can use the above commit and do the sam=
e
>> experiments (with ant_sel=3D0, 1 and 2) in your side, and then share you=
r results.
>> Since performance is tied to signal strength, you can only share signal =
strength.
>>
>
> Please pay attention to cold reboot once ant_sel is changed.
>

I've tested the commit mentioned above and it fixes the problem on top
of v4.16 (in addition to the latest wireless-drivers-next also been
fixed as it already contains such commit). On v4.15, we also need the
following commits before "af8a41cccf8f rtlwifi: cleanup 8723be ant_sel
definition" to have a good performance again:

  874e837d67d0 rtlwifi: fill FW version and subversion
  a44709bba70f rtlwifi: btcoex: Add power_on_setting routine
  40d9dd4f1c5d rtlwifi: btcoex: Remove global variables from btcoex

Surprisingly, it seems forcing ant_sel=3D1 is not needed anymore on
these machines, as the shown by the numbers bellow (ant_sel=3D0 means
that actually no parameter was passed to the module). I have powered
off the machine and done a cold boot for every test. It seems
something have changed in the antenna auto-selection code since v4.11,
the latest point where I could confirm we definitely need to force
ant_sel=3D1. I've been trying to understand what causes this difference,
but haven't made progress on that so far, so any suggestions are
appreciated (we are trying to decide if we can confidently drop the
downstream DMI quirks for these specific machines).

  w-d-n ant_sel=3D0: -14.00 dBm,  69.5 Mbps -> good
  w-d-n ant_sel=3D1: -10.00 dBm,  41.1 Mbps -> good
  w-d-n ant_sel=3D2: -44.00 dBm,   607 kbps -> bad

  v4.16 ant_sel=3D0: -12.00 dBm,  63.0 Mbps -> good
  v4.16 ant_sel=3D1: - 8.00 dBm,  69.0 Mbps -> good
  v4.16 ant_sel=3D2: -50.00 dBm,   224 kbps -> bad

  v4.15 ant_sel=3D0: - 8.00 dBm,  33.0 Mbps -> good
  v4.15 ant_sel=3D1: -10.00 dBm,  38.1 Mbps -> good
  v4.15 ant_sel=3D2: -48.00 dBm,   206 kbps -> bad

--
Jo=C3=A3o Paulo Rechi Vita
http://about.me/jprvita
