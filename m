Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43814 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755775Ab1DGLwI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2011 07:52:08 -0400
Subject: Re: Question of CSA callback
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <op.vtkf4iiu3ri7v4@arend-laptop>
References: <op.vtkf4iiu3ri7v4@arend-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Apr 2011 13:52:08 +0200
Message-ID: <1302177128.3779.12.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-04-07 at 13:42 +0200, Arend van Spriel wrote:
> Hi Johannes,
> 
> Recently I have taken a look at csa switch callback. After looking more  
> closely I decided to let mac80211 handle this itself, but I noticed  
> something strange in the interface so maybe you can clarify this.
> 
> void (*channel_switch)(struct ieee80211_hw *hw,
> 		       struct ieee80211_channel_switch *ch_switch);
> 
> void ieee80211_chswitch_done(struct ieee80211_vif *vif, bool success);
> 
> Basically we get a channel switch callback for iee80211_hw and for the  
> ieee80211_chswitch_done() the driver has to provide a vif. Should the  
> channel switch also operate on a vif?

Ah, well, no, not right now anyway -- mac80211 doesn't support
multi-channel operation yet.

However, I think this kind of hw offload isn't necessary for your device
at all.

johannes

