Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:63083 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab3LQNbs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 08:31:48 -0500
Received: by mail-oa0-f46.google.com with SMTP id o6so6520409oag.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 Dec 2013 05:31:47 -0800 (PST)
Date: Tue, 17 Dec 2013 07:31:46 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	brcm80211-dev-list@broadcom.com,
	"John W. Linville" <linville@tuxdriver.com>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Arend van Spriel <arend@broadcom.com>
Subject: Re: [RFC PATCH 3/8] mac80211: Add powersave module
Message-ID: <20131217133146.GB5175@ubuntu-mba51> (sfid-20131217_143154_147784_CDFB4C6D)
References: <1387231260-2849-1-git-send-email-seth.forshee@canonical.com>
 <1387231260-2849-4-git-send-email-seth.forshee@canonical.com>
 <1387268180.4749.8.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1387268180.4749.8.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 17, 2013 at 09:16:20AM +0100, Johannes Berg wrote:
> On Mon, 2013-12-16 at 16:00 -0600, Seth Forshee wrote:
> 
> > + * When @ps_mode == %IEEE80211_VIF_PS_DOZE or the %IEEE80211_CONF_PS flag is
> > + * set it means that the powersave mode defined in IEEE 802.11-2007 section
> > + * 11.2 is enabled. 
> 
> We might consider updating the references to 802.11-2012 since
> everything shuffled around.

Okay.

> > +++ b/net/mac80211/ieee80211_i.h
> > @@ -1180,6 +1180,7 @@ struct ieee80211_local {
> >  #endif /* CONFIG_MAC80211_DEBUG_COUNTERS */
> >  
> > 
> > +	int awake_cnt;
> 
> How will the locking for this possibly work? :)

Well, I did warn that I still need to look at locking ;-)

Mostly the access is already serialized, either by nature of going
through ieee80211_recalc_ps which already has locking rules or by being
run on the device workqueue. I need to try and grok how all the current
mac80211 locking works and see if I need to add something new.
Suggestions are welcome :-)

> 
> > +#include <linux/nl80211.h>
> > +#include <linux/pm_qos.h>
> > +#include <net/mac80211.h>
> > +#include "ieee80211_i.h"
> > +#include "driver-ops.h"
> > +
> > +/*
> > + * Sets the PS parameters in ieee80211_conf. Uses parameters from the first
> > + * managed interface found which has power save enabled, or failing that
> > + * the parameters from an arbitrary managed interface are used.
> > + */
> > +static void ieee80211_set_ps_params(struct ieee80211_local *local) { struct
> > +	ieee80211_sub_if_data *sdata, *ps_sdata = NULL;
> 
> what happened to indentation here??

Hmm, I don't know. Probably I accidentally hit J in vim a couple of
times and didn't notice.

> > +	if (ps_sdata) {
> > +		struct ieee80211_vif *vif = &sdata->vif;
> 
> add a newline here please

Okay.
