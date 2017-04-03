Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:35636 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751008AbdDCImS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Apr 2017 04:42:18 -0400
Date: Mon, 3 Apr 2017 10:42:13 +0200
From: Johan Hovold <johan@kernel.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Daniel Drake <dsd@gentoo.org>,
        Ulrich Kunitz <kune@deine-taler.de>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        Sujith Manoharan <Sujith.Manoharan@atheros.com>
Subject: Re: [PATCH 1/2] wireless: ath9k_htc: fix NULL-deref at probe
Message-ID: <20170403084213.GE25742@localhost> (sfid-20170403_104300_620229_F17C3A9C)
References: <20170313124421.28587-1-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170313124421.28587-1-johan@kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 13, 2017 at 01:44:20PM +0100, Johan Hovold wrote:
> Make sure to check the number of endpoints to avoid dereferencing a
> NULL-pointer or accessing memory beyond the endpoint array should a
> malicious device lack the expected endpoints.
> 
> Fixes: 36bcce430657 ("ath9k_htc: Handle storage devices")
> Cc: Sujith Manoharan <Sujith.Manoharan@atheros.com>
> Signed-off-by: Johan Hovold <johan@kernel.org>

Is this one still in your queue, Kalle?

As I mentioned earlier, I should have added a

Cc: stable <stable@vger.kernel.org>     # 2.6.39

but left it out as I mistakingly thought the net recommendations to do
so applied also to wireless.

Thanks,
Johan
