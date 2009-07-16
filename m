Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:7871 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757165AbZGPDHI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jul 2009 23:07:08 -0400
Subject: Re: [PATCH v3] cfg80211: rework key operation
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1247669030.10754.1.camel@johannes.local>
References: <1247051586.4755.81.camel@johannes.local>
	 <1247052613.12857.0.camel@johannes.local>
	 <1247055774.24749.0.camel@johannes.local> <1247647086.3695.48.camel@debian>
	 <1247650666.14973.0.camel@johannes.local>
	 <1247669030.10754.1.camel@johannes.local>
Content-Type: text/plain
Date: Thu, 16 Jul 2009 11:07:07 +0800
Message-Id: <1247713627.3695.60.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-07-15 at 22:43 +0800, Johannes Berg wrote:
> I should also note that you can now get rid of the stuff in iwm that
> caches the keys etc -- key callbacks will only be called after
> connecting.

Thanks. Patches are queued. Will send out later.

> As discussed with Samuel, there's a possibility to pass _all_ WEP keys
> directly to connect(), if desirable, instead of adding them with the
> key hooks later.

I think this should be the right way to go. Currently we have no way to
connect to WEP APs (both open and shared) with iwconfig. Because the
driver needs to set the correct cipher before connect. But the key
callbacks are only called after connected... IWAUTH is expected to be
the place to set the cipher here, but unfortunately iwconfig doesn't use
it. Passing the WEP keys to connect() can solve this issue. The driver
can at least parsing the connect parameters to set the correct cipher
before connect.

Thanks,
-yi

