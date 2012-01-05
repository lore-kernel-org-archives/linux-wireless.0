Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53890 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755018Ab2AELjl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jan 2012 06:39:41 -0500
Date: Thu, 5 Jan 2012 12:39:40 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Mike Edenfield <kutulu@kutulu.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: iwl3945: disassociating from current AP on rescan with kernels >
 3.0
Message-ID: <20120105113939.GC2222@redhat.com> (sfid-20120105_123945_484599_3F0C84C3)
References: <012e01ccc67b$bfe90be0$3fbb23a0$@kutulu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <012e01ccc67b$bfe90be0$3fbb23a0$@kutulu.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 29, 2011 at 05:46:48PM -0500, Mike Edenfield wrote:
> After upgrading to a v3.0 kernel, my Intel wireless adapter stopped working
> when used with any UI-based wpa_supplicant front-end that does periodic
> scans, such as NetworkManager and wicd. Whenever the software asks for an AP
> scan, the device disconnects from its current AP and blacklists it, making
> it impossible to reconnect until I kill wpa_supplicant. If I manually
> configure wpa_supplicant and launch it directly, the adapter stays
> associated with the AP properly.
> 
> I was able to reproduct this behavior with kernel version 3.0.4, 3.1.4, and
> 3.1.5, but downgrading to 2.6.39 or lower solves the problem. I haven't seen
> any other reports of this problem specific to 3.x -- did I miss some other
> step I need to do when upgrading?

Are you sure this is 2.6.39 -> 3.0 regression. There are not many
changes in iwlegacy driver between these

$ git log v2.6.39..v3.0 --oneline --no-merges -- drivers/net/wireless/iwlegacy/
51e6525 iwlegacy: fix channel switch locking
51892db iwl4965: set tx power after rxon_assoc
dfe2158 iwl4965: correctly validate temperature value
aac11c1 iwl4965: fix 5GHz operation
8220ba3 iwlegacy: Silence DEBUG_STRICT_USER_COPY_CHECKS=y warning
2245090 iwlegacy: remove sync_cmd_mutex
28a6e57 iwlegacy: more priv->mutex serialization
81e6326 iwlegacy: fix enqueue hcmd race conditions
93fd74e iwlegacy: comment typo fix diable -> disable
7a55237 iwlegacy: remove scan_tx_antennas
5855c7d iwlegacy: remove unneeded __packed
8eb0ac7 iwlegacy: remove unneeded disable_hw_scan check
3e41de8 iwlegacy: simplify init geos
a078a1f iwlegacy: enable only rfkill interrupt when device is down
ab42b40 iwlegacy: remove duplicate initialization in iwl4956_down()
85ee7a1 treewide: cleanup continuations and remove logging message whitespace
0477ad7 iwlegacy: use pci_dev->revision
a22e93f iwl4965: drop a lone pr_err()

and none of it looks suspicious.

Problem looks more like software scanning issue, which we enable
by default on 2.6.39. Can you check if disable_hw_scan=0 module
parameter helps?

Thanks
Stanislaw
