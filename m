Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:50350 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbaJVNzF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2014 09:55:05 -0400
Received: by mail-wi0-f175.google.com with SMTP id d1so1449849wiv.8
        for <linux-wireless@vger.kernel.org>; Wed, 22 Oct 2014 06:55:03 -0700 (PDT)
Date: Wed, 22 Oct 2014 15:54:56 +0200
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Karl Beldan <karl.beldan@rivierawaves.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH v5 0/4] add VHT support to minstrel_ht
Message-ID: <20141022135438.GA29537@magnum.frso.rivierawaves.com> (sfid-20141022_155510_624925_BA27BF04)
References: <1413812762-6605-1-git-send-email-karl.beldan@gmail.com>
 <1413816546.32358.3.camel@jlt4.sipsolutions.net>
 <20141020151302.GB7691@magnum.frso.rivierawaves.com>
 <20141020153421.GC7691@magnum.frso.rivierawaves.com>
 <1413833597.32358.6.camel@jlt4.sipsolutions.net>
 <20141021152658.GA14839@magnum.frso.rivierawaves.com>
 <1413917246.1998.7.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1413917246.1998.7.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 21, 2014 at 08:47:26PM +0200, Johannes Berg wrote:
> On Tue, 2014-10-21 at 17:26 +0200, Karl Beldan wrote:
> 
> > I still don't know why I don't see the smatch array warnings here, I
> > guess I'll live with that for now.
> 
> I'm hoping Dan will eventually pick up on it ;-)
> 
smatch is good, I get your warnings now when unsetting
MAC80211_RC_MINSTREL_VHT. I did not click until after checking
checking smatch's check_overflow.c, when there's a use after check, it
only barks when the indexes checked are out of bounds.

As for the false positive, now we can check the flags instead of doing
comparisons on the indexes, it'd be cleaner and spare this warning,
maybe I should send something.
 
Karl
