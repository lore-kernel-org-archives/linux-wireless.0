Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59817 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbaBTH7o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 02:59:44 -0500
Message-ID: <1392883180.5073.5.camel@jlt4.sipsolutions.net> (sfid-20140220_085947_617740_AD720024)
Subject: Re: [PATCH 2/2] mac80211: protect skb_queue_len(&ps->bc_buf) by lock
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 20 Feb 2014 08:59:40 +0100
In-Reply-To: <20140220075639.GA23439@redhat.com>
References: <1392812916-13656-1-git-send-email-sgruszka@redhat.com>
	 <1392812916-13656-2-git-send-email-sgruszka@redhat.com>
	 <1392815649.4733.23.camel@jlt4.sipsolutions.net>
	 <20140219133546.GE1851@redhat.com>
	 <1392821503.4733.26.camel@jlt4.sipsolutions.net>
	 <20140219150937.GH1851@redhat.com>
	 <1392827818.4733.27.camel@jlt4.sipsolutions.net>
	 <20140220075639.GA23439@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-02-20 at 08:56 +0100, Stanislaw Gruszka wrote:
> On Wed, Feb 19, 2014 at 05:36:58PM +0100, Johannes Berg wrote:
> > Well, OK, so there's some small window of time where the drop code isn't
> > perfect. Does it matter? I'd argue it doesn't - if you're getting close
> > to the drop case then the client is probably misbehaving anyway.
> 
> Ok, let drop those patches. Do you want me to repost first patch with
> just if(old) check to fix kaboom, or you prefer to problem be solved
> properly at once ?

Emmanuel posted his patch, so I think I'll just pick that up. Care to
review it?

johannes

