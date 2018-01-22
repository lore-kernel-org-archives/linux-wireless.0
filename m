Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:45814 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750970AbeAVM4F (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 07:56:05 -0500
Message-ID: <1516625763.2508.21.camel@sipsolutions.net> (sfid-20180122_135608_654253_59C6F729)
Subject: Re: [PATCH 1/4] wireless: allow send peer mac in rssi cqm notify
From: Johannes Berg <johannes@sipsolutions.net>
To: tamizhr@codeaurora.org
Cc: linux-wireless@vger.kernel.org, tamizhr@qti.qualcomm.com,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Date: Mon, 22 Jan 2018 13:56:03 +0100
In-Reply-To: <1516174276-16789-2-git-send-email-tamizhr@codeaurora.org>
References: <1516174276-16789-1-git-send-email-tamizhr@codeaurora.org>
         <1516174276-16789-2-git-send-email-tamizhr@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-01-17 at 13:01 +0530, tamizhr@codeaurora.org wrote:
> From: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
> 
> Extend cqm rssi notifier apis to include peer mac address. Currently
> netlink cqm msg already accepts the mac. With this change just passing
> the mac address as an argument to cfg and mac80211 apis.
> 
It seems eminently reasonable to have this functionality, but I'm not
sure you can implement it like this?

I'd be worried that there's some userspace that just listens for these
events and could get confused if another virtual interface shows up
with notifications - if it's not doing proper filtering etc.?

I'd be more comfortable at least moving the per-station notifications
to a new command ID, or making them opt-in by clients by having a
registration command and sending them unicast instead.

Or actually, perhaps the best would be to just go and create a new
multicast group for them, then we don't need a new command ID and
existing clients can't get confused, but new clients don't really have
to do anything but sign up to the new multicast group. We could check
if the group is non-empty before we even build the message too.

johannes
