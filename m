Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f196.google.com ([209.85.221.196]:43357 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbZG3Oxm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 10:53:42 -0400
Received: by qyk34 with SMTP id 34so819933qyk.33
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2009 07:53:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200907301631.50780.mb@bu3sch.de>
References: <200907301631.50780.mb@bu3sch.de>
Date: Thu, 30 Jul 2009 10:45:37 -0400
Message-ID: <b6c5339f0907300745l3e7ec63eu9819503c4e7766bb@mail.gmail.com>
Subject: Re: Ath5k/mac80211 triggers WARN_ON in kernel/softirq.c
From: Bob Copeland <me@bobcopeland.com>
To: Michael Buesch <mb@bu3sch.de>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: jirislaby@gmail.com, mickflemm@gmail.com, lrodriguez@atheros.com,
	wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 30, 2009 at 10:31 AM, Michael Buesch<mb@bu3sch.de> wrote:
> Ath5k from today's compat-wireless triggers the following WARNing
> on hostapd startup.
> [ 1669.799870] ------------[ cut here ]------------
> [ 1669.799934] WARNING: at kernel/softirq.c:141 local_bh_enable_ip+0x8b/0xb0()

because ath5k calls ieee80211_beacon_get inside a spin_lock_irqsave()
and this is WARN_ON_ONCE(in_irq() || irqs_disabled).

> [ 1669.799982] Hardware name:
> [ 1669.800023] Modules linked in: ath5k mac80211 ath cfg80211
> [ 1669.800192] Pid: 24862, comm: hostapd Not tainted 2.6.30.2 #3
> [ 1669.800238] Call Trace:
> [ 1669.800287]  [<ffffffff80248e3b>] ? local_bh_enable_ip+0x8b/0xb0
> [ 1669.800340]  [<ffffffff802432f8>] warn_slowpath_common+0x78/0xd0
> [ 1669.800391]  [<ffffffff8024335f>] warn_slowpath_null+0xf/0x20
> [ 1669.800441]  [<ffffffff80248e3b>] local_bh_enable_ip+0x8b/0xb0
> [ 1669.800493]  [<ffffffff807e0fef>] _spin_unlock_bh+0xf/0x20
> [ 1669.800564]  [<ffffffffa0040b92>] ieee80211_beacon_get+0x2c2/0x2d0 [mac80211]

I guess this is the first victim of spin_lock_bh conversion?

-- 
Bob Copeland %% www.bobcopeland.com
