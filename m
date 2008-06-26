Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.236]:19596 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756675AbYFZWhO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2008 18:37:14 -0400
Received: by rv-out-0506.google.com with SMTP id k40so250147rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jun 2008 15:37:13 -0700 (PDT)
Message-ID: <1ba2fa240806261537h2dddf468h67243f84772d9da3@mail.gmail.com> (sfid-20080627_003756_956286_6612DD3B)
Date: Fri, 27 Jun 2008 01:37:10 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: RFC: always enable MAC80211_RC_PID?
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Adrian Bunk" <bunk@kernel.org>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Adrian Bunk" <bunk@stusta.de>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	"Rindjunsky, Ron" <ron.rindjunsky@intel.com>
In-Reply-To: <43e72e890806261435t3d06e955x590a6fafb223bbca@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080622125553.GB22539@cs181133002.pp.htv.fi>
	 <43e72e890806220804i347b942claae7b725231afcce@mail.gmail.com>
	 <1214298259.8967.260.camel@johannes.berg>
	 <20080624124311.GC16021@cs181140183.pp.htv.fi>
	 <20080624211222.GB25892@tuxdriver.com>
	 <43e72e890806261435t3d06e955x590a6fafb223bbca@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 27, 2008 at 12:35 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Tue, Jun 24, 2008 at 2:12 PM, John W. Linville
> <linville@tuxdriver.com> wrote:
>> On Tue, Jun 24, 2008 at 03:43:14PM +0300, Adrian Bunk wrote:
>>
>>> Can we get one of either:
>>> - all selected mac80211 algorithms are built into the mac80211 module or
>>
>> This seems fine to me.
>
> OK so just to be clear -- moving forward we strive to not allow driver
> specific rate control algorithms and push out current ones into
> mac80211? This would mean we don't have to *cleanup* support for
> driver specific RCs but instead just have them stashed in as part of
> the build. The difficulty here lies in ensuring they do work for well
> for other drivers but I do agree it strives to cleanup RC code. I
> think vendors also tend to use a few driver specific tweaks to boost
> their own throughput in their own RCs though. Can't say for sure right
> now of specific details but I'll try to get back to you with them.
> Perhaps Tomas can say more about that for iwl's RCs.
>
Annual talk about rate scaling algorithm :)
I understand of need of clean framework however:
Our rate scaling algorithm has intimate knowledge of iwlwifi firmware
and hardware and I'm currently not seeing any benefit for it for other
HW.
I'm also pretty much sure that no other algorithm can do same job for
iwlwifi driver.
For example the rate is not attached to each frame but supplied out of
band in a form of 16 steps rate sale table. I've explained already
benefits of this.

Detaching algorithm form the driver would at minimum require opening
another API for rate scaling not usable by others. And this is not the
end. This just doesn't worth the sweat if no other algorithm can be
used for iwlwifi and this algorithm cannot be used by others.
This would be cleaning code for sake of cleaning code without any
benefits. If there be finally some other 11n card in Linux we can see
the new picture and reevaluate.
I'm not the Kconfig expert but  desalinizing the current iwlwifi
driver for prize of removing MAC80211_RC_DEFAULT_NONE just doesn't
feel OK.
Thanks
Tomas
