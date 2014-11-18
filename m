Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59009 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499AbaKRH75 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Nov 2014 02:59:57 -0500
Message-ID: <1416297593.1939.1.camel@sipsolutions.net> (sfid-20141118_090000_524189_FBD15EB8)
Subject: Re: Error code -149 trying to receive Probe Requests using
 NL80211_CMD_REGISTER_FRAME
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul <ptcongdon@ucdavis.edu>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 18 Nov 2014 08:59:53 +0100
In-Reply-To: <loom.20141118T054805-587@post.gmane.org> (sfid-20141118_060256_456012_8635C1A6)
References: <loom.20141118T054805-587@post.gmane.org>
	 (sfid-20141118_060256_456012_8635C1A6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-11-18 at 04:53 +0000, Paul wrote:
> Hello,
> 
> I'm trying to write an linux process that will receive Probe Request 
> messages from nl80211 using NL80211_CMD_REGISTER_FRAME.   This process 
> will run at the same time hostapd is doing its job.  Is it possible for 
> multiple linux processes to receive the same set of Probe Request messages 
> this way?   I'm getting an error code -149 after issuing my 
> NL80211_CMD_REGISTER_FRAME command. The command is exactly the same 
> command that hostapd is issuing.  It looks like -149 implies EALREADY, 
> which leads me to believe that only one process can register for these 
> frames?  Any suggestions or examples of successfully using 
> NL80211_CMD_REGISTER_FRAME in a separate user space program?

This is (intentionally) not possible since only one of them should be
responding.

Depending on your use cases, you could open an additional monitor
interface and look at all the frames there, or hook out of hostapd for
example.

Of course you can always hack out the check and change the delivery code
to deliver to multiple userspace processes, but I don't think that's
really a good change for upstream.

johannes

