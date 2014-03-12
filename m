Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from coelho.fi ([88.198.205.34]:33031 "EHLO dedo"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754501AbaCLODD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Mar 2014 10:03:03 -0400
Message-ID: <1394632972.16246.0.camel@dubbel> (sfid-20140312_150312_612630_0D7247F5)
From: Luca Coelho <luca@coelho.fi>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	sw@simonwunderlich.de,
	"Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>
Date: Wed, 12 Mar 2014 16:02:52 +0200
In-Reply-To: <CA+BoTQn2qKnSrZxKzO+2OeDEhRRk-o=WgpHsDzOWveGVXnOmsg@mail.gmail.com>
References: <1394629569-13798-1-git-send-email-luciano.coelho@intel.com>
	 <1394629569-13798-4-git-send-email-luciano.coelho@intel.com>
	 <CA+BoTQn2qKnSrZxKzO+2OeDEhRRk-o=WgpHsDzOWveGVXnOmsg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH v7 3/4] mac80211: implement chanctx reservation
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-03-12 at 14:26 +0100, Michal Kazior wrote:
> On 12 March 2014 14:06, Luciano Coelho <luciano.coelho@intel.com> wrote:
> 
> [...]
> 
> > +       if (sdata->vif.bss_conf.chandef.width != sdata->reserved_chandef.width)
> > +               tmp_changed |= BSS_CHANGED_BANDWIDTH;
> > +
> > +       sdata->vif.bss_conf.chandef = sdata->reserved_chandef;
> 
> > +
> > +       /* unref our reservation before assigning */
> > +       ctx->refcount--;
> > +       sdata->reserved_chanctx = NULL;
> > +
> > +       if (old_ctx == ctx) {
> > +               /* This is our own context, just change it */
> > +               ret = __ieee80211_vif_change_channel(sdata, old_ctx,
> > +                                                    &tmp_changed);
> > +               if (ret)
> > +                       goto out;
> > +       } else {
> 
> > +               if (sdata->vif.bss_conf.chandef.width !=
> > +                   sdata->reserved_chandef.width)
> > +                       tmp_changed |= BSS_CHANGED_BANDWIDTH;
> > +
> > +               sdata->vif.bss_conf.chandef = sdata->reserved_chandef;
> 
> You're already doing this a few lines earlier, before branching.

Yeah... too many rebases and I'm not concentrating enough... *sigh*.

