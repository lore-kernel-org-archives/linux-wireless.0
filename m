Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40634 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbbDHIG2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2015 04:06:28 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: Re: [PATCH 4/5] wil6210: stop_ap to leave interface closed
References: <1427704134-30699-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	<1427704134-30699-5-git-send-email-qca_vkondrat@qca.qualcomm.com>
	<1427705156.26117.12.camel@sipsolutions.net>
	<3799169.j0UvFx0Mjg@lx-wigig-72>
	<87k2xnx5n8.fsf@kamboji.qca.qualcomm.com>
	<4C0E19B4-8F05-47B6-B32F-B60F0BC03D3A@sipsolutions.net>
Date: Wed, 08 Apr 2015 11:06:21 +0300
In-Reply-To: <4C0E19B4-8F05-47B6-B32F-B60F0BC03D3A@sipsolutions.net> (Johannes
	Berg's message of "Tue, 07 Apr 2015 21:52:16 +0200")
Message-ID: <87iod7hwn6.fsf@kamboji.qca.qualcomm.com> (sfid-20150408_100636_107377_BD5BB339)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

>>>> "closed" is rather misleading, since you most certainly should *not*
>>do
>>>> dev_close() [and don't, but how should I know reading the commit
>>log?]
>>>> 
>>>> johannes
>>>> 
>>>
>>> Yes, I see.
>>> I meant that actually stop_ap leaves device in state similar to
>>ndo_stop,
>>> where it is non operational.
>>>
>>> Would you suggest better wording? "Inactive", "down", "non
>>operational"
>>> or something else?
>>
>>Isn't "down" good enough here? So can I change it to:
>
> Well that kinda proves my point - down is wrong.
>
> Carrier turned off is probably the right thing to do here.

Ok, I change the commit log to:

  cfg80211_ops.stop_ap supposed to have interface carried turned off as
  post condition. Fulfill this requirement.

-- 
Kalle Valo
