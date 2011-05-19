Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:57025 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932323Ab1ESWsN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 May 2011 18:48:13 -0400
Received: by gwaa18 with SMTP id a18so1117452gwa.19
        for <linux-wireless@vger.kernel.org>; Thu, 19 May 2011 15:48:13 -0700 (PDT)
Message-ID: <4DD59E2A.4070405@lwfinger.net> (sfid-20110520_004828_132242_A926C089)
Date: Thu, 19 May 2011 17:48:10 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: John W Linville <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43: Fix bogus compilation warning for phy_n
References: <4dd58d39.ev8WALmbdvCfJmAJ%Larry.Finger@lwfinger.net>	<BANLkTinDciqW2yJLpwKemnSM=8_1Jy3Fxw@mail.gmail.com>	<4DD595C9.105@lwfinger.net> <BANLkTi=P-uCzunSyjf2ziX6BaCyq9Muj+g@mail.gmail.com>
In-Reply-To: <BANLkTi=P-uCzunSyjf2ziX6BaCyq9Muj+g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/19/2011 05:40 PM, Rafał Miłecki wrote:
>
> I should have describe where I can see the problem.
>
> If error is other than 0 (it can be as the result of "error =
> b43_nphy_tx_tone(dev, freq, 250, true, false);"), then "last" won't be
> set in 3256. In 3300 we use "last", no matter what "error" is.

You are correct. I missed the level of indent in line 3256. What initialization 
should be used for last?  It clearly needs to be set to something.

John: Please drop my patch. I'll let Rafał fix it.

Larry



