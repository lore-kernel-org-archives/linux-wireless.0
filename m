Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.225]:63427 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759391AbYCEKAp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2008 05:00:45 -0500
Received: by wr-out-0506.google.com with SMTP id 50so2002772wra.13
        for <linux-wireless@vger.kernel.org>; Wed, 05 Mar 2008 02:00:44 -0800 (PST)
Message-ID: <c85cb4470803050200w6d981525w11688f0921867d5a@mail.gmail.com> (sfid-20080305_100048_108238_DC144A90)
Date: Wed, 5 Mar 2008 12:00:42 +0200
From: "Ron Rindjunsky" <ron.rindjunsky@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 05/11] mac80211: adding mac80211_tx_control_flags and HT flags
Cc: "Reinette Chatre" <reinette.chatre@intel.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Tomas Winkler" <tomas.winkler@intel.com>
In-Reply-To: <1204710116.25502.48.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1204682972-26004-1-git-send-email-reinette.chatre@intel.com>
	 <1204682972-26004-2-git-send-email-reinette.chatre@intel.com>
	 <1204682972-26004-3-git-send-email-reinette.chatre@intel.com>
	 <1204682972-26004-4-git-send-email-reinette.chatre@intel.com>
	 <1204682972-26004-5-git-send-email-reinette.chatre@intel.com>
	 <1204682972-26004-6-git-send-email-reinette.chatre@intel.com>
	 <1204710116.25502.48.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > Tx command can be a combination of any of these flags, along with
> > bitrate represented by ieee80211_rate. this will allow legacy drivers to
> > switch easily to any 11n rate representation.
>
> Looks good, but I wonder if there's any chance we'll see a generic rate
> control algorithm use these flags? I.e. one not tied to Intel HW and
> hidden in the iwlwifi subdir.
>
I sure hope so. the problem with current use of ieee80211_rates is
since it is targeted for ABG rates you can have all rates ready in
advance in the ieee80211_rates vector, but as soon an algorithm will
need to move those rates to siso/mimo, 40 mhz, ect. each combination
will multiple this vector, ending in a very big one. using the flags
will allow any rate scaling algorithm to keep using current
ieee80211_rates vector method, with any flags combination suitable.

ron
