Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43602 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab2GRPEq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2012 11:04:46 -0400
Message-ID: <1342623886.5310.10.camel@jlt3.sipsolutions.net> (sfid-20120718_170449_419728_6EE087C9)
Subject: Re: [PATCH] mac80211: flush stations before stop beaconing
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 18 Jul 2012 17:04:46 +0200
In-Reply-To: <1342614964-5826-1-git-send-email-eliad@wizery.com> (sfid-20120718_143605_797227_BF73C886)
References: <1342614964-5826-1-git-send-email-eliad@wizery.com>
	 (sfid-20120718_143605_797227_BF73C886)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-07-18 at 15:36 +0300, Eliad Peller wrote:
> When AP interface is going down, the stations
> are flushed (in ieee80211_do_stop()) only after
> the beaconing was stopped.
> 
> However, drivers might rely on stations being
> removed before the beaconing was stopped, in
> order to clean up properly.
> 
> Fix it by flushing the stations on ap stop.
> 
> (we already do the same for other interface
> types, e.g. in ieee80211_set_disassoc())
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>

Applied, thanks.

johannes

