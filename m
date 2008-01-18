Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:37054 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbYARMzo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2008 07:55:44 -0500
Received: by ug-out-1314.google.com with SMTP id z38so466310ugc.16
        for <linux-wireless@vger.kernel.org>; Fri, 18 Jan 2008 04:55:42 -0800 (PST)
Message-ID: <4790A1CA.2010004@gmail.com> (sfid-20080118_125547_152207_ED598704)
Date: Fri, 18 Jan 2008 13:55:38 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Bruno Randolf <bruno@thinktube.com>
CC: ath5k-devel@lists.ath5k.org, mcgrof@gmail.com, mickflemm@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 1/4] ath5k: debug level improvements
References: <20080118125018.6342.94435.stgit@one>
In-Reply-To: <20080118125018.6342.94435.stgit@one>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/18/2008 01:50 PM, Bruno Randolf wrote:
> * use only one debug level for beacon debugging: unify ATH5K_DEBUG_BEACON and
> ATH5K_DEBUG_BEACON_PROC
> 
> * remove debug level ATH5K_DEBUG_FATAL. doesn't make sense as a debug level -
> if it's fatal it should be logged as an error.
> 
> * fancier printing of debug levels. cat /debugfs/ath5k/phy0/debug
> 
> * allow debug levels to be changed by echoing their name into
> /debugfs/ath5k/phy0/debug. this will toggle the state, when it was off it will
> be turned on and vice versa.
> 
> drivers/net/wireless/ath5k/base.c:      Changes-licensed-under: 3-Clause-BSD
> drivers/net/wireless/ath5k/debug.c:     Changes-licensed-under: GPL
> drivers/net/wireless/ath5k/debug.h:     Changes-licensed-under: GPL
> 
> Signed-off-by: Bruno Randolf <bruno@thinktube.com>
> ---
[...]
> +#define TOGGLE_BIT(_x, _m) (_x) = (_x) & (_m) ? (_x) & ~(_m) : (_x) | (_m)

simple XOR :)?

_x ^= _m;
