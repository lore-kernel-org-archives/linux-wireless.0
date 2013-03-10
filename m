Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:40515 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab3CJU5e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Mar 2013 16:57:34 -0400
Received: by mail-ob0-f178.google.com with SMTP id wd20so2722021obb.37
        for <linux-wireless@vger.kernel.org>; Sun, 10 Mar 2013 13:57:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <513CC45E.7090402@lwfinger.net>
References: <1361021140-19871-1-git-send-email-hauke@hauke-m.de>
	<CACna6ryaMfZ9x7VWHnRR9RF0wSN0A+H6vr3AC103Sn4G1XZdKQ@mail.gmail.com>
	<1361381489.3065.1.camel@joe-AO722>
	<51250E6B.3030308@lwfinger.net>
	<1361384969.2219.4.camel@joe-AO722>
	<51252132.3050603@hauke-m.de>
	<1361391065.2223.5.camel@joe-AO722>
	<512595BC.5030607@lwfinger.net>
	<CACna6rzQNo9CBrg08y6y+bf3009_EuL5f2UqOXVLKSoE_q7BRQ@mail.gmail.com>
	<513BCC20.70900@lwfinger.net>
	<CACna6rzNTfcuDOdpQrvbeWa4YhgDm_j6nkJ0OwbrLqCjh+qWJQ@mail.gmail.com>
	<513CC45E.7090402@lwfinger.net>
Date: Sun, 10 Mar 2013 21:57:32 +0100
Message-ID: <CACna6ry=zkuS4aASE=Mc9eOKDDCtLRLn6ZgX4Cqyfj58mdHq3g@mail.gmail.com> (sfid-20130310_215739_057917_3D4F586E)
Subject: Re: [PATCH] ssb: fix unaligned access to mac address
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Joe Perches <joe@perches.com>, Hauke Mehrtens <hauke@hauke-m.de>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/3/10 Larry Finger <Larry.Finger@lwfinger.net>:
> On 03/10/2013 06:36 AM, Rafał Miłecki wrote:
>>
>>
>> Feel free to fix. I've another 3 regressions to track...
>
>
> Upon further investigation, the flipping of the MAC bytes was not due to
> "ssb: pci: Standardize a function to get mac address", or "ssb: fix
> unaligned access to mac address". For other reasons, I had to run 3.8 today
> and found the flipping, even though neither patch was installed. Joe and
> Hauke are blameless - they merely reproduced the existing bug. I have no
> real desire to find out when that error was introduced as I am not an
> archeologist. Note that b43legacy does not have the problem, thus it was
> introduced after the split of those two variants.

It's not about blaming anyone, just finish the bug :)

Reverting e5652756ff36ed9e1283121f788e6a17117efcab which is "ssb: pci:
Standardize a function to get mac address" fixes the MAC address issue
for me.

I'm reverting on top of c49141682cfa9713e67f515cc7faf6145720ec3d.

-- 
Rafał
