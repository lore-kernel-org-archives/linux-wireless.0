Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53342 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab1EDQu6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 May 2011 12:50:58 -0400
Subject: Re: [RFC] mac80211: reestablish mis-configured existing Rx BA
 sessions
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
In-Reply-To: <1304413928-17673-1-git-send-email-arik@wizery.com> (sfid-20110503_111236_686946_877B0C73)
References: <1304413928-17673-1-git-send-email-arik@wizery.com>
	 (sfid-20110503_111236_686946_877B0C73)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 May 2011 18:50:57 +0200
Message-ID: <1304527857.3563.24.camel@jlt3.sipsolutions.net> (sfid-20110504_185103_668897_C0CA52A4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-05-03 at 12:12 +0300, Arik Nemtsov wrote:
> When forming a Rx BA session, sometimes the ADDBA response gets lost.
> This leads to a situation where the session is configured locally, but
> doesn't exist on the remote side. Subsequent ADDBA requests are declined
> by mac80211.
> 
> Fix this by assuming the session state of the initiator is the correct
> one. When receiving an unexpected ADDBA request on a TID with an active
> Rx BA session, delete the existing one and establish a new session.

I thought about this for a while but I don't really have an opinion I
think. Maybe the behaviour could be avoided by checking the ack status,
but that wouldn't be good enough for devices that don't have that...

johannes

