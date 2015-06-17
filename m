Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46926 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752914AbbFQJOR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 05:14:17 -0400
Message-ID: <1434532453.1884.26.camel@sipsolutions.net> (sfid-20150617_111420_547572_ACDB21BF)
Subject: Re: [PATCH] wireless:  Add ifname to STOP_AP event.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Wed, 17 Jun 2015 11:14:13 +0200
In-Reply-To: <1433974625-327-1-git-send-email-greearb@candelatech.com>
References: <1433974625-327-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-06-10 at 15:17 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> In case user-space wants to know the name of the
> device, this will save a name lookup by index, and
> in case where kernel manages to fully delete the
> interface before user-space can determine the name,
> this will ensure user-space has proper name.

None of this reasoning is specific to the STOP_AP event, and I'd hate us
adding it one by one...

I still think there isn't all that much reason to have it (if userspace
really needs the names so badly it could also subscribe to the rtnetlink
and keep a table of index/names!), but I could get behind a refactoring
of all these places (I count at least 10 events that include the wdev
id) to combine the four lines in the patch below into a single helper.

johannes

