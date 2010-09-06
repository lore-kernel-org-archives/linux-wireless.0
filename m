Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38943 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101Ab0IFHfB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Sep 2010 03:35:01 -0400
Date: Mon, 6 Sep 2010 09:30:33 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "Berg, Johannes" <johannes.berg@intel.com>
Cc: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 02/13] iwlwifi: unify scan start checks
Message-ID: <20100906073030.GA3024@redhat.com>
References: <1283515056-11523-1-git-send-email-sgruszka@redhat.com>
 <1283515056-11523-3-git-send-email-sgruszka@redhat.com>
 <1283523813.5211.11.camel@wwguy-ubuntu>
 <C5C86A19469DAE48AAAD0E5F3716E44501CDC1C78D@irsmsx504.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <C5C86A19469DAE48AAAD0E5F3716E44501CDC1C78D@irsmsx504.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 03, 2010 at 03:25:21PM +0100, Berg, Johannes wrote:
> > >         set_bit(STATUS_SCAN_HW, &priv->status);
> > >
> > > -       if (priv->cfg->ops->hcmd->set_pan_params &&
> > > -           priv->cfg->ops->hcmd->set_pan_params(priv))
> > > -               goto done;
> > > +       if (priv->cfg->ops->hcmd->set_pan_params) {
> > > +               ret = priv->cfg->ops->hcmd->set_pan_params(priv);
> > > +               if (ret)
> > > +                       return ret;
> > > +       }
> 
> > STATUS_SCAN_HW bit still set here
> 
> Good catch. 
+1

>Stanislaw, would you mind fixing that? Seems easier than for me to re-send a part of your patch series, but I can do if you prefer.

I will fix.

Stanislaw
