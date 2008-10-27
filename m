Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:36759 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664AbYJ0UCO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2008 16:02:14 -0400
Subject: Re: 2.6.28-rc regression: Can't stop Rx DMA
From: reinette chatre <reinette.chatre@intel.com>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Tomas Winkler <tomasw@gmail.com>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20081019075916.GA12904@isilmar.linta.de>
References: <20081018231046.GA10977@isilmar.linta.de>
	 <1ba2fa240810181630t781468dbi23b103e656f64153@mail.gmail.com>
	 <20081019075916.GA12904@isilmar.linta.de>
Content-Type: text/plain
Date: Mon, 27 Oct 2008 13:02:35 -0700
Message-Id: <1225137755.1115.121.camel@rc-desk> (sfid-20081027_210223_077663_28D15543)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2008-10-19 at 00:59 -0700, Dominik Brodowski wrote:
> On Sun, Oct 19, 2008 at 01:30:50AM +0200, Tomas Winkler wrote:
> > On Sun, Oct 19, 2008 at 1:10 AM, Dominik Brodowski
> > > [   37.340901] iwl3945: Microcode SW error detected.  Restarting 0x82000008.
> > > [   37.340944] iwl3945: Error Reply type 0x00000005 cmd REPLY_SCAN_CMD (0x80) seq 0x4413 ser 0x0000004B
> > > [   37.342349] iwl3945: Can't stop Rx DMA.
> > >
> > > The iwlwifi-3945-1.ucode is the one shipped with Ubuntu's 2.6.24-21-generic
> > > kernel sources (md5sum: 26d10014b09439dc5a8573c2a6f85b0a ). And, as
> > > mentioned in the subject, 2.6.27 or 2.6.26 work perfectly fine.
> >
> > I think you need new uCode, the API has changed to support stealth APs
> > .... I believe there was some misscommunication...
> 
> Thanks for the hint -- indeed, the newest uCode works both with 2.6.26 and
> current git... so the uCode is backwards compatible, but the kernel code is
> not. Should the uCode be named iwlwifi-3945-2.ucode therefore, to notify the
> users that they need something newer? Or can the kernel code be made to work
> with the old uCode again?

Instead of new ucode ... could you please try this patch ?

Thank you

diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c
b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 6c8ac3a..61c9a40 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -709,7 +709,7 @@ static void iwl_bg_request_scan(struct work_struct
*data)
 	u32 tx_ant;
 	u16 cmd_len;
 	enum ieee80211_band band;
-	u8 n_probes = 2;
+	u8 n_probes = 0;
 	u8 rx_chain = 0x7; /* bitmap: ABC chains */
 
 	conf = ieee80211_get_hw_conf(priv->hw);


