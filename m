Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49113 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab0K2Phi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Nov 2010 10:37:38 -0500
Subject: Re: [PATCH RFC] mac80211: fix "NOHZ: local_softirq_pending 08"
From: Johannes Berg <johannes@sipsolutions.net>
To: Johannes Stezenbach <js@sig21.net>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20101129152735.GA32319@sig21.net>
References: <20101129145439.GA31910@sig21.net>
	 <1291043349.3532.4.camel@jlt3.sipsolutions.net>
	 <20101129152735.GA32319@sig21.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Nov 2010 16:37:36 +0100
Message-ID: <1291045056.3532.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-11-29 at 16:27 +0100, Johannes Stezenbach wrote:

> > That's kinda pointless though for drivers that already call it from a
> > tasklet or similar -- how about instead adding an
> > ieee80211_tx_status_ni() inline along the lines of ieee80211_rx_ni()?
> 
> It gets confusing...
> There already is ieee80211_tx_status_irqsafe(), but you want a third
> option, right?

Yes: _irqsafe has to go through the tasklet, _ni just has to disable
local BHs.

johannes

