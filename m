Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40402 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbbDGTwZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2015 15:52:25 -0400
In-Reply-To: <87k2xnx5n8.fsf@kamboji.qca.qualcomm.com>
References: <1427704134-30699-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <1427704134-30699-5-git-send-email-qca_vkondrat@qca.qualcomm.com> <1427705156.26117.12.camel@sipsolutions.net> <3799169.j0UvFx0Mjg@lx-wigig-72> <87k2xnx5n8.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH 4/5] wil6210: stop_ap to leave interface closed
From: Johannes Berg <johannes@sipsolutions.net>
Date: Tue, 07 Apr 2015 21:52:16 +0200
To: Kalle Valo <kvalo@codeaurora.org>,
	Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
CC: linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Message-ID: <4C0E19B4-8F05-47B6-B32F-B60F0BC03D3A@sipsolutions.net> (sfid-20150407_215229_525406_AF4D1E78)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>




>>> "closed" is rather misleading, since you most certainly should *not*
>do
>>> dev_close() [and don't, but how should I know reading the commit
>log?]
>>> 
>>> johannes
>>> 
>>
>> Yes, I see.
>> I meant that actually stop_ap leaves device in state similar to
>ndo_stop,
>> where it is non operational.
>>
>> Would you suggest better wording? "Inactive", "down", "non
>operational"
>> or something else?
>
>Isn't "down" good enough here? So can I change it to:

Well that kinda proves my point - down is wrong.

Carrier turned off is probably the right thing to do here.

johannes
