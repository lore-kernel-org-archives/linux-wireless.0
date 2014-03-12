Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from coelho.fi ([88.198.205.34]:33097 "EHLO dedo"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754481AbaCLOmS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Mar 2014 10:42:18 -0400
Message-ID: <1394634829.16246.4.camel@dubbel> (sfid-20140312_154222_034007_EEEA3599)
From: Luca Coelho <luca@coelho.fi>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	sw@simonwunderlich.de,
	"Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>
In-Reply-To: <CA+BoTQkhc-iWDEaYj5o-RTMaCBoteFObH=Xqco=GYL76yr8OOw@mail.gmail.com>
References: <1394629569-13798-1-git-send-email-luciano.coelho@intel.com>
	 <1394629569-13798-5-git-send-email-luciano.coelho@intel.com>
	 <CA+BoTQkhc-iWDEaYj5o-RTMaCBoteFObH=Xqco=GYL76yr8OOw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Mar 2014 16:33:49 +0200
Mime-Version: 1.0
Subject: Re: [PATCH v7 4/4] mac80211: allow reservation of a running chanctx
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-03-12 at 14:24 +0100, Michal Kazior wrote:
> On 12 March 2014 14:06, Luciano Coelho <luciano.coelho@intel.com> wrote:
> 
> [...]
> 
> > @@ -700,12 +735,7 @@ int ieee80211_vif_use_reserved_context(struct ieee80211_sub_if_data *sdata,
> >
> >         old_ctx = container_of(conf, struct ieee80211_chanctx, conf);
> >
> > -       if (sdata->vif.bss_conf.chandef.width != sdata->reserved_chandef.width)
> > -               tmp_changed |= BSS_CHANGED_BANDWIDTH;
> > -
> > -       sdata->vif.bss_conf.chandef = sdata->reserved_chandef;
> > -
> > -       /* unref our reservation before assigning */
> > +       /* unref our reservation */
> >         ctx->refcount--;
> >         sdata->reserved_chanctx = NULL;
> >
> > @@ -742,11 +772,6 @@ int ieee80211_vif_use_reserved_context(struct ieee80211_sub_if_data *sdata,
> >         }
> >
> >         *changed = tmp_changed;
> > -
> > -       ieee80211_recalc_chanctx_chantype(local, ctx);
> > -       ieee80211_recalc_smps_chanctx(local, ctx);
> > -       ieee80211_recalc_radar_chanctx(local, ctx);
> > -       ieee80211_recalc_chanctx_min_def(local, ctx);
> >  out:
> >         mutex_unlock(&local->chanctx_mtx);
> >         return ret;
> 
> I think you need these for if(old_ctx==new_ctx) case, don't you?

Rebase screw-ups ad-infinitum...

--
Luca.

