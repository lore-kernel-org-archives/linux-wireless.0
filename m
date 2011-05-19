Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:41524 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab1ESW7K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 May 2011 18:59:10 -0400
Received: by qyg14 with SMTP id 14so1817053qyg.19
        for <linux-wireless@vger.kernel.org>; Thu, 19 May 2011 15:59:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DD59E2A.4070405@lwfinger.net>
References: <4dd58d39.ev8WALmbdvCfJmAJ%Larry.Finger@lwfinger.net>
	<BANLkTinDciqW2yJLpwKemnSM=8_1Jy3Fxw@mail.gmail.com>
	<4DD595C9.105@lwfinger.net>
	<BANLkTi=P-uCzunSyjf2ziX6BaCyq9Muj+g@mail.gmail.com>
	<4DD59E2A.4070405@lwfinger.net>
Date: Fri, 20 May 2011 00:59:09 +0200
Message-ID: <BANLkTi=Mepan9vObhminTdAf9iaO6qmBqA@mail.gmail.com> (sfid-20110520_005915_579346_37A4D8FA)
Subject: Re: [PATCH] b43: Fix bogus compilation warning for phy_n
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 20 maja 2011 00:48 użytkownik Larry Finger
<Larry.Finger@lwfinger.net> napisał:
> On 05/19/2011 05:40 PM, Rafał Miłecki wrote:
>>
>> I should have describe where I can see the problem.
>>
>> If error is other than 0 (it can be as the result of "error =
>> b43_nphy_tx_tone(dev, freq, 250, true, false);"), then "last" won't be
>> set in 3256. In 3300 we use "last", no matter what "error" is.
>
> You are correct. I missed the level of indent in line 3256. What
> initialization should be used for last?  It clearly needs to be set to
> something.

http://bcm-v4.sipsolutions.net/802.11/PHY/N/CalTxIqlo does not say
anything about initial value. Guess it should be zero.

-- 
Rafał
