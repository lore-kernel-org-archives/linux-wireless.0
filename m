Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47687 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398Ab2AaPTl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 10:19:41 -0500
Received: by pbdu11 with SMTP id u11so244046pbd.19
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jan 2012 07:19:40 -0800 (PST)
Message-ID: <4F280689.1080402@canonical.com> (sfid-20120131_161944_881614_17EFAA26)
Date: Tue, 31 Jan 2012 08:19:37 -0700
From: Tim Gardner <rtg.canonical@gmail.com>
Reply-To: tim.gardner@canonical.com
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH V3] rtlwifi: Convert to asynchronous firmware load
References: <4f272b8e.6jAMcI3HDthxlb+q%Larry.Finger@lwfinger.net>
In-Reply-To: <4f272b8e.6jAMcI3HDthxlb+q%Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/30/2012 04:45 PM, Larry Finger wrote:
> This patch addresses a kernel bugzilla report and two recent mail threads.
>
> The kernel bugzilla report is https://bugzilla.kernel.org/show_bug.cgi?id=42632,
> which reports a udev timeout on boot.
>
> The first mail thread, which was on LKML (http://lkml.indiana.edu/hypermail/
> linux/kernel/1112.3/00965.html) was for a WARNING that occurs after a
> suspend/resume cycle for rtl8192cu.
>
> The scond mail thread (http://marc.info/?l=linux-wireless&m=132655490826766&w=2)
> concerned changes in udev that break drivers that delay while firmware is loaded
> on modprobe.
>
> This patch converts all rtlwifi-based drivers to use the asynchronous firmware
> loading mechanism. Drivers rtl8192ce, rtl8192cu and rtl8192de share a common
> callback routine. Driver rtl8192se needs different handling of the firmware,
> thus it has its own code.
>
> Signed-off-by: Larry Finger<Larry.Finger@lwfinger.net>
> Cc: Stable<stable@vger.kernel.org>
> ---
>
> V2 - Add check for firmware load callback.
> V3 - Removed some debugging code left in by accident.
>
> ---
>
> John,
>
> This patch will apply to the wireless-testing git tree.
>
> I have mixed feelings about the timing of the inclusion of this patch.
> It is quite invasive, which would normally indicate that it go through
> the normal process and ultimately be included in V3.4 to get further
> testing. On the other hand, the number of bug reports is growing rapidly,
> which argues for it to be included quickly and backported to stable.
>
> I'll leave that decision to you. If you decide to push this to mainline
> now, there is one additional complication due to conflicts with the series
> of patches by Joe Perches that modified the debug printouts (commits
> 804dd24 through 07839b1). I have a version of the patch for Linus's tree,
> but that pushes the conflicts in a later merge in linux-next.
>
> To improve the testing coverage, I will post the mainline patch at b.k.o,
> bug #42632.
>
> Larry
> ---
>


d88e0b3162bded8190866d9a17f5e36c9bb0d29e in wireless-testing (which 
includes 'rtlwifi: Convert to asynchronous firmware load') is working 
well on my RTL8188CE [10ec:8176].

rtg
-- 
Tim Gardner tim.gardner@canonical.com
