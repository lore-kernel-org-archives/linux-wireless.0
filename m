Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1201 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753568Ab1DGLmR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2011 07:42:17 -0400
cc: linux-wireless <linux-wireless@vger.kernel.org>
To: "Johannes Berg" <johannes@sipsolutions.net>
Date: Thu, 7 Apr 2011 13:42:08 +0200
Subject: Question of CSA callback
MIME-Version: 1.0
From: "Arend van Spriel" <arend@broadcom.com>
Message-ID: <op.vtkf4iiu3ri7v4@arend-laptop>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed;
 delsp=yes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

Recently I have taken a look at csa switch callback. After looking more  
closely I decided to let mac80211 handle this itself, but I noticed  
something strange in the interface so maybe you can clarify this.

void (*channel_switch)(struct ieee80211_hw *hw,
		       struct ieee80211_channel_switch *ch_switch);

void ieee80211_chswitch_done(struct ieee80211_vif *vif, bool success);

Basically we get a channel switch callback for iee80211_hw and for the  
ieee80211_chswitch_done() the driver has to provide a vif. Should the  
channel switch also operate on a vif?

Gr. AvS
-- 
"The most merciful thing in the world, I think, is the inability of the  
human
mind to correlate all its contents." - "The Call of Cthulhu"

