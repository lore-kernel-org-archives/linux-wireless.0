Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:4833 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab1AYKhd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jan 2011 05:37:33 -0500
Date: Tue, 25 Jan 2011 05:38:03 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	mickflemm@gmail.com, jirislaby@gmail.com, lrodriguez@atheros.com
Subject: Re: [PATCH 2/2] ath5k: correct endianness of frame duration
Message-ID: <20110125103803.GA2239@hash.localnet>
References: <1295929904-11806-1-git-send-email-me@bobcopeland.com> <1295929904-11806-2-git-send-email-me@bobcopeland.com> <201101251423.32008.br1@einfach.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201101251423.32008.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 25, 2011 at 02:23:31PM +0900, Bruno Randolf wrote:
> > The ath5k version of ieee80211_generic_frame_duration() returns
> > an __le16 for standard modes but a cpu-endian int for turbo/half/
> > quarter rates.  Make it always return cpu-endian values.
> 
> I wonder what effect this has in ath5k_hw_set_ifs_intervals() where 
> ack_tx_time was little endian before...

Good point, I didn't think about that.  My guess is EIFS would have
been much too large on big endian arches before the patch.  But then
EIFS resets after successful rx so maybe our many BE users (heh)
wouldn't have noticed except on very idle channels...

-- 
Bob Copeland %% www.bobcopeland.com

