Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47534 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936AbaEWJ1F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 05:27:05 -0400
Message-ID: <1400837213.4358.14.camel@jlt4.sipsolutions.net> (sfid-20140523_112711_244787_F8049F06)
Subject: Re: [PATCH] mac80211: add a single-transaction driver op to switch
 contexts
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Luca Coelho <luca@coelho.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 23 May 2014 11:26:53 +0200
In-Reply-To: <CA+BoTQnrntQ_BkNFX987d-DuqA0yoVAyFZhp7UB5qk_Q45J=bQ@mail.gmail.com> (sfid-20140523_111644_281107_7F54A496)
References: <1400769938.4174.29.camel@jlt4.sipsolutions.net>
	 <1400812703-15685-1-git-send-email-luca@coelho.fi>
	 <CA+BoTQkof_e_T=xegftVHdKK_XFeb2HegOQWmV5+PkCdLkzEyg@mail.gmail.com>
	 <1400835498.4358.9.camel@jlt4.sipsolutions.net>
	 <CA+BoTQnrntQ_BkNFX987d-DuqA0yoVAyFZhp7UB5qk_Q45J=bQ@mail.gmail.com>
	 (sfid-20140523_111644_281107_7F54A496)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-05-23 at 11:16 +0200, Michal Kazior wrote:
> On 23 May 2014 10:58, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Fri, 2014-05-23 at 10:01 +0200, Michal Kazior wrote:
> >
> >> So.. which patch are we going forward with? Luca's or mine? Either way
> >> is fine with me as long as we reach a conclusion :-)
> >
> > Looks like both are missing some things? Luca's doesn't have tracing,
> > and supports just a single interface (which you'll not like :) ) but
> > personally I liked the struct API a bit better than multiple double
> > pointer arrays you had.
> 
> Well, the 'single interface' problem isn't even a thing. Luca just
> happens to rework ieee80211_vif_use_reserved_
> context() in one go. My patch simply adds the new op since the
> old/single-vif channel csa code gets thrown out later anyway.
> 
> I suppose we can just split Luca's patch and drop the
> vif_use_reserved_context() part (as well as
> IEEE80211_HW_CHANGE_RUNNING_CHANCTX flag removal) as it will get
> overwritten by my patches later anyway?

Oh ok. Can't say I really care :)

johannes

