Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:52209 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872Ab2ESWmn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 May 2012 18:42:43 -0400
Received: by obbtb18 with SMTP id tb18so5911684obb.19
        for <linux-wireless@vger.kernel.org>; Sat, 19 May 2012 15:42:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FB6D114.4050802@candelatech.com>
References: <4FB6D114.4050802@candelatech.com>
Date: Sun, 20 May 2012 01:42:42 +0300
Message-ID: <CAB3XZEem=2P36WgWXynoscemAhMrcgh0mKFocBbGhy8C-cJigQ@mail.gmail.com> (sfid-20120520_004247_251937_588CE5A1)
Subject: Re: lockdep splat related to wifi regulatory in 3.3.6+
From: Eliad Peller <eliad@wizery.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi Ben,

On Sat, May 19, 2012 at 1:45 AM, Ben Greear <greearb@candelatech.com> wrote:
> This appears to be this bug:
>
> https://bugzilla.redhat.com/show_bug.cgi?id=734519
>
> Test case was to create 40 (virtual) stations against an AP that can only
> handle
> 30, so the remaining 10 constantly try to re-associate, get DHCP if
> they manage, etc....
>
>
> cfg80211: Calling CRDA for country: US
>
> ======================================================
> [ INFO: possible circular locking dependency detected ]
> 3.3.6+ #1 Tainted: G        WC O
> -------------------------------------------------------
> kworker/1:2/62 is trying to acquire lock:
>  (cfg80211_mutex){+.+.+.}, at: [<ffffffffa00f7ced>]
> restore_regulatory_settings+0x2c/0x4af [cfg80211]
>
> but task is already holding lock:
>  ((reg_timeout).work){+.+...}, at: [<ffffffff8104c5c1>]
> process_one_work+0x1c2/0x35a
>
> which lock already depends on the new lock.
>
Try this:
http://www.spinics.net/lists/linux-wireless/msg90322.html

Eliad.
