Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:48866 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707Ab1FCIyr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2011 04:54:47 -0400
Received: by vxi39 with SMTP id 39so1234911vxi.19
        for <linux-wireless@vger.kernel.org>; Fri, 03 Jun 2011 01:54:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTincKD1k1Uq=R8uR-KjExMOErDrOgA@mail.gmail.com>
References: <BANLkTimnkGyQmEJ2fcowoiv_f+aLm2AQcg@mail.gmail.com>
	<BANLkTincKD1k1Uq=R8uR-KjExMOErDrOgA@mail.gmail.com>
Date: Fri, 3 Jun 2011 16:54:46 +0800
Message-ID: <BANLkTins6quUKYrE9CyzNF6PkP1GECK1cA@mail.gmail.com> (sfid-20110603_105452_176955_008AB335)
Subject: Re: master-2011-06-01 git tree can't recognize my AR9285 chip.
From: Matt Chen <machen@novell.com>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Mohammed,

2011/6/3 Mohammed Shafi <shafi.wireless@gmail.com>:
> On Fri, Jun 3, 2011 at 12:13 PM, Matt Chen <machen@novell.com> wrote:
>> Hi all,
>> I git pull the latest version of wireless-testing tree and built whole
>> the kernel and related driver. I found my AR9285 (10ec:002b) can't be
>> recognized, and the ath9k is not loaded automatically. I tried the
>> kernel 2.6.39, it is working right.
>
> i am compiling the latest tree, i will try out. any debug messages?
> sudo modprobe -r ath9k
> sudo modprobe -v ath9k debug=0xffffffff(you should have enabled
> ATH_DEBUG and ATH9K_DEBUGFS while compiling the kernel).
OK, already enabled both and recompiled.
When load ath9k with debug parameter, it only showed :

linux:/home/linux # modprobe -v ath9k debug=0xfffffffff
insmod /lib/modules/3.0.0-rc1-wl-0.2.2.2598.1.PTF-pae/kernel/net/wireless/cfg80211.ko
insmod /lib/modules/3.0.0-rc1-wl-0.2.2.2598.1.PTF-pae/kernel/drivers/net/wireless/ath/ath.ko
insmod /lib/modules/3.0.0-rc1-wl-0.2.2.2598.1.PTF-pae/kernel/drivers/net/wireless/ath/ath9k/ath9k_hw.ko
insmod /lib/modules/3.0.0-rc1-wl-0.2.2.2598.1.PTF-pae/kernel/drivers/net/wireless/ath/ath9k/ath9k_common.ko
insmod /lib/modules/3.0.0-rc1-wl-0.2.2.2598.1.PTF-pae/kernel/net/mac80211/mac80211.ko
insmod /lib/modules/3.0.0-rc1-wl-0.2.2.2598.1.PTF-pae/kernel/drivers/net/wireless/ath/ath9k/ath9k.ko
debug=0xfffffffff


/var/log/messages:
Jun  3 16:52:12 linux kernel: [  600.472000] cfg80211: Calling CRDA to
update world regulatory domain

>>
>> Some info as below :
>> 1) linux:/home/linux/git/wireless-testing # git describe
>>    master-2011-06-01
>> 2) linux:/home/linux/git/wireless-testing # lspci -nnk
>>     ....
>>     09:00.0 Network controller [0280]: Atheros Communications Inc.
>> AR9285 Wireless Network Adapter
>>     (PCI-Express) [168c:002b] (rev 01)
>>     ff:00.0 Host bridge [0600]: Intel Corporation Core Processor
>> QuickPath Architecture Generic Non-core Registers
>>     [8086:2c62] (rev 02)
>>     .....
>> --
>> Thanks ~
>> Matt Chen
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
>
> --
> shafi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Thanks ~
Matt Chen
