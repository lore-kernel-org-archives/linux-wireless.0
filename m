Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:32320 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbaLXJcZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Dec 2014 04:32:25 -0500
Message-ID: <549A8827.3070703@broadcom.com> (sfid-20141224_103236_213084_5C7815D3)
Date: Wed, 24 Dec 2014 10:32:23 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Jouni Malinen <j@w1.fi>
CC: "hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: hostapd and 11h support
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jouni,

I am looking at 11h support in hostapd. The supplicant uses 
.start_dfs_cac() driver callback (resulting in NL08211_CMD_RADAR_DETECT) 
and basically the CAC logic is done in the supplicant. Now for our 
devices the entire radar detection and CAC state machine is built in 
firmware. So hostapd would just need to enable 11h in the driver/firmware.

I am considering a new offload feature flag, but not sure whether we 
would need to introduce a new nl80211 command. I am thinking we could 
just reuse .start_dfc_cac(). Because of the feature flag it would have a 
different meaning in the driver. Wanted to know your opinion on this 
approach before starting the work.

Regards,
Arend
