Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f115.google.com ([209.85.222.115]:38033 "EHLO
	mail-pz0-f115.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598AbZEOHLg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2009 03:11:36 -0400
Received: by pzk13 with SMTP id 13so927386pzk.33
        for <linux-wireless@vger.kernel.org>; Fri, 15 May 2009 00:11:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1242362919-9788-1-git-send-email-lrodriguez@atheros.com>
References: <1242362919-9788-1-git-send-email-lrodriguez@atheros.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 15 May 2009 00:11:18 -0700
Message-ID: <43e72e890905150011g2d291806i5c6e590b7fe5e6e0@mail.gmail.com>
Subject: Re: [PATCH] mac80211: fix some unforgotten items on suspend
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 14, 2009 at 9:48 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> We forgot to clear items which stuffed things into the our
> station's workqueues. In particular we forgot to deal with
> the dynamic_ps_timer, ifmgd->timer, ifmgd->chswitch_timer.
>
> While at it we go ahead and add a warning in ieee80211_sta_work()
> if its run while the suspend->resume cycle is in effect. This
> should not happen and if it does it would indicate there is
> a bug lurking in either mac80211 or mac80211 drivers.
>
> With this now wpa_supplicant doesn't blink when I go to suspend
> and resume where as before there where issues with any of the items
> in the workqueue running during the suspend->resume cycle. This
> caused a lot of incorrect assumptions and would at times bring
> back the device in incoherent, but mostly recoverable, states.
>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Please hold on this -- with ath9k with legacy APs I get crap
throughput after pm-suspend if it disassociates. Even worse, with 11n
APs if it disassociates I get a crash. I haven't seen the oops yet...
This is with ath9k PS patches as well but also with the mac80211
debugfs patches pending, HT pending patches (debugfs and HT paches
should have no effect), and the WoW patches (these should have not
have an effect)

  Luis
