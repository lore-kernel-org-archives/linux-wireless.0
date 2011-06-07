Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755103Ab1FGOyr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jun 2011 10:54:47 -0400
Date: Tue, 7 Jun 2011 16:54:35 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Bernhard Schmidt <bschmidt@freebsd.org>
Cc: Paul Bolle <pebolle@tiscali.nl>, linux-wireless@vger.kernel.org
Subject: Re: [iwl4965] Microcode SW error detected
Message-ID: <20110607145435.GA5179@redhat.com> (sfid-20110607_165454_365732_61364772)
References: <1306151106.2066.60.camel@x61.thuisdomein>
 <201106070832.49048.bschmidt@freebsd.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201106070832.49048.bschmidt@freebsd.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 07, 2011 at 08:32:48AM +0200, Bernhard Schmidt wrote:
> On Monday, May 23, 2011 13:45:06 Paul Bolle wrote:
> > 0) Since I started running (release candidates of) kernel v2.6.39 errors
> > like these show up in my log, every now and then:
> > 
> > iwl4965 0000:03:00.0: Microcode SW error detected.  Restarting 0x82000000.
> > iwl4965 0000:03:00.0: Loaded firmware version: 228.61.2.24
> > iwl4965 0000:03:00.0: Start IWL Error Log Dump:
> > iwl4965 0000:03:00.0: Status: 0x000213E4, count: 5
> > iwl4965 0000:03:00.0: Desc                                  Time       data1      data2      line
> > iwl4965 0000:03:00.0: FH_ERROR                     (0x000C) 1821446380 0x00000008 0x03130000 208 
> 
> On a unrelated site note, I have a case where I can trigger a
> FH_ERROR at this line 100% reliably. Not on Linux though..
> While being associated to a 5GHz BSS doing a scan chan by chan
> (instead of all at once) is enough to trigger it.
That could be useful hint, we do not scan chan by chan, but we
have thing called "plcp check health", which "restart radio"
by requesting one channel scan. So perhaps disabling that could
help.

> A workaround
> is too not send probe requests for 2GHz channels at 1Mbps (CCK
> flag) but at 6Mbps instead.
> 
> Maybe this bug report [1] is related too?
> 
> [1] http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=1965

Hard to tell.

Thanks
Stanislaw

diff --git a/drivers/net/wireless/iwlegacy/iwl-rx.c b/drivers/net/wireless/iwlegacy/iwl-rx.c
index 654cf23..6062da0 100644
--- a/drivers/net/wireless/iwlegacy/iwl-rx.c
+++ b/drivers/net/wireless/iwlegacy/iwl-rx.c
@@ -230,6 +230,8 @@ EXPORT_SYMBOL(iwl_legacy_rx_spectrum_measure_notif);
 void iwl_legacy_recover_from_statistics(struct iwl_priv *priv,
 				struct iwl_rx_packet *pkt)
 {
+	return;
+
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 	if (iwl_legacy_is_any_associated(priv)) {
