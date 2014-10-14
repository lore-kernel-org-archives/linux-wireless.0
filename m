Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:44988 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbaJNIZC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2014 04:25:02 -0400
Received: by mail-vc0-f174.google.com with SMTP id hq12so7078434vcb.19
        for <linux-wireless@vger.kernel.org>; Tue, 14 Oct 2014 01:25:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5FF020A1CFFEEC49BD1E09530C4FF5951821936F03@SC-VEXCH1.marvell.com>
References: <CAAfyv35k1mgQh6FcWaaMciAo8Vkp055k=5xF7zu+yrHmrQbbLA@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951819DB12F1@SC-VEXCH1.marvell.com>
	<CAAfyv35j-77AURB4fHcecbEvyGS6U+1APNRFCf3FDAd_rrWnJw@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951821351855@SC-VEXCH1.marvell.com>
	<CAAfyv35E2HUReFpnpdsebPETKk9VPA_hfQHUEJmoJfQt6Q-Puw@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951821936285@SC-VEXCH1.marvell.com>
	<CAAfyv34UXMNwHf+kYCWEn+bcfGda_gA7uroLRLvhTEGGC5R57w@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951821936BBC@SC-VEXCH1.marvell.com>
	<CAAfyv36s+stSKU7Oi372EjsvUi+S6PSbg1wVTD1dJrMrerBPXg@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951821936F03@SC-VEXCH1.marvell.com>
Date: Tue, 14 Oct 2014 10:25:01 +0200
Message-ID: <CAAfyv34ivLF-B0ip+uhCah0PsiRsP1QOD0qW8F73n7KERqgM2w@mail.gmail.com> (sfid-20141014_102526_106205_2E5C1465)
Subject: Re: mwifiex_usb_submit_rx_urb: dev_alloc_skb failed when conected to 5GHz
From: Belisko Marek <marek.belisko@gmail.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Avinash Patil <patila@marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Amitkumar,

On Tue, Oct 14, 2014 at 9:08 AM, Amitkumar Karwar <akarwar@marvell.com> wrote:
> Hi Marek,
>
>>I tried both (slightly modified as we're in 3.9 kernel) but issue is
>>still reproducible. My patch against 3.9 sources:
>
> Thanks a lot for the tests.
>
>>One thing which is not yet still clear to me why kernel console is
>>completely unresponsive when receiving packets in high rates. When use
>>iperf (on client) with -b40m it is OK but when increase to -b100m then
>>console is completely unresponsive until iperf finish.
>
> Does the system recover when "-b100M" iperf is finished? Can we run iperf with "-b40M" later?
> Do you see "dev_alloc_skb failed" messages in dmesg when console is unresponsive?
When we get "dev_alloc_skb failed" then interface is dead (cannot ping
...) so no recovery is possible only system reboot.
I don't see  dev_alloc_skb failed when console is unresponsive.
>
>>Any other ideas
>>what to change to check? Thanks.
>
> Could you please share dmesg log with dynamic debug enabled (using attached script) captured when the problem occurs?
I tried to capture logs but when enable DYNAMIC_DEBUG I cannot
reproduce issue (running test > 30 minutes without allocation
failure).
>
> Best regards,
> Amit

BR,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
