Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from coelho.fi ([88.198.205.34]:58269 "EHLO dedo"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752753AbaCGWFI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2014 17:05:08 -0500
Message-ID: <1394174912.4192.9.camel@dubbel> (sfid-20140307_230555_784677_EBE1EA69)
From: Luca Coelho <luca@coelho.fi>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	sw@simonwunderlich.de,
	"Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>
In-Reply-To: <CA+BoTQkb95xGNtVUxvn_u==P6fuy-h0iNAp8pGEcq8m0ZUm-7A@mail.gmail.com>
References: <1394017904-4012-1-git-send-email-luca@coelho.fi>
	 <1394017904-4012-3-git-send-email-luca@coelho.fi>
	 <CA+BoTQkb95xGNtVUxvn_u==P6fuy-h0iNAp8pGEcq8m0ZUm-7A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Mar 2014 08:48:32 +0200
Mime-Version: 1.0
Subject: Re: [PATCH v5 2/3] mac80211: implement chanctx reservation
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-03-05 at 13:04 +0100, Michal Kazior wrote:
> On 5 March 2014 12:11, Luca Coelho <luca@coelho.fi> wrote:
> 
> [...]
> 
> > +       /* unref our reservation before assigning */
> > +       ctx->refcount--;
> > +       sdata->reserved_chanctx = NULL;
> > +       ret = ieee80211_assign_vif_chanctx(sdata, ctx);
> > +       if (ret) {
> > +               /* if assign fails refcount stays the same */
> > +               if (ctx->refcount == 0)
> > +                       ieee80211_free_chanctx(local, ctx);
> > +               goto out_wake;
> > +       }
> 
> This actually won't work if there are AP VLANs (I noticed that yesterday).
> 
> You can't call ieee80211_vif_copy_chanctx_to_vlans() here due to
> current locking requirements. I have a patch for that though ;-) I'll
> send it soon.

How is this related to this patch?

Anyway, good to know that you have fixed it. :)

--
Luca.

