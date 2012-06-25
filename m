Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59284 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516Ab2FYRdQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2012 13:33:16 -0400
Received: by bkcji2 with SMTP id ji2so3410123bkc.19
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jun 2012 10:33:15 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "Michal Kudelski" <michal@idsia.ch>
Subject: Re: carl9170 driver - reducing the output power
Date: Mon, 25 Jun 2012 19:33:10 +0200
Cc: linux-wireless@vger.kernel.org
References: <web-69364863@ti-edu.ch>
In-Reply-To: <web-69364863@ti-edu.ch>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201206251933.10999.chunkeey@googlemail.com> (sfid-20120625_193319_861957_768E964E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, June 25, 2012 12:38:50 PM Michal Kudelski wrote:
> Thus, my question is: is the function of changing the 
> txpower really supported? If it is, what steps should I 
> take to make it work? I tried with ifconfig up/down when I 
> change the txpower, but it does not change anything. Maybe 
> I do something wrong? Do I use the correct versions of the 
> firmware and the driver?
No special firmware or driver is required. Just as long
as the driver supports the feature.  

> I've noticed a patch related to this issue, published on 
> 2012-01-27 by Christian Lamparter. It seems that it is 
> included in my driver version, but maybe I'm wrong and I 
> should apply some additional patch?
> 
> We use NetGear WNDA3100(v1) hardware [Atheros 
> AR9001U-(2)NG] and carl9170 driver 
> (driverversion=3.0.0-21-generic firmware=1.9.2).
That's probably too old. The patch you are talking about
is not a -stable patch so it's not backported to 3.3.x
(or older) kernels.

So, either you can upgrade to 3.4, use compat-wireless
<http://linuxwireless.org/en/users/Download/#Getting_compat-wireless_on_Ubuntu>
or backport the patch yourself (however, this could be diffcult).

Regards,
	Christian
