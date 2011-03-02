Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64566 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756593Ab1CBSSk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2011 13:18:40 -0500
Received: by fxm17 with SMTP id 17so259395fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 02 Mar 2011 10:18:38 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Michael Buesch <mb@bu3sch.de>, kvalo@adurom.com
Subject: Re: Powersave broken on p54
Date: Wed, 2 Mar 2011 19:18:30 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <1299003142.6461.12.camel@maggie> <201103021813.52719.chunkeey@googlemail.com> <1299086257.13604.17.camel@marge>
In-Reply-To: <1299086257.13604.17.camel@marge>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201103021918.30528.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 02 March 2011 18:17:37 Michael Buesch wrote:
> On Wed, 2011-03-02 at 18:13 +0100, Christian Lamparter wrote:
> > sure there was the rssi->dbm update (I hope you've already updated
> > your eeprom image.)
> 
> What change to the eeprom is needed? My eeprom doesn't
> contain any rssi info (see recent NULL ptr fix).

I think you should (re-)add it, I don't know what the
firmware is doing with it, but maybe Kalle knows more?

see "p54spi: update sample eeprom"
6c1cef43fb9d4979f9f7e0dcc71f61921730149b

(Note: If the rssi values are missing, the driver uses
the default for Indigo/Duette/Frisbee and XBow RF.
But these parameter could confuse p54spi's Longbow RF?)

> > No idea, it looks like the ps-poll is broken, because
> > "iwconfig wlanX power timeout 10" fixes the long delays
> > almost immediately. [let's see if there's more]
> 
> So maybe it's a generic mac80211 bug? Are there other
> devices with PS issues?
Not sure, don't have any hardware to play with ATM.
But maybe the attached "hack" helps a bit?
---
diff --git a/drivers/net/wireless/p54/fwio.c b/drivers/net/wireless/p54/fwio.c
index 2fab7d2..df56a82 100644
--- a/drivers/net/wireless/p54/fwio.c
+++ b/drivers/net/wireless/p54/fwio.c
@@ -615,8 +615,8 @@ int p54_set_ps(struct p54_common *priv)
 	psm->mode = cpu_to_le16(mode);
 	psm->aid = cpu_to_le16(priv->aid);
 	for (i = 0; i < ARRAY_SIZE(psm->intervals); i++) {
-		psm->intervals[i].interval =
-			cpu_to_le16(priv->hw->conf.listen_interval);
+		psm->intervals[i].interval = cpu_to_le16(1);
+//			cpu_to_le16(priv->hw->conf.listen_interval);
 		psm->intervals[i].periods = cpu_to_le16(1);
 	}
 
