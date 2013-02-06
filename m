Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f44.google.com ([209.85.219.44]:47183 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163Ab3BFXuN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 18:50:13 -0500
Received: by mail-oa0-f44.google.com with SMTP id h1so2201912oag.3
        for <linux-wireless@vger.kernel.org>; Wed, 06 Feb 2013 15:50:12 -0800 (PST)
Message-ID: <5112EC32.6020808@lwfinger.net> (sfid-20130207_005018_636579_265F71E7)
Date: Wed, 06 Feb 2013 17:50:10 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: bugreport upstream: 0bda:819a RTL8188CUS WLAN doesn't work out
 of the box
References: <51045387.2040607@gmail.com> <5112A972.3060109@lwfinger.net> <5112E139.6090701@gmail.com>
In-Reply-To: <5112E139.6090701@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/06/2013 05:03 PM, Xose Vazquez Perez wrote:
> On 02/06/2013 08:05 PM, Larry Finger wrote:
>
>> Please install the attached patch, and retry the above method. I fixed the probe function to get rid of the oops. If the device is really foreign, the process that writes new_id will not finish until
>> the device is unplugged; however, the rest of the system is chugging along.
>
> I tried the patch. And now, rtl8192cu doesn't break the kernel.
>
> But it should go out when an unknown chip/rf is detected,
> instead of trying to configure the unknown_device.

No fooling; however, the only way it can tell if the device is known is by 
seeing those USB timeouts. It took a very long time before the probe routine 
gets control again. I don't know any way to fix that.

Larry


