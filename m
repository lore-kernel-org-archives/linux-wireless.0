Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:37999 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729Ab3ITFGy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Sep 2013 01:06:54 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix num_sends_allowed replenishing
References: <1379510537-8731-1-git-send-email-michal.kazior@tieto.com>
Date: Fri, 20 Sep 2013 08:06:50 +0300
In-Reply-To: <1379510537-8731-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Wed, 18 Sep 2013 15:22:17 +0200")
Message-ID: <87zjr8gjyt.fsf@qca.qualcomm.com> (sfid-20130920_070714_413635_052D293D)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Recent ce_sendlist removal patch has broken
> num_sends_allowed incrementing. num_sends_allowed
> exceeded initial values and could overflow.
>
> This code was supposed to replenish
> num_sends_allowed for partial sendlist items (i.e.
> before final sendlist item from a sendlist was
> completed and could be processed by completion
> handlers).
>
> Fortunately it seems it cause any major breakage,
> yet.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Doh, I broke this. Sorry about that.

Applied, but I changed the commit log. Especially notice the changes in
the last sentence:

commit 1073ab2e9b0d45f318052a3f3690405fc04eda75
Author: Michal Kazior <michal.kazior@tieto.com>
Date:   Wed Sep 18 15:22:17 2013 +0200

    ath10k: fix num_sends_allowed replenishing
    
    Commit e9bb0aa39 ("ath10k: delete struct ce_sendlist") broke
    num_sends_allowed incrementing. num_sends_allowed
    exceeded initial values and could overflow.
    
    This code was supposed to replenish
    num_sends_allowed for partial sendlist items (i.e.
    before final sendlist item from a sendlist was
    completed and could be processed by completion
    handlers).
    
    Fortunately it seems it did not cause any major breakage,
    yet.
    
    Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
    Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

-- 
Kalle Valo
