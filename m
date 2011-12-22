Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51708 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab1LVHvx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Dec 2011 02:51:53 -0500
Received: by dajs34 with SMTP id s34so5047919daj.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Dec 2011 23:51:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4EF2DFDB.3070501@gmail.com>
References: <1324467662-10065-1-git-send-email-pontus.fuchs@gmail.com>
 <CAK=WgbacGjAzXPSWd1sF0RwyJ3tbMYTrZM0v2sO-pd5heSawVQ@mail.gmail.com> <4EF2DFDB.3070501@gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 22 Dec 2011 09:51:32 +0200
Message-ID: <CAK=WgbbZVLgYZ-wzGMYP_3e+QMCJyWm-DALAnB4k=ibNTXzckA@mail.gmail.com> (sfid-20111222_085157_147179_1FBF4FE2)
Subject: Re: [PATCH] wl12xx: Fix power control for CONFIG_RUNTIME_PM off configurations
To: Pontus Fuchs <pontus.fuchs@gmail.com>
Cc: ido@wizery.com, coelho@ti.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 22, 2011 at 9:44 AM, Pontus Fuchs <pontus.fuchs@gmail.com> wrote:
> Even without my changes we will call wl12xx_sdio_power_on/off for every
> ifconfig up/down. Is that also a problem or is that case different?

That's ok: if runtime PM is enabled, we always call its API.
