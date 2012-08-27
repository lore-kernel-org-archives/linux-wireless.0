Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35855 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab2H0FiO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Aug 2012 01:38:14 -0400
Message-ID: <1346045881.3746.0.camel@jlt4.sipsolutions.net> (sfid-20120827_073818_095438_8C5B1E39)
Subject: Re: [PATCHv2 2/2] ath9k_htc: advertise allowed VIFs combination
From: Johannes Berg <johannes@sipsolutions.net>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Antonio Quartulli <ordex@autistici.org>,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Date: Mon, 27 Aug 2012 07:38:01 +0200
In-Reply-To: <CAGRGNgUoNnuh_23qzULJyJcvMUgNpUxFnZjaAcGj26_jrTHdeA@mail.gmail.com> (sfid-20120827_014933_243805_D149F43D)
References: <1346014505-7554-1-git-send-email-ordex@autistici.org>
	 <1346014505-7554-2-git-send-email-ordex@autistici.org>
	 <CAGRGNgUoNnuh_23qzULJyJcvMUgNpUxFnZjaAcGj26_jrTHdeA@mail.gmail.com>
	 (sfid-20120827_014933_243805_D149F43D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-08-27 at 09:48 +1000, Julian Calaby wrote:
> Antonio,
> 
> On Mon, Aug 27, 2012 at 6:55 AM, Antonio Quartulli <ordex@autistici.org> wrote:
> > This driver now advertises its allowed VIFs combinations to the mac80211
> > sublayer.
> >
> > Other than that, practical tests shown that ath9k_htc devices allow an IBSS VIF
> > to coexist with VIF set up on other modes. This patch removes the check which
> > block the creation of any other VIF whenever an IBSS one is already present.
> 
> These two patches should really be applied in the opposite order:
> 
> You should add the interface combination data (this patch) then remove
> the old checking code.
> 
> This way there's not a window (admittedly only one patch) where the
> interface combinations aren't enforced.

FWIW, it's the other way around, in that window no combinations would be
permitted at all...

johannes

