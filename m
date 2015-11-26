Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39191 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457AbbKZUVl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 15:21:41 -0500
Message-ID: <1448569296.2167.45.camel@sipsolutions.net> (sfid-20151126_212144_228593_03CF48E6)
Subject: Re: (bug report) iwlwifi: inconsitent NULL checking
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 26 Nov 2015 21:21:36 +0100
In-Reply-To: <20151126194451.GH7289@mwanda>
References: <20151126120317.GJ10556@mwanda>
	 <1448540211.2167.7.camel@sipsolutions.net> <20151126123756.GF7289@mwanda>
	 <1448542297.2167.10.camel@sipsolutions.net> <20151126194451.GH7289@mwanda>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-11-26 at 22:44 +0300, Dan Carpenter wrote:
> 
> The first problem is that it doesn't see that if mvm_sta is non-NULL
> then that implies lq_sta is non-NULL.  But even if that worked, after
> we do the function call, it sees that the function that mvm_sta is
> non-NULL but it wouldn't see that that means lq_sta is non-
> NULL.  It's not so terribly far from working but it's not there yet.
> 

Ah, yes, I completely forgot that it's two (related) variables :)

johannes
