Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f196.google.com ([209.85.222.196]:52460 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbZHMCTr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2009 22:19:47 -0400
Received: by pzk34 with SMTP id 34so307486pzk.4
        for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2009 19:19:48 -0700 (PDT)
Message-ID: <4A83783E.3000607@lwfinger.net>
Date: Wed, 12 Aug 2009 21:19:42 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: bcm43xx-dev@lists.berlios.de,
	=?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] b43: Implement RC calibration for rev.0/1 LP-PHYs
References: <4A830249.1010005@gmail.com> <200908122008.29582.mb@bu3sch.de>
In-Reply-To: <200908122008.29582.mb@bu3sch.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Wednesday 12 August 2009 19:56:25 Gábor Stefanik wrote:
>> +       b43_phy_mask(dev, B43_LPPHY_AFE_DDFS_POINTER_INIT, 0x80FF);
>> +       b43_phy_maskset(dev, B43_LPPHY_AFE_DDFS_INCR_INIT, 0xFF80, incr1);
>> +       b43_phy_maskset(dev, B43_LPPHY_AFE_DDFS_INCR_INIT, 0x80FF, incr2 << 3);
> 
> 3bit shift smells fishy. Did you want 8?

There was a typo in the specs. It now is changed to 8.

>> +		for (j = 5; j <= 25; j++) {
>> +			lpphy_run_ddfs(dev, 1, 1, j, j, 0);
> 
> (Just by guess) Did you really want j,j instead of i,j or something like that?

No, it definitely is j,j.

Larry

