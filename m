Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:44212 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933287AbaDJGuQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2014 02:50:16 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <greearb@candelatech.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [RFTv2 3/5] ath10k: rework peer accounting
References: <1396611464-5940-1-git-send-email-michal.kazior@tieto.com>
	<1397040531-6224-1-git-send-email-michal.kazior@tieto.com>
	<1397040531-6224-4-git-send-email-michal.kazior@tieto.com>
Date: Thu, 10 Apr 2014 09:50:02 +0300
In-Reply-To: <1397040531-6224-4-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Wed, 9 Apr 2014 12:48:49 +0200")
Message-ID: <87ob09he5h.fsf@kamboji.qca.qualcomm.com> (sfid-20140410_085031_829472_AE0F9C87)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> It was troublesome to iterate over peers and
> perform sleepable calls. This will be necessary
> for some upcomming changes to tx flushing.
>
> Make peer allocation and initial setup
> protected by both ar->conf_mutex and
> ar->data_lock. This way it's possible to iterate
> over peers with conf_mutex and call sleepable
> functions.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Sorry, but I'm not really getting your idea here of using both
conf_mutex and data_lock to protect ar->peers. Can you elaborate more,
please? Why can't we just use conf_mutex then? What am I missing?

-- 
Kalle Valo
