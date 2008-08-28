Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:38620 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751974AbYH1LOA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 07:14:00 -0400
From: Bruno Randolf <bruno@thinktube.com>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: pull request: wireless-2.6 2008-08-26
Date: Thu, 28 Aug 2008 13:13:52 +0200
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"Michael Buesch" <mb@bu3sch.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20080827013009.GA15781@tuxdriver.com> <200808281235.35449.bruno@thinktube.com> <1ba2fa240808280352q4a913c1cv33a6bc0998cdbcb9@mail.gmail.com>
In-Reply-To: <1ba2fa240808280352q4a913c1cv33a6bc0998cdbcb9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200808281313.53163.bruno@thinktube.com> (sfid-20080828_131406_290034_2D8028A0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 28 August 2008 12:52:36 Tomas Winkler wrote:
> Do you know how the  TSF is actually synchronized from the HW perspective?

no, unfortuately i have no idea. also i should admit that we have problems 
with atheros hardware in that we don't know when the RX timestamp is taken 
exactly. this means our IBSS merge can't be 100% exact. but the usual case we 
need to catch is when the beacon TSF is much higher than the local TSF. 

i don't care about IBSS power-save right now.

> > with the same HW but it did not work any more - i didn't have the time to
> > investigate this issue...
>
> There is another IBSS bug that was introduced connected to rates maybe
> this is also your problem.. we have something in the pipe that should
> solve this.

good, i'll retest once you subitted the patch.

> Sure but if TSF is not adopted correctly and that's the case probably
> of most of the drivers under mac80211 then it makes
> worth.  Just need to be aware of this.

true, we need to find a way to support this hardware too...

bruno

