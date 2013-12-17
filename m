Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:44598 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872Ab3LQIQZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 03:16:25 -0500
Message-ID: <1387268180.4749.8.camel@jlt4.sipsolutions.net> (sfid-20131217_091628_715064_885C1C8A)
Subject: Re: [RFC PATCH 3/8] mac80211: Add powersave module
From: Johannes Berg <johannes@sipsolutions.net>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	brcm80211-dev-list@broadcom.com,
	"John W. Linville" <linville@tuxdriver.com>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Arend van Spriel <arend@broadcom.com>
Date: Tue, 17 Dec 2013 09:16:20 +0100
In-Reply-To: <1387231260-2849-4-git-send-email-seth.forshee@canonical.com> (sfid-20131216_230109_675659_8D614BB1)
References: <1387231260-2849-1-git-send-email-seth.forshee@canonical.com>
	 <1387231260-2849-4-git-send-email-seth.forshee@canonical.com>
	 (sfid-20131216_230109_675659_8D614BB1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-12-16 at 16:00 -0600, Seth Forshee wrote:

> + * When @ps_mode == %IEEE80211_VIF_PS_DOZE or the %IEEE80211_CONF_PS flag is
> + * set it means that the powersave mode defined in IEEE 802.11-2007 section
> + * 11.2 is enabled. 

We might consider updating the references to 802.11-2012 since
everything shuffled around.

> +++ b/net/mac80211/ieee80211_i.h
> @@ -1180,6 +1180,7 @@ struct ieee80211_local {
>  #endif /* CONFIG_MAC80211_DEBUG_COUNTERS */
>  
> 
> +	int awake_cnt;

How will the locking for this possibly work? :)

> +#include <linux/nl80211.h>
> +#include <linux/pm_qos.h>
> +#include <net/mac80211.h>
> +#include "ieee80211_i.h"
> +#include "driver-ops.h"
> +
> +/*
> + * Sets the PS parameters in ieee80211_conf. Uses parameters from the first
> + * managed interface found which has power save enabled, or failing that
> + * the parameters from an arbitrary managed interface are used.
> + */
> +static void ieee80211_set_ps_params(struct ieee80211_local *local) { struct
> +	ieee80211_sub_if_data *sdata, *ps_sdata = NULL;

what happened to indentation here??

> +	list_for_each_entry(sdata, &local->interfaces, list) {

locking?

> +	if (ps_sdata) {
> +		struct ieee80211_vif *vif = &sdata->vif;

add a newline here please

> +static void __ieee80211_vif_set_ps_mode(struct ieee80211_sub_if_data *sdata,
> +					enum ieee80211_vif_ps_mode mode)
> +{
> +	struct ieee80211_local *local = sdata->local;
> +
> +	if (WARN_ON_ONCE(sdata->vif.type == NL80211_IFTYPE_MONITOR))
> +		return;
> +
> +	switch (mode) {
> +	case IEEE80211_VIF_PS_INACTIVE:
> +	case IEEE80211_VIF_PS_DOZE:
> +		if (sdata->vif.ps_mode > IEEE80211_VIF_PS_DOZE &&
> +		    !WARN_ON(local->awake_cnt <= 0))
> +			local->awake_cnt--;

locking?

johannes

