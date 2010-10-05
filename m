Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:22052 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932799Ab0JEJ7O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 05:59:14 -0400
Received: from vs3017.wh2.ocn.ne.jp (125.206.180.250)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 1-0710102753
	for <linux-wireless@vger.kernel.org>; Tue,  5 Oct 2010 18:59:13 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH 2/4] ath9k_hw: merge codepaths that access the
 =?iso-8859-1?q?cycle=09counter?= registers
Date: Tue, 5 Oct 2010 18:59:14 +0900
Cc: Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
References: <1286125639-15137-1-git-send-email-nbd@openwrt.org> <20101004122432.GA25423@vasanth-laptop> <4CA9CDDC.4000302@openwrt.org>
In-Reply-To: <4CA9CDDC.4000302@openwrt.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201010051859.14594.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon October 4 2010 21:51:40 Felix Fietkau wrote:
> On 2010-10-04 2:24 PM, Vasanthakumar Thiagarajan wrote:
> >> >> +	/* unfreeze counters */
> >> >> +	REG_WRITE(ah, AR_MIBC, 0);
> >> > 
> >> > Please configure the relevant bit to unfreeze the counters.
> >> 
> >> What do you mean?
> > 
> > AR_MIBC does more than just freeze/unfreeze the counters, though I
> > dont see any issues with setting the whole register to zero, it
> > looks buggy. Please configure only the relevant bit to
> > freeze/unfreeze the counters.
> 
> Other places in the code set it to zero as well, though sometimes
> written in a weird way. I also checked the specs, there is no bit that's
> supposed to be active at this point.

hi!

i just sent a patch series, which moves that function to common, to be shared 
between ath5k and ath9k. i implemented it in a rather simple way, i admit, but 
it hope that it is sufficient anyways. the patch series should also include 
what is left from this patch. could you please check and let me know what you 
think? 

thanks,
bruno
