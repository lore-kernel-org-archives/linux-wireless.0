Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:64150 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752850Ab3CJRfb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Mar 2013 13:35:31 -0400
Received: by mail-ob0-f179.google.com with SMTP id un3so2669989obb.10
        for <linux-wireless@vger.kernel.org>; Sun, 10 Mar 2013 10:35:30 -0700 (PDT)
Message-ID: <513CC45E.7090402@lwfinger.net> (sfid-20130310_183535_582941_DCD95824)
Date: Sun, 10 Mar 2013 12:35:26 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Joe Perches <joe@perches.com>, Hauke Mehrtens <hauke@hauke-m.de>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ssb: fix unaligned access to mac address
References: <1361021140-19871-1-git-send-email-hauke@hauke-m.de> <CACna6ryaMfZ9x7VWHnRR9RF0wSN0A+H6vr3AC103Sn4G1XZdKQ@mail.gmail.com> <1361381489.3065.1.camel@joe-AO722> <51250E6B.3030308@lwfinger.net> <1361384969.2219.4.camel@joe-AO722> <51252132.3050603@hauke-m.de> <1361391065.2223.5.camel@joe-AO722> <512595BC.5030607@lwfinger.net> <CACna6rzQNo9CBrg08y6y+bf3009_EuL5f2UqOXVLKSoE_q7BRQ@mail.gmail.com> <513BCC20.70900@lwfinger.net> <CACna6rzNTfcuDOdpQrvbeWa4YhgDm_j6nkJ0OwbrLqCjh+qWJQ@mail.gmail.com>
In-Reply-To: <CACna6rzNTfcuDOdpQrvbeWa4YhgDm_j6nkJ0OwbrLqCjh+qWJQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/10/2013 06:36 AM, Rafał Miłecki wrote:
>
> Feel free to fix. I've another 3 regressions to track...

Upon further investigation, the flipping of the MAC bytes was not due to "ssb: 
pci: Standardize a function to get mac address", or "ssb: fix unaligned access 
to mac address". For other reasons, I had to run 3.8 today and found the 
flipping, even though neither patch was installed. Joe and Hauke are blameless - 
they merely reproduced the existing bug. I have no real desire to find out when 
that error was introduced as I am not an archeologist. Note that b43legacy does 
not have the problem, thus it was introduced after the split of those two variants.

I will submit the fix.

Larry



