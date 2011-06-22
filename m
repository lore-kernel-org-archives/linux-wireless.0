Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49663 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758588Ab1FVSkM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2011 14:40:12 -0400
Received: by pvg12 with SMTP id 12so679193pvg.19
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jun 2011 11:40:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BD54DDEB2546894FAB0731EA7B0EDF8D058350CB@RockMX01.rock.corp>
References: <BD54DDEB2546894FAB0731EA7B0EDF8D05822A57@RockMX01.rock.corp>
	<4DFA2989.10503@candelatech.com>
	<BD54DDEB2546894FAB0731EA7B0EDF8D05833EC1@RockMX01.rock.corp>
	<BANLkTikK2Ju4cCzs5Y5scfGVRyu+ZRs63g@mail.gmail.com>
	<BD54DDEB2546894FAB0731EA7B0EDF8D058350CB@RockMX01.rock.corp>
Date: Wed, 22 Jun 2011 21:40:11 +0300
Message-ID: <BANLkTimSOUrRiOarn5OdwaAk=vxe3WAjZg@mail.gmail.com> (sfid-20110622_204027_471008_BABEB89F)
Subject: Re: Help on AMPDU stuck in transmit queue
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>
Cc: Ben Greear <greearb@candelatech.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Yes. The problem here seems to be the same as you saw.
> There is no ping packet loss when I use AC==BK.
>

Good but further testing needed.
Do the following:
Associate, and get AMPDU working.
when you see AMPDU, stop the traffic and wait until the AP sends a QoS
NULL data packet.
Then, send a single ping and see what happens.

You can do the test in BE and BK (of course the traffic that triggers
AMPDU and the single ping need to be with the same tid.

> Would you please point me to the code, e.g file/function, etc
> I would like to fix this problem (if I can).
>
> Thanks again
>

ieee80211_rx_reorder_ampdu
but the code seems fine:

/* qos null data frames are excluded */
	if (unlikely(hdr->frame_control & cpu_to_le16(IEEE80211_STYPE_NULLFUNC)))
		goto dont_reorder;

You may want to ensure that this test actually dont_reordere the NULL
data pakcet
You can also check this

http://www.spinics.net/lists/linux-wireless/msg17376.html
