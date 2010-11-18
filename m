Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:36642 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759457Ab0KRQe2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 11:34:28 -0500
Received: by pvh1 with SMTP id 1so471607pvh.19
        for <linux-wireless@vger.kernel.org>; Thu, 18 Nov 2010 08:34:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4CE54BE2.2070302@lwfinger.net>
References: <1290083280-13550-1-git-send-email-zajec5@gmail.com>
	<4CE54BE2.2070302@lwfinger.net>
Date: Thu, 18 Nov 2010 17:34:27 +0100
Message-ID: <AANLkTimyVO4nQ+W3C9qJLgjQhW1fbFw90ftV1suSzriJ@mail.gmail.com>
Subject: Re: [PATCH 1/4] b43: N-PHY: fix values for PHY regs in channel tables
 of 2055 radio
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 18 listopada 2010 16:53 użytkownik Larry Finger
<Larry.Finger@lwfinger.net> napisał:
> On 11/18/2010 06:27 AM, Rafał Miłecki wrote:
>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>> ---
>
> This change deserves a bit more explanation. You might include something like
> "These tables came from reverse engineering the 5.10.56.46 version of the
> Broadcom driver. Trace comparisons between b43 and the current Broadcom driver
> (5.10.120.0) show byte reversals for the PHY register writes."

I guess you're right, sorry.

Currently I massively use kernel's MMIO tracing to compare wl hybrid
with b43. After comparing dumps from wl and b43 I noticed tables we
wrote from spect fot bytes swapped for PHY registers values. It also
makes more sense to swap bytes if you simply compare values. Now
values are slightly nicely increasing/decreasing in tables.

If someone is interested in the way I dump operations, please just
ask, I'll provide my /toolchain/.

-- 
Rafał
