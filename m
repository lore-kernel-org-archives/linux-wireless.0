Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f172.google.com ([209.85.212.172]:32858 "EHLO
	mail-vw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbZHSVm2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2009 17:42:28 -0400
Received: by vws2 with SMTP id 2so4013178vws.4
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2009 14:42:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b637ec0b0908191347k4695d528s37940731d3bffc1a@mail.gmail.com>
References: <b637ec0b0908191347k4695d528s37940731d3bffc1a@mail.gmail.com>
Date: Wed, 19 Aug 2009 17:42:29 -0400
Message-ID: <b6c5339f0908191442j6b5733f3rb28967060abdbace@mail.gmail.com>
Subject: Re: WARNING: at net/mac80211/mlme.c:2292
From: Bob Copeland <me@bobcopeland.com>
To: Fabio Comolli <fabio.comolli@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 19, 2009 at 4:47 PM, Fabio Comolli<fabio.comolli@gmail.com> wrote:
> Hi all.
> I see the following warning on an eeePC 900 (AR5001) running
> 2.6.31-rc6 after a suspend/resume cycle:
>
> [  292.377941] ------------[ cut here ]------------
> [  292.377976] WARNING: at net/mac80211/mlme.c:2292
> ieee80211_sta_work+0x89/0xc39 [mac80211]()

    if (WARN_ON(local->suspended)) ...

> [  292.378457]  [<c10199da>] ? __wake_up+0x1d/0x3d
> [  292.378466]  [<c102a529>] ? insert_work+0x8f/0x96
> [  292.378473]  [<c102a777>] ? queue_work_on+0x24/0x2b
> [  292.378480]  [<c102a7a5>] ? queue_work+0x1a/0x39
> [  292.378506]  [<f87e64dc>] ?
> ieee80211_mlme_notify_scan_completed+0x40/0x66 [mac80211]
> [  292.378532]  [<f87e3caa>] ? ieee80211_scan_completed+0x2ef/0x2fc [mac80211]

Looks like ieee80211_scan_completed() racing with suspend()?

> ieee80211_mesh_notify_scan_completed+0x4d/0x64 [mac80211]
> Aug 10 20:08:35 archeee kernel: [ 1440.841185]  [<f84860ce>] ?
> ieee80211_scan_completed+0x327/0x32f [mac80211]

Same here.

> The effect is that after the warning the interface is unusable until
> disabled and reenabled with the rfkill switch.

Interesting, I tried and didn't reproduce it, but I wasn't trying
while scanning before.

-- 
Bob Copeland %% www.bobcopeland.com
