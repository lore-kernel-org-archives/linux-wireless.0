Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40271 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753324AbYGOJ6N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2008 05:58:13 -0400
Message-ID: <20080715115810.nxudx5jrms8s4cko@imap.suse.de> (sfid-20080715_115816_990669_7E9C0B53)
Date: Tue, 15 Jul 2008 11:58:10 +0200
From: Helmut Schaa <hschaa@suse.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Tomas Winkler <tomasw@gmail.com>,
	Kalle Valo <kalle.valo@nokia.com>, linville@tuxdriver.com,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] mac80211: make listen_interval be configurable by
	low level driver
References: <1216038684-29725-1-git-send-email-tomas.winkler@intel.com>
	<1216038684-29725-2-git-send-email-tomas.winkler@intel.com>
	<1216039127.11189.15.camel@johannes.berg>
	<1ba2fa240807140546w4f08e32l59ed88dfa1b86403@mail.gmail.com>
	<87fxqcoaue.fsf@nokia.com> <1216109543.23746.21.camel@johannes.berg>
	<1ba2fa240807150129v4906b7bcyba66ab62b57c5d71@mail.gmail.com>
	(sfid-20080715_102953_982307_5BF8D17D)
	<1216111261.3535.7.camel@johannes.berg>
In-Reply-To: <1216111261.3535.7.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Di 15 Jul 2008 10:41:01 CEST schrieb Johannes Berg  
<johannes@sipsolutions.net>:

> Right, but it does make sense to advertise what we're using, and this
> patch just adds a strict "driver tells mac80211 what it's using" flow.
> That's mostly what I'm objecting to. If you were calling the variable
> "max_listen_interval" and having mac80211 send it back to the driver in
> the BSS config as bssconf->listen_interval, and, for now, simply use the
> max, I wouldn't have a problem with it.

Using "max_listen_interval" as default may possibly result in APs  
rejecting the association. At least the 802.11 spec defines a status  
code 51 with the description "Association denied because the  
ListenInterval is too large".

Maybe retrying the association with a lower listen interval could help  
here. Therefore I agree with Johannes that the decision about what  
value to actually use should be made in mac80211.

Helmut
