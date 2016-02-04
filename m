Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52796 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932140AbcBDQpR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 11:45:17 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Drunk Cat <natserver2@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: alfa awus036nhr v2 and module rtl8xxxu
References: <loom.20160128T003525-188@post.gmane.org>
Date: Thu, 04 Feb 2016 11:45:16 -0500
In-Reply-To: <loom.20160128T003525-188@post.gmane.org> (Drunk Cat's message of
	"Wed, 27 Jan 2016 23:36:13 +0000 (UTC)")
Message-ID: <wrfjd1sco25f.fsf@redhat.com> (sfid-20160204_174523_902118_4D865D26)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drunk Cat <natserver2@gmail.com> writes:
> problem: it does not connect to any wifi network you can see the time out on 
> dmesg
>
>
>>lsusb
>
> Bus 002 Device 007: ID 0bda:817f Realtek Semiconductor Corp. RTL8188RU 
> 802.11n WLAN Adapter
>
>>iwconfig
> wlp0s20u1  IEEE 802.11bgn  ESSID:off/any  
>           Mode:Managed  Access Point: Not-Associated   Tx-Power=20 dBm   
>           Retry short limit:7   RTS thr=2347 B   Fragment thr:off
>           Power Management:off
>>dmesg

Not sure what distribution you are running, but I am seeing problems
with NetworkManager in recent Fedora.

Could you try the following:
1) Unplug the WiFi dongle
2) (Re)load the driver (rmmod rtl8xxxu ; insmod rtl8xxxu)
3) Restart NetworkManager 'systemctl restart NetworkManager'
4) Plug in the WiFi dongle

Thanks,
Jes
