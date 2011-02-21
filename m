Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38849 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261Ab1BURph convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Feb 2011 12:45:37 -0500
Received: by iwn8 with SMTP id 8so2128580iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 21 Feb 2011 09:45:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1297877604-8084-1-git-send-email-rmanoharan@atheros.com>
References: <1297877604-8084-1-git-send-email-rmanoharan@atheros.com>
Date: Mon, 21 Feb 2011 18:45:36 +0100
Message-ID: <AANLkTi=Kpib=BbwmTpOREinsN7mOjKEVs_Z5Fueftsm8@mail.gmail.com>
Subject: Re: [RFC/RFT] ath9k: configure opmode sepecific beacon timers dynamically
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 16, 2011 at 6:33 PM, Rajkumar Manoharan
<rmanoharan@atheros.com> wrote:
> Current ath9k code does not handle beacon timers on opmode
> specific. One such example is that a STA beacon config overwrites
> already configured AP vif's beacon timers during scan.
>
> So select a vif as primary based on opmode and configure that
> vif's bss and beacon config in hw and update the primary vif
> on opmode change, interface up/down and bss info change.
>
> And also while moving back to single STA vif from multi STA vifs,
> power save is enabled and hw has to be reconfigured with proper
> beacon and bssid. Otherwise connection poll will be triggered
> so frequently due to beacon loss.

It's really nice to see multi-vif beacons get some attention, thanks. :)

Just one thought: Is the "opmode" concept really necessary? It's been
discussed previously and I think the conclusion is often that it would
be better to iterate all the current vifs and do something logical
based on that instead of setting an "opmode".

Do you think it would be possible to remove the "opmode" construct
from your patch? Do you think it would be an improvement?

Best regards,

Björn
