Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.243]:63178 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353AbXKWLfG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2007 06:35:06 -0500
Received: by an-out-0708.google.com with SMTP id d31so641920and
        for <linux-wireless@vger.kernel.org>; Fri, 23 Nov 2007 03:35:05 -0800 (PST)
Message-ID: <40f31dec0711230335k6ef0f45erbb1285d8c572cf38@mail.gmail.com> (sfid-20071123_113514_230073_80C679E2)
Date: Fri, 23 Nov 2007 13:35:05 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Bruno Randolf" <bruno@thinktube.com>
Subject: Re: ath5k signal/noise fixes
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, mcgrof@gmail.com, jirislaby@gmail.com
In-Reply-To: <1195815123-22375-1-git-send-email-bruno@thinktube.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1195815123-22375-1-git-send-email-bruno@thinktube.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2007/11/23, Bruno Randolf <bruno@thinktube.com>:
>
> hello!
>
> the next 3 patches contain fixes for the signal/noise level calibration and
> reporting of ath5k.  i split them up because i'm not 100% sure of the second
> two.
>

Good job ;-)

> i'm also not sure if what we call noise calibration in this case really is an
> calibration or just a reading of the values?
>

To enable noise floor calibration on hw we set AGCTL_NF, if we want to
read the value and make checks/update stats etc we read PHY_NF. I
agree with your approach of noise floor calibration + update value in
all cases. This patch aso makes code cleaner because noise floor
calibration belongs inside phy.c




-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
