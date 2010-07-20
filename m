Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:4490 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932998Ab0GTXQI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jul 2010 19:16:08 -0400
Date: Tue, 20 Jul 2010 19:16:29 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Derek Smithies <derek@indranet.co.nz>
Cc: Jonathan Guerin <jonathan@guerin.id.au>,
	"Ath5k Devel issues." <ath5k-devel@lists.ath5k.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [ath5k-devel] ath5k Ad Hoc Association
Message-ID: <20100720231629.GC7049@hash.localnet>
References: <AANLkTilmifjH5Zopo82LhjidzsYfT_xRgKJzjGCZZPlq@mail.gmail.com> <AANLkTintLd8YTgMQuzbEB36t_i5AL4TePBSDAa7G2zvl@mail.gmail.com> <alpine.DEB.2.00.1007211002410.21858@kauri.acheron.indranet.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <alpine.DEB.2.00.1007211002410.21858@kauri.acheron.indranet.co.nz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 21, 2010 at 10:11:14AM +1200, Derek Smithies wrote:
>> Then on the other machine (Vista) I just located 'myibss' (so beacons
>> are working) and selected it, then successfully pinged 192.168.10.1.
> Wrong.
> If the other machine located your node, then one of the four statements  
> is true:

Ok, fine, I just set up a monitor interface and I see beacons
(and probe responses) for my setup on that channel.

> A scan should not be necessary - if both ends are put on channel 2462- a  
> scan should not be required - there is no channel changing. Yet - my  
> colleague noted a scan helped nodes to associate.

There was a bug in older kernels that wouldn't fully configure the
beacons until after a reset, which scanning happens to do.  It's
possible something similar is going on.

Also, scanning might open a previously passive channel because we might
get lucky and receive a beacon from another node on it.  The 'iw phy
phy0 info' can show this kind of thing.

-- 
Bob Copeland %% www.bobcopeland.com

