Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.225]:8511 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895AbXFLHho (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2007 03:37:44 -0400
Received: by wx-out-0506.google.com with SMTP id t15so1708261wxc
        for <linux-wireless@vger.kernel.org>; Tue, 12 Jun 2007 00:37:43 -0700 (PDT)
Message-ID: <1ba2fa240706120037g767a330fsa1e838f378ce2b58@mail.gmail.com>
Date: Tue, 12 Jun 2007 10:37:43 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [Take 2] mac80211 IEEE802.11e/WMM code cleanup
Cc: yi.zhu@intel.com, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1181584907.29767.30.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <20070611085950.GA5540@mail.intel.com>
	 <1181584907.29767.30.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6/11/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> Hi Yi,
>
> In sta_process_dls_req, you currently always accept DLS. I'm not sure
> how well power save mode works in mac80211 (probably not at all, someone
> versed in 802.11 should probably look at it some time soon), but once
> DLS is set up power saving must be disabled by the DLS peer. This,
> however, possibly leads to battery lifetime diminishing, so always
> accepting the direct link might not be desirable. Any thoughts?
>

This is correct that power save must be disabled explicitly in this
implementation.  Usually you want to establish DLS for increasing
throughput so you won't go to power save mode anyway.

One other thing is encryption, the path for peer key handshake must be
opened in mac80211 in addition to this patch.


> Should we have user-space controlled list of DLS possible DLS peers? Or
> call out to userspace via nl80211 to make a decision? The list would be
> easy by simply adding a sta_info for a possible DLS peer, callout also
> shouldn't be too hard by sending a message to some QoS nl80211 multicast
> group and possibly not responding to the DLS request at all when our
> userspace doesn't accept it (that way it'll just time out on the other
> side).
>
> johannes
>
>
