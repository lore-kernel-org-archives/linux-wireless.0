Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:55407 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932223AbXCUPYV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Mar 2007 11:24:21 -0400
Date: Wed, 21 Mar 2007 16:24:19 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Andy Green <andy@warmcat.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Faking powersave for fun and realtime channel muxing
Message-ID: <20070321162419.09b45703@griffin.suse.cz>
In-Reply-To: <45FEEB34.1000403@warmcat.com>
References: <45FEEB34.1000403@warmcat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 19 Mar 2007 19:57:40 +0000, Andy Green wrote:
> Depending on the limitations of the time you can arrange to "sleep" with 
> the AP, using this technique you could even associate multiple logical 
> interfaces to APs on different channels despite they are sharing one 
> physical radio.  That could be cool for dealing with realtime selection 
> of the best channel/AP when the guy is mobile, for example.

Nice idea, but it won't work. You are completely dependent on AP's
timing and if the beacon interval and DTIM period is the same at both
APs (that's quite likely) and DTIMs are sent at more or less the same
time (that could happen), bad luck. How would you explain to users that
it won't work in some random cases?

Using the time between two DTIMs to tune to other channels for other
purposes (like _active_ scanning - note that passive scanning won't
work) or getting rough idea of channels usage could work. But as was
already noted, it requires tx traffic to be buffered, thus degrading
performance. You need to balance these two things pretty well - not an
easy job, I would say.

Also, consider that an amount of time required to tune to another
channel is not zero.

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
