Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62496 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699Ab0LVPw0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 10:52:26 -0500
Received: by iwn9 with SMTP id 9so5344255iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Dec 2010 07:52:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1293032660-3627-1-git-send-email-senthilkumar@atheros.com>
References: <1293032660-3627-1-git-send-email-senthilkumar@atheros.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 22 Dec 2010 10:52:06 -0500
Message-ID: <AANLkTikGgSbAY1FRHNOoVmgVk3BKdvBtY+ir9y5BywW0@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] ath9k_hw: Fix incorrect macversion and macrev checks
To: Senthil Balasubramanian <senthilkumar@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Stable Kernel <stable@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 22, 2010 at 10:44 AM, Senthil Balasubramanian
<senthilkumar@atheros.com> wrote:
> There are few places where we are checking for macversion and revsions
> before RTC is powered ON. However we are reading the macversion and
> revisions only after RTC is powered ON and so both macversion and
> revisions are actully zero and this leads to incorrect srev checks
>
> Incorrect srev checks can cause registers to be configured wrongly and can
> cause unexpected behavior. Fixing this seems to address the ASPM issue that
> we have observed. The laptop becomes very slow and hangs mostly with ASPM L1
> enabled without this fix.

On what chipset? Or did we see this on one chipset and suspect it can
affect others?

 Luis
