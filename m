Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:36811 "EHLO
	mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbcBECh1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 21:37:27 -0500
Received: by mail-io0-f179.google.com with SMTP id g73so115005503ioe.3
        for <linux-wireless@vger.kernel.org>; Thu, 04 Feb 2016 18:37:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1454636750-2372-1-git-send-email-miaoqing@codeaurora.org>
References: <1454636750-2372-1-git-send-email-miaoqing@codeaurora.org>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 5 Feb 2016 13:37:06 +1100
Message-ID: <CAGRGNgUqLjafsLL5uqw=HdFo_LPGSr7UPczCXapfwhhapVQFkw@mail.gmail.com> (sfid-20160205_033730_292033_08CBC1E8)
Subject: Re: [PATCH v2] ath9k: make NF load complete quickly and reliably
To: miaoqing@codeaurora.org
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@qca.qualcomm.com, Kalle Valo <kvalo@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Miaoqing,

On Fri, Feb 5, 2016 at 12:45 PM,  <miaoqing@codeaurora.org> wrote:
> From: Miaoqing Pan <miaoqing@codeaurora.org>
>
> Make NF load complete quickly and reliably. NF load execution
> is delayed by HW to end of frame if frame Rx or Tx is ongoing.
> Increasing timeout to max frame duration. If NF cal is ongoing
> before NF load, stop it before load, and restart it afterwards.
>
> Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
> ---
>  drivers/net/wireless/ath/ath9k/calib.c | 38 ++++++++++++++++++++++++++++------
>  1 file changed, 32 insertions(+), 6 deletions(-)

You should add a changelog here so people know what's changed in this
version of the patch.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
