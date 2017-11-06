Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f175.google.com ([74.125.82.175]:47801 "EHLO
        mail-ot0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751405AbdKFCJE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 5 Nov 2017 21:09:04 -0500
Received: by mail-ot0-f175.google.com with SMTP id s88so7084015ota.4
        for <linux-wireless@vger.kernel.org>; Sun, 05 Nov 2017 18:09:04 -0800 (PST)
Subject: Re: rtl8821ae dbi read question
To: Nik Nyby <nikolas@gnu.org>, linux-wireless@vger.kernel.org,
        pkshih@realtek.com
References: <d46763ef-14d1-a6fa-fb33-a0bd676ef056@gnu.org>
 <695fe947-7b0d-ef4b-5e90-ff503df6a08b@lwfinger.net>
 <6912fa90-4b21-c325-993b-27fed3c75293@gnu.org>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <702e4270-dcf3-5916-daee-f2265e0da907@lwfinger.net> (sfid-20171106_030908_145253_FAFAE0D0)
Date: Sun, 5 Nov 2017 20:09:02 -0600
MIME-Version: 1.0
In-Reply-To: <6912fa90-4b21-c325-993b-27fed3c75293@gnu.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/05/2017 03:15 PM, Nik Nyby wrote:
> I also want to note that adding rtl8821ae.aspm=0 to my grub kernel boot command 
> doesn't fix my problem. (I'm building this driver into the kernel, not as a 
> module). My connection dropping problem is fixed only if I comment out the aspm 
> init code in the driver, per this patch:
>    https://patchwork.kernel.org/patch/9951511/

Disabling all of _rtl8821ae_enable_aspm_back_door() may not be wise. We tried 
that patch as part of debugging.

That routine consists of two mdio r/w sequences, and 3 dbi r/w sequences. The 
third one of the latter is only used for RTL8812AE, thus it can be ignored.

What happens if you try disabling those r/w pairs one at a time? It is possible 
that one, or more of them, should be disabled when aspm is zero. It should not 
matter whether the driver is built in, or loaded as a module. Please note that I 
never build that code in as I always want the option of refreshing the driver 
without rebooting.

Larry
