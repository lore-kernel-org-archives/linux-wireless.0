Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:37123 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791AbbAWRbB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 12:31:01 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: rtlwifi/rtl8192de: remove redundant else if check
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1421158054-22566-1-git-send-email-colin.king@canonical.com>
To: Colin Ian King <colin.king@canonical.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Message-Id: <20150123173101.2E01C1416F0@smtp.codeaurora.org> (sfid-20150123_183123_036757_8A05F0B3)
Date: Fri, 23 Jan 2015 17:31:01 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Colin Ian King <colin.king@canonical.com>
> 
> The else if check condition checks for the opposite of the
> if check, hence the else if check is redundant and can be
> replaced with a simple else:
> 
> if (rtlpriv->rtlhal.macphymode == SINGLEMAC_SINGLEPHY) {
> 	..
> } else if (rtlpriv->rtlhal.macphymode != SINGLEMAC_SINGLEPHY) {
> 	..
> }
> 
> replaced with:
> 
> if (rtlpriv->rtlhal.macphymode == SINGLEMAC_SINGLEPHY) {
> 	..
> } else {
> 	..
> }
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
