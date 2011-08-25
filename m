Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:53827 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753185Ab1HYKDv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 06:03:51 -0400
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Cc: Joe Perches <joe@perches.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V2 3/3] ath6kl: Add debugfs file entry to dump credit distribution stats
References: <1314257441-8092-1-git-send-email-vthiagar@qca.qualcomm.com>
	<1314257441-8092-3-git-send-email-vthiagar@qca.qualcomm.com>
	<1314260797.15882.63.camel@Joe-Laptop>
	<20110825093339.GA17131@vasanth-laptop>
From: Kalle Valo <kvalo@adurom.com>
Date: Thu, 25 Aug 2011 13:03:46 +0300
In-Reply-To: <20110825093339.GA17131@vasanth-laptop> (Vasanthakumar Thiagarajan's message of "Thu\, 25 Aug 2011 15\:03\:40 +0530")
Message-ID: <8762llolj1.fsf@purkki.adurom.net> (sfid-20110825_120358_533809_14575BEC)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com> writes:

> On Thu, Aug 25, 2011 at 01:26:37AM -0700, Joe Perches wrote:
>> On Thu, 2011-08-25 at 13:00 +0530, Vasanthakumar Thiagarajan wrote:
>> > +	struct ath6kl *ar = file->private_data;
>> > +	struct htc_target *target = ar->htc_target;
>> > +	struct htc_endpoint_credit_dist *ep_list;
>> > +	char *buf;
>> > +	unsigned int buf_len = 128, len = 0;
>> > +	ssize_t ret_cnt;
>> > +
>> > +	buf_len += get_queue_depth(&target->cred_dist_list) * 128;
>> 
>> Doesn't look like 128 is the right size.
>
> It is well enough, needed is only around 110 bytes.

Proper defines for the values would be nice. Magic numbers are always
tricky.

-- 
Kalle Valo
