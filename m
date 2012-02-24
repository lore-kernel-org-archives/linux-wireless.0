Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:46140 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755468Ab2BXUns (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Feb 2012 15:43:48 -0500
Received: by eekc4 with SMTP id c4so1121353eek.19
        for <linux-wireless@vger.kernel.org>; Fri, 24 Feb 2012 12:43:47 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
Subject: Re: [RFC] carl9170: Fix memory accounting when sta is in power-save mode.
Date: Fri, 24 Feb 2012 21:43:42 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <1330012414-26559-1-git-send-email-cavallar@lri.fr> <201202231752.44125.chunkeey@googlemail.com> <4F46771F.9000200@lri.fr>
In-Reply-To: <4F46771F.9000200@lri.fr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201202242143.42669.chunkeey@googlemail.com> (sfid-20120224_214352_264006_F3CA2932)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 23 February 2012 18:27:59 Nicolas Cavallari wrote:
> On 23/02/2012 17:52, Christian Lamparter wrote:
> > On Thursday, February 23, 2012 04:53:34 PM Nicolas Cavallari wrote:
> >> While this seems to fix my problem, there could still be problems remaining
> >> in this code path.  Particularly carl9170_tx_status will do lots of things
> >> like incrementing counters and waking up mac80211 queues...
> > That should be alright. As a rule of thumb, for every call to
> > carl9170_tx_accounting [called by carl9170_op_tx tx handler]
> > we need to call carl9170_tx_status. If the station is still in
> > ps mode, mac80211 will cache the station's frames and sets
> > the TIM bits. 
> 
> Part of the reason i wrote this, is because, while this patch fixes the
> memory accounting problem and prevent the AP from stopping working, the
> powersaving station sometimes cannot communicate with the AP anymore
> (other stations can). The station uses ath9k, and is just really doing a
> background scan. The first traces that i have just indicate that the
> station entered powersave mode, then sends probe requests and probe
> requests directed to the AP, then sends authentication requests to the
> AP (?), but the AP does not respond to any of them...
understood. 

In the meantime, I think we can put this fix into the kernel queue right away.

John,
	would you please do the honors? :-D

Regards,
	Chr
