Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:44205 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974Ab0LGEMg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Dec 2010 23:12:36 -0500
Received: by qwa26 with SMTP id 26so69778qwa.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Dec 2010 20:12:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <19709.45926.38551.25130@gargle.gargle.HOWL>
References: <19701.62091.644444.121284@gargle.gargle.HOWL> <20101202193024.GC2358@tuxdriver.com>
 <19704.23185.565826.890275@gargle.gargle.HOWL> <AANLkTinPLPoAHxauaXj8Sj=zjyHQPyxO0ku342ersZQ4@mail.gmail.com>
 <19709.45926.38551.25130@gargle.gargle.HOWL>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 6 Dec 2010 20:12:15 -0800
Message-ID: <AANLkTinNF2dnacLof_knM3OAf6ADCCPsb8DO1VE6c31U@mail.gmail.com>
Subject: Re: [PATCH 2/2] ath9k_htc: Fix suspend/resume
To: Sujith <m.sujith@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 6, 2010 at 8:09 PM, Sujith <m.sujith@gmail.com> wrote:
> Luis R. Rodriguez wrote:
>> Just curious, if you revert this patch and apply the ones I just
>> posted, does it fix it, or is this patch required either way?
>
> Well, I don't see this patch in -testing, -next-2.6 or -2.6.
> Maybe Linville overlooked this patch.
>
> Applying 4/5 and 5/5 from your series seems to fix the issue though.
> I am able to suspend/resume without hiccups with UB95.
>
> But, I think this is purely an ath9k issue, mac80211 is probably right in
> assuming that only devices that have been issued ~IEEE80211_CONF_IDLE
> would have their radios enabled anyway.
>
> ath9k doesn't differentiate between init/start and enables the radio
> (setting it to AWAKE mode) in the initialization sequence.
> Why should mac80211 issue a CONF_IDLE notification when the device
> was never powered up .. ?

That's the thing, the device was powered up, lifted from idle, but we
never got notified we are back in idle, since we stop the device but
never issue the idle call since the open_count was already 0 after a
device stop.

  Luis
