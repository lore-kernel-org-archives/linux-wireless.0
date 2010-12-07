Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:31684 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752132Ab0LGC3X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Dec 2010 21:29:23 -0500
Received: from vs3016.wh2.ocn.ne.jp (125.206.180.189)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 1-0733818959
	for <linux-wireless@vger.kernel.org>; Tue,  7 Dec 2010 11:29:21 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: sedat.dilek@gmail.com
Subject: Re: [ath5k-devel] ath5k: Weird Retransmission Behaviour
Date: Tue, 7 Dec 2010 11:29:05 +0900
Cc: Nick Kossifidis <mickflemm@gmail.com>,
	Jonathan Guerin <jonathan@guerin.id.au>,
	"ath5k-devel" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <AANLkTimDF3kofO=kiuOsz+WrTGROdOL8-3eNvKd5NrD3@mail.gmail.com> <AANLkTiky-Q6DLxXSKf-+UU6avpaVikRgtt5078+Ui7Uh@mail.gmail.com> <AANLkTinKuj+e+yEwn_1g268BLPBMt71gKkUmzjbz2a3e@mail.gmail.com>
In-Reply-To: <AANLkTinKuj+e+yEwn_1g268BLPBMt71gKkUmzjbz2a3e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201012071129.05281.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon December 6 2010 19:53:49 Sedat Dilek wrote:
> >> But it seems weird that there are so many retransmissions. The default
> >> maximum numbers of retransmissions should be 7 for short frames and 4
> >> for long frames (dot11[Short|Long]RetryLimit), and this is what is set
> >> as defaults in mac80211 (local->hw.conf.short_frame_max_tx_count).
> >> Seems we are getting many
> > 
> >> retransmissions from minstel, i added some debug prints:
> > When ath5k doesn't get retry limits from above it uses the following
> > defaults on dcu.
> > For now i don't think we use local->hw.conf.short_frame_max_tx_count
> > for that so the
> > default is ah_limit_tx_retries (AR5K_INIT_TX_RETRY) but seems it's
> > wrong and we should
> > fix it...
> > 
> > /* Tx retry limits */
> > #define AR5K_INIT_SH_RETRY                      10
> > #define AR5K_INIT_LG_RETRY                      AR5K_INIT_SH_RETRY
> > /* For station mode */
> > #define AR5K_INIT_SSH_RETRY                     32
> > #define AR5K_INIT_SLG_RETRY                     AR5K_INIT_SSH_RETRY
> > #define AR5K_INIT_TX_RETRY                      10

> You mean sth. like the attached patch?

Not quite. We should get the values from mac80211 and use them.

At least this does explain the resetting of the contention window after 10.

bruno
