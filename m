Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eggs.gnu.org ([208.118.235.92]:58878 "EHLO eggs.gnu.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1764204AbdKSAjw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 18 Nov 2017 19:39:52 -0500
Received: from Debian-exim by eggs.gnu.org with spam-scanned (Exim 4.71)
        (envelope-from <nikolas@gnu.org>)
        id 1eGDeH-0001Wf-1m
        for linux-wireless@vger.kernel.org; Sat, 18 Nov 2017 19:39:49 -0500
Subject: Re: rtl8821ae dbi read question
To: Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org, pkshih@realtek.com
References: <d46763ef-14d1-a6fa-fb33-a0bd676ef056@gnu.org>
 <695fe947-7b0d-ef4b-5e90-ff503df6a08b@lwfinger.net>
 <6912fa90-4b21-c325-993b-27fed3c75293@gnu.org>
 <702e4270-dcf3-5916-daee-f2265e0da907@lwfinger.net>
 <ca520364-0d18-54c2-e6bc-b8245f8408ea@gnu.org>
 <41409929-78bb-f00b-74e5-b70d6d157c52@lwfinger.net>
From: Nik Nyby <nikolas@gnu.org>
Message-ID: <18ae2e47-aed9-0caa-7a17-1c98e4abc91c@gnu.org> (sfid-20171119_014028_984151_D93623A7)
Date: Sat, 18 Nov 2017 19:39:41 -0500
MIME-Version: 1.0
In-Reply-To: <41409929-78bb-f00b-74e5-b70d6d157c52@lwfinger.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/06/2017 08:52 AM, Larry Finger wrote:
> 
> Your results seem to indicate that aspm, which is support_aspm 
> internally, is not being set to zero. The first executable statement in 
> enable_aspm is
> 
>          if (!ppsc->support_aspm)
>                  return;
> 
> That statement should disable the entire routine; however, you still 
> need to disable the call to this routine. It is possible that the timing 
> is messed up when built into the kernel. Building as a module will be 
> instructive.
> 
> Larry
> 

FYI, when building this driver as a module, I'm not seeing my unstable 
connection problem anymore, with the aspm=0 config set in 
/etc/modprobe.d/. Thanks for your help with this.
