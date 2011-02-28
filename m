Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37307 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab1B1Aio (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Feb 2011 19:38:44 -0500
Date: Mon, 28 Feb 2011 03:38:23 +0300
From: Dan Carpenter <error27@gmail.com>
To: Alessio Igor Bogani <abogani@kernel.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	linux-wireless@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	Tim Bird <tim.bird@am.sony.com>
Subject: Re: [PATCH] rtlwifi: make gcc happy
Message-ID: <20110228003734.GA9075@bicker>
References: <1298841390-1194-1-git-send-email-abogani@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1298841390-1194-1-git-send-email-abogani@kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 27, 2011 at 10:16:30PM +0100, Alessio Igor Bogani wrote:
> drivers/net/wireless/rtlwifi/rtl8192ce/trx.c: In function ‘rtl92ce_rx_query_desc’:
> drivers/net/wireless/rtlwifi/rtl8192ce/trx.c:255:5: warning: ‘rf_rx_num’ may be used uninitialized in this function
> drivers/net/wireless/rtlwifi/rtl8192ce/trx.c:257:12: warning: ‘total_rssi’ may be used uninitialized in this function
> drivers/net/wireless/rtlwifi/rtl8192ce/trx.c:466:6: warning: ‘weighting’ may be used uninitialized in this function
> 

These fix actual bugs where uninitialized values are used; it's not
just a matter of silencing warnings.  The patch title should mention
that.  Perhaps something like:

[patch] rtlwifi: fix places where uninitialized data is used

regards,
dan carpenter
