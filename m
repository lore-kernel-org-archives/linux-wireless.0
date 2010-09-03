Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:42408 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754588Ab0ICOcm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Sep 2010 10:32:42 -0400
From: "Berg, Johannes" <johannes.berg@intel.com>
To: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 3 Sep 2010 15:31:20 +0100
Subject: RE: [PATCH 03/13] iwlwifi: move scan completed flags handling
Message-ID: <C5C86A19469DAE48AAAD0E5F3716E44501CDC1C79A@irsmsx504.ger.corp.intel.com>
References: <1283515056-11523-1-git-send-email-sgruszka@redhat.com>
	 <1283515056-11523-4-git-send-email-sgruszka@redhat.com>
 <1283524159.5211.13.camel@wwguy-ubuntu>
In-Reply-To: <1283524159.5211.13.camel@wwguy-ubuntu>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> > @@ -554,7 +543,7 @@ static void iwl_bg_scan_completed(struct
> work_struct *work)
> >  {
> >  	struct iwl_priv *priv =
> >  	    container_of(work, struct iwl_priv, scan_completed);
> > -	bool internal = false;
> > +	bool internal = false, aborted;
> >  	struct iwl_rxon_context *ctx;
> >
> >  	IWL_DEBUG_SCAN(priv, "SCAN complete scan\n");
> > @@ -562,6 +551,15 @@ static void iwl_bg_scan_completed(struct
> work_struct *work)
> >  	cancel_delayed_work(&priv->scan_check);
> >
> >  	mutex_lock(&priv->mutex);
> > +
> > +	aborted = test_and_clear_bit(STATUS_SCAN_ABORTING, &priv-
> >status);
> > +	if (aborted)
> > +		IWL_DEBUG_INFO(priv, "Aborted scan completed.\n");
> > +
> > +	IWL_DEBUG_INFO(priv, "Setting scan to off\n");
> > +
> > +	clear_bit(STATUS_SCANNING, &priv->status);
> > +
> >  	if (priv->is_internal_short_scan) {
> >  		priv->is_internal_short_scan = false;
> >  		IWL_DEBUG_SCAN(priv, "internal short scan completed\n");
> > @@ -569,7 +567,7 @@ static void iwl_bg_scan_completed(struct
> work_struct *work)
> >  	} else if (priv->scan_request) {
> >  		priv->scan_request = NULL;
> >  		priv->scan_vif = NULL;
> > -		ieee80211_scan_completed(priv->hw, false);
> > +		ieee80211_scan_completed(priv->hw, aborted);
> >  	}
> >
> >  	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
> 
> Not too sure about the flow, just asking is it ok to do all thses
> before check "STATUS_EXIT_PENFING"?

I believe it's necessary, because otherwise in the exit pending case we will never complete with mac80211.

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

