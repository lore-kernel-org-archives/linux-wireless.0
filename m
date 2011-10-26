Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42630 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932879Ab1JZRWg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Oct 2011 13:22:36 -0400
Message-ID: <4EA7D8B5.5060306@sipsolutions.net> (sfid-20111026_192239_772806_E99A59B8)
Date: Wed, 26 Oct 2011 11:53:57 +0200
From: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
To: Eliad Peller <eliad@wizery.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: use min rate as basic rate for buggy APs
References: <1319531194-26839-1-git-send-email-eliad@wizery.com> (sfid-20111025_102706_344094_565C07C0)
In-Reply-To: <1319531194-26839-1-git-send-email-eliad@wizery.com> (sfid-20111025_102706_344094_565C07C0)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/25/2011 10:26 AM, Eliad Peller wrote:
> Some buggy APs (and even P2P_GO) don't advertise their
> basic rates in the association response.
>
> In such case, use the min supported rate as the
> basic rate.

I seem to vaguely remember discussing using mandatory rates, did we?

Also this seems like a last resort fallback, I'd really also try using 
the probe response information -- we should have that information still 
at this point. But maybe that doesn't make sense -- fix the APs instead!

I'd really like a (debug?) message here though. This is a stupid AP, and 
I will need to know if I'm debugging some throughput issues etc.

johannes
