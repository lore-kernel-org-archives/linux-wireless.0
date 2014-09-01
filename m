Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:53812 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638AbaIAMdO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Sep 2014 08:33:14 -0400
From: Shakil A Khan <shakilk1729@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/2] nl80211.c: Fixed the wdev_id being used uninitialized.
Date: Mon, 1 Sep 2014 08:33:10 -0400
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, davem@davemloft.net, linville@tuxdriver.com
References: <1409572467-50908-1-git-send-email-shakilk1729@gmail.com> <1409573258.2703.0.camel@jlt4.sipsolutions.net>
In-Reply-To: <1409573258.2703.0.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201409010833.10647.shakilk1729@gmail.com> (sfid-20140901_143502_040409_7AAC5BD1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 01 September 2014 08:07:38 Johannes Berg wrote:
> > +	u64 wdev_id = 0;
> 
> it's not used uninitialized, NACK.
> 
> johannes
> 

wdev_id can be used uninitialized if  have_wdev_id turns to be false, which may happen if the entry for NL80211_ATTR_WDEV is removed in future. Who knows.
