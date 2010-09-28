Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60131 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755915Ab0I1PSk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 11:18:40 -0400
Subject: Re: [PATCH 2/2] mac80211:  Allow scanning single channel if other
 VIF is associated.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4CA206F0.40607@candelatech.com>
References: <1285632457-27539-1-git-send-email-greearb@candelatech.com>
	 <1285632457-27539-2-git-send-email-greearb@candelatech.com>
	 <1285658564.3885.1.camel@jlt3.sipsolutions.net>
	 <4CA1F2A4.2090005@candelatech.com>
	 <1285682224.3885.18.camel@jlt3.sipsolutions.net>
	 <4CA206F0.40607@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Sep 2010 17:18:40 +0200
Message-ID: <1285687120.3885.20.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-09-28 at 08:17 -0700, Ben Greear wrote:

> > You can run all networks in a single wpa_s instance, I believe, and then
> > it'd know about all this, right?
> 
> But then, if you want to add an additional interface, you have to restart
> everything.

Well, you can add it dynamically over dbus or the unix socket control
interface.

> I was thinking that maybe I could keep the logic in wpa_s, but instead of
> all the special casing, just locate the current associated channel for the
> phy in question and populate the scan-req with that single channel.
> 
> Then, I think I wouldn't have to muck with much of the scan logic..just
> a bit of code on the entry point to select the proper channel.
> 
> Does that sound like a possible solution to you?

I don't care all that much, but I really don't like the in-kernel
workaround. For that, you'd have to iterate over "iw <wlanX> link" I
suppose.

johannes

