Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:38699 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbbE0OSg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 May 2015 10:18:36 -0400
Received: by wizo1 with SMTP id o1so24430836wiz.1
        for <linux-wireless@vger.kernel.org>; Wed, 27 May 2015 07:18:35 -0700 (PDT)
Message-ID: <5565D238.4090409@gmail.com> (sfid-20150527_161854_202034_6CE8491C)
Date: Wed, 27 May 2015 17:18:32 +0300
From: Nick Dimov <dimovnike@gmail.com>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: Emmanuel Grumbach <egrumbach@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: packet loss, disconnects and possible bug in iwlwifi
References: <55605637.1080503@gmail.com>	 <CANUX_P0OzQ45pChQxc-9WVK=7_qh6M4CcE28U6pnu5RbH-qNuQ@mail.gmail.com>	 <55650565.6020303@gmail.com> <1432734873.15971.2.camel@redhat.com> <1432735728.15971.3.camel@redhat.com>
In-Reply-To: <1432735728.15971.3.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
these logs are produced with NetworkManager (i connected using network
manager). The only log that was produced with wpa_supplicant only is
wifi.log where u can see the wpa_supplicant command arguments. The
NetworkManager was stopped with systemctl stop (however I did not use
systemctl mask, but from what I've checked, there was no network manger
shown in process list). I will try to redo the test with NM masked.

Btw, I tried a Fedora 22 livecd and there were no disconnects at all (it
has new wpa_supplicant 2.3.3, here I have 2.1), however the max
connection speed I saw there was 300mbps. Here on Ubuntu Vivid i see
speeds up to 620mbps (and in Windows 7 I have  866mbps).

On 27.05.2015 17:08, Dan Williams wrote:
> On Wed, 2015-05-27 at 08:54 -0500, Dan Williams wrote:
>> On Wed, 2015-05-27 at 02:44 +0300, Nick Dimov wrote:
>>> Hello,
>>> thank you for your response. I attach the full syslog since the last
>>> boot which contains some disconnects. I enabled debug mode for
>>> wpa_supplicant with -dd option (let me know if you need anything else).
>>>
>>> I also tried connecting directly, i.e. without NetworkManager but
>>> manually with wpa_supplicant and I still get disconnects, howvever
>>> wpa_supplicant gives different logs with different drivers. Please, see
>>> the file wifi.log (you can see there the driver i used in
>>> wpa_supplicant, that log doesn't have the debug activated but let me
>>> know if you need that too)
>> Also, make sure you stop NetworkManager when you're doing the manual
>> connection.  With systemd, you need to 'systemctl mask NetworkManager'
>> and then 'systemctl stop NetworkManager' to prevent it from being D-Bus
>> activated too.
> Or, "nmcli net off" to put NM to sleep temporarily, without messing
> around with systemd.
>
> Dan
>
>> The reason I say this is because in your logs there are
>> locally-generated disconnections, and that happens when NetworkManager
>> is still running and hasn't been told to stop handling WiFi, and then
>> somebody runs another wpa_supplicant alongside.
>>
>> Dan
>>
>>> Thank you again,
>>> Nick.
>>>
>>> On 25.05.2015 14:33, Emmanuel Grumbach wrote:
>>>> On Sat, May 23, 2015 at 1:28 PM, Nick Dimov <dimovnike@gmail.com> wrote:
>>>>> Hello,
>>>>> I recently bought the Intel 7260 AC wifi card (below is the PCI info)
>>>>> and the card works perfectly in windows with the latest intel driver but
>>>>> in linux I get deauthenticating and disconnects (reason -3) every minute
>>>>> or so. When these disconnects happen I get packet loss. In the attached
>>>>> file iwlwifi_dmesg.txt you can see the log that is produced each time a
>>>>> disconnect happens. I also tried connecting on 2.4Ghz but I get the same
>>>>> packet loss. I also put the last firmware from
>>>>> http://git.kernel.org/?p=linux/kernel/git/firmware/linux-firmware.git
>>>>> but it did not help.
>>>> Please increase the debug level of the supplicant. And attach the full syslog.
>>>>
>>>>> There is also another problem: In windows i can see it connecting on
>>>>> 860mbps, but on linux it never goes higher than 600mbps (i check this
>>>>> with iwconfig) and it stays somewhere on 500mbps.
>>>>>
>>>>> Can you please help me solve this?
>>>>> Thank you.
>>>>>
>>>>> uname -a
>>>>> Linux nick-laptop 3.19.0-18-generic #18-Ubuntu SMP Tue May 19 18:31:35
>>>>> UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
>>>>>
>>>>> lspci info:
>>>>> 03:00.0 Network controller: Intel Corporation Wireless 7260 (rev bb)
>>>>>         Subsystem: Intel Corporation Dual Band Wireless-AC 7260
>>>>>         Flags: bus master, fast devsel, latency 0, IRQ 29
>>>>>         Memory at f7200000 (64-bit, non-prefetchable) [size=8K]
>>>>>         Capabilities: [c8] Power Management version 3
>>>>>         Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
>>>>>         Capabilities: [40] Express Endpoint, MSI 00
>>>>>         Capabilities: [100] Advanced Error Reporting
>>>>>         Capabilities: [140] Device Serial Number d8-fc-93-ff-ff-e4-70-d7
>>>>>         Capabilities: [14c] Latency Tolerance Reporting
>>>>>         Capabilities: [154] Vendor Specific Information: ID=cafe Rev=1
>>>>> Len=014 <?>
>>>>>         Kernel driver in use: iwlwifi
>>>>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

