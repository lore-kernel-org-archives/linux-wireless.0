Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:57250 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932167Ab2LNTB3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Dec 2012 14:01:29 -0500
Received: by mail-ie0-f174.google.com with SMTP id c11so6430090ieb.19
        for <linux-wireless@vger.kernel.org>; Fri, 14 Dec 2012 11:01:29 -0800 (PST)
Date: Fri, 14 Dec 2012 14:00:27 -0500
From: Bob Copeland <me@bobcopeland.com>
To: devel@lists.open80211s.org
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH/RFC] nl80211/cfg80211/mac80211: add
 NL80211_CMD_GET_MESH_SETUP
Message-ID: <20121214190027.GE3078@localhost> (sfid-20121214_200133_136715_A75F0DBB)
References: <20121214151442.GA10736@localhost>
 <CAPjQAd8-pFCRQLb=t4Cx+RaLbU8ZMT5_1Xc36sNsRgjm4NdgJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAPjQAd8-pFCRQLb=t4Cx+RaLbU8ZMT5_1Xc36sNsRgjm4NdgJw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 14, 2012 at 10:17:24AM -0800, Javier Cardona wrote:

Thanks for the review!

> > +       setup->is_authenticated = ifmsh->security & IEEE80211_MESH_SEC_AUTHED;
> +       setup->is_authenticated = !!(ifmsh->security &
> IEEE80211_MESH_SEC_AUTHED));
> 
> i.e. to force the value to be 0 or 1.

Agreed if they were ints, but in this case .is_authenticated and
.is_secure are type bool, so it shouldn't make a difference, right?

-- 
Bob Copeland %% www.bobcopeland.com
