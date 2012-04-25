Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:65239 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065Ab2DYF2T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Apr 2012 01:28:19 -0400
Received: by qatm19 with SMTP id m19so3304796qat.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 Apr 2012 22:28:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201204231945.05113.chunkeey@googlemail.com>
References: <CAFED-j=fZjXVhLKe=eOHM-rhR7g1ZvHeSMm1jUA0bdJbk4_qWQ@mail.gmail.com>
	<201204201959.56495.chunkeey@googlemail.com>
	<CAFED-jkFtT2agUpymwWN-srTVH+wkh7bbkgkxQg9e4vy+q-Xvw@mail.gmail.com>
	<201204231945.05113.chunkeey@googlemail.com>
Date: Wed, 25 Apr 2012 07:28:18 +0200
Message-ID: <CAFED-j=4NWR2mjnooQs4V_T23cV9iPAUi65J-FZ7JjC28aZ=Gw@mail.gmail.com> (sfid-20120425_072823_249942_41D31E74)
Subject: Re: carl9170 - monitor mode TP drop
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 23 kwietnia 2012 19:45 u¿ytkownik Christian Lamparter
<chunkeey@googlemail.com> napisa³:
> On Monday, April 23, 2012 06:27:03 AM Janusz Dziedzic wrote:
>> This is a scenario:
>> AP <--> STA1 (channel 6)
>> STA2 == carl_monitor (channel 6)
> ah, I assumed you were running the STA & Monitor on the same
> device [which is possible for most mac80211 devices!].
>
>> This is what I can see on STA1:
>> # iperf -c 192.168.254.1 -t 100 -i 5
>> ------------------------------------------------------------
>> Client connecting to 192.168.254.1, TCP port 5001
>> TCP window size:  512 KByte (default)
>> ------------------------------------------------------------
>> [  3] local 192.168.254.181 port 46048 connected with 192.168.254.1 port 5001
>> [ ID] Interval       Transfer     Bandwidth
>> [  3]  0.0- 5.0 sec  17.4 MBytes  29.2 Mbits/sec
>> [  3]  5.0-10.0 sec  19.6 MBytes  32.9 Mbits/sec
>> [ 3] 10.0-15.0 sec  20.4 MBytes  34.2 Mbits/sec
>>
>> =====> here I setup carl monitor on second PC, like this:
>> =====> iw dev wlan0 set type monitor
>> =====> iw dev wlan0 set freq 2437
>> =====> ifconfig wlan0 up
>>
>> [  3] 40.0-45.0 sec  2.38 MBytes  3.98 Mbits/sec
>> [  3] 45.0-50.0 sec  2.50 MBytes  4.19 Mbits/sec
>> [  3] 50.0-55.0 sec  3.00 MBytes  5.03 Mbits/sec
>>
>> Seems I don't even need to start wireshark here ... and see this TP drop.
> Well, there's the "AR9170_MAC_RX_CTRL_ACK_IN_SNIFFER = bit (30)"
> in "AR9170_MAC_REG_RX_CONTROL = (0x1c3c40)".  If you have enabled
> CONFIG_CARL9170_DEBUGFS build option, you can disable this
> bit (on the fly) by executing:
>
> echo "0x1c3c40 0x10000003" > /sys/kernel/debug/ieee80211/phyX/carl9170/hw_iowrite32
>
> (phyX needs to be the phy dev of the carl9170 instance)
>
> and there's the AR9170_MAC_SNIFFER_ENABLE_PROMISC (bit 0) in
> AR9170_MAC_REG_SNIFFER (0x1c3674). Which can be disabled in a
> similar way:
>
> echo "0x1c3674 0x02000000" > /sys/...
>

Hello,

Thanks Christian.
I disabled this in code.

diff --git a/drivers/net/wireless/ath/carl9170/mac.c
b/drivers/net/wireless/ath/carl9170/mac.c
index 53415bf..f3a7669 100644
--- a/drivers/net/wireless/ath/carl9170/mac.c
+++ b/drivers/net/wireless/ath/carl9170/mac.c
@@ -354,7 +354,7 @@ int carl9170_set_operating_mode(struct ar9170 *ar)
                enc_mode |= AR9170_MAC_ENCRYPTION_RX_SOFTWARE;

        if (ar->sniffer_enabled) {
-               rx_ctrl |= AR9170_MAC_RX_CTRL_ACK_IN_SNIFFER;
+//             rx_ctrl |= AR9170_MAC_RX_CTRL_ACK_IN_SNIFFER;
                sniffer |= AR9170_MAC_SNIFFER_ENABLE_PROMISC;
                enc_mode |= AR9170_MAC_ENCRYPTION_RX_SOFTWARE;
        }

After that I don't see any TP drop and can see all packets in
wireshark (as expected).

Why carl try to ACK rx packets in monitor mode? Is that a correct behaviour?

BR
Janusz
