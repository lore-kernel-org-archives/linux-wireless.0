Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945Ab3FKQHj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jun 2013 12:07:39 -0400
Date: Tue, 11 Jun 2013 18:09:50 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Jake Edge <jake@lwn.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFT/RFC 0/4] iwlegacy: workaround for firmware frame tx
 rejection
Message-ID: <20130611160949.GA1696@redhat.com> (sfid-20130611_180742_851356_16A9498C)
References: <1369311660-15378-1-git-send-email-sgruszka@redhat.com>
 <20130610143848.7afd5acc@chukar.edge2.net>
 <20130610214134.36085c4b@chukar.edge2.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130610214134.36085c4b@chukar.edge2.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 10, 2013 at 09:41:34PM -0600, Jake Edge wrote:
> On Mon, 10 Jun 2013 14:38:48 -0600 Jake Edge wrote:
> 
> > > Please apply it together with this mac80211 patch:
> > > http://marc.info/?l=linux-wireless&m=136879090123023&w=2 
> > > which I already posted and is queued to upstream. Not having
> > > it may cause troubles and influence negatively this set test.
> > 
> > I tried it on both 3.9 (without 4/4 since it doesn't have that
> > workaround in it) and on 3.10-rc4 and in both cases, i get the same
> > behavior: it tries to connect many times and fails, then eventually
> > connects (after like 20 tries from KDE network manager) ...
> 
> actually, i spoke too soon, the 3.10-rc4 has not been able to connect
> at all, after many hours of trying.  I manually went in and selected
> the other 2.4GHz SSID (rather than the 5GHz it had been trying) and it
> connected right away, fwiw ...

I found a bug in one patch, perhaps it is a reason of failure.
Please apply patch 5/4 from here:
http://marc.info/?l=linux-wireless&m=136947199729148&q=raw 
and patch from the end of this email, which fix the bug.

Could you also recheck that "mac80211: fix direct probe auth" patch
is applied, note that it is included in 3.10-rc5 as commit
6211dd12da609bc6893b9c3182630b494737ec4b

If it still will not help, please provide dmesg with debug messages
gathered by following instructions:

dmesg -c
modprobe -r iwl4965
modprobe iwl4965 debug=0x00800001
# wait about 30 seconds until first connection try fail
modprobe -r iwl4965
dmesg > dmesg.txt

Kernel has to be compiled with CONFIG_IWLEGACY_DEBUG=y to print debug
messages.

Thanks
Stanislaw

diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 2c77431..d287fd2 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -2818,7 +2818,7 @@ il4965_hdl_tx(struct il_priv *il, struct il_rx_buf *rxb)
 	 * note received beacon or other frame. We unblock queues in
 	 * il4965_pass_packet_to_mac80211 or in il_mac_bss_info_changed.
 	 */
-	if (unlikely(status == TX_STATUS_FAIL_PASSIVE_NO_RX) &&
+	if (unlikely((status & TX_STATUS_MSK) == TX_STATUS_FAIL_PASSIVE_NO_RX) &&
 	    il->iw_mode == NL80211_IFTYPE_STATION) {
 		il_stop_queues_by_reason(il, IL_STOP_REASON_PASSIVE);
 		D_INFO("Stopped queues - RX waiting on passive channel\n");

