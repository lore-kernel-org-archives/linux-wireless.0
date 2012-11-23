Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail022-1.exch022.serverdata.net ([64.78.22.98]:50519 "EHLO
	mail022-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030282Ab2KWJ4Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2012 04:56:25 -0500
Message-ID: <50AF4844.2040001@posedge.com> (sfid-20121123_105633_370138_E64C4678)
Date: Fri, 23 Nov 2012 15:26:20 +0530
From: Saravana <saravanad@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Julian Calaby <julian.calaby@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: RFC[1/2]mac80211: Add Statistic to debugfs
References: <50AF0E91.30709@posedge.com>  <CAGRGNgW1x0O26SxytoDQLYXFqWcmfaCGE=Q_pxGg31mW0HyRtw@mail.gmail.com>  <50AF1A1E.8090704@posedge.com> <1353654716.10197.0.camel@jlt4.sipsolutions.net>
In-Reply-To: <1353654716.10197.0.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,
On 11/23/2012 12:41 PM, Johannes Berg wrote:
> On Fri, 2012-11-23 at 12:09 +0530, Saravana wrote:
>
>>> Also, as you're adding new statistics which are only used when debugfs
>>> is enabled, you might want to wrap them in #ifdefs so that they're
>>> only compiled when debugfs support is compiled.
>
> [...]
>> Hence we don't need to wrap this up in #ifdef as it is already taken
>> care during the directory creation.
>
> I think Julian is arguing that you should have the *counters* themselves
> be under ifdef, and I tend to agree.
>
When we went through the make file of mac80211, it is seen that the only 
when CONFIG_MAC80211_DEBUGFS macro is enabled, the files debugfs.c, 
debugfs_sta.c, debugfs_netdev.c, debugfs_key.c are compiled in.

So it may not be required to wrap up any piece of code in these files 
are they will not be compiled in the first place when the macro 
CONFIG_MAC80211_DEBUGFS is disabled.
Let me know your thoughts on this.
> johannes
>
>

