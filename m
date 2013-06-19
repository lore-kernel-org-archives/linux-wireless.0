Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:54197 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934462Ab3FSQ5k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jun 2013 12:57:40 -0400
Message-ID: <51C1E2FF.3030309@candelatech.com> (sfid-20130619_185749_451807_8EB170EA)
Date: Wed, 19 Jun 2013 09:57:35 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] nl80211: fix attrbuf access race by allocating a separate
 one
References: <CA+55aFxOde8n0M2=77-TQ2Ea9iz8s-e8zGFwjj6RVyMFXBgxEA@mail.gmail.com>  <20130618.190632.33329016434510583.davem@davemloft.net>  <CA+55aFz=eG5-zh1toHxrx=4Qm4DvwyiBCU3u-6tc0-utfZ6xiA@mail.gmail.com>  (sfid-20130619_042459_700600_08CD35A3) <1371628488.8349.3.camel@jlt4.sipsolutions.net>  (sfid-20130619_095509_334897_6BA231FA) <1371630238.8349.6.camel@jlt4.sipsolutions.net>
In-Reply-To: <1371630238.8349.6.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/19/2013 01:23 AM, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Since my commit 3713b4e364, nl80211_dump_wiphy() uses the global
> nl80211_fam.attrbuf for parsing the incoming data. This wouldn't
> be a problem if it only did so on the first dump iteration which
> is locked against other commands in generic netlink, but due to
> space constraints in cb->args (the needed state doesn't fit) I
> decided to always parse the original message. That's racy though
> since nl80211_fam.attrbuf could be used by some other parsing in
> generic netlink concurrently.
>
> For now, fix this by allocating a separate parse buffer (it's a
> bit too big for the stack, currently 1448 bytes on 64-bit). For
> -next, I'll change the code to parse into the global buffer in
> the first round only and then allocate a smaller buffer to keep
> the state in cb->args.

The commit mentioned above (3713b4e364) is in 3.9.6, but this patch
doesn't come close to applying on my 3.9.6.

Do you happen to know if this should be backported to 3.9 stable or not?

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

