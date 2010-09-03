Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20200 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753985Ab0ICO0W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Sep 2010 10:26:22 -0400
From: "Berg, Johannes" <johannes.berg@intel.com>
To: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 3 Sep 2010 15:25:21 +0100
Subject: RE: [PATCH 02/13] iwlwifi: unify scan start checks
Message-ID: <C5C86A19469DAE48AAAD0E5F3716E44501CDC1C78D@irsmsx504.ger.corp.intel.com>
References: <1283515056-11523-1-git-send-email-sgruszka@redhat.com>
	 <1283515056-11523-3-git-send-email-sgruszka@redhat.com>
 <1283523813.5211.11.camel@wwguy-ubuntu>
In-Reply-To: <1283523813.5211.11.camel@wwguy-ubuntu>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> >         set_bit(STATUS_SCAN_HW, &priv->status);
> >
> > -       if (priv->cfg->ops->hcmd->set_pan_params &&
> > -           priv->cfg->ops->hcmd->set_pan_params(priv))
> > -               goto done;
> > +       if (priv->cfg->ops->hcmd->set_pan_params) {
> > +               ret = priv->cfg->ops->hcmd->set_pan_params(priv);
> > +               if (ret)
> > +                       return ret;
> > +       }

> STATUS_SCAN_HW bit still set here

Good catch. Stanislaw, would you mind fixing that? Seems easier than for me to re-send a part of your patch series, but I can do if you prefer.

johannes
--------------------------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen, Deutschland 
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 
Ust.-IdNr./VAT Registration No.: DE129385895
Citibank Frankfurt a.M. (BLZ 502 109 00) 600119052

