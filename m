Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:56088 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753234AbeAFNNb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 6 Jan 2018 08:13:31 -0500
Received: from [192.168.0.2] ([87.123.51.189]) by mail.gmx.com (mrgmx003
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0LfSyv-1fDmrY2sWn-00p6Ij for
 <linux-wireless@vger.kernel.org>; Sat, 06 Jan 2018 14:13:29 +0100
Subject: Realtek USB Wifi (0x0bda:0xb720) RTL8723BU does not work
References: <57e38dc6-71cf-6828-dc5c-27c200f77d75@gmx.de>
To: linux-wireless@vger.kernel.org
From: Stefan Pappalardo <stefan.pappalardo@gmx.de>
Message-ID: <14bcb0af-6c41-7fe2-9bbf-50dfa2751c5b@gmx.de> (sfid-20180106_141417_913573_6F91029B)
Date: Sat, 6 Jan 2018 14:13:29 +0100
MIME-Version: 1.0
In-Reply-To: <57e38dc6-71cf-6828-dc5c-27c200f77d75@gmx.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Am 04.01.2018 um 19:40 schrieb Jes Sorensen:
> On 01/03/2018 04:26 PM, Stefan Pappalardo wrote:
>> Dear Jes,
>>
>> see attached the result from dmesg of ubuntu 16.04 (amd64) running on a Medion
>> AKOYA S4220 Notebook.
>>
>> The Notbook has got an integrated Wifi / Bluetooth device.
>> lsusb: Bus 001 Device 004: ID 0bda:b720 Realtek Semiconductor Corp.
>>
>> The Bluetooth function does work out of the box.
>>
>> But the Wifi is down after boot and login.
>> And there seemed to be nothing to improve the situation.
>> After many hours of searching the internet I found the following url with the
>> same issue and an interesting workaround:
>>
>> https://www.questarter.com/q/can-39-t-detect-wifi-networks-until-put-to-sleep-3_988896.html
>>
>> Workaround: Wifi works, but only if you put the notebook into sleep mode and
>> wake it up again.
>>
>> After reboot I tried scanning for wifi networks with NetworkManager and Wicd to
>> be sure this is a kernel issue, and no application issue.
>> Wifi does not work until sleep & wakeup. No difference if you use NetworkManager
>> or Wicd.
>>
>> The notebook came with Windows 10, which is unusable with the underpowered hardware.
>> My niece asked me if I could help her with an alternative solution.
>> The performance of Ubuntu looks much more better then Windows 10.
>> But the only network device in the notebook is the wifi with the above described
>> issue.
>>
>> Would you please be so kind to have look at the issue?
> Please post such things to the linux-wireless list and not my personal
> inbox.
>
> The 8723bu is a combo device, requiring the bluetooth and wifi sides to
> collaborate. Since you're running a bluetooth driver that doesn't
> collaborate, the two obviously cannot work at the same time. Blacklist
> the bluetooth driver and try again.
>
> Jes
>
>
>
I've tried to blacklist the bluetooth driver by placing a file with the name blacklist-bluetooth.conf in /etc/modprobe.d with the content "blacklist bluetooth". But this didn't help. Any idea what I did wrong?

-- 
Stefan
