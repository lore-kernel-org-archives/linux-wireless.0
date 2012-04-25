Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:44876 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757441Ab2DYSYY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Apr 2012 14:24:24 -0400
Received: by qatm19 with SMTP id m19so3699457qat.19
        for <linux-wireless@vger.kernel.org>; Wed, 25 Apr 2012 11:24:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201204251928.21559.chunkeey@googlemail.com>
References: <CAFED-j=fZjXVhLKe=eOHM-rhR7g1ZvHeSMm1jUA0bdJbk4_qWQ@mail.gmail.com>
	<201204231945.05113.chunkeey@googlemail.com>
	<CAFED-j=4NWR2mjnooQs4V_T23cV9iPAUi65J-FZ7JjC28aZ=Gw@mail.gmail.com>
	<201204251928.21559.chunkeey@googlemail.com>
Date: Wed, 25 Apr 2012 20:24:23 +0200
Message-ID: <CAFED-j=_kPNmj-OyhFAdi_LM+rqbW6JLHC64BzdTKPyQ3iAMYg@mail.gmail.com> (sfid-20120425_202429_499066_69C40BF1)
Subject: Re: carl9170 - monitor mode TP drop
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 25 kwietnia 2012 19:28 u¿ytkownik Christian Lamparter
<chunkeey@googlemail.com> napisa³:
> On Wednesday, April 25, 2012 07:28:18 AM Janusz Dziedzic wrote:
>> W dniu 23 kwietnia 2012 19:45 u¿ytkownik Christian Lamparter
>> <chunkeey@googlemail.com> napisa³:
>> >> This is what I can see on STA1:
>> >> # iperf -c 192.168.254.1 -t 100 -i 5
>> >> [ 3] 10.0-15.0 sec  20.4 MBytes  34.2 Mbits/sec
>> >>
>> >> =====> here I setup carl monitor on second PC, like this:
>> >> =====> iw dev wlan0 set type monitor
>> >> =====> iw dev wlan0 set freq 2437
>> >> =====> ifconfig wlan0 up
>> >>
>> >> [  3] 40.0-45.0 sec  2.38 MBytes  3.98 Mbits/sec
>> > Well, there's the "AR9170_MAC_RX_CTRL_ACK_IN_SNIFFER = bit (30)"
>> > in "AR9170_MAC_REG_RX_CONTROL = (0x1c3c40)".
>> I disabled this in code.
>>
>> -               rx_ctrl |= AR9170_MAC_RX_CTRL_ACK_IN_SNIFFER;
>> +//             rx_ctrl |= AR9170_MAC_RX_CTRL_ACK_IN_SNIFFER;
>>
>> After that I don't see any TP drop and can see all packets in
>> wireshark (as expected).
>>
>> Why carl try to ACK rx packets in monitor mode?
>> Is that a correct behaviour?
> Well, it depends.
>
> You see without the BIT set, the hardware won't sent any ACKs
> (Not even those which are directed at this interface - which of
> course is also bad, or even worse?) and with the BIT set (and if
> the HW is in Sniffer Mode) then the hardware acks every frames,
> even if they are for a different stations.
> So your fix might break someone else's setup.
>

As I understand, some time ago we had wpa_supplicant AP (GO) mode as a
two interfaces: AP + MONITOR.
But now MONITOR is not used.
Do you know other setup?

So, maybe firmware should ACK  frames with correct destination address
only (if AR9170_MAC_RX_CTRL_ACK_IN_SNIFFER)?
Or that is not possible because of HW limitation?

BR
Janusz
