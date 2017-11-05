Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from store.laptop.org ([18.85.44.157]:48639 "EHLO swan.laptop.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750724AbdKEV3y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 5 Nov 2017 16:29:54 -0500
Date: Mon, 6 Nov 2017 08:29:47 +1100
From: James Cameron <quozl@laptop.org>
To: Nik Nyby <nikolas@gnu.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org, pkshih@realtek.com
Subject: Re: rtl8821ae dbi read question
Message-ID: <20171105212947.GB26699@us.netrek.org> (sfid-20171105_223025_736380_C4F27076)
References: <d46763ef-14d1-a6fa-fb33-a0bd676ef056@gnu.org>
 <695fe947-7b0d-ef4b-5e90-ff503df6a08b@lwfinger.net>
 <6912fa90-4b21-c325-993b-27fed3c75293@gnu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6912fa90-4b21-c325-993b-27fed3c75293@gnu.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 05, 2017 at 04:15:36PM -0500, Nik Nyby wrote:
> I also want to note that adding rtl8821ae.aspm=0 to my grub kernel
> boot command doesn't fix my problem. (I'm building this driver into
> the kernel, not as a module). My connection dropping problem is
> fixed only if I comment out the aspm init code in the driver, per
> this patch:
>   https://patchwork.kernel.org/patch/9951511/

Interesting; that patch was for testing, and did more than just aspm=0.

Check for a BIOS update from your vendor.  Device registers can be
configured and persist despite warm reboot, which implies there is no
register reset in driver start or device reset, which further implies
that the BIOS can easily affect the outcome.

Check also for different behaviour after cold reboot; that is a power
down for 30 seconds then power up.

Do you yet have a known working kernel to bisect against?

-- 
James Cameron
http://quozl.netrek.org/
