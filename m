Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:43704 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752365AbeFEWx3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Jun 2018 18:53:29 -0400
Received: by mail-pl0-f66.google.com with SMTP id c41-v6so2473391plj.10
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jun 2018 15:53:29 -0700 (PDT)
Date: Tue, 5 Jun 2018 15:53:25 -0700
From: Brian Norris <briannorris@chromium.org>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: How to let devcoredump know data has been read?
Message-ID: <20180605225324.GA195207@rodete-desktop-imager.corp.google.com> (sfid-20180606_005334_267586_9E29A02A)
References: <6f54d11c-74a5-568a-ba1e-3f37edb28384@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <6f54d11c-74a5-568a-ba1e-3f37edb28384@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Tue, Jun 05, 2018 at 03:27:28PM -0700, Ben Greear wrote:
> I have been testing ath10k on 4.16, which uses the devcoredump API
> to notify about dumps.
> 
> I am able to see the binary crash dump at /sys/class/devcoredump/devcd2/data,
> for instance, but if I do another crash quickly, I get no new uevent sent
> and no new crash.
> 
> I see there is a 5 minute timer on the coredump data, but it also seems to indicate
> that if I read the crash, the data should be cleared and ready to be
> recreated again?  How do you notify the system that the crash data has
> been read?
> 
> I tried 'cat' on the data file, but that did not seem to clear anything.

Try *writing* to it?

https://elixir.bootlin.com/linux/v4.16/source/drivers/base/devcoredump.c#L91

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=833c95456a70826d1384883b73fd23aff24d366f

<quote>
The dumped data will be readable in sysfs in the virtual device's
data file under /sys/class/devcoredump/devcd*/. Writing to it will
free the data and remove the device, as does a 5-minute timeout.
</quote>

e.g.:

# ls -l /sys/class/devcoredump/devcd1
lrwxrwxrwx. 1 root root 0 Jun  5 15:49 /sys/class/devcoredump/devcd1 -> ../../devices/virtual/devcoredump/devcd1
# echo 1 > /sys/class/devcoredump/devcd1/data
# ls -l /sys/class/devcoredump/devcd1
ls: cannot access '/sys/class/devcoredump/devcd1': No such file or directory

Unfortunately, devcoredump is a bit lacking in documentation. Arend was
writing a bit for the new trigger mechanism at least.

Brian
