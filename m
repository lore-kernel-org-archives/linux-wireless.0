Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:36154 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754379AbZEaOVC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 May 2009 10:21:02 -0400
Received: by bwz22 with SMTP id 22so7002130bwz.37
        for <linux-wireless@vger.kernel.org>; Sun, 31 May 2009 07:21:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3ace41890905302156t6f3e4422h5083e2926ffaa6b0@mail.gmail.com>
References: <3ace41890905302156t6f3e4422h5083e2926ffaa6b0@mail.gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Sun, 31 May 2009 16:20:43 +0200
Message-ID: <69e28c910905310720w227aa533td3ca82d96d615cb5@mail.gmail.com>
Subject: Re: compat-wireless won't associate on 2nd load
To: Hin-Tak Leung <hintak.leung@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've been experiencing something similar in vmware, though I thought
it was vmware's fault. (I have an 8187L.) In my case, detaching and
re-attaching the device to the VM was sufficient to reset it.

On Sun, May 31, 2009 at 6:56 AM, Hin-Tak Leung <hintak.leung@gmail.com> wrote:
> I have been having some curious problem with rtl8187 for about a week
> - having problem associating with 'direct probe to AP <mac-addrr>
> timed out' after a reboot, and/or switching between compat-wireless
> modules. I thought it is a temporary problem with
> wireless-testing/compat-wireless but obviously nobody else has seen
> anything like mine from the mailing-list traffic. So I tried
> bisecting, etc and the results are inconsistent. Then I came to a
> vaguely working solution - it seems that I cannot modprobe
> compat-wireless twice - i.e. I can associate with compat-wireless
> after make install, make unload, modprobe; but modprobe -r then
> modprobe -v again I can't associate . I thought about restarting
> network manager, wpa_supplicant, etc without success, but the surest
> way to re-gain connectivity is simply to blow away /lib/modules/`uname
> -r`/updates, depmod -a and load the as-shipped modules. (and then I
> can make install compat-wireless and use it, and the cycle repeats if
> I unload compat-wireless and try to install a different
> compat-wireless snapshot, etc).
>
> This is really curious, as it seems that I cannot unload
> compat-wireless and reload it (or a later snapshot) without going
> through as-shipped-by-distro modules ( 2.6.29.4-167.fc11.x86_64) in
> the middle. How is that possible? One possibility is that as-shipped
> module does a reset of hardware on unload or wireless-testing put the
> hardware in a bad state on unload; but I know of no change of that
> sort. Anybody else having problems associating after modprobe -r
> /modprobe  -v with recent compat-wireless/wireless-testing?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
