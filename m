Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:28348 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755108AbcGHOEV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2016 10:04:21 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,
 1/6] ath9k: Correct TSF adjustment to align the beacon time correctly
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1467635845-32653-1-git-send-email-benjamin@sipsolutions.net>
To: Benjamin Berg <benjamin@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	"Felix Fietkau" <nbd@nbd.name>, <ath9k-devel@lists.ath9k.org>,
	Benjamin Berg <benjamin.berg@open-mesh.com>
Message-ID: <0baa0e2ea2244c589e28ac00b92fe252@euamsexm01a.eu.qualcomm.com> (sfid-20160708_160424_718982_CDC2A4D9)
Date: Fri, 8 Jul 2016 16:04:13 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Benjamin Berg <benjamin@sipsolutions.net> wrote:
> From: Benjamin Berg <benjamin.berg@open-mesh.com>
> 
> Beacons were not send out at (timestamp % beacon_time == 0) for interfaces
> other than the primary one. To send out beacons with the correct timestamp
> according to 10.1.3.2 of the 802.11 standard the tsf_adjustment has to be
> set to the negative time difference instead of positive. This way the
> later beacons get corrected to have a lower (and similar) timestamp with
> regard to the beacon from slot 0.
> 
> I am not aware about any issues that have been caused by this.
> 
> Signed-off-by: Benjamin Berg <benjamin.berg@open-mesh.com>

Thanks, 6 patches applied to ath-next branch of ath.git:

fa5106e1d793 ath9k: Correct TSF adjustment to align the beacon time correctly
9580cb889f35 ath9k: Handle channel context in get_/set_/reset_tsf
bec9a94bc4e2 ath9k: Use tsf offset helper in ath9k_hw_reset
7fde51227aed ath9k: Expose tsf_adjustment in mac80211 tsf getters and setters.
11b0ac2e0c1c ath9k: Remove some #defined constants to decrease verbosity
cfda2d8e2314 ath9k: Fix beacon configuration for addition/removal of interfaces

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9212535/

