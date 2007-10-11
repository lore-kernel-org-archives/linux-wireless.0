Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:62981 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754906AbXJKRtN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Oct 2007 13:49:13 -0400
Received: by nf-out-0910.google.com with SMTP id g13so538110nfb
        for <linux-wireless@vger.kernel.org>; Thu, 11 Oct 2007 10:49:11 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: rt2500pci 2.0.9 not working
Date: Thu, 11 Oct 2007 20:05:55 +0200
Cc: Marcus Better <marcus@better.se>, linux-wireless@vger.kernel.org
References: <fdqhn4$qab$1@sea.gmane.org> <55623.80.169.182.16.1192093534.squirrel@www.dactylis.com> <1192094159.4770.21.camel@johannes.berg>
In-Reply-To: <1192094159.4770.21.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200710112005.56101.IvDoorn@gmail.com> (sfid-20071011_184918_459016_2501AA57)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 11 October 2007, Johannes Berg wrote:
> On Thu, 2007-10-11 at 11:05 +0200, Marcus Better wrote:
> 
> > > No, but you can comment out the B mode registration in rt2500pci and see
> > > if that helps.
> > 
> > I have very limited time to find out how to do that, but will gladly try a
> > patch...
> 
> Me neither. It seems to be in rt2x00dev.c, Ivo can you help maybe? Just
> for debugging. I'd have thought that adding the 'break' statement would
> fix it.

Patch added below.

> Alternatively, could you print out the selected mode in
> ieee80211_ioctl.c:ieee80211_set_channel?
> 
> something like
> printk(KERN_DEBUG "selected mode %d\n", local->oper_hw_mode->mode);
> printk(KERN_DEBUG "select channel %d\n", local->oper_channel);

---

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 360f03a..89470c0 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -866,9 +866,9 @@ static int rt2x00lib_probe_hw_modes(struct rt2x00_dev *rt2x00dev,
 	    ieee80211_register_hwmode(hw, &hwmodes[HWMODE_G]))
 		goto exit_free_rates;
 
-	if (spec->num_modes > HWMODE_B &&
+	/*if (spec->num_modes > HWMODE_B &&
 	    ieee80211_register_hwmode(hw, &hwmodes[HWMODE_B]))
-		goto exit_free_rates;
+		goto exit_free_rates;*/
 
 	if (spec->num_modes > HWMODE_A &&
 	    ieee80211_register_hwmode(hw, &hwmodes[HWMODE_A]))
 


