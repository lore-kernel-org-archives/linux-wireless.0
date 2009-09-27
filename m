Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vms173019pub.verizon.net ([206.46.173.19]:52250 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010AbZI0PPO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Sep 2009 11:15:14 -0400
Received: from [192.168.1.6] ([173.66.147.207]) by vms173019.mailsrvcs.net
 (Sun Java(tm) System Messaging Server 6.3-7.04 (built Sep 26 2008; 32bit))
 with ESMTPA id <0KQM00ALNYDGXP28@vms173019.mailsrvcs.net> for
 linux-wireless@vger.kernel.org; Sun, 27 Sep 2009 10:15:18 -0500 (CDT)
Message-id: <4ABF8184.9060904@verizon.net>
Date: Sun, 27 Sep 2009 11:15:16 -0400
From: Clyde McPherson <ccmcphe@verizon.net>
MIME-version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	Tim Gardner <tim.gardner@canonical.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	bcm43xx-dev@lists.berlios.de
Subject: Re: A problem loading ssb module
References: <1253811559.4579.44.camel@pc3.dido>
 <4ABBAB47.8040300@canonical.com> <4ABBBB8C.8080401@hauke-m.de>
 <43e72e890909241137o7e853edfxb9e159df34927d7b@mail.gmail.com>
In-reply-to: <43e72e890909241137o7e853edfxb9e159df34927d7b@mail.gmail.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> On Thu, Sep 24, 2009 at 11:33 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
>   
>> Bryan Wu wrote:
>>     
>>> Mauro Di Domenico wrote:
>>>       
>>>> Hi,
>>>> I'm testing new b43 modules for my 14e4:4315 broadcom card.
>>>> I've compiled and installed compat-wireless-2009-09-16 in a debian
>>>> machine with kernel version 2.6.30-6.
>>>>
>>>> During the boot I experience this problem:
>>>>
>>>> $ dmesg|egrep "b43|ssb"
>>>>
>>>> [    2.384463] b43-pci-bridge 0000:06:00.0: PCI INT A -> GSI 17 (level,
>>>> low) -> IRQ 17
>>>> [    2.384477] b43-pci-bridge 0000:06:00.0: setting latency timer to 64
>>>> [    2.544344] ssb: Sonics Silicon Backplane found on PCI device
>>>> 0000:06:00.0
>>>> [    6.968981] b43: disagrees about version of symbol
>>>> ssb_device_is_enabled
>>>> [    6.968986] b43: Unknown symbol ssb_device_is_enabled
>>>> [    6.969280] b43: Unknown symbol ssb_pmu_set_ldo_paref
>>>> [    6.969407] b43: disagrees about version of symbol
>>>> ssb_pcicore_dev_irqvecs_enable
>>>> [    6.969410] b43: Unknown symbol ssb_pcicore_dev_irqvecs_enable
>>>> .....
>>>> ....
>>>> ...
>>>>
>>>>         
>>> I faced the exactly same issue as Mauro did. +1 from me, but currently have
>>> no time to take a deeper look.
>>>
>>> Thanks
>>>       
>> Hi,
>>
>> I had the same problem with the ssb module and compat-wireless in ubuntu
>> 9.04. The problem is that the ssb module is integrated into the
>> initramfs image. The version out of the initramfs image is loaded on
>> startup and not the version of compat-wireless. Running "sudo
>> update-initramfs -u" after installing compat-wireless and restaing the
>> system fixes the problem for me. Either Debian/Ubuntu should remove ssb
>> form default initramfs image or compat-wireless should update the image
>> with the install command. At least the compat-wireless documentation
>> needs an update.
>>
>> Hauke
>>
>> (adding Luis and linux-wireless list)
>>     
>
> Tim, do you guys update the initramfs upon installation of lbm? If a
> user does not use lbm and uses compat-wireless I suppose we need to do
> something similar.
>
>   Luis
> _______________________________________________
> Bcm43xx-dev mailing list
> Bcm43xx-dev@lists.berlios.de
> https://lists.berlios.de/mailman/listinfo/bcm43xx-dev
>   

All:
I have a large group that uses the ssb module along with the Broadcom 
4318, in a CF form factor. If the CF card is inserted before boot, and 
the ssb module is not in the initrd process, the laptops lock up and do 
not become operational. The solution to this problem is/was adding the 
ssb.ko to the initrd process. So I agree with Luis on this, the ssb 
module will have to be added/updated to the initrd process. As for PCI 
operations, I don't know, but for PCMCIA operations ssb.ko has to be 
added and/or updated. Anytime I am testing new releases of b43, I run 
"update-initramfs -u" to update the ssb module. (Sometimes you can do a 
rmmod ssb and rmmod b43, and then modprobe them back in. - This saves a 
reboot)

Thanks
-Tex
