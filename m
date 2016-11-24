Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33074 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750762AbcKXGG6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Nov 2016 01:06:58 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Thu, 24 Nov 2016 14:06:57 +0800
From: miaoqing@codeaurora.org
To: Jason Cooper <jason@lakedaemon.net>,
        Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: linux-wireless@vger.kernel.org,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        ath9k-devel <ath9k-devel@qca.qualcomm.com>,
        ath9k-devel@lists.ath9k.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Kalle Valo <kvalo@codeaurora.org>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: ath9k ARMv7 OOPS in v4.8.6, v4.2.8
In-Reply-To: <aaba8b1e30dd4c22be52e50befb202b2@aptaiexm02f.ap.qualcomm.com>
References: <20161123191539.GF2799@io.lakedaemon.net>
 <20161123195120.GE14217@n2100.armlinux.org.uk>
 <20161123205917.GI2799@io.lakedaemon.net>
 <20161123211745.GF14217@n2100.armlinux.org.uk>
 <20161123214053.GJ2799@io.lakedaemon.net>
 <aaba8b1e30dd4c22be52e50befb202b2@aptaiexm02f.ap.qualcomm.com>
Message-ID: <7aba95bdf0d562f3c9640d533c33e1ca@codeaurora.org> (sfid-20161124_070702_605012_2EFFE7C1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>> Okay, so i was 0, so running UP probably isn't going to help.  r7 is
>> also spec_priv->rfs_chan_spec_scan.
>> 
>> So, I think the question is... how is this NULL - and has it always
>> been NULL...
> 
> The problem appears to be that ath_cmn_process_fft() isn't called that
> often.  When it is, it crashes in ath_cmn_is_fft_buf_full() because
> spec_priv->rfs_chan_spec_scan is NULL when ATH9K_DEBUGFS=n. :-(
> 
> I'm running with ATH9K_DEBUGFS=y now.  If it goes a couple of days
> without crashing, I'll gin up a patch.
> 

A similar patch was applied to ath-next branch: 
https://patchwork.kernel.org/patch/9431163/.

--
Miaoqing
