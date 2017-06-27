Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33040 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751716AbdF0R1l (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Jun 2017 13:27:41 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: Re: [PATCH 8/8] qtnfmac: implement scan timeout
References: <20170620195517.18373-1-sergey.matyukevich.os@quantenna.com>
        <20170620195517.18373-9-sergey.matyukevich.os@quantenna.com>
Date: Tue, 27 Jun 2017 20:27:37 +0300
In-Reply-To: <20170620195517.18373-9-sergey.matyukevich.os@quantenna.com>
        (Sergey Matyukevich's message of "Tue, 20 Jun 2017 22:55:17 +0300")
Message-ID: <87o9t949yu.fsf@purkki.adurom.net> (sfid-20170627_192744_949694_792D5982)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> writes:

> Userspace tools may hang on scan in the case when scan completion event
> is not returned by firmware. This patch implements the scan timeout
> to avoid such situation.
>
> Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

[...]

> +static __always_inline void qtnf_wmac_lock(struct qtnf_wmac *mac)
> +{
> +	mutex_lock(&mac->mac_lock);
> +}
> +
> +static __always_inline void qtnf_wmac_unlock(struct qtnf_wmac *mac)
> +{
> +	mutex_unlock(&mac->mac_lock);
> +}

Why? These look pointless to me.

-- 
Kalle Valo
