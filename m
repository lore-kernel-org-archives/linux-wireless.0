Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:8890 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753959AbXEJDUk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 May 2007 23:20:40 -0400
Subject: Re: [PATCH] mac80211: fail back to use associate from reassociate
From: Zhu Yi <yi.zhu@intel.com>
To: Jouni Malinen <jkm@devicescape.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20070509152855.GB941@devicescape.com>
References: <20070509054152.GA30839@mail.intel.com>
	 <20070509152855.GB941@devicescape.com>
Content-Type: text/plain
Date: Thu, 10 May 2007 11:20:50 +0800
Message-Id: <1178767250.3045.36.camel@debian.sh.intel.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-05-09 at 08:28 -0700, Jouni Malinen wrote:
> Can you please identify such an AP? This sounds like a workaround that
> makes the non-AP STA (client) behave in a way that does not match with
> IEEE 802.11 standard and in general, I'm against this change without a
> very good reason for it. 

I take it an error handling code. When an AP denies a STA reassociation
request with the reason "there is no previous association, why do you
send reassociation request to me?", this is an indication for the STA to
switch to association request and retry. Currently, mac80211 just try
reassociation over and over. The result is it can never associate with
the AP.

I don't see how it breaks the 802.11 standard. If you do, please point
it out and how are you going to fix this problem?

> This type of change would, e.g., break IEEE
> 802.11r fast transition which can only be done using reassociation. 

In .11r, can AP reject reassociation request if there is no previous
association from the same STA?

Thanks,
-yi
