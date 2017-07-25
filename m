Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33784 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751720AbdGYNWr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Jul 2017 09:22:47 -0400
Received: by mail-wm0-f65.google.com with SMTP id q189so5101755wmd.0
        for <linux-wireless@vger.kernel.org>; Tue, 25 Jul 2017 06:22:46 -0700 (PDT)
From: Rafal <fatwildcat@gmail.com>
Date: Tue, 25 Jul 2017 15:22:39 +0200 (CEST)
To: Arend van Spriel <arend.vanspriel@broadcom.com>
cc: Rafal <fatwildcat@gmail.com>, Dan Williams <dcbw@redhat.com>,
        linux-wireless@vger.kernel.org
Subject: Re: brcfmac: add possibility to turn off powersave on wiphy
In-Reply-To: <59773261.5030100@broadcom.com>
Message-ID: <alpine.DEB.2.20.1707251413390.30843@wilk> (sfid-20170725_152251_226187_3DAE7063)
References: <alpine.DEB.2.20.1707211652430.10663@wilk> <1500655872.10725.1.camel@redhat.com> <alpine.DEB.2.20.1707212252060.13284@wilk> <59773261.5030100@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 25 Jul 2017, Arend van Spriel wrote:

> On 7/21/2017 11:19 PM, Rafal wrote:
>> On Fri, 21 Jul 2017, Dan Williams wrote:
>> 
>>> On Fri, 2017-07-21 at 16:56 +0200, Rafal wrote:
>>>> I have a board with ap6212 chip and I have encountered two problems
>>>> with the brcmfmac driver operating with this device. First problem I
>>>> describe below, second one in separate mail.
>>>> 
>>>> 
>>>> Namely, I have noticed quite poor connection with the device despite
>>>> good signal strength. Ping to the device was very uneven, about 50 -
>>>> 100 ms in average, 10 - 20% of packets loss. After some
>>>> investigations I have found that problem is caused by powersave
>>>> feature on wiphy (BRCMF_C_SET_PM command). When the value is set to
>>>> PM_OFF, the problem does not appear - ping is quite stable, ~2ms.
>>>> When set to PM_FAST, the ping is bad.
>>>> 
>>>> The brcmfmac driver currently does not have possibility to turn off
>>>> the powersave feature. I have added the possibility on 4.11.6 kernel
>>> 
>>> I don't think that's true?  The driver implements the nl80211
>>> set_power_mgmt hook, which lets you turn off powersave with 'iw'.  That
>>> seems like a much better option than a module parameter.  I know other
>>> drivers have the module parameter, but I personally consider that
>>> legacy/holdover, given that we have runtime toggles for this kind of
>>> thing.
>>> 
>>> brcmf_cfg80211_set_power_mgmt() should do what you need, right?
>> 
>> Yes, it does.
>> 
>> In fact, I needed only a parameter in OF database. This is a bug in the
>> device or firmware and I needed to disable the feature for this chip.
>> Many device drivers allow to specify in OF database that driver should
>> use a quirk. This is similar situation.
>> 
>> I have added the kernel parameter as an additional feature. I thought
>> that not all platforms are using devicetree database. But maybe it is a
>> bad idea.
>
> I was going to make the same remark as Dan. Anyway, the ping times are not 
> really unexpected. It depends on your beacon period and dtim setting. 
> However, the packet loss is not expected and will require analyzing a sniff 
> capture.
>
> Regards,
> Arend

Ping times are very uneven, but it depends. Let's I give some output.
In ouptuts below, the "wilk" machine is my PC, the "nano" machine is the
device with ap6212 chip.

First, the power save is OFF:

rafal@wilk:~$ ping -c 10 nano
PING nano (192.168.1.22) 56(84) bytes of data.
64 bytes from nano (192.168.1.22): icmp_seq=1 ttl=64 time=1.90 ms
64 bytes from nano (192.168.1.22): icmp_seq=2 ttl=64 time=1.82 ms
64 bytes from nano (192.168.1.22): icmp_seq=3 ttl=64 time=1.98 ms
64 bytes from nano (192.168.1.22): icmp_seq=4 ttl=64 time=1.77 ms
64 bytes from nano (192.168.1.22): icmp_seq=5 ttl=64 time=1.73 ms
64 bytes from nano (192.168.1.22): icmp_seq=6 ttl=64 time=1.79 ms
64 bytes from nano (192.168.1.22): icmp_seq=7 ttl=64 time=1.86 ms
64 bytes from nano (192.168.1.22): icmp_seq=8 ttl=64 time=1.92 ms
64 bytes from nano (192.168.1.22): icmp_seq=9 ttl=64 time=1.93 ms
64 bytes from nano (192.168.1.22): icmp_seq=10 ttl=64 time=1.80 ms

--- nano ping statistics ---
10 packets transmitted, 10 received, 0% packet loss, time 9015ms
rtt min/avg/max/mdev = 1.734/1.854/1.980/0.085 ms


Now, the ping with power save ON, two tests run one by one:

rafal@wilk:~$ ping -c 10 nano
PING nano (192.168.1.22) 56(84) bytes of data.
64 bytes from nano (192.168.1.22): icmp_seq=1 ttl=64 time=69.4 ms
64 bytes from nano (192.168.1.22): icmp_seq=2 ttl=64 time=91.7 ms
64 bytes from nano (192.168.1.22): icmp_seq=3 ttl=64 time=113 ms
64 bytes from nano (192.168.1.22): icmp_seq=4 ttl=64 time=31.4 ms
64 bytes from nano (192.168.1.22): icmp_seq=5 ttl=64 time=53.8 ms
64 bytes from nano (192.168.1.22): icmp_seq=6 ttl=64 time=141 ms
64 bytes from nano (192.168.1.22): icmp_seq=7 ttl=64 time=98.0 ms
64 bytes from nano (192.168.1.22): icmp_seq=8 ttl=64 time=1249 ms
64 bytes from nano (192.168.1.22): icmp_seq=9 ttl=64 time=241 ms
64 bytes from nano (192.168.1.22): icmp_seq=10 ttl=64 time=58.6 ms

--- nano ping statistics ---
10 packets transmitted, 10 received, 0% packet loss, time 9021ms
rtt min/avg/max/mdev = 31.443/214.922/1249.321/349.321 ms, pipe 2
rafal@wilk:~$ ping -c 20 nano
PING nano (192.168.1.22) 56(84) bytes of data.
64 bytes from nano (192.168.1.22): icmp_seq=3 ttl=64 time=56.7 ms
64 bytes from nano (192.168.1.22): icmp_seq=4 ttl=64 time=179 ms
64 bytes from nano (192.168.1.22): icmp_seq=7 ttl=64 time=19.0 ms
64 bytes from nano (192.168.1.22): icmp_seq=8 ttl=64 time=141 ms
64 bytes from nano (192.168.1.22): icmp_seq=10 ttl=64 time=593 ms
64 bytes from nano (192.168.1.22): icmp_seq=9 ttl=64 time=1598 ms
64 bytes from nano (192.168.1.22): icmp_seq=11 ttl=64 time=104 ms
64 bytes from nano (192.168.1.22): icmp_seq=12 ttl=64 time=127 ms
64 bytes from nano (192.168.1.22): icmp_seq=15 ttl=64 time=34.6 ms
64 bytes from nano (192.168.1.22): icmp_seq=16 ttl=64 time=167 ms
64 bytes from nano (192.168.1.22): icmp_seq=19 ttl=64 time=107 ms
64 bytes from nano (192.168.1.22): icmp_seq=20 ttl=64 time=230 ms

--- nano ping statistics ---
20 packets transmitted, 12 received, 40% packet loss, time 19173ms
rtt min/avg/max/mdev = 19.073/280.098/1598.506/422.557 ms, pipe 2

But look at ping with 0.1 seconds interval (powersave is ON):

rafal@wilk:~$ sudo ping -i 0.1 -c 10 nano
PING nano (192.168.1.22) 56(84) bytes of data.
64 bytes from nano (192.168.1.22): icmp_seq=1 ttl=64 time=77.4 ms
64 bytes from nano (192.168.1.22): icmp_seq=2 ttl=64 time=1.61 ms
64 bytes from nano (192.168.1.22): icmp_seq=3 ttl=64 time=1.79 ms
64 bytes from nano (192.168.1.22): icmp_seq=4 ttl=64 time=1.63 ms
64 bytes from nano (192.168.1.22): icmp_seq=5 ttl=64 time=1.71 ms
64 bytes from nano (192.168.1.22): icmp_seq=6 ttl=64 time=1.69 ms
64 bytes from nano (192.168.1.22): icmp_seq=7 ttl=64 time=1.69 ms
64 bytes from nano (192.168.1.22): icmp_seq=8 ttl=64 time=1.62 ms
64 bytes from nano (192.168.1.22): icmp_seq=9 ttl=64 time=1.56 ms
64 bytes from nano (192.168.1.22): icmp_seq=10 ttl=64 time=1.66 ms

--- nano ping statistics ---
10 packets transmitted, 10 received, 0% packet loss, time 908ms
rtt min/avg/max/mdev = 1.566/9.243/77.427/22.728 ms

Ping from the device looks good. With powersave ON:

rafal@nano:~$ ping -c 10 wilk
PING wilk (192.168.1.5) 56(84) bytes of data.
64 bytes from wilk (192.168.1.5): icmp_seq=1 ttl=64 time=7.37 ms
64 bytes from wilk (192.168.1.5): icmp_seq=2 ttl=64 time=7.29 ms
64 bytes from wilk (192.168.1.5): icmp_seq=3 ttl=64 time=7.33 ms
64 bytes from wilk (192.168.1.5): icmp_seq=4 ttl=64 time=11.3 ms
64 bytes from wilk (192.168.1.5): icmp_seq=5 ttl=64 time=7.25 ms
64 bytes from wilk (192.168.1.5): icmp_seq=6 ttl=64 time=9.07 ms
64 bytes from wilk (192.168.1.5): icmp_seq=7 ttl=64 time=7.23 ms
64 bytes from wilk (192.168.1.5): icmp_seq=8 ttl=64 time=7.41 ms
64 bytes from wilk (192.168.1.5): icmp_seq=9 ttl=64 time=7.19 ms
64 bytes from wilk (192.168.1.5): icmp_seq=10 ttl=64 time=7.42 ms

--- wilk ping statistics ---
10 packets transmitted, 10 received, 0% packet loss, time 9035ms
rtt min/avg/max/mdev = 7.191/7.891/11.319/1.261 ms


Now, powersave OFF:

rafal@nano:~$ sudo iw wlan0 set power_save off
rafal@nano:~$ ping -c 10 wilk
PING wilk (192.168.1.5) 56(84) bytes of data.
64 bytes from wilk (192.168.1.5): icmp_seq=1 ttl=64 time=2.57 ms
64 bytes from wilk (192.168.1.5): icmp_seq=2 ttl=64 time=2.29 ms
64 bytes from wilk (192.168.1.5): icmp_seq=3 ttl=64 time=4.35 ms
64 bytes from wilk (192.168.1.5): icmp_seq=4 ttl=64 time=2.35 ms
64 bytes from wilk (192.168.1.5): icmp_seq=5 ttl=64 time=1.68 ms
64 bytes from wilk (192.168.1.5): icmp_seq=6 ttl=64 time=4.40 ms
64 bytes from wilk (192.168.1.5): icmp_seq=7 ttl=64 time=1.67 ms
64 bytes from wilk (192.168.1.5): icmp_seq=8 ttl=64 time=1.71 ms
64 bytes from wilk (192.168.1.5): icmp_seq=9 ttl=64 time=1.96 ms
64 bytes from wilk (192.168.1.5): icmp_seq=10 ttl=64 time=1.72 ms

--- wilk ping statistics ---
10 packets transmitted, 10 received, 0% packet loss, time 9035ms
rtt min/avg/max/mdev = 1.672/2.473/4.408/1.002 ms


Do you want some results with other options?

Much simpler solution for me is to disable powersave in the kernel by
default. I'm providing on github customized kernel for the device (with
some drivers specific for the board) and I don't want to explain
everyone that "wifi will work fine when you add somewhere in startup
script XY command". It would be only a trouble for me.

By the way, the device has also 3.x kernel provided by vendor. The 3.x
kernel has bcmdhd driver, which is compiled with option which disables
powersave.
