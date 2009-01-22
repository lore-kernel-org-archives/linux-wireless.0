Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:4575 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbZAVUHA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 15:07:00 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: linville@tuxdriver.com, jirislaby@gmail.com,
	lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
Subject: Re: [PATCH 3/6] ath5k: continue reset sequence if gain calibration fails
Date: Thu, 22 Jan 2009 15:06:50 -0500
Message-Id: <20090122194551.M1478@bobcopeland.com> (sfid-20090122_210704_072364_1EC26916)
In-Reply-To: <40f31dec0901221103t10c433f4h7eea23b98a69cd70@mail.gmail.com>
References: <1232631861-6028-4-git-send-email-me@bobcopeland.com> <40f31dec0901220936n27736162vade7e7c53e35a490@mail.gmail.com> <20090122174721.M76206@bobcopeland.com> <40f31dec0901221103t10c433f4h7eea23b98a69cd70@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 22 Jan 2009 21:03:17 +0200, Nick Kossifidis wrote
> > OTOH, I'm pretty sure miscalibrated phy is responsible for all the
> > "unsupported jumbo" errors; I hexdumped some of those and they're all
> > just noise.
> >
> 
> Don't we get a phy error interrupt ?  I haven't looked into this ;-(

I printk-ed rs.rs_status, it's 0, so AR5K_RXERR_PHY is unset.  

I think the jumbo flag is supposed to indicate the packet is larger
than the buffer size.  However, we have a buffer size of 2500 so that
shouldn't happen for standard frames.  I did check into whether there
was a corruption issue, like skb_tailroom was smaller than a full 
packet because of an skb reuse bug or something like that.  But no, 
all were > 2500 bytes (incl roundup for cache line).  That's when 
I did the unmap and a hexdump and saw they have no 802.11 headers or
anything of the sort.  Felix suggested we just drop the warning.

> > (Side note, any reason we call reset() from ath5k_config_interface?
> > We're not changing channels, just setting the bssid.)
> >
> 
> Hmm, i'll check that and come back to you, i think we have to
> re-initialize PCU but i'm not sure. Also if it's supposed to set the
> bssid on a virtual if, we also have to set bssid mask to allow all
> configured bssids for all vifs.

Cool, let me know.  Yeah, configure_interface() doesn't do anything
with the bssid mask (other than reloading it inside hw_set_associd);
in fact it's all-1s forever right now, it seems.

--  
Bob Copeland %% www.bobcopeland.com


