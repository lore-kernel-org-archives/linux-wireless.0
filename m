Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49621 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab2BLQAD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Feb 2012 11:00:03 -0500
Received: by iacb35 with SMTP id b35so2898092iac.19
        for <linux-wireless@vger.kernel.org>; Sun, 12 Feb 2012 08:00:03 -0800 (PST)
Message-ID: <4F37E200.90507@lwfinger.net> (sfid-20120212_170009_292439_C9C723B5)
Date: Sun, 12 Feb 2012 10:00:00 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Sivakumar Pothireddy
	<Sivakumar.Pothireddy@infotech-enterprises.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Regarding RTL8191SU-GR
References: <845B9439DBA52942BE709500EAB58CE002C4CD3D@INFHYDEX10MB3.corp.infotech-enterprises.com>,<845B9439DBA52942BE709500EAB58CE002C4CD9E@INFHYDEX10MB3.corp.infotech-enterprises.com> <845B9439DBA52942BE709500EAB58CE002C4CDF9@INFHYDEX10MB3.corp.infotech-enterprises.com>
In-Reply-To: <845B9439DBA52942BE709500EAB58CE002C4CDF9@INFHYDEX10MB3.corp.infotech-enterprises.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/12/2012 12:22 AM, Sivakumar Pothireddy wrote:
>
> Dear All,
> We have a Unigen device(UGWDR82NUH50) which uses RTL8191SU-GR Wi-Fi chipset.
> We know that this device will work in Client mode in Linux-3.0 using the staging driver i.e. r8712u.
> Our task was to make the device to run as Access point with mac80211 and nl80211.
> In this regard i have few queries which are very important for us to proceed.
>
> 1) Will the same firmware used for client supports AP mode or not?
> 2) If it supports , does the driver code has enough calls to send the commands for AP?
> 3) We currently doenst have a datasheet for RTL8191SU-GR, so without having the knowledge of register set ,
> can we proceed?, i mean the current driver and firmware had the commands to support AP?
>
> It would be of great help if can look in to this and reply ASAP,

This topic has been discussed several times in this mailing list. The driver 
works in ad-hoc mode, and would probably work in AP mode, if one has a suitable 
equivalent of hostapd that would work with it. The latest versions of hostapd 
are tailored toward the nl80211 interface; however, r8712u does hot use the 
mac80211-based stack. As the wireless extensions interface is not sufficient to 
implement an AP, it follows that r8712u will not work as an AP. The firmware 
might, or might not work - there is no way to test.

The way to go would be to write a driver for the RTL8191SU that uses rtlwifi and 
a new driver rtl8192su for these USB devices that works with mac80211. Such a 
driver is on my todo list, but it has low priority.

Note: I do not have a datasheet for the device either. My feeling is that a 
study of drivers r8712u and rtl8192se would provide sufficient information. The 
underlying wireless chip is nearly the same as that of the RTL8192SE - only the 
USB interconnect is different.

Larry


