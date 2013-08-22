Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:48064 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326Ab3HVOKP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Aug 2013 10:10:15 -0400
Received: by mail-ob0-f178.google.com with SMTP id ef5so3753925obb.9
        for <linux-wireless@vger.kernel.org>; Thu, 22 Aug 2013 07:10:13 -0700 (PDT)
Date: Thu, 22 Aug 2013 09:10:11 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] mac80211: ignore obviously bogus ECSAs in probe response
 frames
Message-ID: <20130822141011.GA24445@thinkpad-t410> (sfid-20130822_161025_980422_7E4EE525)
References: <1377179613-26591-1-git-send-email-seth.forshee@canonical.com>
 <1377180063.14110.23.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1377180063.14110.23.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 22, 2013 at 04:01:03PM +0200, Johannes Berg wrote:
> On Thu, 2013-08-22 at 08:53 -0500, Seth Forshee wrote:
> > The Netgear WNDAP360 sends invalid ECSA IEs in probe response
> > frames
> 
> I think we shouldn't be checking probe response frames at all. That
> seems like a mistake. Can you try this?

I had considered this, but the spec says that it's at least valid for
the AP to be sending ECSAs in probe responses. IEEE 802.11-2012 section
10.3.3.2:

  ...an AP shall inform associated STAs that the AP is moving to a new
  channel and/or operating class and maintain the association by
  advertising the switch using Extended Channel Switch Announcement
  elements in any transmitted Beacon frames, Probe Response frames, and
  Extended Channel Switch Announcement frames until the intended channel
  switch time.

Perhaps we can still ignore them though? I suppose we'd expect to
receive some other frame with the ECSA before it actually happens.

Seth
