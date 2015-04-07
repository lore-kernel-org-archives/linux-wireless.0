Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55645 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbbDGQao (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2015 12:30:44 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: Re: [PATCH 4/5] wil6210: stop_ap to leave interface closed
References: <1427704134-30699-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	<1427704134-30699-5-git-send-email-qca_vkondrat@qca.qualcomm.com>
	<1427705156.26117.12.camel@sipsolutions.net>
	<3799169.j0UvFx0Mjg@lx-wigig-72>
Date: Tue, 07 Apr 2015 19:30:35 +0300
In-Reply-To: <3799169.j0UvFx0Mjg@lx-wigig-72> (Vladimir Kondratiev's message
	of "Mon, 30 Mar 2015 16:56:55 +0300")
Message-ID: <87k2xnx5n8.fsf@kamboji.qca.qualcomm.com> (sfid-20150407_183047_343988_041769CF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com> writes:

> On Monday, March 30, 2015 10:45:56 AM Johannes Berg wrote:
>> On Mon, 2015-03-30 at 11:28 +0300, Vladimir Kondratiev wrote:
>> > cfg80211_ops.stop_ap supposed to have interface closed
>> > as post condition. Fulfill this requirement.
>> 
>> "closed" is rather misleading, since you most certainly should *not* do
>> dev_close() [and don't, but how should I know reading the commit log?]
>> 
>> johannes
>> 
>
> Yes, I see.
> I meant that actually stop_ap leaves device in state similar to ndo_stop,
> where it is non operational.
>
> Would you suggest better wording? "Inactive", "down", "non operational"
> or something else?

Isn't "down" good enough here? So can I change it to:

  cfg80211_ops.stop_ap supposed to have interface down as post
  condition. Fulfill this requirement.

-- 
Kalle Valo
