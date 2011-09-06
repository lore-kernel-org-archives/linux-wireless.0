Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44476 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab1IFEKB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Sep 2011 00:10:01 -0400
Received: by fxh19 with SMTP id 19so4253625fxh.19
        for <linux-wireless@vger.kernel.org>; Mon, 05 Sep 2011 21:10:00 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Subject: Re: [RESEND][PATCH] minstrel_ht: fix Open BA session request floods
Date: Tue, 6 Sep 2011 06:09:46 +0200
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>, nbd@openwrt.org
References: <201109030906.21009.chunkeey@googlemail.com> <CAD2nsn16Otuzp9KbivA03Q5ySMBHLp36J+-HfU=wRcqkSD6QRg@mail.gmail.com>
In-Reply-To: <CAD2nsn16Otuzp9KbivA03Q5ySMBHLp36J+-HfU=wRcqkSD6QRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201109060609.46663.chunkeey@googlemail.com> (sfid-20110906_061009_310143_A7D11149)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, September 05, 2011 05:20:09 PM Mohammed Shafi wrote:
> On Sat, Sep 3, 2011 at 12:36 PM, Christian Lamparter
> <chunkeey@googlemail.com> wrote:
> > Minstrel HT tries very hard to establish a BA session with
> > each peer once there's some data on the way. However the
> > stack does not inform minstrel if an aggregation session
> > is already in place, so it keeps trying and wastes good
> > cycles in the tx status path.
> >
> > [ 8149.946393] Open BA session requested for $AP tid 0
> > [ 8150.048765] Open BA session requested for $AP tid 0
> > [ 8150.174509] Open BA session requested for $AP tid 0
> > [ 8150.274376] Open BA session requested for $AP tid 0
> > ...
> 
> 
> Hi Christian,
> 
> I got this messages in ath9k after few cycles of suspend and resume.
There's nothing wrong with the message... as long as its reasonable
and does not spam the logs as in my case [had about 100k entries].

> doing the same fix in ath9k rate control tx_status callback the
> messages did not re-appear. I will soon send a proper patch for ath9k
> too.
Well, ath9k's rc works different than minstrel_ht. In fact that check
is not needed as ath9k's rc can check the tid state directly in
ath_tx_aggr_check [which I think it already does... unless something
is wrong with the txtid->state check?!].

Regards,
	Chr
