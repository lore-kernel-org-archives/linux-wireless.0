Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:59635 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965621AbdEWPYE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 May 2017 11:24:04 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: wcn36xx: Close SMD channel on device removal
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20170509043637.28179-1-bjorn.andersson@linaro.org>
References: <20170509043637.28179-1-bjorn.andersson@linaro.org>
To: Bjorn Andersson <bjorn.andersson@linaro.org>
CC: Eugene Krasnikov <k.eugene.e@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Eyal Ilsar <c_eilsar@qti.qualcomm.com>,
        <wcn36xx@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>
Message-ID: <791ac0fefa814db68e482254b91e45ca@euamsexm01a.eu.qualcomm.com> (sfid-20170523_172441_545629_545CB067)
Date: Tue, 23 May 2017 17:23:48 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bjorn Andersson <bjorn.andersson@linaro.org> wrote:
> The SMD channel is not the primary WCNSS channel and must explicitly be
> closed as the device is removed, or the channel will already by open on
> a subsequent probe call in e.g. the case of reloading the kernel module.
> 
> This issue was introduced because I simplified the underlying SMD
> implementation while the SMD adaptions of the driver sat on the mailing
> list, but missed to update these patches. The patch does however only
> apply back to the transition to rpmsg, hence the limited Fixes.
> 
> Fixes: 5052de8deff5 ("soc: qcom: smd: Transition client drivers from smd to rpmsg")
> Reported-by: Eyal Ilsar <c_eilsar@qti.qualcomm.com>
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Patch applied to ath-current branch of ath.git, thanks.

efad8396e906 wcn36xx: Close SMD channel on device removal

-- 
https://patchwork.kernel.org/patch/9717027/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
