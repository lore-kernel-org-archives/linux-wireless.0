Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57870 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167Ab2LNS7C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Dec 2012 13:59:02 -0500
Message-ID: <1355511551.9571.10.camel@jlt4.sipsolutions.net> (sfid-20121214_195908_351167_5F8D19B3)
Subject: Re: [PATCH/RFC] nl80211/cfg80211/mac80211: add
 NL80211_CMD_GET_MESH_SETUP
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: devel@lists.open80211s.org, linux-wireless@vger.kernel.org
Date: Fri, 14 Dec 2012 19:59:11 +0100
In-Reply-To: <CAPjQAd8-pFCRQLb=t4Cx+RaLbU8ZMT5_1Xc36sNsRgjm4NdgJw@mail.gmail.com> (sfid-20121214_191745_479609_553E8FC2)
References: <20121214151442.GA10736@localhost>
	 <CAPjQAd8-pFCRQLb=t4Cx+RaLbU8ZMT5_1Xc36sNsRgjm4NdgJw@mail.gmail.com>
	 (sfid-20121214_191745_479609_553E8FC2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-12-14 at 10:17 -0800, Javier Cardona wrote:

> > +       setup->is_authenticated = ifmsh->security & IEEE80211_MESH_SEC_AUTHED;
> +       setup->is_authenticated = !!(ifmsh->security &
> IEEE80211_MESH_SEC_AUTHED));
> 
> i.e. to force the value to be 0 or 1.

is_authenticate is a bool, so no need, the compiler has to do it.

johannes

