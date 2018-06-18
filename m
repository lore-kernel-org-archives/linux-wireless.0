Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtpcmd0986.aruba.it ([62.149.156.86]:35390 "EHLO
        smtpcmd0986.aruba.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935052AbeFROgN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Jun 2018 10:36:13 -0400
To: linux-wireless@vger.kernel.org
From: Mauro Ziliani <mauro@faresoftware.it>
Subject: rtl8192cu with Edimax 7811UN and IMX6
Message-ID: <6b5f7f08-8fcf-0423-0307-03d75425998d@faresoftware.it> (sfid-20180618_163619_285879_B239AF9A)
Date: Mon, 18 Jun 2018 16:29:10 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Goodmorning.
My name's Mauro Ziliani and I write from Parma, Italy.
I need to plug he dongle Edimax 7811UN into a IMX6DLSABRESD board, using 
kerne 4.1.15  (Yocto Krogoth)

I have the following problem.
I switch on the board wth dongle plugged.
I try a sftp transfer from my PC and the board. All works fine.

I wait for some minute, I retry the transfer, but the board doesn't 
start to receive the file, and the file stay for some minuti waiting to 
start.
Than the PC goes in timeout

This is what I do

1. scp app_1.0_armhf.deb root@imx6dlsabresd:/home/root
The transfer is completed. The progress bar is shown and the amount of 
transfered data

2. I wait some minutes
...
...
I retry the transfer
scp app_1.0_armhf.deb root@imx6dlsabresd:/home/root

the PC wait for 5 minute about and then it goes to timeout.

On the imx6dlsabresd board dmesg tells nothing of interesting

Looking with iwconfig wlan0 I get this


wlan0     IEEE 802.11bgn  ESSID:"STUDIO"
           Mode:Managed  Frequency:2.437 GHz  Access Point: 
00:0C:E6:0A:3E:CA
           Bit Rate=72.2 Mb/s   Tx-Power=20 dBm
           Retry short limit:7   RTS thr=2347 B   Fragment thr:off
           Encryption key:off
           Power Management:off
           Link Quality=62/70  Signal level=-48 dBm
           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
           Tx excessive retries:0  Invalid misc:240   Missed beacon:0

The power management is always off


Where I can look to get some more information on this strange behaviour?

There is a mini-cd sold with the dongle Edimax, but the linux driver is 
for kernel 3.x


Best regards,
   Mauro Ziliani
