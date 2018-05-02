Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42370 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750869AbeEBH7E (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 May 2018 03:59:04 -0400
Message-ID: <24f6604b3d45c04c2dd15b2c47855a739c8ced1a.camel@coelho.fi> (sfid-20180502_100318_862625_A9F92BB4)
From: Luca Coelho <luca@coelho.fi>
To: Jape Person <japers@comcast.net>, linux-wireless@vger.kernel.org
Cc: emmanuel.grumbach@intel.com
Date: Wed, 02 May 2018 10:58:59 +0300
In-Reply-To: <1b91c09e-d20b-bcb2-5961-7c7b400a78d9@comcast.net>
References: <1b91c09e-d20b-bcb2-5961-7c7b400a78d9@comcast.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: Possible Regression in Wireless Driver Affecting Intel
 Corporation Wireless 7265 (rev 59)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-04-30 at 18:01 -0400, Jape Person wrote:
> Two recent kernel upgrades seem to have both affected the Intel
> Corporation Wireless 7265 (rev 59) adapters on our systems in a
> manner which causes their network transfer rates to be reduced
> dramatically. File transfers which normally require a few
> minutes are now taking several hours.
> 
> These systems are running the Debian testing distribution with
> the iwilwifi drivers from Debian's testing/contrib. The altered
> behavior came when the Debian linux-image version advanced to
> 4.15.*.
> 
> I looked online for similar reports and didn't find anything
> that seemed directly applicably. I finally got lucky when I
> experimented with the net.ipv4.tcp_congestion_control setting.
> 
> I understand that in version 4.15 of the kernel the default was
> changed from cubic to bbr. I used
> 
> # sysctl net.ipv4.tcp_congestion_control=cubic
> 
> to revert to the previous default on all of the systems. This
> has caused all of the systems to return to their normal file
> transfer speeds.
> 
> Please let me know by direct reply (I'm not subscribed.) if I
> can supply more information.

Do you see anything in dmesg? SYSASSERT messages or something? Please
send your dmesg so we can take a look.

Are you by any chance using NFS? Emmanuel has recently fixed a problem
that was occurring with NFS (but probably happens with other protocols
too).  Can you apply the patch included in the following bugzilla
report and see if it helps?

https://bugzilla.kernel.org/show_bug.cgi?id=199209#c18

--
Cheers,
Luca.
