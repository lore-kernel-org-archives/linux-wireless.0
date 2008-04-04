Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.188]:17941 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbYDDLYT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Apr 2008 07:24:19 -0400
Received: by rn-out-0910.google.com with SMTP id e24so7681rng.1
        for <linux-wireless@vger.kernel.org>; Fri, 04 Apr 2008 04:24:18 -0700 (PDT)
Message-ID: <1ba2fa240804040418l5a5edce3u2f4ce868e65cd8bf@mail.gmail.com> (sfid-20080404_122422_151317_BA980DC6)
Date: Fri, 4 Apr 2008 14:18:06 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH/RFC v3] mac80211: proper STA info locking
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Ron Rindjunsky" <ron.rindjunsky@intel.com>,
	"Luis Carlos Cobo" <luisca@cozybit.com>
In-Reply-To: <1207228472.3636.69.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1206569781.22530.18.camel@johannes.berg>
	 <1207056452.5143.95.camel@johannes.berg>
	 <1207067026.5143.120.camel@johannes.berg>
	 <1207228472.3636.69.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 3, 2008 at 4:14 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>
>  On Tue, 2008-04-01 at 18:23 +0200, Johannes Berg wrote:
>  > As discussed earlier, we can unify locking in struct sta_info
>  > and use just a single spinlock protecting all members of the
>  > structure that need protection. Many don't, but one of the
>  > especially bad ones is the 'flags' member that can currently
>  > be clobbered when RX and TX is being processed on different
>  > CPUs at the same time.
>
>  No objections? I remember Tomas wasn't entirely happy with the
>  suggestion that RX/TX aggregation don't need separate spinlocks.

Yes starting TX and RX aggregation happens usually proximately at the
same time, i.e. both sides  of the link decide at the same time that
it's worth to start the hight throughput traffic.
We didn't get to investigating if the single lock will be a problem.
Unfortunately there are too many open issues currently so we need to
prioritize.
I think it's time we push multqueue in, otherwise we will have to push
some ugly patches to solve some problems with aggregation we found
lately.

Thanks
Tomas


>  johannes
>
