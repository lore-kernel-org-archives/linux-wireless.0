Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:48135 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751773Ab0I2Fia (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Sep 2010 01:38:30 -0400
Date: Tue, 28 Sep 2010 22:38:26 -0700
From: Jouni Malinen <j@w1.fi>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH hostap] wpa_supplicant:  Support scanning single
 channel.
Message-ID: <20100929053826.GA8382@jm.kir.nu>
References: <1285632859-2014-1-git-send-email-greearb@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1285632859-2014-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 27, 2010 at 05:14:19PM -0700, greearb@candelatech.com wrote:
> This depends on patches recently submitted to the kernel.
> When the can_scan_one flag is true, the kernel will not
> scan other channels if at least one interface on this phy
> is already associated.

Could you please send wpa_supplicant patches to hostap@lists.shmoo.com
or at least cc me if you want to get this in. It is way too easy for me
to miss the patch if it does not get in the correct mail folder..
Though, in case of this particular change, I'm not going to be including
it before the matching change for nl80211 goes in into
wireless-testing.git, so a reminder at that point would be appreciated.

> --- a/wpa_supplicant/config.c
> +++ b/wpa_supplicant/config.c
> @@ -2143,6 +2143,7 @@ struct wpa_config * wpa_config_alloc_empty(const char *ctrl_interface,
> +	config->can_scan_one = DEFAULT_CAN_SCAN_ONE;

This doesn't sound like a parameter that should be a global one in
wpa_supplicant. Doesn't it depend on what you are doing whether it is
acceptable to scan only a single channel? For example, in P2P Search
scans, all the social channels must be scanned and a global override
here does not seem to make much sense.

-- 
Jouni Malinen                                            PGP id EFC895FA
