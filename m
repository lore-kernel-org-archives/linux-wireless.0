Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:36625 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864Ab3I2VK2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Sep 2013 17:10:28 -0400
Received: by mail-we0-f181.google.com with SMTP id p61so4685415wes.40
        for <linux-wireless@vger.kernel.org>; Sun, 29 Sep 2013 14:10:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <31357461.i5mG9q5IfA@naboo>
References: <31357461.i5mG9q5IfA@naboo>
Date: Sun, 29 Sep 2013 23:10:26 +0200
Message-ID: <CACna6rx-8C+jMDG+BL3RQhfqp1+ozbjqamvn=7PzKG=JUa1J_w@mail.gmail.com> (sfid-20130929_231043_051363_CF5729EF)
Subject: Re: NetworkManager not listing access points
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Detlev Casanova <detlev.casanova@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	laurent.pinchart@ideasonboard.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/9/18 Detlev Casanova <detlev.casanova@gmail.com>:
> After a bisection on the kernel, it seems that a patch is causing a
> problem with NetworkManager:
>
> commit 0172bb75073e11a5aa9d8a953bdaefb8709f00c8 ("cfg80211:
> use DS or HT operation IEs to determine BSS channel")
>
> (...)
>
> The hardware is: 14e4:4315 (Network controller: Broadcom Corporation
> BCM4312 802.11b/g LP-PHY (rev 01)) on an Intel Core i3 M370 CPU (64
> bits) computer.

See:
http://www.spinics.net/lists/linux-wireless/msg105359.html
("Scanning regression since "cfg80211: use DS or HT operation IEs to
determine BSS channel"")

It seems that starting with the mentioned commit, b43 doesn't report
any results on the 1st scanning. No idea how this patch affected b43.
Scanning on channel b43 is failing even worse starting with that
commit.

-- 
Rafał
