Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:48907 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933033Ab3EBUpt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 May 2013 16:45:49 -0400
Message-ID: <5182D078.4020605@candelatech.com> (sfid-20130502_224556_512232_51196E1D)
Date: Thu, 02 May 2013 13:45:44 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: mac80211:  3.9.0+:  Invalid WDS/flush state and non-connecting
 station.
References: <5182C38B.7060107@candelatech.com>  (sfid-20130502_215043_578677_76592D19) <1367526288.11375.2.camel@jlt4.sipsolutions.net>
In-Reply-To: <1367526288.11375.2.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/02/2013 01:24 PM, Johannes Berg wrote:
> On Thu, 2013-05-02 at 12:50 -0700, Ben Greear wrote:
>> Kernel is hacked 3.9.0+
>
> Clearly :)
>
>> I've been seeing this problem for a while (and posted about it previously).  The problem
>> is that a station appears to associate fine, but never actually 'connects'.  This problem
>> is not easy to reproduce...
>
> It would be useful to know what you added ... the message you point to
> (invalid wds/flush whatever) doesn't exist upstream.

Gobs of stuff, as usual.  Thought I had that WDS thing pushed upstream,
but I guess not.

http://dmz2.candelatech.com/git/gitweb.cgi?p=linux-3.9.dev.y/.git;a=summary

That message comes from:

	/*
	 * Remove all stations associated with this interface.
	 *
	 * This must be done before calling ops->remove_interface()
	 * because otherwise we can later invoke ops->sta_notify()
	 * whenever the STAs are removed, and that invalidates driver
	 * assumptions about always getting a vif pointer that is valid
	 * (because if we remove a STA after ops->remove_interface()
	 * the driver will have removed the vif info already!)
	 *
	 * This is relevant only in WDS mode, in all other modes we've
	 * already removed all stations when disconnecting or similar,
	 * so warn otherwise.
	 *
	 * We call sta_info_flush_cleanup() later, to combine RCU waits.
	 */
	flushed = sta_info_flush_defer(sdata);
	if ((sdata->vif.type != NL80211_IFTYPE_WDS && flushed > 0) ||
	    (sdata->vif.type == NL80211_IFTYPE_WDS && flushed != 1)) {
		sdata_info(sdata,
			   "Invalid WDS/flush state, type: %i  WDS: %i  flushed: %i\n",
			   sdata->vif.type, NL80211_IFTYPE_WDS, flushed);
		WARN_ON_ONCE(1);
	}

I notice __cfg80211_connect_result checks the wdev state, so I added some
printouts there to see if it is bailing due to some funny state, but will
probably be a while before I reproduce it again and know for sure.

Thanks,
Ben


>
> johannes
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

