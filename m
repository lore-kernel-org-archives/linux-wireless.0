Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:43803 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbYLRVsx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 16:48:53 -0500
Received: by wf-out-1314.google.com with SMTP id 27so672607wfd.4
        for <linux-wireless@vger.kernel.org>; Thu, 18 Dec 2008 13:48:51 -0800 (PST)
Message-ID: <b6c5339f0812181348x49e5c68bia827d9feb4ef0e6c@mail.gmail.com> (sfid-20081218_224857_256476_E31F8751)
Date: Thu, 18 Dec 2008 16:48:51 -0500
From: "Bob Copeland" <bcopeland@gmail.com>
To: sbrown@cortland.com
Subject: Re: Mesh now completely broken on ath5k, latest git
Cc: Keir <keirlawson@gmail.com>,
	"Nick Kossifidis" <mickflemm@gmail.com>,
	"Andrey Yurovsky" <andrey@cozybit.com>,
	linux-wireless@vger.kernel.org, javier@cozybit.com
In-Reply-To: <494ABA6D.8070002@cortland.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <e27b78a40812160405h2241e1acqa0dc8e593d6ebfad@mail.gmail.com>
	 <4947ABAF.9060205@cortland.com>
	 <e27b78a40812160807j7549e1a5hf3bee474b31c29b7@mail.gmail.com>
	 <45e8e6c40812161030x1f7fb374qd4a386ef9022a853@mail.gmail.com>
	 <40f31dec0812170906vd8e4445q9920c66905064df8@mail.gmail.com>
	 <e27b78a40812171004r3a8d424dk7c390aaf7c757665@mail.gmail.com>
	 <494A578A.7070803@cortland.com>
	 <b6c5339f0812181138s1ba134a6qeff21eb063a87e08@mail.gmail.com>
	 <494ABA6D.8070002@cortland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 18, 2008 at 4:02 PM, Steve Brown <sbrown@cortland.com> wrote:
> Lots of these however:
> Dec 18 15:53:20 fl-ws kernel: ath5k phy23: beacon queue 7 didn't stop?

Can you change the if statement that prints that in ath5k_beacon_send() in
base.c to capture the return value?  i.e.:

int err;
...

err = ath5k_hw_stop_tx_dma(ah, sc->bhalq);
if (unlikely(err)) {
    ATH5K_WARN(... "...didn't stop? %d\n", sc->bhalq, err);
}

> If I make the same change to the current git, still no beacons. But, the
> "queue 7" msgs persist.

Not sure, I was about to blame ath5k_configure_filter() but I see it does
turn on the beacons for mesh.

-- 
Bob Copeland %% www.bobcopeland.com
