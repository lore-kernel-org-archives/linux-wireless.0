Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:63648 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759934AbaJ3N4I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2014 09:56:08 -0400
Received: by mail-wg0-f47.google.com with SMTP id a1so4304512wgh.34
        for <linux-wireless@vger.kernel.org>; Thu, 30 Oct 2014 06:56:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5FF020A1CFFEEC49BD1E09530C4FF5951821B4843B@SC-VEXCH1.marvell.com>
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
	<CAAfyv34ivLF-B0ip+uhCah0PsiRsP1QOD0qW8F73n7KERqgM2w@mail.gmail.com>
	<CAAfyv37uyPwED3tzX_4RjeTuf8LXqtL3zH4f-cNOLuRB+w=z6Q@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951821545AE6@SC-VEXCH1.marvell.com>
	<CAAfyv35G=9WyYxQZjt3EYfGC+u0z81ktXrO7LEUrADxKX3XDNA@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951821B47FD7@SC-VEXCH1.marvell.com>
	<CAAfyv35oXYBqQsPzLWz4k6cM44+GSmPC6TTgVoELEjM_FAoYQw@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951821B4843B@SC-VEXCH1.marvell.com>
Date: Thu, 30 Oct 2014 14:56:06 +0100
Message-ID: <CAAfyv351AXRuZw5zYQ2=6jmJrnzLLscggzduKuL6GeQbzQgNqg@mail.gmail.com> (sfid-20141030_145612_965121_DD8225C7)
Subject: Re: mwifiex_usb_submit_rx_urb: dev_alloc_skb failed when conected to 5GHz
From: Belisko Marek <marek.belisko@gmail.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Avinash Patil <patila@marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Amitkumar,

On Thu, Oct 30, 2014 at 11:01 AM, Amitkumar Karwar <akarwar@marvell.com> wrote:
> Hi Marek,
>
> Thanks a lot for testing. I have added flow control logic to limit pending Rx packets. Could you please check if attached patch fixes out of memory issue?
> You can also backport below patch to your 3.9 kernel for rx_pending count imbalance issue.
With rx_pending count imbalance + your patch on top I cannot reproduce
allocation failure issue (tested on 1 hour iperf session).
Reason why console was completely blocked was that iperf server eats ~
55% cpu + kworker ~27 + ksoftirq ~14 so I think this is cause
why console was unresponsive. Thanks for patches. You can add my Tested-by ;)
>
> http://www.spinics.net/lists/linux-wireless/msg115536.html
>
> Your hacks to decrement rx_pending count won't be needed now.
>
> Regards,
> Amitkumar

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
