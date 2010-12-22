Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59589 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab0LVOm3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 09:42:29 -0500
Received: by iyi12 with SMTP id 12so4110319iyi.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Dec 2010 06:42:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1293025638-3255-1-git-send-email-senthilkumar@atheros.com>
References: <1293025638-3255-1-git-send-email-senthilkumar@atheros.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 22 Dec 2010 09:42:08 -0500
Message-ID: <AANLkTi=P967+E=j4JT7fQjX0T0+yLHbFrdsT3-_CVPvn@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] ath9k_hw: Fix incorrect macversion and macrev checks
To: Senthil Balasubramanian <senthilkumar@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Stable Kernel <stable@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 22, 2010 at 8:47 AM, Senthil Balasubramanian
<senthilkumar@atheros.com> wrote:
> There are few places where we are checking for macversion and revsions
> before RTC is powered ON. However we are reading the macversion and
> revisions only after RTC is powered ON and so both macversion and
> revisions are actully zero and this leads to incorrect srev checks.
>
> fix this by reading the macversion and revisisons even before we start
> using them. There is no reason why should we delay reading this info
> until RTC is powered on as this is just a register information.
>
> Cc: Stable Kernel <stable@kernel.org>
> Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
> ---
> v2 -- fixed reading revisions unnecessarily during every reset.

The description can be extended explaining what specific real life
issues this fixes and can help in the evaluation for stable, consider
helping to the extend even Andi Kleen can read this and easily decide
to either suck this into 2.6.35 longterm or not. To help with this it
will help to know what chipsets are affected and so on. I suspect it
can say something like:

"This fixes programming the hardware incorrectly for x and y chipsets
where the wrong chipset was being picked up. Without this those
chipsets would be programmed incorrectly and would not be functional"

  Luis
