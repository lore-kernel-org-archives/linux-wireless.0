Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44747 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386Ab1CVHlA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Mar 2011 03:41:00 -0400
Received: by eyx24 with SMTP id 24so1721946eyx.19
        for <linux-wireless@vger.kernel.org>; Tue, 22 Mar 2011 00:40:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1300742385-15813-1-git-send-email-coelho@ti.com>
References: <1300742385-15813-1-git-send-email-coelho@ti.com>
Date: Tue, 22 Mar 2011 09:40:59 +0200
Message-ID: <AANLkTimLvjiHMFJ7dxhLnKVcAU2co2d5uoEE6R0mi4-G@mail.gmail.com>
Subject: Re: [PATCH] wl12xx: use a bitmask instead of list of booleans in scanned_ch
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 21, 2011 at 11:19 PM, Luciano Coelho <coelho@ti.com> wrote:
> We were using an array of booleans to mark the channels we had already scanned.  This was causing a sparse error, because bool is not a type with defined size.  To fix this, use bitmasks instead, which is much cleaner anyway.
>
> Thanks Johannes Berg for the idea.
>
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---
[...]
> +       /* make sure all our channels fit in the scanned_ch bitmask */
> +       BUG_ON(ARRAY_SIZE(wl1271_channels) + ARRAY_SIZE(wl1271_channels_5ghz) >
> +              WL1271_MAX_CHANNELS);

maybe use BUILD_BUG_ON here?

Eliad.
