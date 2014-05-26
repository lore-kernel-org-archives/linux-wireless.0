Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57587 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656AbaEZG3d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2014 02:29:33 -0400
Message-ID: <1401085766.4162.3.camel@jlt4.sipsolutions.net> (sfid-20140526_082937_301872_3B72604C)
Subject: Re: [PATCH v2 3/5] ath10k: drain tx before restarting hw
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 26 May 2014 08:29:26 +0200
In-Reply-To: <CA+BoTQmmYJ8Mjv1=w=ZijFzZ-FB+PyEV5SKtzvVW7A8_kirueg@mail.gmail.com> (sfid-20140526_074857_736667_6ABB96A9)
References: <1399637749-13489-1-git-send-email-michal.kazior@tieto.com>
	 <1400143324-14911-1-git-send-email-michal.kazior@tieto.com>
	 <1400143324-14911-4-git-send-email-michal.kazior@tieto.com>
	 <87oayovr1m.fsf@kamboji.qca.qualcomm.com>
	 <CA+BoTQmJTsh3Kcwmqx19WAzoBhYrhkQaPT_S=JFVPptkVaaKyw@mail.gmail.com>
	 <87bnuovq6x.fsf@kamboji.qca.qualcomm.com>
	 <CA+BoTQn_V5zGA18qGMNrWYy_-fBQzBi1=EmzMs=0SLvk1LBVJQ@mail.gmail.com>
	 <1400850209.4358.31.camel@jlt4.sipsolutions.net>
	 <CA+BoTQmmYJ8Mjv1=w=ZijFzZ-FB+PyEV5SKtzvVW7A8_kirueg@mail.gmail.com>
	 (sfid-20140526_074857_736667_6ABB96A9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-05-26 at 07:48 +0200, Michal Kazior wrote:
> On 23 May 2014 15:03, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Fri, 2014-05-23 at 11:06 +0200, Michal Kazior wrote:
> >
> >> There's nothing wrong with other thread holding it. Actually that's
> >> the reason for this very check.
> >>
> >> The point is to prevent ath10k_drain_tx() being called while caller
> >> (current thread) holds conf_mutex. If it were to hold conf_mutex then
> >> cancel_work_sync() can deadlock as both workers it tries to stop try
> >> to get a hold of the lock too.
> >
> > That seems pointless - lockdep would warn you about that *anyway*
> > because cancel_work_sync() and friends have proper annotations. Try it
> > sometime :)
> 
> Does it splat every time or just by chance or after a deadlock?

Whenever you execute the second path for the first time.

johannes

