Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f20.google.com ([209.85.220.20]:35240 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbZBKWpG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Feb 2009 17:45:06 -0500
Received: by mail-fx0-f20.google.com with SMTP id 13so1323814fxm.13
        for <linux-wireless@vger.kernel.org>; Wed, 11 Feb 2009 14:45:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <6ad5d99d0902111412m97608eanf6c2fd3e8bc6af4c@mail.gmail.com>
References: <6ad5d99d0902091343v693173f2w61ff60a216bb15e9@mail.gmail.com>
	 <4990AC02.6030703@lwfinger.net>
	 <3ace41890902091433g4c4e0c17n9e01aabc613d5bb6@mail.gmail.com>
	 <6ad5d99d0902111412m97608eanf6c2fd3e8bc6af4c@mail.gmail.com>
Date: Wed, 11 Feb 2009 22:45:05 +0000
Message-ID: <3ace41890902111445k606682a8p197a9eb65cdbc3a2@mail.gmail.com> (sfid-20090211_234512_822183_CDA46CA5)
Subject: Re: rtl8187 in Toshiba L300 linux troubles
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Jorge Munoz <jorgeroden1@gmail.com>
Cc: wireless <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 11, 2009 at 10:12 PM, Jorge Munoz <jorgeroden1@gmail.com> wrote:
> It's all right. I have followed all the steps written in compat-wireless
> (http://linuxwireless.org/en/users/Download#Buildingandinstalling) and it
> works!
> First of all I have had to install build-essential and
> linux-headers-2.6.27-11-generic  in my ubuntu based distro
> (www.molinux.info) compilation has done without any error (very clean).
> This is a key improvement, now  the signal level is better and wireless
> traffic isn't interrupted. Good job. Thank you.
>
> In order to help my colleagues I would like you to advice me about next
> issue. Ubuntu has a linux-backports-modules-2.6.27-11-generic but your
> improvement isn't on it yet. The problem is that this package includes
> others modules for Toshiba L300 hardware support (webcam, ...) and should be
> necessary install it. My question is if I can install the rtl8187.ko file
> directly (without compilation process) in another L300 laptop after
> upgrading the system with linux-backports-modules-2.6.27-11-generic.
> Thanks again

Kernel modules are matched to the specific kernel version (and
archtecture). I am not familiar with Ubuntu,
but in fact any of your colleague could just
1) copy your /lib/modules/<kver>/updates/ recursively
2) run "depmod -a"
3) either reboot or unload and reload the kernel module with "modprobe
-r rtl8187" then "modprobe -v rtl8187"

In fact step two is probably not necessary if you choose to reboot,
since depmod is often run just based on time-stamp at boot up.

I assume your question is just whether step 1) would work - the answer
is yes, provided you run depmod afterwards, or equivalent. You
actually don't need to copy the whole of that 40+ modules from
compar-wireless, just 4:
rtl8187
mac80211
eeprom_93cx6
cfg80211

(lsmod would tell you this).
