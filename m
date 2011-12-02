Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36050 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab1LBUTd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Dec 2011 15:19:33 -0500
Subject: Re: iwlwifi: kernel panic if try to open tid with large index (>=8)
From: Johannes Berg <johannes@sipsolutions.net>
To: wwguy <wey-yi.w.guy@intel.com>
Cc: Nikolay Martynov <mar.kolya@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1322838068.24199.0.camel@wwguy-ubuntu>
References: <CALGY4fvH5EbBm1oSBHsmXw5r5yfWMQ4yJyVyBx3y70FOEVeT6A@mail.gmail.com>
	 (sfid-20111202_052910_037002_B91C34E9)  <1322817100.4162.0.camel@jlt3.sipsolutions.net>
	 <1322838068.24199.0.camel@wwguy-ubuntu>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Dec 2011 21:19:29 +0100
Message-ID: <1322857169.4124.5.camel@jlt3.sipsolutions.net> (sfid-20111202_211937_415998_7B9C8CAE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-12-02 at 07:01 -0800, wwguy wrote:
> On Fri, 2011-12-02 at 01:11 -0800, Johannes Berg wrote:
> > On Thu, 2011-12-01 at 23:29 -0500, Nikolay Martynov wrote:
> > > Hi.
> > > 
> > >   I have an intel 5300 card running on latest compat-wireless.
> > >   If I do:
> > > echo "tx start 8" >
> > > /sys/kernel/debug/ieee80211/phy0/netdev\:wlan1/stations/XX\:XX\:XX\:XX\:XX\:XX/agg_status
> > 
> > Yikes. I think mac80211 should just reject that since it will never put
> > traffic into that TID anyway.
> > 
> Johannes, are you going to help fix that :-)

I *think* this is the right fix. Do you agree? It fixes it for sure --
but does it really not have any side effects? I'm pretty sure it doesn't
since I looked at all the code just now ...

johannes

---
 drivers/net/wireless/iwlwifi/iwl-commands.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/iwlwifi/iwl-commands.h	2011-12-02 21:12:01.000000000 +0100
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h	2011-12-02 21:12:02.000000000 +0100
@@ -814,7 +814,7 @@ struct iwl_qosparam_cmd {
 #define	IWLAGN_STATION_COUNT	16
 
 #define	IWL_INVALID_STATION 	255
-#define IWL_MAX_TID_COUNT	9
+#define IWL_MAX_TID_COUNT	8
 
 #define STA_FLG_TX_RATE_MSK		cpu_to_le32(1 << 2)
 #define STA_FLG_PWR_SAVE_MSK		cpu_to_le32(1 << 8)


