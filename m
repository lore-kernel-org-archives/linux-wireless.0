Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:12672 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756299Ab2BGWPo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Feb 2012 17:15:44 -0500
Date: Tue, 7 Feb 2012 17:15:38 -0500
From: Pavel Roskin <proski@gnu.org>
To: Alfonso Fiore <alfonso.fiore@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Setting up an AP @ 5 GHz 802.11a - hostapd refuses [Could not
 select hw_mode and channel. (-1)]
Message-ID: <20120207171538.3336af0c@mj> (sfid-20120207_231548_803767_678DF44F)
In-Reply-To: <CAO=xpBGT7ovdSOV77AV6wpUcTDFYr0t8GEab474mVmZm0-BhVA@mail.gmail.com>
References: <CAO=xpBHy9p4yzhxaWTfG+jjw7f_OzbACmxxPnDL8AmLBS-JdwQ@mail.gmail.com>
	<CAO=xpBGT7ovdSOV77AV6wpUcTDFYr0t8GEab474mVmZm0-BhVA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 7 Feb 2012 09:20:53 +0100
Alfonso Fiore <alfonso.fiore@gmail.com> wrote:

> I also found out about ath_info
> http://madwifi-project.org/wiki/UserDocs/AthInfo and I rewrote my
> regdomain:
> ./ath_info -v -g 4:0 -w 0xeffd0000 regdomain 0x68

That may be dangerous.  Not all cards work with ath_info, and some can
be broken by it permanently.  It's much safer to adjust
ath_regd_sanitize() in drivers/net/wireless/ath/regd.c.

That way, you can play with different regdomain settings.

>                         * 2472 MHz [13] (20.0 dBm)
>                         * 2484 MHz [14] (disabled)
> 
> *** But why I still can't access any channel at 5 GHz? *** and what's
> the meaning of (disabled)? Is this due to a hardware limitation?

I believe it's a regdomain limitation.

> This is the situation at 5 Ghz:

>                         * 5260 MHz [52] (30.0 dBm) (passive scanning,
> no IBSS, radar detection)

I think it means it should be possible to use the band as long as DFS
is implemented, but it's not (in ath5k).

Try other regdomains, I think some should enable 5GHz unconditionally,
but please keep in mind that you may be breaking regulations.

-- 
Regards,
Pavel Roskin
