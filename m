Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62781 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757074Ab1CRRgB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 13:36:01 -0400
Received: by gyf1 with SMTP id 1so1662952gyf.19
        for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2011 10:36:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1300416312-16808-1-git-send-email-lrodriguez@atheros.com>
References: <1300416312-16808-1-git-send-email-lrodriguez@atheros.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 18 Mar 2011 10:35:40 -0700
Message-ID: <AANLkTik8iUxgniVHB2UBC359GxrmAxUTLGL-_eZ7Gtom@mail.gmail.com>
Subject: Re: [PATCH] ath6kl: fix device registration ordering
To: gregkh@suse.de
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org, vmehta@atheros.com,
	devel@linuxdriverproject.org, naveen.singh@atheros.com,
	stable@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 17, 2011 at 7:45 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> Defer device registration to cfg80211 until it is ready.
> This fixes a race against udev whereby device events
> (both udev and RTNL) might be emitted with an unregistered
> device specification (wlan%d).
>
> This fixes a race on ath6kl on systems where the device
> boots up really quickly to the the point udev and the
> respective userspace daemon tries to start mucking with
> the device prior to the device being initialized properly.
>
> This fixes this bug:
>
> http://code.google.com/p/chromium-os/issues/detail?id=13159
>
> Without this loading of ath6kl will fail.
>
> Cc: stable@kernel.org
> Cc: Naveen Singh <naveen.singh@atheros.com>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Please disregard this for now, I am testing ath6k right now on x86_64
where it has a failure upon load and it oopses, likely due to this
patch and what I believe is wiphy_unregister() being called twice.
I'll fix the oops first and then resubmit a v2. If you do not hit a
failure upon load though then the patch would help your issues with
udev, but still we must handle the failure cases better. My failure
are because I'm using an x86_64 box to test ath6kl and its buggy
there.

  Luis
