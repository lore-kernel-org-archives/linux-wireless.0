Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:59875 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1031037AbXD3R3Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Apr 2007 13:29:16 -0400
Date: Mon, 30 Apr 2007 19:29:51 +0200
From: Jiri Benc <jbenc@suse.cz>
To: James Ketrenos <jketreno@linux.intel.com>
Cc: linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>,
	John Linville <linville@tuxdriver.com>
Subject: Re: "Stable" branch of mac80211
Message-ID: <20070430192951.26bdf1df@griffin.suse.cz>
In-Reply-To: <46361EE3.6060107@linux.intel.com>
References: <20070429194855.451b9e7c@logostar.upir.cz>
	<46361EE3.6060107@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 30 Apr 2007 09:52:51 -0700, James Ketrenos wrote:
> I'm curious what the criteria was for removing code from 'stable'  
> 
> Are there known bugs/oops?  Is it known to be broken, or ?  
> 
> For code we know we ultimately want to be redone, removed, or whatever,
> I can understand not wanting to merge the code.

AP and user space MLME mode don't have clarified user space interface.
We don't want to support the current mess (mgmt interface) forever. WDS
is tightly linked with AP.

802.11n code is not deeply reviewed by anyone and thus it's unclear
whether it will need to be changed (I already heard some objections) or
not.

> However we ultimately want AP, WDS, and 802.11n.

We ultimately want STA mode and - maybe - IBSS. Other things are just
nice to have. They will still stay in wireless-dev, of course.

> At least with 802.11n, I haven't seen anything indicating the code
> needs to be done any differently than it is currently being done.  

Nobody uses it. I don't see a reason why it needs to go in now. I
really want those patches to be reviewed by someone before considering
them "stable". It can be me, but I need some time to study .11n draft,
or someone else experienced with different hw designs.

> I assume the entire new tree will be marked as 'experimental', so what
> is the advantage gained by pulling this code out now?

Once the code is in vanilla, user space interfaces are set in stone.
Regarding .11n, untested and unreviewed patches shouldn't go to vanilla.

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
