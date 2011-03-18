Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:35629 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756795Ab1CRPXR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 11:23:17 -0400
Received: by vxi39 with SMTP id 39so3626528vxi.19
        for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2011 08:23:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201103172107.25316.helmut.schaa@googlemail.com>
References: <AANLkTik9wfkskAHEpmsm4_gPM0FFBf=q8OVXM99NBRjO@mail.gmail.com>
	<201103171316.02636.helmut.schaa@googlemail.com>
	<AANLkTi=Gm-apOyop22UgFMgoQE_+maEQgrMDdH-kTxZq@mail.gmail.com>
	<201103172107.25316.helmut.schaa@googlemail.com>
Date: Fri, 18 Mar 2011 16:23:15 +0100
Message-ID: <AANLkTi=u3dw1D1-+-Cy9aEPc2H1MAF+cUi=ucvMTNrNc@mail.gmail.com>
Subject: Re: [rt2x00-users] rt2800usb stops working with big file transfers in
 AP and IBSS
From: Juan Carlos Garza <juancarlosgarza@gmail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Helmut,

Thanks a lot for your help!

I applied the patches (manually), and tested the stick.

The transfer of big loads now is successful. The
"rt2800_txdone_entry_check:" warnings are still there, but they are
less frequent (just like in the example i gave you with the laptop
where it succeeded with the unpatched driver), some 5 warnings every
1, 2 or 3 seconds.

I was able to transfer a 512 MByte file from a Linux 2.6.24 system
running an Intel Atom processor with a rt3071 USB stick to the
follwing NICs:

Intel 3945ABG running Windows XP 32 bit
Realtek rtl8188cus running on Windows XP 32 bit
Dell 1397 running Windows 7 64 bit
Broadcom 4306 running Linux
Intel 4965 running Windows XP 32 bit
Ralink rt3070 running Windows XP 32 bit.
Atheros AR9170 running Windows XP 64 bit and 32 bit.

Once again, thanks a lot for your support, and I'm glad to be able to
test the experimental patches.

Best regards,

Juan Carlos


On Thu, Mar 17, 2011 at 9:07 PM, Helmut Schaa
<helmut.schaa@googlemail.com> wrote:
> Am Donnerstag, 17. März 2011 schrieb Juan Carlos Garza:
>> Warning - TX status report missed for queue 0 entry 42
>> Mar 17 17:10:26 LS817 kernel: phy0 -> rt2x00queue_flush_queue: Warning
>> - Queue 0 failed to flush
>
> Looks as if some tx status reports got lost and that triggered the
> watchdog. There are some experimental patches in the rt2x00 experimental
> tree ([1], [2], [3] and [4]) that might mitigate some of these issues.
>
> Mind to try these out and report back if they improve the behavior
> under load?
>
> Thanks,
> Helmut
>
> [1] http://git.kernel.org/?p=linux/kernel/git/ivd/rt2x00.git;a=commit;h=878a2bbc20100d8bccf84cc058373fe7de2e6501
> [2] http://git.kernel.org/?p=linux/kernel/git/ivd/rt2x00.git;a=commit;h=4f3ab1e88d8b5ce4852d075016ca784a00383452
> [3] http://git.kernel.org/?p=linux/kernel/git/ivd/rt2x00.git;a=commit;h=c8cb3a0af064fb5d9cbbaa16bd2f308ba3b90ceb
> [4] http://git.kernel.org/?p=linux/kernel/git/ivd/rt2x00.git;a=commit;h=66b096e6ad64f718425d2de9a70d82ba187d7db4
>



-- 
________________________________
M.Sc. Juan Carlos Garza Fernández
Chistophstr. 14
70178 Stuttgart, Deutschland
+49 711 4080769
+49 176 21947676
juancarlosgarza@gmail.com
________________________________
