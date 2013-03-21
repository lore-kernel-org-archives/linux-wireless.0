Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:55560 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab3CUTVZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Mar 2013 15:21:25 -0400
Received: by mail-la0-f49.google.com with SMTP id fs13so5764242lab.8
        for <linux-wireless@vger.kernel.org>; Thu, 21 Mar 2013 12:21:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1363655666-1217-1-git-send-email-mcgrof@do-not-panic.com>
References: <1363655666-1217-1-git-send-email-mcgrof@do-not-panic.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 21 Mar 2013 12:21:03 -0700
Message-ID: <CAB=NE6UC=vVkzYKbMNAyQY1iuBEP-sQOsPopwoBemX0hMquopg@mail.gmail.com> (sfid-20130321_202128_728783_9F06D6C6)
Subject: Re: [PATCH] ath9k: skip rearming rx_poll_timer when quiescing
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 18, 2013 at 6:14 PM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
>
> When mac80211 goes to suspend we disarm our timers
> but users of mod_timer() must ensure to use
> mod_timer_pending() where appropriate to avoid
> re-arming them before coming up after suspend. This
> is one case that was reported by Parag.
>
> Issue reported:
>
> WARNING: at net/mac80211/util.c:599 ieee80211_can_queue_work.isra.7+0x32/0x40 [mac80211]()
> Hardware name: iMac12,1
> queueing ieee80211 work while going to suspend
> Pid: 0, comm: swapper/0 Tainted: PF          O 3.8.2-206.fc18.x86_64 #1
> Call Trace: Mar 16 09:39:17 Parags-iMac kernel: [ 3993.642992]  <IRQ>
> [<ffffffff8105e61f>] warn_slowpath_common+0x7f/0xc0
> [<ffffffffa0581420>] ? ath_start_rx_poll+0x70/0x70 [ath9k]
> <ffffffff8105e716>] warn_slowpath_fmt+0x46/0x50
> [<ffffffffa045b542>] ieee80211_can_queue_work.isra.7+0x32/0x40
>
> Other timers on 802.11 drivers, mac80211 and cfg80211
> should be groomed to verify the same is avoided.
>
> Reported-by: Parag Warudkar <parag.lkml@gmail.com>
> Tested-by: Parag Warudkar <parag.lkml@gmail.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>

John, please hold off on this.

  Luis
