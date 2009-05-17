Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.237]:27586 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbZEQV1M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 May 2009 17:27:12 -0400
Received: by rv-out-0506.google.com with SMTP id f9so1477226rvb.1
        for <linux-wireless@vger.kernel.org>; Sun, 17 May 2009 14:27:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A0FEC03.9090803@centrum.cz>
References: <4A0FEC03.9090803@centrum.cz>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Sun, 17 May 2009 14:26:53 -0700
Message-ID: <43e72e890905171426xf9f483dh9d2477cebd4eab47@mail.gmail.com>
Subject: Re: rt2x00 - wireless compat - can not load compiled rt61pci
To: trencan <trencan@centrum.cz>
Cc: linux-wireless@vger.kernel.org, Felix Bitterli <ic.felix@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 17, 2009 at 3:50 AM, trencan <trencan@centrum.cz> wrote:
> Hello,
>
> I use latest Mandriva distribution 2009.1 with kernel 2.6.29.1-desktop-4mnb.
> I have rt2561 wifi card in my PC. I would like to switch my wifi card to AP
> or Ad-hoc mode. My distribution's rt61pci module doesn't support these
> modes. So I have downloaded compat-wireless-2.6.30-rc4.tar.bz2
> <http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.30/compat-wireless-2.6.30-rc4.tar.bz2>.
>
> I ran:
> make
> make install
> make unload
>
> Everything fine. But then "modprobe rt61pci" loaded my distribution's
> rt61pci module and not the compiled one. Distribution's one is in folder:
>
> [root@trencancan compat-wireless-2.6.30-rc4]# ls -la
> /lib/modules/2.6.29.1-desktop-4mnb/kernel/drivers/net/wireless/rt2x00/rt61pci.ko.gz
> -rw-r--r-- 1 root root 11279 2009-04-21 01:13
> /lib/modules/2.6.29.1-desktop-4mnb/kernel/drivers/net/wireless/rt2x00/rt61pci.ko.gz
>
> Compiled one is in folder:
> [root@trencancan compat-wireless-2.6.30-rc4]# ls -la
> /lib/modules/2.6.29.1-desktop-4mnb/updates/drivers/net/wireless/rt2x00/rt61pci.ko.gz
> -rw-r--r-- 1 root root 123843 2009-05-16 23:21
> /lib/modules/2.6.29.1-desktop-4mnb/updates/drivers/net/wireless/rt2x00/rt61pci.ko.gz
>
>
> But after I type "modprobe rt61pci", then:
> [root@trencancan compat-wireless-2.6.30-rc4]# modinfo rt61pci
> filename:
> /lib/modules/2.6.29.1-desktop-4mnb/kernel/drivers/net/wireless/rt2x00/rt61pci.ko.gz
> license:        GPL
> firmware:       rt2661.bin
> firmware:       rt2561s.bin
> firmware:       rt2561.bin
> description:    Ralink RT61 PCI & PCMCIA Wireless LAN driver.
> version:        2.2.3
> author:         http://rt2x00.serialmonkey.com
> srcversion:     E8C0D3A4B7F36984638CEDF
> alias:          pci:v00001814d00000401sv*sd*bc*sc*i*
> alias:          pci:v00001814d00000302sv*sd*bc*sc*i*
> alias:          pci:v00001814d00000301sv*sd*bc*sc*i*
> depends:        rt2x00lib,rt2x00pci,eeprom_93cx6,crc-itu-t
> vermagic:       2.6.29.1-desktop-4mnb SMP mod_unload modversions 686
> parm:           nohwcrypt:Disable hardware encryption. (bool)
>
>
> So you can see that Distribution's module (in kernel folder) was loaded. I
> think root cause of problem is that run of command: "depmod -ae" finds first
> rt61pci in kernel's folder and then next instance in updates folder is not
> considered. If I look at output of depmod command:
>
> [root@trencancan compat-wireless-2.6.30-rc4]# grep -i rt61pci
> /lib/modules/2.6.29.1-desktop-4mnb/modules.dep
> kernel/drivers/net/wireless/rt2x00/rt61pci.ko.gz: kernel/lib/crc-itu-t.ko.gz
> kernel/drivers/net/wireless/rt2x00/rt2x00pci.ko.gz
> kernel/drivers/net/wireless/rt2x00/rt2x00lib.ko.gz
> kernel/net/rfkill/rfkill.ko.gz kernel/drivers/leds/led-class.ko.gz
> kernel/net/mac80211/mac80211.ko.gz kernel/net/wireless/cfg80211.ko.gz
> kernel/drivers/misc/eeprom/eeprom_93cx6.ko.gz
>
> So you may see that rt61pci in
> /lib/modules/2.6.29.1-desktop-4mnb/updates/drivers/net/wireless/rt2x00/
> folder is not considered.
>
> Please, how can I workaround this? Or what do I wrong? One solution can be
> to install all compat-wireless modules into kernel folder instead of updates
> folder. But then distribution's ones will be overwritten and un-installation
> will be impossible.

Mandriva may not look for updates/ dir by default. For Ubuntu I still
see this respected.

For example on ubuntu I see:

mcgrof@tesla $ cat /etc/depmod.d/ubuntu.conf
search updates ubuntu built-in

Can you check your /etc/depmod.d/ directory or /etc/depmod.conf file?

  Luis
