Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60442 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932713Ab1DMQo3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2011 12:44:29 -0400
Received: by fxm17 with SMTP id 17so585940fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 13 Apr 2011 09:44:28 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Damian Lesiuk <lesiuk@gmail.com>
Subject: Re: carl9170: TP-LINK TL-WN822N slow connection speeds (16 mbps) MASTER MODE
Date: Wed, 13 Apr 2011 18:43:57 +0200
Cc: linux-wireless@vger.kernel.org
References: <BANLkTimreffpSdBUogakk=E6Hn1Lf6KJ_w@mail.gmail.com> <BANLkTi=BgKRJXqM+8idBr-txCDPGFQSFhw@mail.gmail.com> <BANLkTi=Dtbhz=kGUSdH57JRG1DoRFP7kLw@mail.gmail.com>
In-Reply-To: <BANLkTi=Dtbhz=kGUSdH57JRG1DoRFP7kLw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201104131843.57676.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 13 April 2011 18:11:48 Damian Lesiuk wrote:
> When I turned off N i have this in log.
> http://pastebin.com/raw.php?i=q0zKxUZn
 
That's an assert to catch unwanted calls into the driver by
the stack or from userspace. In this case the driver WARNED
that it received an update to the bss_conf after all virtual
interfaces have been removed. (This makes no sense, since
*vif might not point to an old/gone ieee80211_vif.)

But it's simple to fix: get compat-wireless.
<http://wireless.kernel.org/en/users/Download>

Regards,
	Chr

P.S.: where's that hostapd from 2011-04-20 coming from?
AFAIK it's still the 13/14th of April on Earth :D
