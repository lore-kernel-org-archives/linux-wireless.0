Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:52849 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754898Ab3CIBxS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Mar 2013 20:53:18 -0500
Received: by mail-ob0-f169.google.com with SMTP id ta14so1834544obb.28
        for <linux-wireless@vger.kernel.org>; Fri, 08 Mar 2013 17:53:18 -0800 (PST)
Message-ID: <513A960B.2020304@lwfinger.net> (sfid-20130309_025330_764993_9856353B)
Date: Fri, 08 Mar 2013 19:53:15 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Vincent Brillault <gentoo@lerya.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: Warnings with ASUS PCE-N15 (RTL8188CE)
References: <20130307192920.GB8668@Fea.lerya.net> <20130308215833.GA2829@Fea.lerya.net>
In-Reply-To: <20130308215833.GA2829@Fea.lerya.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/08/2013 03:58 PM, Vincent Brillault wrote:
> Hi again,
>
> I forgot to mention that those warning from mac80211 (the associated
> comments in the code are 'RC is busted' or 'uh huh?') seems to somehow
> disable completely the rate control: 'iw wlan0 link' gives 'tx bitrate:'
> with nothing after. Furthermore, I loose the network from time to time
> on reason 7. I went back to kernel 3.8.0: if there is enough traffic
> continuously, the link is stable but I loose it randomly when there is
> no traffic.
>
> I made more debug on the 3.8.0 kernel, the first warning correspond to
> the following test:
> (info->control.rates[i].idx) 15 >= (sband->n_bitrates) 12
>
> Please tell me what test I can make to find the source of this problem.

 From what I remember, that problem has been fixed. The correct code should be 
in 3.8.2 and in 3.9-rc1.

The firmware in all the cards that use the rtlwifi family of drivers its own 
rate control. The drivers do not pay any attention to any rate-setting calls 
from user space.

I also see reason 7 disconnects; however, with NetworkManager, the network is 
reconnects. If you are using ifup or similar method, it probably does not reconnect.

Larry

