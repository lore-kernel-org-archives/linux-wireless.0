Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:2974 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379Ab1AETyB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jan 2011 14:54:01 -0500
Subject: Re: [PATCH 1/3] ath5k: move nohwcrypt to ath_common structure
From: Joe Perches <joe@perches.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
	ath9k-devel@venema.h4ckr.net
In-Reply-To: <AANLkTi=v3oHGiQjASQqChmmsXHuv=UF17_A9XdeFeFNR@mail.gmail.com>
References: <1294255328-14322-1-git-send-email-linville@tuxdriver.com>
	 <1294256409.12561.8.camel@Joe-Laptop>
	 <AANLkTi=v3oHGiQjASQqChmmsXHuv=UF17_A9XdeFeFNR@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 Jan 2011 11:53:59 -0800
Message-ID: <1294257239.12561.12.camel@Joe-Laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-01-05 at 14:49 -0500, Bob Copeland wrote:
> On Wed, Jan 5, 2011 at 2:40 PM, Joe Perches <joe@perches.com> wrote:
> > On Wed, 2011-01-05 at 14:22 -0500, John W. Linville wrote:
> >> diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
> > []
> >> +     bool nohwcrypt;
> >> diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
> >> -int modparam_nohwcrypt;
> >> +static int modparam_nohwcrypt;
> >>  module_param_named(nohwcrypt, modparam_nohwcrypt, bool, S_IRUGO);
> > bool/int matching?
> It used to be the case that you had to use ints here.  Google tells me
> that changed about 2 years ago, so bool should be ok.

bool is OK.

modparam_nohwcrypt is declared int and should be declared bool.
Also should be declared and used as bool in ath9k and ath9k_htc too.

