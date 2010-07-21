Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:55742 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab0GUAA5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jul 2010 20:00:57 -0400
Received: by qyk38 with SMTP id 38so2812623qyk.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Jul 2010 17:00:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100720231629.GC7049@hash.localnet>
References: <AANLkTilmifjH5Zopo82LhjidzsYfT_xRgKJzjGCZZPlq@mail.gmail.com>
	<AANLkTintLd8YTgMQuzbEB36t_i5AL4TePBSDAa7G2zvl@mail.gmail.com>
	<alpine.DEB.2.00.1007211002410.21858@kauri.acheron.indranet.co.nz>
	<20100720231629.GC7049@hash.localnet>
From: Jonathan Guerin <jonathan@guerin.id.au>
Date: Wed, 21 Jul 2010 10:00:36 +1000
Message-ID: <AANLkTilD94SJFfNK4CHxsbD1lyQiu33k3WeQtsjMUyei@mail.gmail.com>
Subject: Re: [ath5k-devel] ath5k Ad Hoc Association
To: Bob Copeland <me@bobcopeland.com>
Cc: Derek Smithies <derek@indranet.co.nz>,
	"Ath5k Devel issues." <ath5k-devel@lists.ath5k.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do you remember what version kernel this was fixed in? I can update
the nodes to at least this version and see if it helps...

On my setup, I am not seeing ANY probes from the ath5k nodes at all.
If I start a MadWifi node and the ath5k nodes join it, then bring down
the MadWifi node, the ath5k nodes ALL start beaconing...

Cheers,

--
Jonathan Guerin



On Wed, Jul 21, 2010 at 9:16 AM, Bob Copeland <me@bobcopeland.com> wrote:
> On Wed, Jul 21, 2010 at 10:11:14AM +1200, Derek Smithies wrote:
>>> Then on the other machine (Vista) I just located 'myibss' (so beacons
>>> are working) and selected it, then successfully pinged 192.168.10.1.
>> Wrong.
>> If the other machine located your node, then one of the four statements
>> is true:
>
> Ok, fine, I just set up a monitor interface and I see beacons
> (and probe responses) for my setup on that channel.
>
>> A scan should not be necessary - if both ends are put on channel 2462- a
>> scan should not be required - there is no channel changing. Yet - my
>> colleague noted a scan helped nodes to associate.
>
> There was a bug in older kernels that wouldn't fully configure the
> beacons until after a reset, which scanning happens to do.  It's
> possible something similar is going on.
>
> Also, scanning might open a previously passive channel because we might
> get lucky and receive a beacon from another node on it.  The 'iw phy
> phy0 info' can show this kind of thing.
>
> --
> Bob Copeland %% www.bobcopeland.com
>
>
