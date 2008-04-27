Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0708.google.com ([209.85.198.250]:40651 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752463AbYD0IKt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Apr 2008 04:10:49 -0400
Received: by rv-out-0506.google.com with SMTP id k29so2567434rvb.1
        for <linux-wireless@vger.kernel.org>; Sun, 27 Apr 2008 01:10:48 -0700 (PDT)
Message-ID: <c85cb4470804270110q417d6152o907293ced4471bc5@mail.gmail.com> (sfid-20080427_101110_477710_A3737914)
Date: Sun, 27 Apr 2008 11:10:48 +0300
From: "Ron Rindjunsky" <rindjon@googlemail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC] mac80211: handling Qdisc issues
Cc: "Winkler, Tomas" <tomas.winkler@intel.com>,
	"John Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1209225760.10943.35.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1204822307-5111-1-git-send-email-ron.rindjunsky@intel.com>
	 <1879838866982C46A9CB3D56BA49ADEB04B42158@hasmsx411.ger.corp.intel.com>
	 <1208426282.4066.3.camel@johannes.berg>
	 <1879838866982C46A9CB3D56BA49ADEB04CCE9C4@hasmsx411.ger.corp.intel.com>
	 <C07C4589BE74A34981C3C3525EE1F80103BAF061@hasmsx412.ger.corp.intel.com>
	 <1208469393.4066.92.camel@johannes.berg>
	 <C07C4589BE74A34981C3C3525EE1F80103BF5D59@hasmsx412.ger.corp.intel.com>
	 <1209027037.3357.39.camel@johannes.berg>
	 <1879838866982C46A9CB3D56BA49ADEB04D09D98@hasmsx411.ger.corp.intel.com>
	 <1209225760.10943.35.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > >>> such as not using QoS packets when hw->queues < 4.
> > >>
> > >> We should not advertise QoS in that case.
> >
> > > Ok :) I'll look if I can fix it.
> >
> > In that case no HT should be published as well.
>
> Yeah. Can you see whether the below patch looks ok to you?
>
> @@ -2046,7 +2054,7 @@ static void ieee80211_rx_mgmt_assoc_resp
>

i would add the check to HT as well:


-	if (elems.ht_cap_elem && elems.ht_info_elem && elems.wmm_param) {
+	if (elems.ht_cap_elem && elems.ht_info_elem && elems.wmm_param
+                    && (ifsta->flags & IEEE80211_STA_WMM_ENABLED)) {
		struct ieee80211_ht_bss_info bss_info;
		ieee80211_ht_cap_ie_to_ht_info(
				(struct ieee80211_ht_cap *)

>        rate_control_rate_init(sta, local);
>
> -       if (elems.wmm_param && (ifsta->flags & IEEE80211_STA_WMM_ENABLED)) {
> +       if (elems.wmm_param) {
>                sta->flags |= WLAN_STA_WME;
>                rcu_read_unlock();
>                ieee80211_sta_wmm_params(dev, ifsta, elems.wmm_param,

All other looks ok

Ron
