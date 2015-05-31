Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50958 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753239AbbEaIbe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 May 2015 04:31:34 -0400
Message-ID: <1433061092.2370.1.camel@sipsolutions.net> (sfid-20150531_103140_329334_C6320DCA)
Subject: Re: [PATCH v2] cfg80211: Don't re-use the skb for larger NL
 messages.
From: Johannes Berg <johannes@sipsolutions.net>
To: Chaitanya T K <chaitanya.mgit@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Sun, 31 May 2015 10:31:32 +0200
In-Reply-To: <1433028494-9665-1-git-send-email-chaitanya.mgit@gmail.com> (sfid-20150531_012825_827034_87A26BAD)
References: <1433028494-9665-1-git-send-email-chaitanya.mgit@gmail.com>
	 (sfid-20150531_012825_827034_87A26BAD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2015-05-31 at 04:58 +0530, Chaitanya T K wrote:
> cfg80211 reuses the skb before asking for a fresh on from genl framework, 
> this works efficiently for smaller messages but NLM_F_DUMP is normally 
> used to transport larger data normally > PAGE_SIZE, so if the message 
> occupies more than GOODSIZE its better to ask for a new, saves couple
> of hanshakes with the driver.
> 
> This improves the time to get the DUMP response across to user space.

This doesn't make any sense. If the driver is slow to actually create
the data, it should implement this logic, but realistically the driver
should just check if there's enough space and only try to create data to
put into the skb if it's sufficient?

It sounds to me like you're actually interacting with the hardware at
this point (otherwise it wouldn't be slow!) which pretty much seems
wrong anyway.

johannes

