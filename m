Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:45585 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970Ab1HMD1r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 23:27:47 -0400
Received: by yie30 with SMTP id 30so2381164yie.19
        for <linux-wireless@vger.kernel.org>; Fri, 12 Aug 2011 20:27:47 -0700 (PDT)
Message-ID: <4E45EF30.3070103@lwfinger.net> (sfid-20110813_052756_320279_E806F1F7)
Date: Fri, 12 Aug 2011 22:27:44 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Roman Krylov <volyrkr@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: rtl8192* wifi driver
References: <4E45A973.6060305@gmail.com> <4E45AF82.5040407@lwfinger.net> <4E45D65F.6000306@gmail.com> <4E45DCB2.5020905@lwfinger.net> <4E45EA54.5010500@gmail.com>
In-Reply-To: <4E45EA54.5010500@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/12/2011 10:07 PM, Roman Krylov wrote:
>
>> What do you see in the NM log file? It should be at /var/log/NetworkManager?
>>
>> I would also like to see the output of the 'iwlist scan' command when run as
>> root.
>>
>> Larry
> Aug 12 21:26:11 volyrkr NetworkManager: <info> Activation (wlan3/wireless):
> connection 'Auto bhn 310' has security, and secrets exist. No new secrets needed.
> Aug 12 21:26:11 volyrkr NetworkManager: <info> Config: added 'ssid' value 'bhn 310'

What is your ESSID? Two lines up, I see 'Auto bhn 310' and one line up I see 
'bhn 310'. Based on my logs, those two should be the same. I'll set one of my 
APs to the first ESSID and see if I can connect.

I found the problem in the driver you sent. One needs to add

#include <linux/interrupt.h>

to file include/osdep_service.h. Once I did that, it built and works.

Larry

