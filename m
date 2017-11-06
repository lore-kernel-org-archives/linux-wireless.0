Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eggs.gnu.org ([208.118.235.92]:56017 "EHLO eggs.gnu.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750817AbdKFEJ3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 5 Nov 2017 23:09:29 -0500
Received: from Debian-exim by eggs.gnu.org with spam-scanned (Exim 4.71)
        (envelope-from <nikolas@gnu.org>)
        id 1eBYj0-0005tM-4W
        for linux-wireless@vger.kernel.org; Sun, 05 Nov 2017 23:09:26 -0500
Subject: Re: rtl8821ae dbi read question
To: Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org, pkshih@realtek.com
References: <d46763ef-14d1-a6fa-fb33-a0bd676ef056@gnu.org>
 <695fe947-7b0d-ef4b-5e90-ff503df6a08b@lwfinger.net>
 <6912fa90-4b21-c325-993b-27fed3c75293@gnu.org>
 <702e4270-dcf3-5916-daee-f2265e0da907@lwfinger.net>
From: Nik Nyby <nikolas@gnu.org>
Message-ID: <ca520364-0d18-54c2-e6bc-b8245f8408ea@gnu.org> (sfid-20171106_050941_485634_E2AF2078)
Date: Sun, 5 Nov 2017 23:09:15 -0500
MIME-Version: 1.0
In-Reply-To: <702e4270-dcf3-5916-daee-f2265e0da907@lwfinger.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/05/2017 09:09 PM, Larry Finger wrote:
> Disabling all of _rtl8821ae_enable_aspm_back_door() may not be wise. We 
> tried that patch as part of debugging.
> 
> That routine consists of two mdio r/w sequences, and 3 dbi r/w 
> sequences. The third one of the latter is only used for RTL8812AE, thus 
> it can be ignored.
> 
> What happens if you try disabling those r/w pairs one at a time? It is 
> possible that one, or more of them, should be disabled when aspm is 
> zero. 

I first tried disabling only the mdio sequences, then the dbi sequences. 
I was able to reproduce my problem in both cases. But I have found that 
my problem is resolved by only removing the enable_aspm() call, and 
leaving the call to _rtl8821ae_enable_aspm_back_door() intact.

If removing rtlpriv->intf_ops->enable_aspm(hw) is the same as setting 
aspm=0, then it's possible I'm not setting the option correctly. But as 
far as I can see right now, removing enable_aspm() is necessary for my 
stable connection.

> It should not matter whether the driver is built in, or loaded as 
> a module. Please note that I never build that code in as I always want 
> the option of refreshing the driver without rebooting.

Thanks for the info - I'll do the same.
