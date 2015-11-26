Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37017 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046AbbKZMvk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 07:51:40 -0500
Message-ID: <1448542297.2167.10.camel@sipsolutions.net> (sfid-20151126_135143_600218_B35D0111)
Subject: Re: (bug report) iwlwifi: inconsitent NULL checking
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 26 Nov 2015 13:51:37 +0100
In-Reply-To: <20151126123756.GF7289@mwanda>
References: <20151126120317.GJ10556@mwanda>
	 <1448540211.2167.7.camel@sipsolutions.net> <20151126123756.GF7289@mwanda>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-11-26 at 15:37 +0300, Dan Carpenter wrote:
> 
> Ah.  Thanks for looking at this.  Eventually Smatch will be smart
> enoughto figure this implication out but not yet.  No need to change 
> the code because the static checker isn't capable enough...
> 

Actually I just had an idea - we should put those two *checks* into an
inline anyway since they're actually really unlikely and we might not
want to take the function call every time...

So I thought that smatch would then be able to see through it, since
it's now an inline, but it doesn't seem like it can?

https://p.sipsolutions.net/a162ca550f675800.txt

johannes
