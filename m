Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47226 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbbC3N5C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 09:57:02 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Kalle Valo <kvalo@codeaurora.org>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: Re: [PATCH 4/5] wil6210: stop_ap to leave interface closed
Date: Mon, 30 Mar 2015 16:56:55 +0300
Message-ID: <3799169.j0UvFx0Mjg@lx-wigig-72> (sfid-20150330_155811_203792_FBD946C6)
In-Reply-To: <1427705156.26117.12.camel@sipsolutions.net>
References: <1427704134-30699-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <1427704134-30699-5-git-send-email-qca_vkondrat@qca.qualcomm.com> <1427705156.26117.12.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, March 30, 2015 10:45:56 AM Johannes Berg wrote:
> On Mon, 2015-03-30 at 11:28 +0300, Vladimir Kondratiev wrote:
> > cfg80211_ops.stop_ap supposed to have interface closed
> > as post condition. Fulfill this requirement.
> 
> "closed" is rather misleading, since you most certainly should *not* do
> dev_close() [and don't, but how should I know reading the commit log?]
> 
> johannes
> 

Yes, I see.
I meant that actually stop_ap leaves device in state similar to ndo_stop,
where it is non operational.

Would you suggest better wording? "Inactive", "down", "non operational"
or something else?

Thanks, Vladimir
