Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39638 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757802Ab1KPRnR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 12:43:17 -0500
Received: by fagn18 with SMTP id n18so1802135fag.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Nov 2011 09:43:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1321445323-71774-2-git-send-email-nbd@openwrt.org>
References: <1321445323-71774-1-git-send-email-nbd@openwrt.org> <1321445323-71774-2-git-send-email-nbd@openwrt.org>
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Date: Wed, 16 Nov 2011 09:42:54 -0800
Message-ID: <CAB=NE6XOz9p=GwQWZ3TibMMan70QO7dXgVRP4PLuV6p=P1-RXA@mail.gmail.com> (sfid-20111116_184326_606964_53E75C69)
Subject: Re: [PATCH 2/4] ath9k: rework power state handling
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	Paul Stewart <pstew@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 16, 2011 at 4:08 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> Turning off the radio when mac80211 tells the driver that it's idle is not
> a good idea, as idle interfaces might still occasionally scan or send packets.
> The only time the radio can be safely turned off is when drv_stop has been
> called. In the mean time, use sc->ps_idle only to indicate network sleep vs
> full sleep.
> Move the LED GPIO changes out of the PCI suspend/resume path, the start/stop
> functions already take care of that.
>
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>

This set of patches are going to need some good amount of testing for
power impact. The benefits and gains need to be considered. I'll yield
to Senthil and Paul for final approval on this.

  Luis
