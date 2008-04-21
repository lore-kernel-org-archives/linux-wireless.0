Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:13558 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbYDUFuj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 01:50:39 -0400
Received: by wa-out-1112.google.com with SMTP id m16so2863351waf.23
        for <linux-wireless@vger.kernel.org>; Sun, 20 Apr 2008 22:50:38 -0700 (PDT)
Subject: Re: [PATCH] mac80211: simplify code in util.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1208755440.2595.7.camel@debian.sh.intel.com>
References: <1208745396.7941.14.camel@brick>
	 <1208755440.2595.7.camel@debian.sh.intel.com>
Content-Type: text/plain
Date: Sun, 20 Apr 2008 22:50:54 -0700
Message-Id: <1208757054.7941.18.camel@brick> (sfid-20080421_065042_684134_B63BF636)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-04-21 at 13:24 +0800, Zhu Yi wrote:
> On Sun, 2008-04-20 at 19:36 -0700, Harvey Harrison wrote:
> > -		hdrlen += (fc & IEEE80211_STYPE_QOS_DATA)
> > -				>> (ilog2(IEEE80211_STYPE_QOS_DATA)-1);
> > +		if (fc & IEEE80211_STYPE_QOS_DATA)
> > +			hdrlen += 2;
> 
> You need also take other QoS types (i.e QOS_NULLFUNC) into
> consideration. Please take a look at WLAN_FC_IS_QOS_DATA macro.
> 

Well, that would be a change from what's there now, I've just got a
few pure cleanup patches I've done while making some changes in wpa.c
I'm going to submit the cleanup patches on their own first, then
patches with more substance.

Cheers,

Harvey

