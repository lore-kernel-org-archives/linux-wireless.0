Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f182.google.com ([74.125.82.182]:49841 "EHLO
        mail-ot0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752591AbdKFNwV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Nov 2017 08:52:21 -0500
Received: by mail-ot0-f182.google.com with SMTP id c47so8628651otj.6
        for <linux-wireless@vger.kernel.org>; Mon, 06 Nov 2017 05:52:21 -0800 (PST)
Subject: Re: rtl8821ae dbi read question
To: Nik Nyby <nikolas@gnu.org>, linux-wireless@vger.kernel.org,
        pkshih@realtek.com
References: <d46763ef-14d1-a6fa-fb33-a0bd676ef056@gnu.org>
 <695fe947-7b0d-ef4b-5e90-ff503df6a08b@lwfinger.net>
 <6912fa90-4b21-c325-993b-27fed3c75293@gnu.org>
 <702e4270-dcf3-5916-daee-f2265e0da907@lwfinger.net>
 <ca520364-0d18-54c2-e6bc-b8245f8408ea@gnu.org>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <41409929-78bb-f00b-74e5-b70d6d157c52@lwfinger.net> (sfid-20171106_145225_960629_E6B1C159)
Date: Mon, 6 Nov 2017 07:52:19 -0600
MIME-Version: 1.0
In-Reply-To: <ca520364-0d18-54c2-e6bc-b8245f8408ea@gnu.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/05/2017 10:09 PM, Nik Nyby wrote:
> On 11/05/2017 09:09 PM, Larry Finger wrote:
>> Disabling all of _rtl8821ae_enable_aspm_back_door() may not be wise. We tried 
>> that patch as part of debugging.
>>
>> That routine consists of two mdio r/w sequences, and 3 dbi r/w sequences. The 
>> third one of the latter is only used for RTL8812AE, thus it can be ignored.
>>
>> What happens if you try disabling those r/w pairs one at a time? It is 
>> possible that one, or more of them, should be disabled when aspm is zero. 
> 
> I first tried disabling only the mdio sequences, then the dbi sequences. I was 
> able to reproduce my problem in both cases. But I have found that my problem is 
> resolved by only removing the enable_aspm() call, and leaving the call to 
> _rtl8821ae_enable_aspm_back_door() intact.
> 
> If removing rtlpriv->intf_ops->enable_aspm(hw) is the same as setting aspm=0, 
> then it's possible I'm not setting the option correctly. But as far as I can see 
> right now, removing enable_aspm() is necessary for my stable connection.

Your results seem to indicate that aspm, which is support_aspm internally, is 
not being set to zero. The first executable statement in enable_aspm is

         if (!ppsc->support_aspm)
                 return;

That statement should disable the entire routine; however, you still need to 
disable the call to this routine. It is possible that the timing is messed up 
when built into the kernel. Building as a module will be instructive.

Larry
