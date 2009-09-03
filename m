Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:36442 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753911AbZICSqi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Sep 2009 14:46:38 -0400
Date: Thu, 3 Sep 2009 21:44:59 +0300
From: Jouni Malinen <j@w1.fi>
To: Zhu Yi <yi.zhu@intel.com>
Cc: hostap@lists.shmoo.com, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH V2] nl80211 connect API support
Message-ID: <20090903184459.GA11492@jm.kir.nu>
References: <1250489084-13368-1-git-send-email-yi.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1250489084-13368-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 17, 2009 at 02:04:44PM +0800, Zhu Yi wrote:
> nl80211 driver connect API support.

> V2: Use auth/assoc as the default operations if they are supported.

Thanks!

It looks like there is still some misunderstanding regarding the SME
design in wpa_supplicant. It was designed to be used when the driver
does provide the separate authentication and association commands. There
is not much point in trying to convert the SME implementation to work
with the case where connect command is used. It is just duplicating
functionality that is already present in the old associate
(pre-auth/assoc SME case) operation.

I took about half of the patch, i.e., the changes to add driver
capability query, connect events, and actual connect/disconnect
functions. Instead of the changes in sme.c and driver interface, I glued
the new functions together within driver_nl80211.c since rest of
wpa_supplicant do not really need to (nor should) know about yet another
driver operation for connecting in a single step. The driver
capabilities are used to select which functions to use within
driver_nl80211.c. Since the WPA_DRIVER_FLAGS_SME is now set based on
driver capabilities, core wpa_supplicant code is able to switch between
the SME (separate auth/assoc calls) and single associate ("connect" in
nl80211 terminology) call.

I did not go through the details of sme_connect() function, but I would
expect that it was providing the same conversion from configuration to
driver parameters that was already done in wpa_supplicant.c. If there
was something else there, it should be added to the version in
wpa_supplicant.c instead of introducing a new, duplicated function.

It looks like the end result works fine at least with mac80211_hwsim
(with hardcoded driver capability detection that does not find the
separate authenticate command). This version is now in my git repository
and it would be good if you could verify that it works with your driver,
too.

-- 
Jouni Malinen                                            PGP id EFC895FA
