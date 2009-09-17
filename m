Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f175.google.com ([209.85.211.175]:58948 "EHLO
	mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbZIQXMB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2009 19:12:01 -0400
Received: by mail-yw0-f175.google.com with SMTP id 5so650736ywh.4
        for <linux-wireless@vger.kernel.org>; Thu, 17 Sep 2009 16:12:05 -0700 (PDT)
Subject: Re: regression?  No connection with master-2009-09-16 was fine
 until master-2009-09-14
From: ASIC Felix <ic.felix@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <20090917195141.GB2562@tuxdriver.com>
References: <1253208348.6601.17.camel@darkslate>
	 <20090917195141.GB2562@tuxdriver.com>
Content-Type: text/plain
Date: Thu, 17 Sep 2009 16:06:31 -0700
Message-Id: <1253228791.6914.2.camel@darkslate>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-09-17 at 15:51 -0400, John W. Linville wrote:
> On Thu, Sep 17, 2009 at 10:25:48AM -0700, ASIC Felix wrote:
> > Hi,
> > 
> > with master-2009-09-16 my laptop can no longer connect to the network.
> > I can see all the APs, but can't connect.
> > The issue is new, w-t kernel master-2009-09-14 was fine.
> > 
> > Sorry for pasting the whole /var/log/messages from boot to boot,
> > but I see anything obvious by myself.
> 
> Perhaps you could bisect between master-2009-09-14 and
> master-2009-09-16?  There are only a handful of patches.

]$ git bisect good
389ce02fdca74c15984edced7a2f1879fe08a8b1 is first bad commit
commit 389ce02fdca74c15984edced7a2f1879fe08a8b1
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Wed Sep 16 09:04:26 2009 -0700

    cfg80211: fix SME connect
    
    There's a check saying
    	/* we're good if we have both BSSID and channel */
    	if (wdev->conn->params.bssid && wdev->conn->params.channel) {


This commit prevents connection for me.

Best regards,
Felix

