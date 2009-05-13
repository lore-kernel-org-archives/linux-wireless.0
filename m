Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:46852 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbZEMAuj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2009 20:50:39 -0400
Received: by ewy24 with SMTP id 24so434442ewy.37
        for <linux-wireless@vger.kernel.org>; Tue, 12 May 2009 17:50:38 -0700 (PDT)
Subject: Re: [BUG] scans can still hang with -EBUSY on iwl3945
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: reinette chatre <reinette.chatre@intel.com>,
	iwlwifi maling list <ipw3945-devel@lists.sourceforge.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1242170403.14227.18.camel@johannes.local>
References: <1241179203.8086.3.camel@maxim-laptop>
	 <1241193513.10498.97.camel@rc-desk> <1241208792.7082.47.camel@maxim-laptop>
	 <1241227946.5192.3.camel@maxim-laptop>
	 <1241374060.13562.37.camel@johannes.local>
	 <1241387163.10486.6.camel@maxim-laptop>
	 <1241421545.6866.2.camel@johannes.local>
	 <1242161643.26484.2.camel@maxim-laptop>
	 <1242169824.5146.31.camel@maxim-laptop>
	 <1242169934.14227.16.camel@johannes.local>
	 <1242170080.5146.32.camel@maxim-laptop>
	 <1242170403.14227.18.camel@johannes.local>
Content-Type: text/plain
Date: Wed, 13 May 2009 03:50:33 +0300
Message-Id: <1242175833.5154.2.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-05-13 at 01:20 +0200, Johannes Berg wrote:
> On Wed, 2009-05-13 at 02:14 +0300, Maxim Levitsky wrote:
> 
> > > So it's a bug in iwlwifi, it neither rejects nor executes a scan when in
> > > rfkill.
> > But I use disable_hw_scan=1 !
> 
> Load the driver with debug=1 and see what it shows then. I don't think
> there's a way for mac80211 to get stuck.
> 
> Also you could stick some printks into
> net/mac80211/scan.c:ieee80211_scan_work() at strategic places and see...
> but if they never happen you haven't turned off hw scan.
You know, you are right, it turns out that hw scan was active (due to
all the experimentation, I forgot to turn it off...) and it is obvious
that iwlwifi has rfkill related bugs there, I handle that later.

But without hw scan, something is still there, I sooneer or later will
understand.

Best regards, and sorry
	Maxim Levitsky




