Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:40734 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751921Ab1IZLbH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Sep 2011 07:31:07 -0400
Date: Mon, 26 Sep 2011 14:30:59 +0300
From: Jouni Malinen <j@w1.fi>
To: Vivek Natarajan <nataraja@qca.qualcomm.com>
Cc: hostap@lists.shmoo.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wpa_supplicant: Modify bgscan based roaming behaviour.
Message-ID: <20110926113059.GA12346@jm.kir.nu> (sfid-20110926_133111_912170_EE1A5F9E)
References: <1314608205-4995-1-git-send-email-nataraja@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1314608205-4995-1-git-send-email-nataraja@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 29, 2011 at 02:26:45PM +0530, Vivek Natarajan wrote:
> Cancel background scan based roaming behavior if the driver
> is capable of handling roaming in the firmware. For fullmac
> drivers like ath6kl, the roaming logic is handled in the
> firmware and for supplicant to initiate roam, the station
> has to disconnect completely and then reconnect with the
> new AP which takes a longer time without preauth.
> 
> Currently, if the supplicant also tries to roam, all requests
> are rejected by cfg80211 resulting in a spam of log.

I applied the driver.h and driver_nl80211.c parts to get the new driver
flag for this, but the change to events.c did not look correct, so I
left that out. wpa_supplicant will need quite a bit more changes to be
able to work in ap_scan=2 like way in the default ap_scan=1 mode when
the driver indicates this BSS-selection-in-driver(firmware) capability.
Those changes will take care of not even getting to the
wpa_supplicant_connect(), so there should be no need to modify it in the
way done in this patch.

-- 
Jouni Malinen                                            PGP id EFC895FA
