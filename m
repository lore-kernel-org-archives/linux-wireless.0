Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:40344 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567AbbHNA05 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2015 20:26:57 -0400
Date: Thu, 13 Aug 2015 17:26:55 -0700 (PDT)
Message-Id: <20150813.172655.794541030036505262.davem@davemloft.net> (sfid-20150814_022700_456030_2C423706)
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	johannes.berg@intel.com
Subject: Re: [PATCH 1/2] average: provide macro to create static EWMA
From: David Miller <davem@davemloft.net>
In-Reply-To: <1439457109-21833-1-git-send-email-johannes@sipsolutions.net>
References: <1439457109-21833-1-git-send-email-johannes@sipsolutions.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Thu, 13 Aug 2015 11:11:48 +0200

> From: Johannes Berg <johannes.berg@intel.com>
> 
> Having the EWMA parameters stored in the runtime struct imposes
> memory requirements for the constant values that could just be
> inlined in the code. This particularly makes sense if there are
> a lot of such structs, for example in mac80211 in the station
> table where each station has a number of these in an array, and
> there can be many stations.
> 
> Provide a macro DECLARE_EWMA() that declares the necessary struct
> and inline functions to access it with the parameters hard-coded;
> using this also means the user no longer needs to 'select AVERAGE'
> as it's entirely self-contained.
> 
> In the mac80211 case, on x86-64, this actually slightly *reduces*
> code size, while also saving 80 bytes of runtime memory per sta.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
> As the next patch relies on this, I'll take this through my tree
> unless I hear objections.

This looks fine to me.
