Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.3eti.com ([65.220.88.139]:58559 "EHLO 3eSpam.3eti.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757942Ab1FVN4k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2011 09:56:40 -0400
From: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>
To: 'Emmanuel Grumbach' <egrumbach@gmail.com>
CC: Ben Greear <greearb@candelatech.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: Help on AMPDU stuck in transmit queue
Date: Wed, 22 Jun 2011 13:56:32 +0000
Message-ID: <BD54DDEB2546894FAB0731EA7B0EDF8D058350CB@RockMX01.rock.corp> (sfid-20110622_155645_552178_DA183BF3)
References: <BD54DDEB2546894FAB0731EA7B0EDF8D05822A57@RockMX01.rock.corp>
	<4DFA2989.10503@candelatech.com>
	<BD54DDEB2546894FAB0731EA7B0EDF8D05833EC1@RockMX01.rock.corp>
 <BANLkTikK2Ju4cCzs5Y5scfGVRyu+ZRs63g@mail.gmail.com>
In-Reply-To: <BANLkTikK2Ju4cCzs5Y5scfGVRyu+ZRs63g@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks Emmanuel

Yes. The problem here seems to be the same as you saw.
There is no ping packet loss when I use AC==BK.

Would you please point me to the code, e.g file/function, etc
I would like to fix this problem (if I can).

Thanks again


-----Original Message-----
From: Emmanuel Grumbach [mailto:egrumbach@gmail.com] 
Sent: Tuesday, June 21, 2011 4:11 PM
To: Chaoxing Lin
Cc: Ben Greear; ath9k-devel@lists.ath9k.org; linux-wireless@vger.kernel.org
Subject: Re: Help on AMPDU stuck in transmit queue

On Tue, Jun 21, 2011 at 19:16, Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com> wrote:
>
> Anybody,any ideas/comments?
>
> Here is my update.
>
> I tried 2.6.39.1. The situation gets better, but not fixed completely. The ping packets still lose (about 62 seconds) once a while.
> I say "gets better" because it recovers.
>
> The ping session recovers after about 62 seconds which matches to 2 NULL data packet interval. I sniffed the air, it looks like every 31 seconds, a NULL data packet is sent out from client.
>
>
> Again, the symptom does not happen when 802.11n is disabled on AP.
>
> Can anyone explain or help?
>
> Below is my ping session info (message on console)
>

Can you please try to send the pings with AC != BE. I saw once a bug
related to ampdu reordering buffer. NULL packets would enter the
reordering buffer and mess up the counters there. Since the reordering
buffer is tid-wise, trying with another AC may help to understand. I
assume that QoS NULL data packets are sent as BE. The fact that the
ping recovers after a while may be explained by the wrap around of the
sequence.
This is a really wild guess... but sometimes it can hit....
