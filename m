Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:56824 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab3CBMwr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Mar 2013 07:52:47 -0500
Received: by mail-wg0-f41.google.com with SMTP id ds1so434679wgb.2
        for <linux-wireless@vger.kernel.org>; Sat, 02 Mar 2013 04:52:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5131D2D1.7020709@erley.org>
References: <CABFmVg5sPub5Q4n+7PnkUn7weQLEUabONeJQZY6aFS2yFZAf2Q@mail.gmail.com>
	<CABFmVg5AaTG-F_myEA=WGdYpnwN9X=QfLcjKvwJ1-SUX0quaOg@mail.gmail.com>
	<CABFmVg5J6nWfBFL1VAsD+V3X_xPD6v4wLz0X5Wv4p082Trdshw@mail.gmail.com>
	<5131D2D1.7020709@erley.org>
Date: Sat, 2 Mar 2013 14:52:45 +0200
Message-ID: <CABFmVg7t2ZtvHNetSyJXoUmtakO49PBYX0nzbscHdsxANKj0-w@mail.gmail.com> (sfid-20130302_135257_659506_C226EAEA)
Subject: Re: Fwd: Intel Wifilink 5100 AGN - Does it support Access Point
 Infrastructure Mode ?
From: Abdelmuhaimen Seaudi <aseaudi@gmail.com>
To: Pat Erley <pat-lkml@erley.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Pat,
I have tried this, and I get the following error.
Is there another way to enable AP master mode for the Intel WifiLink 5100 AGN ?
Is there a driver or firmware that I can use to enable AP mode ?
Thanks,

aseaudi@Home:~$ sudo hostapd hostapd.conf
Configuration file: hostapd.conf
Failed to update rate sets in kernel module
Could not connect to kernel driver.
Using interface wlan0 with hwaddr 00:24:d6:5b:71:d2 and ssid 'test'
Failed to set beacon parameters
wlan0: STA 00:22:57:1f:c4:2b IEEE 802.11: disassociated
^CCould not connect to kernel driver.

aseaudi@Home:~$ cat hostapd.conf
#change wlan0 to your wireless device
interface=wlan0
driver=nl80211
ssid=test
channel=1


On 3/2/13, Pat Erley <pat-lkml@erley.org> wrote:
> On 03/02/2013 04:51 AM, Abdelmuhaimen Seaudi wrote:
>> Hello iwlwifi support,
>> I want to run my Wifi Intel WifiLink 5100 AGN in Access Point
>> Infrstructure Mode, so that I can connect via WiFi with other devices
>> to my workstation.
>> This is under Ubuntu Linux 12.10.
>> I have tried setting the wlan0 to run in master mode, but it gives me
>> error, as shown below.
>> Is it possible to run this WiFi radio in AP Infrstrucutre mode ? How ?
>> Thanks,
>>
>> aseaudi@Home:~$ iwconfig
>> wlan0     IEEE 802.11abgn  ESSID:"3Com"
>>            Mode:Managed  Frequency:2.462 GHz  Access Point:
>> 00:22:57:1F:C4:2B
>>            Bit Rate=48 Mb/s   Tx-Power=15 dBm
>>            Retry  long limit:7   RTS thr:off   Fragment thr:off
>>            Power Management:off
>>            Link Quality=51/70  Signal level=-59 dBm
>>            Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>>            Tx excessive retries:0  Invalid misc:468   Missed beacon:0
>> lo        no wireless extensions.
>> eth0      no wireless extensions.
>>
>> aseaudi@Home:~$ sudo iwconfig wlan0 mode master
>> Error for wireless request "Set Mode" (8B06) :
>>      SET failed on device wlan0 ; Invalid argument.
>
> http://linuxwireless.org/en/users/Documentation/hostapd
>
> Master mode requires userspace to handle setup and control.  That page
> should cover most/all of what you need.
>
> Pat Erley
>
>


-- 
Thanks and best regards

Abdel-Muhaimen Seaudi
CCIE # 25265
aseaudi@gmail.com
Tel.: +2010-0538-7426
