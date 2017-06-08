Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f43.google.com ([74.125.83.43]:35812 "EHLO
        mail-pg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751673AbdFHUBA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Jun 2017 16:01:00 -0400
Received: by mail-pg0-f43.google.com with SMTP id k71so19301983pgd.2
        for <linux-wireless@vger.kernel.org>; Thu, 08 Jun 2017 13:01:00 -0700 (PDT)
Date: Thu, 8 Jun 2017 13:00:56 -0700
From: Brian Norris <briannorris@chromium.org>
To: "Chadzynski, MikolajX" <mikolajx.chadzynski@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "amitkarwar@gmail.com" <amitkarwar@gmail.com>,
        "nishants@marvell.com" <nishants@marvell.com>,
        "gbhat@marvell.com" <gbhat@marvell.com>,
        "huxm@marvell.com" <huxm@marvell.com>
Subject: Re: porting 'mwifiex: resolve races between async FW init (failure)
 and device removal' to kernel 4.1.x
Message-ID: <20170608200055.GA109284@google.com> (sfid-20170608_220109_764559_88124464)
References: <382E97DBE488D844B7F3CE8D1D2355C83717C8B6@IRSMSX104.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <382E97DBE488D844B7F3CE8D1D2355C83717C8B6@IRSMSX104.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 08, 2017 at 01:11:28PM +0000, Chadzynski, MikolajX wrote:
> Races between async firmware initialization and device removal appears on kernel 4.1.x.
> Whole scenario leading to the error together with logs is in https://bugzilla.kernel.org/show_bug.cgi?id=196003
> Mapping the patch from kernel 4.11.x "mwifiex: resolve races between async FW init (failure) and device removal" solved the problem.

FWIW, that patch was also in v4.10.

> In Bugzilla I've also attached patch which I've tested for pcie interface and it works.

What are you asking for? An official backport to the 4.1.x stable
series? I'm not super interested in trying to do that. And IIUC, your
patch is a no-go, as it will break the SDIO and USB driver builds.

If you do try to go forward with this, do try to note any follow-up
patches. I don't recall how many other related bugs there might have
been. I tried to mark things correctly with Fixes tags, but I may have
missed something, especially if such bugfixes also made it into 4.10.

Brian
