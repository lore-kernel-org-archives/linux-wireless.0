Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:36150 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753355AbdHQSCF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Aug 2017 14:02:05 -0400
Received: by mail-oi0-f54.google.com with SMTP id g131so74129026oic.3
        for <linux-wireless@vger.kernel.org>; Thu, 17 Aug 2017 11:02:05 -0700 (PDT)
Subject: Re: iw not finding physical interface
To: Fredrik Gustafsson <iveqy@iveqy.com>,
        linux-wireless@vger.kernel.org
References: <20170817111804.GE24362@paksenarrion.iveqy.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <89c3c2c0-9ec7-f7a0-3032-c5ebc469a308@lwfinger.net> (sfid-20170817_200209_280320_181E49E0)
Date: Thu, 17 Aug 2017 13:02:03 -0500
MIME-Version: 1.0
In-Reply-To: <20170817111804.GE24362@paksenarrion.iveqy.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/17/2017 06:18 AM, Fredrik Gustafsson wrote:
> I've a dwlink dwi-131 usb wifi adapter that I'm trying to use with buildroot (for a sama5d2xplained board) for hostadp.
> 
> I use a driver from github:
> https://github.com/Mange/rtl8192eu-linux-driver
> 
> The driver works and I can successfully connect to my AP. But setting up hostapd on the device itself fails. I suppose this is because the physical network device is not found by iw. However it is found by ip, iwconfig and ipconfig.
> 
> How can I debug this?

The first thing to check if that out-of-kernel driver supports CFG80211.  With 
most of these, there is a configuration parameter that is used to enable the 
feature.

Those Realtek USB drivers are a real mess. Debugging them is never an easy job. 
In addition, I'm not sure if any kernel developers will be interested in 
helping. I certainly am not.

The long-term future for RTL8192EU is to use rtl8xxxu. As far as I know, it 
works, and that driver will work just fine with hostapd. If not, that is the 
place to devote some effort. The USB Id for your device may not be in the driver 
yet. That would be the first thing to check.

Larry
