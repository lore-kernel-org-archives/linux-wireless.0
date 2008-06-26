Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.240]:56630 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbYFZVfq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2008 17:35:46 -0400
Received: by an-out-0708.google.com with SMTP id d40so48681and.103
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jun 2008 14:35:44 -0700 (PDT)
Message-ID: <43e72e890806261435t3d06e955x590a6fafb223bbca@mail.gmail.com> (sfid-20080626_233552_200571_E0FA6500)
Date: Thu, 26 Jun 2008 14:35:42 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: RFC: always enable MAC80211_RC_PID?
Cc: "Adrian Bunk" <bunk@kernel.org>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Adrian Bunk" <bunk@stusta.de>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	"Rindjunsky, Ron" <ron.rindjunsky@intel.com>,
	"Winkler, Tomas" <tomas.winkler@intel.com>
In-Reply-To: <20080624211222.GB25892@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080622125553.GB22539@cs181133002.pp.htv.fi>
	 <43e72e890806220804i347b942claae7b725231afcce@mail.gmail.com>
	 <1214298259.8967.260.camel@johannes.berg>
	 <20080624124311.GC16021@cs181140183.pp.htv.fi>
	 <20080624211222.GB25892@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 24, 2008 at 2:12 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Tue, Jun 24, 2008 at 03:43:14PM +0300, Adrian Bunk wrote:
>
>> Can we get one of either:
>> - all selected mac80211 algorithms are built into the mac80211 module or
>
> This seems fine to me.

OK so just to be clear -- moving forward we strive to not allow driver
specific rate control algorithms and push out current ones into
mac80211? This would mean we don't have to *cleanup* support for
driver specific RCs but instead just have them stashed in as part of
the build. The difficulty here lies in ensuring they do work for well
for other drivers but I do agree it strives to cleanup RC code. I
think vendors also tend to use a few driver specific tweaks to boost
their own throughput in their own RCs though. Can't say for sure right
now of specific details but I'll try to get back to you with them.
Perhaps Tomas can say more about that for iwl's RCs.

  Luis
