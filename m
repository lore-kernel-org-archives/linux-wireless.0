Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35951 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab1CRAvA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2011 20:51:00 -0400
Received: by wya21 with SMTP id 21so3368259wya.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2011 17:50:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTim=KNYmEVddpNRD33iOYiMBh+x0WnegBWD0i3FO@mail.gmail.com>
References: <1296119711-4024-1-git-send-email-vnatarajan@atheros.com>
	<1296119711-4024-2-git-send-email-vnatarajan@atheros.com>
	<1296119711-4024-3-git-send-email-vnatarajan@atheros.com>
	<1296119711-4024-4-git-send-email-vnatarajan@atheros.com>
	<AANLkTim=KNYmEVddpNRD33iOYiMBh+x0WnegBWD0i3FO@mail.gmail.com>
Date: Fri, 18 Mar 2011 06:20:59 +0530
Message-ID: <AANLkTimDyJ3C4UOi_F_UtMdhO=4MoYjyoCh4zSixKg5p@mail.gmail.com>
Subject: Re: [PATCH 4/5] ath9k: Fix a locking related issue.
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Vivek Natarajan <vnatarajan@atheros.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 18, 2011 at 5:49 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Thu, Jan 27, 2011 at 1:15 AM, Vivek Natarajan <vnatarajan@atheros.com> wrote:
>> Spin_lock has been tried to be acquired twice from ath9k_tasklet
>> to ath_reset which resulted in a machine freeze.
>>
>> Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
>> ---
>
> Was this a stable fix? :(
>

Actually this was meant to be a quickfix for the panic we had noticed.
A proper fix would be to review all the spinlocks in ath9k and do a
revamp. Anyhow, such a revamp might take some time and before that we
will have this patch for stable. Thanks a lot, I will resend this to
stable.

Vivek.
