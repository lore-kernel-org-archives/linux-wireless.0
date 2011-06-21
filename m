Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33084 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab1FUUKz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 16:10:55 -0400
Received: by pvg12 with SMTP id 12so78770pvg.19
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jun 2011 13:10:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BD54DDEB2546894FAB0731EA7B0EDF8D05833EC1@RockMX01.rock.corp>
References: <BD54DDEB2546894FAB0731EA7B0EDF8D05822A57@RockMX01.rock.corp>
	<4DFA2989.10503@candelatech.com>
	<BD54DDEB2546894FAB0731EA7B0EDF8D05833EC1@RockMX01.rock.corp>
Date: Tue, 21 Jun 2011 23:10:54 +0300
Message-ID: <BANLkTikK2Ju4cCzs5Y5scfGVRyu+ZRs63g@mail.gmail.com> (sfid-20110621_221057_793321_F6C7C7F8)
Subject: Re: Help on AMPDU stuck in transmit queue
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>
Cc: Ben Greear <greearb@candelatech.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
