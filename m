Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:32811 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab1FUWII (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 18:08:08 -0400
Received: by iwn6 with SMTP id 6so195362iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jun 2011 15:08:08 -0700 (PDT)
Message-ID: <4E011644.3070906@lwfinger.net> (sfid-20110622_000813_875912_43403640)
Date: Tue, 21 Jun 2011 17:08:04 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: ali@internetdog.org
CC: linux-wireless@vger.kernel.org
Subject: Re: r8712u driver for the rtl8192su chip.
References: <776913.88107.qm@web161609.mail.bf1.yahoo.com> <4DC0312A.4040303@lwfinger.net> <BANLkTinw+jv8zBi29EKs2K2=tAJMYCEdgQ@mail.gmail.com> <4DC0669E.4040100@lwfinger.net> <BANLkTikxS_2wJEpijmYQy3nPy2-9pykxdA@mail.gmail.com> <4DC06BF3.6070208@lwfinger.net> <20110621124954.GA8462@internetdog.org>
In-Reply-To: <20110621124954.GA8462@internetdog.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/21/2011 07:49 AM, Ali Bahar wrote:
> Hi Larry,
>
> this is more of a quick FYI, regarding Staging's r8712u driver.
>
> I ran iwconfig on this device in order to put it into Monitor mode, or
> even to change its ssid. Both failed because the Set ioctls were not
> permitted.
> Again, this is more of an FYI, since I don't really use this device.
>
> PPS for the benefit of googlers: the device is the ASUS WL-167G V3
> wireless USB adapter.
>
> root@hashbang Tue Jun 21 18:25:09 ~$ lsusb|grep :1791
> Bus 001 Device 002: ID 0b05:1791 ASUSTek Computer, Inc.
> root@hashbang Tue Jun 21 18:28:48 ~$ iwconfig wlan2 mode Monitor
> Error for wireless request "Set Mode" (8B06) :
>      SET failed on device wlan2 ; Invalid argument.
> root@hashbang Tue Jun 21 18:30:06 ~$ iwconfig wlan2 essid "h55m"
> Error for wireless request "Set ESSID" (8B1A) :
>      SET failed on device wlan2 ; Operation not permitted.
> root@hashbang Tue Jun 21 18:30:47 ~$ uname -r
> 3.0.0-rc2-wl_m_Sat12jun2011
> root@hashbang Tue Jun 21 18:36:57 ~$

Setting monitor mode is not implemented; however, setting the essid is 
implemented. Your command failed because you ran the command as an unprivileged 
user. Notice the differences in the error messages.

Larry
