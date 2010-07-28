Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55871 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab0G1T6E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jul 2010 15:58:04 -0400
Received: by bwz1 with SMTP id 1so4145834bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 28 Jul 2010 12:58:02 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] ar9170: add get_survey callback in order to get channel noise
Date: Wed, 28 Jul 2010 21:57:56 +0200
Cc: linux-wireless@vger.kernel.org,
	Benoit Papillault <benoit.papillault@free.fr>
References: <1280342924-22811-1-git-send-email-linville@tuxdriver.com> <201007282110.31458.chunkeey@googlemail.com> <20100728191552.GA2668@tuxdriver.com>
In-Reply-To: <20100728191552.GA2668@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201007282157.57068.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 28 July 2010 21:15:53 John W. Linville wrote:
> On Wed, Jul 28, 2010 at 09:10:31PM +0200, Christian Lamparter wrote:
> > On Wednesday 28 July 2010 20:48:44 John W. Linville wrote:
> > > Signed-off-by: John W. Linville <linville@tuxdriver.com>
> > > ---
> > >  drivers/net/wireless/ath/ar9170/main.c |   17 +++++++++++++++++
> > >  1 files changed, 17 insertions(+), 0 deletions(-)
> > >  [...]
> > One problem: the noisefloor stays at the same level and
> > is not updated. You would have to call ar9170_set_channel,
> > but I don't recommend that because that may lockup
> > the device :(.
> 
> I'm not sure I understand -- isn't ar9170_set_channel already called
> from ar9170_op_config? Or are you saying that the value will be
> stale unless you call ar9170_set_channel again?
the latter... come to think of it, I wrote a RFT a while back:
"[RFT] ar9170: implement get_survey" <- 27. April

and Benoit joined in to point out that he has/had the same
issue with ath9k hardware. Was this ever sorted out? 

> How is this patch any worse than the situation was before commit
> 5d6566ff356a19fb6ad994717cb937ff88063fa6?

Well, a dodgy value is hardly an improvement, right?
Sure it is _just_ the noise *floor* and people
might argue that any value is better than nothing at all. 

Therefore, yes:

Acked-by: Christian Lamparter <chunkeey@googlemail.com>

and add the nf-update to the TODO-list...
Or wait and look how ath9k(_htc) does/did it. 

Regards,
	Christian
