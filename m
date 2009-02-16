Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:47463 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728AbZBPLeB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2009 06:34:01 -0500
Received: by fg-out-1718.google.com with SMTP id 16so215552fgg.17
        for <linux-wireless@vger.kernel.org>; Mon, 16 Feb 2009 03:34:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <3ace41890902111445k606682a8p197a9eb65cdbc3a2@mail.gmail.com>
References: <6ad5d99d0902091343v693173f2w61ff60a216bb15e9@mail.gmail.com>
	 <4990AC02.6030703@lwfinger.net>
	 <3ace41890902091433g4c4e0c17n9e01aabc613d5bb6@mail.gmail.com>
	 <6ad5d99d0902111412m97608eanf6c2fd3e8bc6af4c@mail.gmail.com>
	 <3ace41890902111445k606682a8p197a9eb65cdbc3a2@mail.gmail.com>
Date: Mon, 16 Feb 2009 12:33:59 +0100
Message-ID: <ec5eb5d60902160333k52bfcb5bj4122be2f853f0590@mail.gmail.com> (sfid-20090216_123408_212231_39EE1129)
Subject: Re: rtl8187 in Toshiba L300 linux troubles
From: =?ISO-8859-1?Q?Jorge_Mu=F1oz?= <jorgeroden@gmail.com>
To: Hin-Tak Leung <hintak.leung@gmail.com>
Cc: Jorge Munoz <jorgeroden1@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks Hin-Tak, I haven't checked your answer yet. When I have got an
answer I' ll post here. But I have to say that I' ve compiled (Ubuntu
8.10 distro based) compat-wireless without uninstalling
linux-backports-modules-2.6.27-11-generic and rtl8187 works correctly.

In order to installing compat-wireless rtl8187 driver I' ve done a
shell script to automate compilation process but next
step should be create a .deb package to include this in a repository
tree. Do you know if is there one with stable rtl8187 driver yet
(2.6.27-11)?


On 2/11/09, Hin-Tak Leung <hintak.leung@gmail.com> wrote:
> On Wed, Feb 11, 2009 at 10:12 PM, Jorge Munoz <jorgeroden1@gmail.com> wrote:
>> It's all right. I have followed all the steps written in compat-wireless
>> (http://linuxwireless.org/en/users/Download#Buildingandinstalling) and it
>> works!
>> First of all I have had to install build-essential and
>> linux-headers-2.6.27-11-generic  in my ubuntu based distro
>> (www.molinux.info) compilation has done without any error (very clean).
>> This is a key improvement, now  the signal level is better and wireless
>> traffic isn't interrupted. Good job. Thank you.
>>
>> In order to help my colleagues I would like you to advice me about next
>> issue. Ubuntu has a linux-backports-modules-2.6.27-11-generic but your
>> improvement isn't on it yet. The problem is that this package includes
>> others modules for Toshiba L300 hardware support (webcam, ...) and should
>> be
>> necessary install it. My question is if I can install the rtl8187.ko file
>> directly (without compilation process) in another L300 laptop after
>> upgrading the system with linux-backports-modules-2.6.27-11-generic.
>> Thanks again
>
> Kernel modules are matched to the specific kernel version (and
> archtecture). I am not familiar with Ubuntu,
> but in fact any of your colleague could just
> 1) copy your /lib/modules/<kver>/updates/ recursively
> 2) run "depmod -a"
> 3) either reboot or unload and reload the kernel module with "modprobe
> -r rtl8187" then "modprobe -v rtl8187"
>
> In fact step two is probably not necessary if you choose to reboot,
> since depmod is often run just based on time-stamp at boot up.
>
> I assume your question is just whether step 1) would work - the answer
> is yes, provided you run depmod afterwards, or equivalent. You
> actually don't need to copy the whole of that 40+ modules from
> compar-wireless, just 4:
> rtl8187
> mac80211
> eeprom_93cx6
> cfg80211
>
> (lsmod would tell you this).
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
www.jorgeroden.blogspot.com
FSF member 5687
