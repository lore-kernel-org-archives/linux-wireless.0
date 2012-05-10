Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38814 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241Ab2EJPiY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 11:38:24 -0400
Received: by yenm10 with SMTP id m10so1599337yen.19
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 08:38:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F904DB7.7030007@lwfinger.net>
References: <CAKa7sPSOBYmaoCRZZa=R0UT59bD+cxmtSPqxZ6754CmarNfXzA@mail.gmail.com>
 <CAKa7sPQYpgmh+=nLWGNzaXRL4_wHmpY4pScuwk4kTmYKCyU6dg@mail.gmail.com> <4F904DB7.7030007@lwfinger.net>
From: Viktar Palstsiuk <viktar.palstsiuk@promwad.com>
Date: Thu, 10 May 2012 18:37:43 +0300
Message-ID: <CAKa7sPRFP0M57qnnOpOLqNAzxu=Fzbw7bk2FYKuQ9_ieRaR4iw@mail.gmail.com> (sfid-20120510_173828_275618_51B0B711)
Subject: Re: Rtlwifi with hostapd
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm using 2.6.37 which is in OpenWRT's trunk for kirkwood platform.
I've compiled compat-wireless-2012-04-17 and now RTL8192DE doesn't
hang during hostapd start.
But the AP can't be found during scan performed on PC.

root@CPE:/# dmesg | grep rtl
[   12.203143] rtl8192de: FW Power Save off (module option)
[   12.208714] rtl8192de: Driver for Realtek RTL8192DE WLAN interface
[   12.214945] rtl8192de: Loading firmware file rtlwifi/rtl8192defw.bin
[   12.248888] rtl8192de: FW Power Save off (module option)
[   12.254450] rtl8192de: Driver for Realtek RTL8192DE WLAN interface
[   12.260680] rtl8192de: Loading firmware file rtlwifi/rtl8192defw.bin
[   12.370814] ieee80211 phy1: Selected rate control algorithm 'rtl_rc'
[   12.371499] rtlwifi: wireless switch is on
[   12.380271] ieee80211 phy0: Selected rate control algorithm 'rtl_rc'
[   12.380947] rtlwifi: wireless switch is on
root@CPE:/# lsmod | grep rtl
rtl8192de              95684  0
rtl8192ce              46108  0
rtl8192c_common        31104  1 rtl8192ce
rtlwifi                49488  2 rtl8192de,rtl8192ce
mac80211              234384  7
ath9k,rtl8192ce,rtl8192c_common,rt2800lib,rtlwifi,rt2x00pci,rt2x00lib
cfg80211              133544  5 ath9k,rtlwifi,ath,rt2x00lib,mac80211
compat                  5872  9
rt2800pci,ath9k,rtl8192de,rtl8192ce,ath9k_common,ath9k_hw,rtlwifi,mac80211,cfg80211
root@CPE:/# dmesg | grep compat-wireless
[   10.704691] Compat-wireless backport release:
compat-wireless-2012-04-17-1-r779

Also I've tried to install RTL8192CE into the same board and it worked
well in AP mode, so I managed to connect to it.

On Thu, Apr 19, 2012 at 8:39 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 04/19/2012 03:25 AM, Viktar Palstsiuk wrote:
>>
>> Hello
>>
>> I'm trying to run RTL8192DE-based wifi module in AP mode using hostapd.
>> RTL8192DE is connected to Marvell Kirkwood CPU using PCI Express bus.
>> But the kernel hangs right after hostapd was started.
>> In STA mode it is possible to scan for networks in 2.4 GHz band and it
>> discovers ~10 APs.
>> Was rtlwifi driver tested to work with hostapd?
>> I've tried compat-wireless-2011-12-01 and
>> 92ce_se_de_linux_mac80211_0005.1230.2011.tar.gz from Realtek site.
>
>
> without knowing any details of the kernel hangs, it is impossible to know
> what might be wrong. If you switch to the logging console immediately upon
> starting hostapd, is anything reported on the screen?
>
> I have not used the RTL8192DE as an AP, but the SE variety does work. There
> are some important fixes for AP mode that are not in compat-wireless as old
> as the one you are using. Please try a version from this week. Those fixes
> are also not included in the driver on the Realtek site.
>
> What kernel version are you using? Is there a possibility to switch to the
> kernel from the wireless-testing git tree?
>
> Larry
>



-- 
Best regards,
Viktar Palstsiuk

--
Software engineer
Promwad Innovation Company
22, Olshevskogo St.,
220073, Minsk, BELARUS
Phone/Fax: +375 (17) 312-12-46
E-mail: viktar.palstsiuk@promwad.com
Skype: vipals
Web: www.promwad.com
