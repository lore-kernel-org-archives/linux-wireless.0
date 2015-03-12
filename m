Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:28214 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbbCLLJF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 07:09:05 -0400
Message-ID: <550173CE.8000708@broadcom.com> (sfid-20150312_120911_409947_B1539378)
Date: Thu, 12 Mar 2015 12:09:02 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: German <gentgerman@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iw dev wlp1s0 scan hangs
References: <20150311161757.dac357e24509141a4c98e84b@gmail.com>	<5500A4B6.4050702@broadcom.com>	<20150311163353.74922db84fc618b3b9039515@gmail.com>	<5500A93C.7060309@broadcom.com>	<20150311170018.c2581ec2ddfb4589f5c8b154@gmail.com>	<5500B0F2.3010804@broadcom.com>	<20150311182146.bde39b79fad1e8cc61d6f4a0@gmail.com>	<55014E36.5040707@broadcom.com> <20150312045001.654f6b4706acdd9e9367caab@gmail.com>
In-Reply-To: <20150312045001.654f6b4706acdd9e9367caab@gmail.com>
Content-Type: multipart/mixed;
	boundary="------------030205000208080501090601"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--------------030205000208080501090601
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit

On 03/12/15 09:50, German wrote:
> On Thu, 12 Mar 2015 09:28:38 +0100
> Arend van Spriel<arend@broadcom.com>  wrote:
>
>> On 03/11/15 23:21, German wrote:
>>> On Wed, 11 Mar 2015 22:17:38 +0100
>>> Arend van Spriel<arend@broadcom.com>   wrote:
>>>
>>>> On 03/11/15 22:00, German wrote:
>>>>> On Wed, 11 Mar 2015 21:44:44 +0100
>>>>> Arend van Spriel<arend@broadcom.com>    wrote:
>>>>>
>>>>>> On 03/11/15 21:33, German wrote:
>>>>>>> On Wed, 11 Mar 2015 21:25:26 +0100
>>>>>>> Arend van Spriel<arend@broadcom.com>     wrote:
>>>>>>>
>>>>>>>> On 03/11/15 21:17, German wrote:
>>>>>>>>> Hi. When I try to run aformentioned command it hangs for about 20 secs and no output is returned. What's the problem might be? Thanks
>>>>>>>>
>>>>>>>> any more details you can share? What kernel version, what specific
>>>>>>>> device is wlp1s0, do you have any kernel logging.
>>>>>>>>
>>>>>>
>>>>>> When I wrote down the questions I was wondering how specifc I should be.
>>>>>>> Kernel 3.18.7-gentoo.
>>>>>>
>>>>>> ok
>>>>>>
>>>>>>> wlp1s0 is my network card.
>>>>>>
>>>>>> Sure. I meant what brand and model.
>>>>>>
>>>>>> Can you run following commands:
>>>>>> $ lspci
>>>>>> $ lsusb
>>>>>>
>>>>> realtek RTL8723BE PCIe Wireless Network Adapter
>>>>>
>>>>>>> As for kernel logging, I simply don't know if I have it. Thanks
>>>>>>
>>>>>> Ok. Can you run following command after aborting the hanging iw scan
>>>>>> command:
>>>>>>
>>>>>> $ dmesg
>>>>>
>>>>> Polling FW ready fail! Firmware is not ready to run.
>>>>>
>>>>> Ok, so I need some sort of firmware? That's what I thought. What is this and where can I find it in kernel when I compile it? Thanks
>>>>
>>>> Not familiar with Realtek equipment but it might be provided by the
>>>> linux-firmware package so:
>>>>
>>>> $ sudo emerge --ask linux-firmware
>>>>
>>>
>>> Thanks Arend. This did the trick. I can now scan networks and I found mine. But how I actually connect to my network? I guess it is encrypted, but I have wpa_supplicant installed.
>>
>> Gentoo does not seem to provide NetworkManager as a solution. I found
>> this page [1]. Maybe it helps.
>
> Thanks Arend for pointing me to this link. NetworkManager was proposed to me on gentoo mailing list as a way to control both wireless and wired interfaces. It pulled a bunch of dependencies, though I used -X flag in USE variable not to use X server. the compile took about an hour and after all this, my system became unstable. It doesn't at all feels right, it is clunky. For now I am building gentoo laptop in pure console mode, so from all my research, iw is the only CLI tool for wireless and I like the fact it doesn't need bunch of dependences. I already installed it and I like it, so would you be so kind to get me through a set up? Documentation seems confusing. Thanks

Well. iw is really for testing/debugging. Especially with WPA/RSN 
networks that do periodic rekeying you need wpa_supplicant. It will do 
the scanning on its own and establish connection and such.

You could also opt for using nmcli, but that might be what you tried 
already.

I am no gentoo expert, but let's try to get this working. I am following 
the wpa_supplicant section of the link I send earlier.

1. modify /etc/conf.d/net

Not sure if you only use wireless on the machine. Otherwise, you can 
copy the attach conf.net file:

$ sudo cp conf.net /etc/conf.d/net

2. install wpa_supplicant configuration

Edit attached wpa_supplicant.conf with your ssid and psk and copy it:

$ sudo cp wpa_supplicant.conf /etc/wpa_supplicant

3. restart networking

$ sudo /etc/init.d/net restart

Not sure if step 3. is entirely correct regarding the script name. I 
don't use Gentoo.

Regards,
Arend
>> Regards,
>> Arend
>>
>> [1]
>> http://wiki.gentoo.org/wiki/Handbook:Parts/Networking/Wireless#Wireless_tools
>>
>>>> Regards,
>>>> Arend
>>>>
>>>>>>
>>>>>> Regards,
>>>>>> Arend
>>>>>>
>>>>>>>> Regards,
>>>>>>>> Arend
>>>>>>>
>>>>>>>
>>>>>>
>>>>>
>>>>>
>>>>
>>>
>>>
>>
>
>


--------------030205000208080501090601
Content-Type: text/plain; name="conf.net"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="conf.net"

# Prefer wpa_supplicant over wireless-tools
modules="wpa_supplicant"

# It's important to tell wpa_supplicant which driver it should
# be using as it's not very good at guessing yet
wpa_supplicant_wlp1s0="-Dnl80211"

config_wlp1s0="dhcp"
dhcp_wlp1s0="release nontp nonis"

--------------030205000208080501090601
Content-Type: text/plain; name="wpa_supplicant.conf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="wpa_supplicant.conf"

# The below line not be changed otherwise wpa_supplicant refuses to work
ctrl_interface=/var/run/wpa_supplicant

# Ensure that only root can read the WPA configuration
ctrl_interface_group=0

# Let wpa_supplicant take care of scanning and AP selection
ap_scan=1

# Simple case: WPA-PSK, PSK as an ASCII passphrase, allow all valid ciphers
network={
  ssid="simple"
  key_mgmt=WPA-PSK
  psk="your_passphrase"
}


--------------030205000208080501090601--
