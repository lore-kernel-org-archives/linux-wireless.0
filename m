Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:59964 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750875AbZHETFL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2009 15:05:11 -0400
Message-ID: <4A79D7E5.1080604@gmx.de>
Date: Wed, 05 Aug 2009 21:05:09 +0200
From: Joerg Albert <jal2@gmx.de>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ar9170: cleanup of bss_info_changed and beacon config
References: <4A78CE98.70903@gmx.de> <200908050404.47371.chunkeey@web.de>
In-Reply-To: <200908050404.47371.chunkeey@web.de>
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/05/2009 04:04 AM, Christian Lamparter wrote:

> no signed/cc here?

oops, forgot it. Seems like both patches miss some context lines at the end, too.

> > ...
> the beacon timer isn't exclusively used to notify the driver when its 
> time for a new beacon... The STA mode uses the same _timer_
> in reverse to wait for the next beacon form the assoc. AP.

> that said: It does not look like the firmware implements anything
> in this direction... But this is a clearly MAC register and there
> could be something in the silicon which does something useful with
> this information.

I wasn't aware of this usage within STA mode.

> so, to be on the safe side: why not preserve the old behavior for the
> STA mode as well and simply tell the hardware about dtim & beacon interval?

ar9170_set_beacon_timers() uses the beacon interval only if for AP mode, dtim is left in STA mode.

> The only remaining question is where to disabled the timer for STA.
> (which is in some way relevant to: [PATCH 2/2] because previously,
>  these timers were always disabled by remove_interface.)
> 
> I think the best place is in ar9170_op_bss_info_changed:
>        if (changed & BSS_CHANGED_ASSOC) {
> 
> just when bss_conf->assoc gets "0".

Yes. IMHO also enable on bss_conf->assoc == 1.

I'll look into another version of both patches after running some tests in STA mode.


Regards,
Joerg.
