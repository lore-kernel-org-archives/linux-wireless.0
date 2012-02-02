Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:44202 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754318Ab2BBJbd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 04:31:33 -0500
Received: by lboi15 with SMTP id i15so471877lbo.21
        for <linux-wireless@vger.kernel.org>; Thu, 02 Feb 2012 01:31:30 -0800 (PST)
Subject: Re: [PATCH v2 0/7] wl12xx: add some psm/suspend features
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1328021048-8944-1-git-send-email-eliad@wizery.com>
References: <1328021048-8944-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Feb 2012 11:31:27 +0200
Message-ID: <1328175087.3626.298.camel@cumari> (sfid-20120202_103139_239901_ADFA8192)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-01-31 at 16:44 +0200, Eliad Peller wrote: 
> Add some psm / suspend features:
> * Add the ability to force psm (by default, the fw uses dynamic ps)
> * Use differnet wake up conditions on suspend
> * Add pattern support to wowlan triggers
> 
> (depends on the "wl12xx: update fw api" patchset)
> 
> v2: the rx filters patches were squashed and rewritten (thanks Eyal!)
> 
> Eyal Shapira (7):
>   wl12xx: Set different wake up conditions in case of suspend
>   wl12xx: add suspend_listen_interval debugfs file
>   wl12xx: add forced_ps mode
>   wl12xx: add forced_ps debugfs file
>   wl12xx: add RX data filter ACX commands
>   wl12xx: add RX data filters management functions
>   wl12xx: support wowlan wakeup patterns
> 
>  drivers/net/wireless/wl12xx/acx.c     |  115 +++++++++++++-
>  drivers/net/wireless/wl12xx/acx.h     |   34 ++++-
>  drivers/net/wireless/wl12xx/conf.h    |   19 +++
>  drivers/net/wireless/wl12xx/debugfs.c |  131 ++++++++++++++++-
>  drivers/net/wireless/wl12xx/main.c    |  272 +++++++++++++++++++++++++++++++--
>  drivers/net/wireless/wl12xx/ps.c      |   12 +-
>  drivers/net/wireless/wl12xx/rx.c      |   61 ++++++++
>  drivers/net/wireless/wl12xx/rx.h      |    8 +-
>  drivers/net/wireless/wl12xx/wl12xx.h  |   38 +++++-
>  9 files changed, 662 insertions(+), 28 deletions(-)

Eliad, could you split this patchset in two? I can take the first part,
about forced PS when you send v2.

The WoWLAN part needs to be reworked.  Let's split it out so that it
doesn't hold the forced PS back.


-- 
Cheers,
Luca.

