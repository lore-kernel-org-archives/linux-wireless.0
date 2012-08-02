Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47985 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533Ab2HBPoy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2012 11:44:54 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Swxa0-0004nH-NO
	for linux-wireless@vger.kernel.org; Thu, 02 Aug 2012 17:44:52 +0200
Message-ID: <1343922290.4471.21.camel@jlt3.sipsolutions.net> (sfid-20120802_174459_068415_B4418BC1)
Subject: mac80211-wip preview
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 02 Aug 2012 17:44:50 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This is a more tentative preview, things are still subject to change.

The included patchsets and their status:
 * P2P Device work
   I posted this, I'll apply it when I get back unless I see any
   objections then :-)
 * some more cleanups, including the CSA cleanups
   I posted most of these I believe, and will also apply most of it when
   I get back
 * a brcmsmac patch that I posted -- I'm not going to apply it but I
   just wanted to do a random cleanup (the obsolete functions removal)
 * and channel context code of course!
   This is still WIP, I need to
   - address SMPS -- I might just do passive/active # of chains per
     channel context and let the driver sort out the rest, this gives it
     more information and flexibility
   - TX power -- I'm open to suggestions about how we should do this,
     technically the user setting could be per virtual interface, but do
     we care? I have a feeling it should be per channel since even 11h
     TX power reduction is defined for the entire channel

FWIW, multi-channel works in hwsim, but hasn't been tested with actual
drivers yet. If somebody wants to do that while I'm on vacation, the
code is all there in the mac80211-next/wip branch on git.kernel.org. :-)

johannes


Johannes Berg (31):
      mac80211: remove unneeded 'bssid' variable
      mac80211: clean up CSA handling code
      mac80211: fix CSA handling timer
      mac80211: check size of channel switch IE when parsing
      mac80211: make ieee80211_beacon_connection_loss_work static
      mac80211: disconnect if channel switch fails
      brcmsmac: use ieee80211_channel_to_frequency
      wireless: remove obsolete chan no/center freq conversion functions
      cfg80211: add P2P Device abstraction
      mac80211: support P2P Device abstraction
      mac80211: add IEEE80211_HW_P2P_DEV_ADDR_FOR_INTF
      mac80211_hwsim: add support for P2P Device
      mac80211: mesh: don't use global channel type
      mac80211: remove almost unused local variable
      mac80211: remove freq/chantype from debugfs
      mac80211: use oper_channel in rate init
      mac80211: don't assume channel is set in tracing
      mac80211: use RX status band instead of current band
      mac80211: check operating channel in scan
      mac80211: convert ops checks to WARN_ON
      mac80211: pass channel to ieee80211_send_probe_req
      mac80211: clean up ieee80211_subif_start_xmit
      mac80211: check channel context methods
      mac80211: track whether to use channel contexts
      mac80211: allow drv_add_chanctx to fail
      mac80211: return error code from ieee80211_vif_use_channel
      mac80211: use channel contexts
      mac80211_hwsim: move module_init/exit
      mac80211_hwsim: use channel contexts
      cfg80211: add ieee80211_operating_class_to_band
      mac80211: support extended channel switch

Michal Kazior (5):
      mac80211: introduce channel context skeleton code
      mac80211: introduce new ieee80211_ops
      mac80211: use channel context notifications
      mac80211: refactor set_channel_type
      mac80211: reuse channels for channel contexts


