Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.186]:10051 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbYKNSgR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2008 13:36:17 -0500
Received: by ti-out-0910.google.com with SMTP id b6so922086tic.23
        for <linux-wireless@vger.kernel.org>; Fri, 14 Nov 2008 10:36:15 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <18717.50308.330801.765686@localhost.localdomain> (sfid-20081114_193619_710815_B4B097C1)
Date: Sat, 15 Nov 2008 00:03:40 +0530
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Sujith <m.sujith@gmail.com>, "Bob Copeland" <me@bobcopeland.com>,
	"Dan McGee" <dpmcgee@gmail.com>, linux-wireless@vger.kernel.org,
	"Michael Buesch" <mb@bu3sch.de>,
	"Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: Kernel oops when loading ath5k from compat-wireless in 2.6.27
In-Reply-To: <43e72e890811141029q24ad722fi6a7ae1e7dcd463bd@mail.gmail.com>
References: <449c10960811132146s40aef6c6ue8dfeef5ba29812a@mail.gmail.com>
	<43e72e890811132217k160db63ch77e7d03c38e81d5f@mail.gmail.com>
	<b6c5339f0811140902t7c7cfc0wa54c3cf578a620ff@mail.gmail.com>
	<43e72e890811140937h4dc03cf8g50df7f74efcd28b2@mail.gmail.com>
	<b6c5339f0811140949m462e3eecx49f114f729b33e7c@mail.gmail.com>
	<43e72e890811141006x1c396c78ube87a526f1435676@mail.gmail.com>
	<18717.49111.572993.44410@localhost.localdomain>
	<43e72e890811141029q24ad722fi6a7ae1e7dcd463bd@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> > From the original log:
> > ath5k_pci 0000:01:00.0: registered as ''
> 
> That comes from
> 
> dev_info(&pdev->dev, "registered as '%s'\n", wiphy_name(hw->wiphy));
> 
> which means that may be buggy too as wiphy_name() gets
> 
> return wiphy->dev.bus_id;
> 
> and we only have set at that point wiphy->dev.parent IIRC.
> 

Nope, parent is set after that call in SET_IEEE80211_DEV()
phy[x] gets assigned in alloc_hw().

So why is it NULL even if alloc_hw() succeeds ?

Sujith
