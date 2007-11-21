Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qb-out-0506.google.com ([72.14.204.234]:15304 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbXKUGTo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2007 01:19:44 -0500
Received: by qb-out-0506.google.com with SMTP id e12so416429qba
        for <linux-wireless@vger.kernel.org>; Tue, 20 Nov 2007 22:19:44 -0800 (PST)
Message-ID: <b3153e950711202219m4953e48g3ab2e4b510404f18@mail.gmail.com> (sfid-20071121_061949_005029_180AD173)
Date: Tue, 20 Nov 2007 22:19:42 -0800
From: "mohamed salim abbas" <mabbaswireless@gmail.com>
To: "Dan Williams" <dcbw@redhat.com>
Subject: Re: [PATCH] mac80211: hardware scan rework (V2)
Cc: "Abbas, Mohamed" <mohamed.abbas@intel.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Zhu, Yi" <yi.zhu@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	"Cahill, Ben M" <ben.m.cahill@intel.com>
In-Reply-To: <1195579307.3389.52.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <119553601948-git-send-email-yi.zhu@intel.com>
	 <1195566632.10920.39.camel@johannes.berg>
	 <33E1C72C74DBE747B7B59C1740F74437027F30D4@orsmsx417.amr.corp.intel.com>
	 <1195579307.3389.52.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Acually it is better to bock any managemnt frame task while scanning,
in this function we might end up calling the driver to tune to a
channel, which will cause to stop scan. I think it is better to keep
the check and return if we are doing any scan. I guess this condition
is added to stabilize the mac80211 and it will do the same for iwl
driver with HW scan.
> >
> > > @@ -1985,7 +2003,7 @@ void ieee80211_sta_work(struct work_struct
> > *work)
> > >     if (!netif_running(dev))
> > >             return;
> > >
> > > -   if (local->sta_scanning)
> > > +   if (local->sta_sw_scanning || local->sta_hw_scanning)
> > >             return;
> >
> > Shouldn't the sta work be able to run normally while hw scan is in
> > progress?
> >
