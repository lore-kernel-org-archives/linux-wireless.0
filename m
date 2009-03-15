Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.237]:21035 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbZCOSrR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Mar 2009 14:47:17 -0400
Received: by rv-out-0506.google.com with SMTP id g37so1229062rvb.1
        for <linux-wireless@vger.kernel.org>; Sun, 15 Mar 2009 11:47:15 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <18877.19828.446040.815905@gargle.gargle.HOWL> (sfid-20090315_194722_143459_E0B4189A)
Date: Mon, 16 Mar 2009 00:18:20 +0530
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	me@bobcopeland.com
Subject: Re: [PATCH] mac80211: Tear down aggregation sessions for
 suspend/resume
In-Reply-To: <1237140134.24621.0.camel@johannes.local>
References: <18876.41851.397740.847705@gargle.gargle.HOWL>
	<1237140134.24621.0.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Sun, 2009-03-15 at 12:13 +0530, Sujith wrote:
> > When the driver has been notified with a STA_REMOVE, it tears down
> > the internal ADDBA state. On resume, trying to initiate aggregation would
> > fail because mac80211 has not cleared the operational state for that <TID,STA>.
> > This can be fixed by tearing down the existing sessions on a suspend.
> 
> Agreed, but Bob said there were some deadlocks with this?
> 

It works with ath9k, I don't see any deadlocks.
And I have been testing with the 'reset' debugfs file.
Too lazy to do a full suspend/resume cycle. :)
It shouldn't matter though, right ?

Sujith
