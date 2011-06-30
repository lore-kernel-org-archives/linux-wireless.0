Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56632 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751707Ab1F3VeL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2011 17:34:11 -0400
Date: Thu, 30 Jun 2011 14:33:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>,
	chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: rtl8192de/phy.c: fix udelay() usage
Message-Id: <20110630143358.cf4d4e2f.akpm@linux-foundation.org> (sfid-20110630_233414_851379_DE5F3A2A)
In-Reply-To: <4e0cea92.d87Od1Tkbar3iIK/%Larry.Finger@lwfinger.net>
References: <4e0cea92.d87Od1Tkbar3iIK/%Larry.Finger@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also, there are eleventy billion instances of

	for (j = 0; j < N; j++)
		udelay(MAX_STALL_TIME);

which seem rather unnecessary.

static inline void rtl8192c_udelay(unsigned n)
{
	if (n < 1000)
		udelay(n);
	else
		mdelay(n / 1000);
}

or something.
