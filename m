Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51963 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932430AbbLBJqy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Dec 2015 04:46:54 -0500
Message-ID: <1449049610.2449.3.camel@sipsolutions.net> (sfid-20151202_104704_583272_D0BEC947)
Subject: Re: pull-request: mac80211 2015-11-26
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 02 Dec 2015 10:46:50 +0100
In-Reply-To: <1448552352.2167.14.camel@sipsolutions.net> (sfid-20151126_163919_664516_CC0F7608)
References: <1448552352.2167.14.camel@sipsolutions.net>
	 (sfid-20151126_163919_664516_CC0F7608)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> ----------------------------------------------------------------
> A small set of fixes for 4.4:
>  * remove NL80211_FEATURE_FULL_AP_CLIENT_STATE again, it
>    was broken and needs more work, we'll enable it for 4.5
>  * fix call_rcu() induced use-after-reset/free in mesh
>    (that was suddenly causing issues in certain tests)
>  * always request block-ack window size 64 as we found
>    some APs will otherwise crash (really ...)
>  * fix P2P-Device teardown sequence to avoid restarting
>    with uninitialized data

I've got two more fairly important changes - one for regulatory issues
and one for an uninitialized variable that was leading to fairly
obscure bugs - do you prefer I wait, or send a new pull request
covering this one plus the two new fixes?

Thanks,
johannes
