Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.179]:18899 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899AbXK0BTi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 20:19:38 -0500
Received: by py-out-1112.google.com with SMTP id u77so1832294pyb
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2007 17:19:37 -0800 (PST)
Message-ID: <43e72e890711261719p3bd3e420u858b3437be24781c@mail.gmail.com> (sfid-20071127_011941_957466_15D6DB44)
Date: Mon, 26 Nov 2007 20:19:37 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Bruno Randolf" <bruno@thinktube.com>
Subject: Re: [PATCH 1/1] ath5k: more consistent debugging
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com
In-Reply-To: <1196077433-12358-2-git-send-email-bruno@thinktube.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1196077433-12358-1-git-send-email-bruno@thinktube.com>
	 <1196077433-12358-2-git-send-email-bruno@thinktube.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Nov 26, 2007 6:43 AM, Bruno Randolf <bruno@thinktube.com> wrote:
> * move all debugging functions to new files debug.c and debug.h.
>
> * consistently use ATH5K_DEBUG instead of AR_DEBUG and AR5K_DEBUG defines.
> ATH5K_DEBUG can be set from outside the Makefile via KCFLAGS.
>
> * rename DPRINTF to ATH5K_DBG to be consistent with the other logging
> functions.  ATH5K_DBG honors the debug level set on module load or by debugfs
> and is limited by net_ratelimit().  another define ATH5K_DBG_UNLIMIT can be
> used specifically when we do not want the output to be rate limited.
>
> * move all instances where the debugging output was controlled by additional
> defines (ATH_DEBUG_MODES, ATH_DUMP_SKB) to use the debug level too.
>
> * make ATH5K_TRACE honor the debug level as well.
>
> * remove ath5k_hw_dump_state().
>
> * rename all debugging functions to ath5k_debug_xxx. these are static inline {}
> when ATH5K_DEBUG is 0.
>
> * make ath5k_debug_dump_skb distinguish between RX and TX, so we can choose
> wether we want to see RX or TX packets. also prepend the "phyX" name.
>
> * added debugfs entry (ath5k/phyX/debug) to control the debug level for each
> device.
>
> * add kerneldoc for debugging levels.
>
> base.[ch]:
> Changes-licensed-under: 3-clause-BSD
>
> hw.c, ath5k.h, phy.c:
> Changes-licensed-under: ISC
>
> debug.[ch]:
> Changes-licensed-under: GPL

Very nice, I have reviewed the patch quickly and this time it seems to
address the license issues correctly provided your intention was to
GPL your contributions. Just going to give this a spin and review
debug.[ch] a bit more, I'll try to do it tonight.

  Luis
