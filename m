Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3568 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047AbYHQSca (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Aug 2008 14:32:30 -0400
Date: Sun, 17 Aug 2008 14:18:09 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: chunkeey@web.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH V2] p54: Fix regression due to commit b19fa1f
Message-ID: <20080817181809.GB30679@tuxdriver.com> (sfid-20080817_203241_634015_755DD1DB)
References: <489e345f.H31YqguRuy6IgNjN%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <489e345f.H31YqguRuy6IgNjN%Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 09, 2008 at 07:20:47PM -0500, Larry Finger wrote:
> From: Christian Lamparter <chunkeey@web.de>
> 
> This patch fixes the regression due to commit b19fa1f. In addition,
> the old logic always tx'ed cts frames (if enabled) with a
> short preamble when [rate > 3]. (i.e. with any 802.11g rate).
> Of course this isn't that bad, but it's still wrong!

> -	if (info->flags & IEEE80211_TX_CTL_USE_RTS_CTS)
> +		cts_rate |= 0x10;
> +	} if (info->flags & IEEE80211_TX_CTL_USE_RTS_CTS) {

Style whoops...I'll correct it locally...

-- 
John W. Linville
linville@tuxdriver.com
