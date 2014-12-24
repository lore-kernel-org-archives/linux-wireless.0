Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:49657 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751366AbaLXRca (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Dec 2014 12:32:30 -0500
Date: Wed, 24 Dec 2014 19:32:27 +0200
From: Jouni Malinen <j@w1.fi>
To: Arend van Spriel <arend@broadcom.com>
Cc: "hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: hostapd and 11h support
Message-ID: <20141224173227.GA1969@w1.fi> (sfid-20141224_183233_721129_9887417D)
References: <549A8827.3070703@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <549A8827.3070703@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 24, 2014 at 10:32:23AM +0100, Arend van Spriel wrote:
> I am looking at 11h support in hostapd. The supplicant uses
> .start_dfs_cac() driver callback (resulting in
> NL08211_CMD_RADAR_DETECT) and basically the CAC logic is done in the
> supplicant. Now for our devices the entire radar detection and CAC
> state machine is built in firmware. So hostapd would just need to
> enable 11h in the driver/firmware.
> 
> I am considering a new offload feature flag, but not sure whether we
> would need to introduce a new nl80211 command. I am thinking we
> could just reuse .start_dfc_cac(). Because of the feature flag it
> would have a different meaning in the driver. Wanted to know your
> opinion on this approach before starting the work.

There's already one vendor-specific mechanism for supporting such
offloading.. Could you please check whether that would work for your
driver as well? Search for WPA_DRIVER_FLAGS_DFS_OFFLOAD to see how the
hostapd-based operations are skipped. This driver flag is currently set
based on a QCA vendor specific driver capability indication.

I'm not sure I understood why we would use .start_dfs_cac() for a driver
that takes care of CAC logic completely (i.e., I'd assume the driver
would be capable of handling this automatically without additional input
from user space). I don't really want to get N+1 different ways of doing
DFS offloading, so if you can either use as-is or build on top of the
existing design (without breaking it for other, obviously), that would
be preferred.

-- 
Jouni Malinen                                            PGP id EFC895FA
