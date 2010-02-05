Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f182.google.com ([209.85.216.182]:36823 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540Ab0BEPy2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Feb 2010 10:54:28 -0500
Received: by pxi12 with SMTP id 12so4342661pxi.33
        for <linux-wireless@vger.kernel.org>; Fri, 05 Feb 2010 07:54:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1265372852-4692-2-git-send-email-vnatarajan@atheros.com>
References: <1265372852-4692-1-git-send-email-vnatarajan@atheros.com>
	<1265372852-4692-2-git-send-email-vnatarajan@atheros.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 5 Feb 2010 07:54:07 -0800
Message-ID: <43e72e891002050754t7254348fhf7960ce927a5098e@mail.gmail.com>
Subject: Re: [PATCH 2/2 v2] mac80211: Reset dynamic ps timer in Rx path.
To: Vivek Natarajan <vnatarajan@atheros.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 5, 2010 at 4:27 AM, Vivek Natarajan <vnatarajan@atheros.com> wrote:
> The current mac80211 implementation enables power save if there
> is no Tx traffic for a specific timeout. Hence, PS is triggered
> even if there is a continuous Rx only traffic(like UDP) going on.
> This makes the drivers to wait on the tim bit in the next beacon
> to awake which leads to redundant sleep-wake cycles.
> Fix this by restarting the dynamic ps timer on receiving every
> data packet.
>
> Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>

Seems small enough and worth it for stable to me.

  Luis
