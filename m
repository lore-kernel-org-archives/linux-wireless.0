Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53569 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724Ab1JTNw6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Oct 2011 09:52:58 -0400
Received: by gyb13 with SMTP id 13so2798041gyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Oct 2011 06:52:57 -0700 (PDT)
MIME-Version: 1.0
From: =?ISO-8859-1?Q?Andr=E9s_Garc=EDa_Saavedra?=
	<andres.garcia.saavedra@gmail.com>
Date: Thu, 20 Oct 2011 15:52:37 +0200
Message-ID: <CADxqDgEmJ_+=WcmvYRV_H6t4Ac_Ouvf9yaB1ecU65-Ws=FZPaA@mail.gmail.com> (sfid-20111020_155301_142746_FF4F482E)
Subject: Commanding sleep/awake from mac80211
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I am testing a custom algorithm whereby I'd like to adaptively command
a STA to sleep/awake. Of course I would like to do so in the higher
level possible (for simplicity). The following is a sort of a summary
of my conclusions on the "state-of-art" on the implementation of such
a thing. I would like to ask you whether i am totally misleaded here.
Thanks in advance!


* mac80211: I can see in mac80211 that the function
ap_sta_ps_start/end() is defined to notify drivers of such transitions
using drv_sta_notify(STA_NOTIFY_AWAKE/SLEEP) callback. This looked
promising but... reading ath5k/ath9k/b43 driver codes, the atheros
ones do not implement these notification handlers at all, and b43 does
not do anything important eventually with them.

So, my guess is that actually the drivers themselves are the ones in
commanding the powersaving mode transitions awake/sleep regardless of
what mac80211 "could say".

* ath5k: seems to not command HW to sleep ever. (Only implemented the
"hw on hold" which is not used within ath5k).
* ath9k: Indeed it schedules sleep/awake timers. This way, it  is
ath9k decision regardless what mac80211 say.
* b43: seems to not command HW to sleep ever...

Again, I'd appreciate if someone would point me out whether my
conclusions are correct.

Thanks!
