Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25403 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752511Ab2AYN2A (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jan 2012 08:28:00 -0500
Date: Wed, 25 Jan 2012 14:27:56 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Maxime Bizon <mbizon@freebox.fr>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [iwlegacy/4965] Microcode SW error detected on 3.3rc1
Message-ID: <20120125132755.GA4595@redhat.com> (sfid-20120125_142805_783867_12C54B6C)
References: <1327441910.21837.94.camel@sakura.staff.proxad.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="HcAYCG3uE/tztfnV"
In-Reply-To: <1327441910.21837.94.camel@sakura.staff.proxad.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

On Tue, Jan 24, 2012 at 10:51:50PM +0100, Maxime Bizon wrote:
> I can reliably reproduce this on 3.3rc1 (build from ubuntu ppa), it was
> present on 3.2 too.
What was the latest working kernel you know about?

> [ 1053.054034] iwl4965 0000:03:00.0: Microcode SW error detected.  Restarting 0x2000000.
> [ 1053.054047] iwl4965 0000:03:00.0: Loaded firmware version: 228.61.2.24
> [ 1053.054069] iwl4965 0000:03:00.0: Start IWL Error Log Dump:
> [ 1053.054077] iwl4965 0000:03:00.0: Status: 0x000213E4, count: 5
> [ 1053.054239] iwl4965 0000:03:00.0: Desc                                  Time       data1      data2      line
> [ 1053.054250] iwl4965 0000:03:00.0: NMI_INTERRUPT_WDG            (0x0004) 0643296734 0x00000002 0x07430000 208
> [ 1053.054258] iwl4965 0000:03:00.0: pc      blink1  blink2  ilink1  ilink2  hcmd
> [ 1053.054266] iwl4965 0000:03:00.0: 0x0046C 0x08370 0x004C2 0x006DE 0x018B8 0x7DB001C
[snip]
> Single TCP transfer (AP -> STA) on a 802.11n/HT20 AP 2.4G
> 
> Once rate reaches about 7MB/s, then transfer stalls for 1 second and
> starts again, I get one of this about every minute.
Ehh, looks like scaning problem ..., you can probably workaround it 
by disable_hw_scan=1 module parameter, or setup NetworkManager to
configure constant BSSID (AP MAC address) in your wireless
network parameters in NM, hence stop NM requesting periodic scan.

I'm also attaching patch for test.

> Any log I could enable to help you ?

Yes (if patch does not help) plese configure syslog to log
debug messages into /var/log/kernel (some hint here:
https://fedoraproject.org/wiki/DebugWireless), restart
syslog, then do:

modprobe -r iwl4965
echo > /var/log/kernel
modprobe iwl4965 debug=0x47ffffff
wait minute or two for microcode error.
modprobe -r iwl4965

assure micocode error is in the log, and post me compressed
file. If it will be too big, you can wip out data starting
from microcode error to end of the file.

Thanks
Stanislaw

--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="iwl4965_th_disabled.patch"

diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 1667232..e4ca7b4 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -962,7 +962,7 @@ il4965_request_scan(struct il_priv *il, struct ieee80211_vif *vif)
 	 * here instead of IL_GOOD_CRC_TH_DISABLED.
 	 */
 	scan->good_CRC_th =
-	    is_active ? IL_GOOD_CRC_TH_DEFAULT : IL_GOOD_CRC_TH_NEVER;
+	    is_active ? IL_GOOD_CRC_TH_DEFAULT : IL_GOOD_CRC_TH_DISABLED;
 
 	band = il->scan_band;
 

--HcAYCG3uE/tztfnV--
