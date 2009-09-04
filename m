Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:4854 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932476AbZIDDVD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Sep 2009 23:21:03 -0400
Subject: Re: [PATCH V2] nl80211 connect API support
From: Zhu Yi <yi.zhu@intel.com>
To: Jouni Malinen <j@w1.fi>
Cc: "hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Samuel Ortiz <sameo@linux.intel.com>
In-Reply-To: <20090903184459.GA11492@jm.kir.nu>
References: <1250489084-13368-1-git-send-email-yi.zhu@intel.com>
	 <20090903184459.GA11492@jm.kir.nu>
Content-Type: text/plain
Date: Fri, 04 Sep 2009 11:21:03 +0800
Message-Id: <1252034463.5650.8.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-09-04 at 02:44 +0800, Jouni Malinen wrote:
> It looks like there is still some misunderstanding regarding the SME
> design in wpa_supplicant. It was designed to be used when the driver
> does provide the separate authentication and association commands. There
> is not much point in trying to convert the SME implementation to work
> with the case where connect command is used. It is just duplicating
> functionality that is already present in the old associate
> (pre-auth/assoc SME case) operation.

I searched WPA_DRIVER_FLAGS_SME is set only by driver_nl80211. So I
thought you might also want the connect API more visible for the whole
wpa_supplicant. But it turns I was wrong.

> I took about half of the patch, i.e., the changes to add driver
> capability query, connect events, and actual connect/disconnect
> functions. Instead of the changes in sme.c and driver interface, I glued
> the new functions together within driver_nl80211.c since rest of
> wpa_supplicant do not really need to (nor should) know about yet another
> driver operation for connecting in a single step. The driver
> capabilities are used to select which functions to use within
> driver_nl80211.c. Since the WPA_DRIVER_FLAGS_SME is now set based on
> driver capabilities, core wpa_supplicant code is able to switch between
> the SME (separate auth/assoc calls) and single associate ("connect" in
> nl80211 terminology) call.
> 
> I did not go through the details of sme_connect() function, but I would
> expect that it was providing the same conversion from configuration to
> driver parameters that was already done in wpa_supplicant.c. If there
> was something else there, it should be added to the version in
> wpa_supplicant.c instead of introducing a new, duplicated function.
> 
> It looks like the end result works fine at least with mac80211_hwsim
> (with hardcoded driver capability detection that does not find the
> separate authenticate command). This version is now in my git repository
> and it would be good if you could verify that it works with your driver,
> too.

I confirm it also works for iwmc3200wifi. Tested for WEP, PSK and EAP.

Thanks,
-yi

