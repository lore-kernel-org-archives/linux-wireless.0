Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:21954 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754826AbaDGOKR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Apr 2014 10:10:17 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] ath10k: refactor radar detection code
References: <1396337123-12622-1-git-send-email-michal.kazior@tieto.com>
	<1396610926-5787-1-git-send-email-michal.kazior@tieto.com>
	<1396610926-5787-3-git-send-email-michal.kazior@tieto.com>
Date: Mon, 7 Apr 2014 17:04:39 +0300
In-Reply-To: <1396610926-5787-3-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 4 Apr 2014 13:28:46 +0200")
Message-ID: <87bnwdnslk.fsf@kamboji.qca.qualcomm.com> (sfid-20140407_161021_461132_7433ED21)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> If 20MHz CAC completed successfully then
> subsequent CAC with wider bandwidth (40Mhz, 80Mhz)
> with identical control frequency did not start
> monitor vdev making it impossible to detect any
> radar pulses during intended CAC.
>
> It also was incorrect to assume ath10k_config() will
> be called after CAC is finished. Theoretically for
> non-HT channels nothing changes between CAC and
> start_ap() (albeit in practice this can be
> different). The incorrect assumption led to CAC
> not being stopped on non-HT chandefs leading to
> all Rx being drooped making it impossible for
> clients to associate.
>
> While at it clean up the code a bit.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

[...]

> @@ -858,6 +830,11 @@ static int ath10k_vdev_stop(struct ath10k_vif *arvif)
>  		return ret;
>  	}
>  
> +	if (!WARN_ON(ar->num_started_vdevs == 0)) {

Even though this is correct, I think it's still a bit evil. For example,
I missed '!' the first time I looked at this. Even this is a line
longer, I think it would be easier to read:

WARN_ON(ar->num_started_vdevs == 0);

if (ar->num_started_vdevs != 0) {
        ...
}

-- 
Kalle Valo
