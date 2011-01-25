Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:6922 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751829Ab1AYKrI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jan 2011 05:47:08 -0500
Received: from vs3011.wh2.ocn.ne.jp (125.206.180.239)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 5-0182472425
	for <linux-wireless@vger.kernel.org>; Tue, 25 Jan 2011 19:47:07 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Bob Copeland <me@bobcopeland.com>
Subject: Re: [PATCH 2/2] ath5k: correct endianness of frame duration
Date: Tue, 25 Jan 2011 19:47:03 +0900
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	mickflemm@gmail.com, jirislaby@gmail.com, lrodriguez@atheros.com
References: <1295929904-11806-1-git-send-email-me@bobcopeland.com> <201101251423.32008.br1@einfach.org> <20110125103803.GA2239@hash.localnet>
In-Reply-To: <20110125103803.GA2239@hash.localnet>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201101251947.03685.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue January 25 2011 19:38:03 Bob Copeland wrote:
> On Tue, Jan 25, 2011 at 02:23:31PM +0900, Bruno Randolf wrote:
> > > The ath5k version of ieee80211_generic_frame_duration() returns
> > > an __le16 for standard modes but a cpu-endian int for turbo/half/
> > > quarter rates.  Make it always return cpu-endian values.
> > 
> > I wonder what effect this has in ath5k_hw_set_ifs_intervals() where
> > ack_tx_time was little endian before...
> 
> Good point, I didn't think about that.  My guess is EIFS would have
> been much too large on big endian arches before the patch.  But then
> EIFS resets after successful rx so maybe our many BE users (heh)
> wouldn't have noticed except on very idle channels...

Allright, just the EIFS is affected - shouldn't be a big deal. Anyhow it's 
correct now and was wrong before.

But you meant on a very busy channel, right?

I'm on a BE board ;) I can try to see what difference it makes tomorrow.

bruno
