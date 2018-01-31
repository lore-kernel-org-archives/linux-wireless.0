Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f182.google.com ([74.125.82.182]:38372 "EHLO
        mail-ot0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753203AbeAaRGP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Jan 2018 12:06:15 -0500
Received: by mail-ot0-f182.google.com with SMTP id v5so14068379oth.5
        for <linux-wireless@vger.kernel.org>; Wed, 31 Jan 2018 09:06:15 -0800 (PST)
Subject: Re: rtl8821ae keep alive not set, connection lost
To: James Cameron <quozl@laptop.org>, linux-wireless@vger.kernel.org
Cc: Ping-Ke Shih <pkshih@realtek.com>
References: <20170912220916.GB32211@us.netrek.org>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <a9a1ff03-d12f-7437-e7bc-5f01b195f753@lwfinger.net> (sfid-20180131_180620_556631_4F471481)
Date: Wed, 31 Jan 2018 11:06:12 -0600
MIME-Version: 1.0
In-Reply-To: <20170912220916.GB32211@us.netrek.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/12/2017 05:09 PM, James Cameron wrote:
> Summary: 40b368af4b75 ("rtlwifi: Fix alignment issues") breaks
> rtl8821ae keep alive, causing "Connection to AP lost" and deauth, but
> why?
> 
> Wireless connection is lost after a few seconds or minutes, on every
> OLPC NL3 laptop with rtl8821ae, with any stable kernel after 4.10.1,
> and any kernel with 40b368af4b75.
> 
> dmesg contains
> 
>    wlp2s0: Connection to AP 2c:b0:5d:a6:86:eb lost
> 
> iw event shows
> 
>    wlp2s0: del station 2c:b0:5d:a6:86:eb
>    wlp2s0 (phy #0): deauth 74:c6:3b:09:b5:0d -> 2c:b0:5d:a6:86:eb reason 4: Disassociated due to inactivity
>    wlp2s0 (phy #0): disconnected (local request)
> 
> Workaround is to bounce the link, then reconnect;
> 
>    ip link set wlp2s0 down
>    ip link set wlp2s0 up
>    iw dev wlp2s0 connect qz
> 
> A nearby monitor host captures a deauthentication packet sent by the
> device.
> 
> Bisection showed cause is 40b368af4b75 ("rtlwifi: Fix alignment
> issues") which changes the width of DBI register read.
> 
> On the face of it, 40b368af4b75 looks correct, especially compared
> against same function in rtl8723be.
> 
> I've no idea why reverting fixes the problem.  I'm hoping someone here
> might speculate and suggest ways to test.
> 
> As keep alive is set through this path, my guess is that keep alive is
> not being set in the device.  Or perhaps reading 16-bits perturbs
> another register.  Is there a way to test?
> 
> http://dev.laptop.org/~quozl/z/1drtGD.txt dmesg of 4.13
> 
> http://dev.laptop.org/~quozl/z/1drt7c.txt dmesg with 4.13 and revert
> of 40b368af4b75

James,

I'm afraid we are needing to revisit this problem again. Changing that 8-bit 
read to a 16-bit version causes an unaligned memory reference in AARCH64, thus 
we will need to re-revert. To prevent problems on systems such as yours, PK 
plans to turn off ASPM capability and backdoor in certain platforms that will be 
listed in a quirks table. Please report the output of 'dmidecode -t system' for 
you affected system(s).

We hope you will be able to test any proposed patches.

Thanks,

Larry
