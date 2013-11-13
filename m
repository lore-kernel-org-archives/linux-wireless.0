Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:50356 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932356Ab3KMI7d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 03:59:33 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: Marek Puzyniak <marek.puzyniak@tieto.com>,
	<linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH 1/3] ath10k: add phyerr/dfs handling
References: <1383048394-15256-1-git-send-email-marek.puzyniak@tieto.com>
	<87bo1xuajk.fsf@kamboji.qca.qualcomm.com>
	<CALhHN=oj2hg6zRf5rKyDBexWOdR08=aRXRJtD9gQQs7i_tjjMQ@mail.gmail.com>
	<87habnau4d.fsf@kamboji.qca.qualcomm.com>
Date: Wed, 13 Nov 2013 10:59:27 +0200
In-Reply-To: <87habnau4d.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
	of "Fri, 8 Nov 2013 15:41:22 +0200")
Message-ID: <87r4ak8yog.fsf@kamboji.qca.qualcomm.com> (sfid-20131113_095939_175300_027DFC96)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

>> I think we can use here spin_lock_bh(&ar->data_lock) when setting
>> ar->debug.dfs_stats and when reading this from debugfs.
>> But, is that really needed (in worst case we will get older values via debugfs)?
>
> I would prefer not to have any race conditions in the driver, even if
> it's just statistics. If there's only a race with statistics atomic
> variables are also one option.

I took a new look at these statistics and I think you are right. It
feels a bit overkill to use locking or atomic variables here.

-- 
Kalle Valo
