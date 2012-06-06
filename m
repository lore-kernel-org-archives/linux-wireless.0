Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:35679 "EHLO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751712Ab2FFRHo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 13:07:44 -0400
Received: by lbbgj10 with SMTP id gj10so6510340lbb.37
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jun 2012 10:07:34 -0700 (PDT)
Message-ID: <1339002452.7078.40.camel@cumari.coelho.fi> (sfid-20120606_190747_426868_B6D886D0)
Subject: Re: [PATCH 0/5] TKIP/GEM support for 18xx
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 06 Jun 2012 20:07:32 +0300
In-Reply-To: <1337316400-23875-1-git-send-email-arik@wizery.com>
References: <1337316400-23875-1-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-05-18 at 07:46 +0300, Arik Nemtsov wrote:
> TKIP extra padding is not required for 18xx cards. Turn this into a
> quirk for 12xx cards only.
> 18xx cards must have their Tx spare-blocks updated before any vif can
> transmit GEM or TKIP encrypted packets. When spare blocks are updated,
> we must make sure no Tx frame reaches the FW. Otherwise our Tx block
> accounting will be out of sync.
> Introduce new internal Tx queue wake/stop APIs to allow us to safely
> stop the queues for multiple reasons (similar to mac80211). Use the
> new APIs to prevent all Tx during the change of spare blocks.
> 
> Arik Nemtsov (5):
>   wlcore/wl12xx/wl18xx: introduce quirk to remove TKIP header space
>   wlcore/wl12xx/wl18xx: handle spare blocks spacial cases per arch
>   wlcore: add stop reason bitmap for waking/starting queues
>   wlcore: stop queues on Tx flush
>   wlcore/wl12xx/wl18xx: implement op_set_key per HW arch

Applied this set and pushed.  Thanks, dude!

--
Luca.

