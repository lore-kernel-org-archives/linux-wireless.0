Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:45566 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755441AbaC0SWs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Mar 2014 14:22:48 -0400
Message-ID: <1395944562.4111.0.camel@jlt4.sipsolutions.net> (sfid-20140327_192257_931237_67906796)
Subject: Re: [PATCH] mac80211: add vif to flush call
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date: Thu, 27 Mar 2014 19:22:42 +0100
In-Reply-To: <53346ABB.1060907@broadcom.com>
References: <1395912629-1458-1-git-send-email-egrumbach@gmail.com>
	 <53346ABB.1060907@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-03-27 at 19:15 +0100, Arend van Spriel wrote:
> On 03/27/14 10:30, Emmanuel Grumbach wrote:
> > From: Emmanuel Grumbach<emmanuel.grumbach@intel.com>
> >
> > This will allow the low level driver to make decision based
> > on the vif such as queues etc...
> > Since the vif might be NULL, we can't add it to the tracing
> > functions.
> 
> Although this argument sound fair my rule about interfaces is that a 
> change should be needed, ie. a low-level driver that needs the info, 
> instead of hypothetical use. You have one up your sleeve ? ;-)

Yeah, we do have a change for iwlmvm in the pipeline - the reason we
need the vif rather than just the queue bitmap there is that there are
(aggregation) queues that are hidden from mac80211's view.

johannes

