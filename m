Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f54.google.com ([74.125.83.54]:45498 "EHLO
        mail-pg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935230AbeEIUdx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 16:33:53 -0400
MIME-Version: 1.0
In-Reply-To: <1525768634.2885.11.camel@realtek.com>
References: <CA+A7VXX+z8FrDhzW2BQ6AGMJ=_j_53wkUL_YNgkreEbWSh+jCw@mail.gmail.com>
 <afdf0498-c0a9-936c-0c9b-1b6da6eb5957@lwfinger.net> <CA+A7VXWjWaSSUiX3h_rpFXrSwtUkynKR9tpvnsSe=DZrC+mF-Q@mail.gmail.com>
 <059b40f0-b8e2-b55f-92d5-a859ba4204a4@lwfinger.net> <CA+A7VXUUsZHD2gr9TBcV6jZBOPGZv7_vK-wWZ0MvGgiCnAiUgQ@mail.gmail.com>
 <5B2DA6FDDF928F4E855344EE0A5C39D13BEC14C0@RTITMBSV07.realtek.com.tw>
 <1525240713.3735.3.camel@realtek.com> <CA+A7VXWywjTVeb3DTjVMVTUw-vjAjD+3XTuVNk8S=8D7W=MkPQ@mail.gmail.com>
 <1525768634.2885.11.camel@realtek.com>
From: =?UTF-8?Q?Jo=C3=A3o_Paulo_Rechi_Vita?= <jprvita@gmail.com>
Date: Wed, 9 May 2018 13:33:11 -0700
Message-ID: <CA+A7VXWhi24iw=TpoWQe6AY-pyvF6-C03dc+AN9kXeLPhLni+g@mail.gmail.com> (sfid-20180509_223414_233267_0A4FA2FA)
Subject: Re: RTL8723BE performance regression
To: Pkshih <pkshih@realtek.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
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

On Tue, May 8, 2018 at 1:37 AM, Pkshih <pkshih@realtek.com> wrote:
> On Mon, 2018-05-07 at 14:49 -0700, Jo=C3=A3o Paulo Rechi Vita wrote:
>> On Tue, May 1, 2018 at 10:58 PM, Pkshih <pkshih@realtek.com> wrote:
>> > On Wed, 2018-05-02 at 05:44 +0000, Pkshih wrote:
>> >>
>> >> > -----Original Message-----
>> >> > From: Jo=C3=A3o Paulo Rechi Vita [mailto:jprvita@gmail.com]
>> >> > Sent: Wednesday, May 02, 2018 6:41 AM
>> >> > To: Larry Finger
>> >> > Cc: Steve deRosier; =E8=8E=8A=E5=BD=A5=E5=AE=A3; Pkshih; Birming Ch=
iu; Shaofu; Steven Ting; Chaoming_Li; Kalle Valo;
>> >> > linux-wireless; Network Development; LKML; Daniel Drake; Jo=C3=A3o =
Paulo Rechi Vita; linux@endless
>> m.c
>> >> om
>> >> > Subject: Re: RTL8723BE performance regression
>> >> >
>> >> > On Tue, Apr 3, 2018 at 7:51 PM, Larry Finger <Larry.Finger@lwfinger=
.net> wrote:
>> >> > > On 04/03/2018 09:37 PM, Jo=C3=A3o Paulo Rechi Vita wrote:
>> >> > >>
>> >> > >> On Tue, Apr 3, 2018 at 7:28 PM, Larry Finger <Larry.Finger@lwfin=
ger.net>
>> >> > >> wrote:
>> >> > >>
>> >> > >> (...)
>> >> > >>
>> >> > >>> As the antenna selection code changes affected your first bisec=
tion, do
>> >> > >>> you
>> >> > >>> have one of those HP laptops with only one antenna and the inco=
rrect
>> >> > >>> coding
>> >> > >>> in the FUSE?
>> >> > >>
>> >> > >>
>> >> > >> Yes, that is why I've been passing ant_sel=3D1 during my tests -=
- this
>> >> > >> was needed to achieve a good performance in the past, before thi=
s
>> >> > >> regression. I've also opened the laptop chassis and confirmed th=
e
>> >> > >> antenna cable is plugged to the connector labeled with "1" on th=
e
>> >> > >> card.
>> >> > >>
>> >> > >>> If so, please make sure that you still have the same signal
>> >> > >>> strength for good and bad cases. I have tried to keep the drive=
r and the
>> >> > >>> btcoex code in sync, but there may be some combinations of ante=
nna
>> >> > >>> configuration and FUSE contents that cause the code to fail.
>> >> > >>>
>> >> > >>
>> >> > >> What is the recommended way to monitor the signal strength?
>> >> > >
>> >> > >
>> >> > > The btcoex code is developed for multiple platforms by a differen=
t group
>> >> > > than the Linux driver. I think they made a change that caused ant=
_sel to
>> >> > > switch from 1 to 2. At least numerous comments at
>> >> > > github.com/lwfinger/rtlwifi_new claimed they needed to make that =
change.
>> >> > >
>> >> > > Mhy recommended method is to verify the wifi device name with "iw=
 dev". Then
>> >> > > using that device
>> >> > >
>> >> > > sudo iw dev <dev_name> scan | egrep "SSID|signal"
>> >> > >
>> >> >
>> >> > I have confirmed that the performance regression is indeed tied to
>> >> > signal strength: on the good cases signal was between -16 and -8 dB=
m,
>> >> > whereas in bad cases signal was always between -50 to - 40 dBm. I'v=
e
>> >> > also switched to testing bandwidth in controlled LAN environment us=
ing
>> >> > iperf3, as suggested by Steve deRosier, with the DUT being the only
>> >> > machine connected to the 2.4 GHz radio and the machine running the
>> >> > iperf3 server connected via ethernet.
>> >> >
>> >>
>> >> We have new experimental results in commit af8a41cccf8f46 ("rtlwifi: =
cleanup
>> >> 8723be ant_sel definition"). You can use the above commit and do the =
same
>> >> experiments (with ant_sel=3D0, 1 and 2) in your side, and then share =
your results.
>> >> Since performance is tied to signal strength, you can only share sign=
al strength.
>> >>
>> >
>> > Please pay attention to cold reboot once ant_sel is changed.
>> >
>>
>> I've tested the commit mentioned above and it fixes the problem on top
>> of v4.16 (in addition to the latest wireless-drivers-next also been
>> fixed as it already contains such commit). On v4.15, we also need the
>> following commits before "af8a41cccf8f rtlwifi: cleanup 8723be ant_sel
>> definition" to have a good performance again:
>>
>>   874e837d67d0 rtlwifi: fill FW version and subversion
>>   a44709bba70f rtlwifi: btcoex: Add power_on_setting routine
>>   40d9dd4f1c5d rtlwifi: btcoex: Remove global variables from btcoex
>
> v4.15 isn't longterm version and had been EOL.
>

Right, but this is a performace regression in comparison to v4.11, so
if "af8a41cccf8f rtlwifi: cleanup 8723be ant_sel definition" is marked
for stable, shouldn't these other patches be brought as well? All
releases since v4.11 are probably affected, but honestly I don't have
a strong understanding of how the stable trees operate in situations
like this.

>>
>> Surprisingly, it seems forcing ant_sel=3D1 is not needed anymore on
>> these machines, as the shown by the numbers bellow (ant_sel=3D0 means
>> that actually no parameter was passed to the module). I have powered
>> off the machine and done a cold boot for every test. It seems
>> something have changed in the antenna auto-selection code since v4.11,
>> the latest point where I could confirm we definitely need to force
>> ant_sel=3D1. I've been trying to understand what causes this difference,
>> but haven't made progress on that so far, so any suggestions are
>> appreciated (we are trying to decide if we can confidently drop the
>> downstream DMI quirks for these specific machines).
>>
> I think your rtl8723be module programed correct efuse content, so it
> works properly with ant_sel=3D0, and quirk isn't required for your
> machine.
>
>>   w-d-n ant_sel=3D0: -14.00 dBm,  69.5 Mbps -> good
>>   w-d-n ant_sel=3D1: -10.00 dBm,  41.1 Mbps -> good
>>   w-d-n ant_sel=3D2: -44.00 dBm,   607 kbps -> bad
>>
>>   v4.16 ant_sel=3D0: -12.00 dBm,  63.0 Mbps -> good
>>   v4.16 ant_sel=3D1: - 8.00 dBm,  69.0 Mbps -> good
>>   v4.16 ant_sel=3D2: -50.00 dBm,   224 kbps -> bad
>>
>>   v4.15 ant_sel=3D0: - 8.00 dBm,  33.0 Mbps -> good
>>   v4.15 ant_sel=3D1: -10.00 dBm,  38.1 Mbps -> good
>>   v4.15 ant_sel=3D2: -48.00 dBm,   206 kbps -> bad
>>
>
> With your results, the efuse content is programmed as one or two antenna
> on AUX path.
>

With v4.11 I had good performance results on this very same machine
(thus same efuse contents) only when passing ant_sel=3D1, so there has
to be some change on the code that parses the efuse contents and
decides which antenna will be used.

--
Jo=C3=A3o Paulo Rechi Vita
http://about.me/jprvita
