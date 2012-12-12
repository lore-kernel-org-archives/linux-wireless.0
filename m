Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48787 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257Ab2LLORf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2012 09:17:35 -0500
Message-ID: <1355321878.9708.6.camel@jlt4.sipsolutions.net> (sfid-20121212_151738_778738_A047E871)
Subject: Re: adding ba_policy member in drv_ampdu_action op - request
 information
From: Johannes Berg <johannes@sipsolutions.net>
To: vivekanandah@posedge.com
Cc: linux-wireless@vger.kernel.org
Date: Wed, 12 Dec 2012 15:17:58 +0100
In-Reply-To: <95cd69900bf76c0024d3a0838ed38d30@posedge.com>
References: <95cd69900bf76c0024d3a0838ed38d30@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-12-12 at 12:10 +0530, vivekanandah@posedge.com wrote:
> Hi,
> 
> presently in code, the block ack policy is not sent by mac80211 to the 
> lower level driver via the ampdu_action callback.
> 
> The mac80211 while transmitting a block ack (ADDBA)request, hardcodes 
> the block ack methodology to immediate block ack.
> 
> on the receive side, the delayed block ack bit is checked along-with 
> the capability of the receiver station to support delayed block ack. 
> even if the station supports delayed block ack, mac80211 does not send 
> the ba_policy down to the driver.
> 
> should ba_policy be sent to the driver so that lower level drivers can 
> take a call as to send block ack response in a delayed manner at its 
> convenience?

Well, if you wanted to support it, you'd first have to change the
negotiation to actually ask for it, no?

johannes

