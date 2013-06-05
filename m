Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:7472 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699Ab3FEKF0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 06:05:26 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Antonio Quartulli <antonio@open-mesh.com>
CC: Antonio Quartulli <ordex@autistici.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] nl80211: allow sending CMD_FRAME without specifying any frequency
References: <1370241587-2609-1-git-send-email-ordex@autistici.org>
	<877gi8khyi.fsf@kamboji.qca.qualcomm.com>
	<20130605095311.GA2349@open-mesh.com>
Date: Wed, 5 Jun 2013 13:05:21 +0300
In-Reply-To: <20130605095311.GA2349@open-mesh.com> (Antonio Quartulli's
	message of "Wed, 5 Jun 2013 11:53:11 +0200")
Message-ID: <87y5aoj2ji.fsf@kamboji.qca.qualcomm.com> (sfid-20130605_120529_686478_D12F9CE0)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Antonio Quartulli <antonio@open-mesh.com> writes:

> On Wed, Jun 05, 2013 at 02:47:01AM -0700, Kalle Valo wrote:
>> Antonio Quartulli <ordex@autistici.org> writes:
>> 
>> > From: Antonio Quartulli <antonio@open-mesh.com>
>> >
>> > Users may want to send a frame on the current channel
>> > without specifying it.
>> >
>> > Make mgmt_tx pass a NULL channel to mac80211 if none has
>> > been specified by the user.
>> >
>> > Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
>> 
>> Why? And what users are we talking about here? It would be nice if the
>> commit log would give some context here for use who nothing about this
>> patch. "Users may want" is not very informative :)
>
> Hello Kalle,
> thanks for your feedback.
>
> Sure, I can change the commit log.
>
> However, I already wrote a couple of (userspace) applications which wanted to
> send a message on the current channel and the only way to do it was to first get
> the current channel and then pass it when sending a CMD_FRAME via nl80211. Of
> course this approach is just a bit racy :-)
>
> Moreover, I'm currently working on improving IBSS/RSN support in wpa_supplicant
> and sending frames on the current channel is needed.
>
> Do you think it is worth mentioning userspace applications like wpa_s in the
> kernel commit message?

I don't know what others think, but to me it is. It makes it easier to
understand why the change is made. And also do we really need the change
or not.

-- 
Kalle Valo
