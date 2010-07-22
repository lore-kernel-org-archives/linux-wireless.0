Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:46897 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758825Ab0GVUho (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 16:37:44 -0400
Received: by pvc7 with SMTP id 7so3198017pvc.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Jul 2010 13:37:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1279725698.10426.4.camel@sakura.staff.proxad.net>
References: <1279336415.1941.6.camel@kero> <1279394982.3931.0.camel@jlt3.sipsolutions.net>
	<1279725698.10426.4.camel@sakura.staff.proxad.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 22 Jul 2010 13:37:09 -0700
Message-ID: <AANLkTikX13IaCmwzYSGTkbkz2pDW1FSxeZ5Cpq4XmtgK@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: fix race between sysfs and cfg80211
To: mbizon@freebox.fr
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 21, 2010 at 8:21 AM, Maxime Bizon <mbizon@freebox.fr> wrote:
> From: Maxime Bizon <mbizon@freebox.fr>
>
> device_add() is called before adding the phy to the cfg80211 device
> list.
>
> So if a userspace program uses sysfs uevents to detect new phy
> devices, and queries nl80211 to get phy info, it can get ENODEV even
> though the phy exists in sysfs.
>
> An easy workaround is to hold the cfg80211 mutex until the phy is
> present in sysfs/cfg80211/debugfs.
>
> Signed-off-by: Maxime Bizon <mbizon@freebox.fr>
> ---

You should resubmit as a new e-mail with a subject of [PATCH v2].

  Luis
