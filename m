Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46960 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364Ab3CETcm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Mar 2013 14:32:42 -0500
Message-ID: <1362511955.638.3.camel@jlt4.sipsolutions.net> (sfid-20130305_203246_919933_A421D4DE)
Subject: Re: WARNING from net/wireless/mlme.c
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John W Linville <linville@tuxdriver.com>
Date: Tue, 05 Mar 2013 20:32:35 +0100
In-Reply-To: <513570D0.4070302@lwfinger.net> (sfid-20130305_051310_497727_E0519ADC)
References: <513570D0.4070302@lwfinger.net>
	 (sfid-20130305_051310_497727_E0519ADC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry,

> With 3.9-rc1 from wireless-testing, I get a warning from the line
>          if (WARN(!wdev->current_bss, "sme_state=%d\n", wdev->sme_state))
> 
> [ 4250.226882] ------------[ cut here ]------------
> [ 4250.226929] WARNING: at net/wireless/mlme.c:517 
> cfg80211_mlme_disassoc+0x192/0x3a0 [cfg80211]()
> [ 4250.226933] Hardware name: HP Pavilion dv2700 Notebook PC
> [ 4250.226936] sme_state=2

Heh, adding the sme_state=2 there was stupid of me ... there's an if
right in front. Oh well.

Anyway, can you reproduce this? I looked at the code for the umpteenth
time and can't really find it. Capturing cfg80211 tracing might be
helpful.

johannes

