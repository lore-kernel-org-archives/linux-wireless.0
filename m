Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:42935 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933322AbXCBKp7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2007 05:45:59 -0500
Message-ID: <45E80064.6000200@warmcat.com>
Date: Fri, 02 Mar 2007 10:45:56 +0000
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: move PHY things to debugfs
References: <1172774065.3381.3.camel@johannes.berg>	 <45E72174.9060104@warmcat.com>  <1172775866.3381.7.camel@johannes.berg>	 <1172776049.3381.10.camel@johannes.berg>  <45E7DF58.6080608@warmcat.com> <1172830582.3482.4.camel@johannes.berg>
In-Reply-To: <1172830582.3482.4.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:

Hi Johannes -

>> I guess I'll stick with sysfs for now since the code is written already: 
>> if I will find add_iface and so on down there then I guess it will all 
>> work out with minor edits.
> 
> Just make sure you're running the very latest kernel with
> CONFIG_SYSFS_DEPRECATED disabled (I think that's necessary, not entirely
> sure). You'll notice when anything but the current CVS version of HAL no
> longer displays network devices :/

I am currently using stock Fedora kernels, they have 
CONFIG_SYSFS_DEPRECATED disabled already.  In current FC7 development 
kernels they have mac80211 in there too now.  So I will mod this when it 
breaks on the latest Fedora kernels.

>> Can I ask how stable this byzantine path I am currently following to get 
>> a "Management interface" for tx injection is going to be?  Not even 
>> standard wireless ioctl but Private IOCTL SIOCIWFIRSTPRIV+0 opens out 
>> into a secret garden of "PRISM2" special features... is this already in 
>> a little black refactoring book somewhere? 
> 
> Yup, it is. But there's still debate on whether it should be done
> through netlink (nl80211) or some new special injection format for the
> monitor interfaces like the management interface currently has.
> 
> [you can rip code from wpa_supplicant to inject frames]

Yeah that is good advice, I will look to the wpa_supplicant code, 
especially since my code doesn't work yet.

> Btw, here's another argument against the monitor interfaces: having them
> up takes the card out of powersave mode which they should only be while
> not associated, even with a userspace MLME.

It's better said "hardware promisc" than "Monitor Mode" if I understood 
you.   The previous patches forced hardware promisc and then filtered 
for the magic packets without using Monitor mode, but that has the same 
power objection.

It's mitigated a bit by only bringing the monitor interface up 
automatically when the daemon starts and down when it stops, but of 
course normally the daemon runs all the time.  The daemon can even be 
configured by the user to act differently if he wants if it sees he is 
on battery.  Also mitigating it is that for the largest intended usage 
case, people at home communicating with neighbours, the stations are 
plugged in the wall.

But if there is a better way for the stack to get unencrypted broadcasts 
(that is all I really want, addr1->FF:FF:FF:FF:FF:FF packets) through to 
usermode, which you would think might not actually require hardware 
promisc on the hardware, then I am quite motivated to work on that.

-Andy
