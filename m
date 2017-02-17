Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:48210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754149AbdBQCJ1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Feb 2017 21:09:27 -0500
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: johannes.berg@intel.com, luciano.coelho@intel.com,
        emmanuel.grumbach@intel.com, tj@kernel.org, arjan@linux.intel.com,
        ming.lei@canonical.com, zajec5@gmail.com
Cc: jeyu@redhat.com, rusty@rustcorp.com.au, pmladek@suse.com,
        gregkh@linuxfoundation.org, linuxwifi@intel.com,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [RFC 0/5] iwlwifi: enhance final opmode work
Date: Thu, 16 Feb 2017 18:08:58 -0800
Message-Id: <20170217020903.6370-1-mcgrof@kernel.org> (sfid-20170217_031056_571505_F608D489)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Although these are iwlwifi patches, there are some core module, async,
firmware questions I'd appreciate a bit more review from folks on -- tx!

Firmware folks / async folks / module folks:

I started to look to generalize the way the iwlwifi driver uses the
firmware API to request for firmware through a series of API versions,
to chain firmware requests. I had to start examining its firmware
callback carefully as it used request_module() and because the driver
data API [0] (an evolution of the firmware API) I've been developing
uses async_schedule() instead of workqueues. Although I had started
using workqueues to match the old firmware API I went with
async_schedule() since I noticed most drivers using an async callback
also had to add a completion struct on their drivers and later waited
for completion at some other point. Using async framework we can just
give users a cookie, and they can use that to sync for completion.

One of the limitations of using async_schedule() though is we cannot
request_module() synchronously on async calls given that the module
initialization code will call async_synchronize_full() if the module
being initialized happened to have used async work on its initialization
routine, otherwise we'd deadlock.

So, I either I change back to workqueus or we live happy with either:

   a) Use request_module_nowait() on async calls -- this works
   b) If you need request_module() on your async call, consider a
      workqueue

Module folks:

One of the issues with a) is that contrary to try_then_request_module()
which helps validate module loading we have had no common generic
lightweight form to validate a module loaded correctly if you use
request_module_nowait(). You can surely use a module notifier with
register_module_notifier() -- but again, that is not lightweight, quick
and easy. From the look of it though, most current users simply call
request_module_nowait() and hope for the best -- there are no verifiers.
That's probably fine (?) -- other than failures can be silent. At least
iwlwifi would want to make a beep about failures it seems, so I went
with b).

In this series I went with b) but still note that iwlwifi cannot use
bare try_then_request_module() cleanly -- so it has its own wrapper (see
patch 02).

iwlfifi folks:

This patch series does not depend on the driver data API, but its is an
example of b). It also contains a series of other fixes and enhancements
for iwlwifi's opmode final work worth revising -- regardless of what
happens with the driver data API. With these patches average boot time
seems to improve slightly, but I'd expect much more testing would be
required before making any clear determination. I used 5 boots per patch.
I started with next-20170213. Following data is average boot times as
per systemd-analyze. The vanilla kernel (patch-00) got more testing as
I'm also using this a base for other testing -- 100 boots.

patch-00 Startup finished in  2.64057s (kernel) +  5.52668s (initrd) +  11.3024s (userspace) =  19.4707s
patch-01 Startup finished in    2.574s (kernel) +   5.1505s (initrd) +  11.0698s (userspace) =  18.7952s
patch-02 Startup finished in    2.618s (kernel) +   5.3102s (initrd) +  11.1736s (userspace) =  19.1026s
patch-03 Startup finished in   2.5612s (kernel) +   5.3274s (initrd) +  11.0226s (userspace) =  18.9122s
patch-04 Startup finished in   2.5475s (kernel) +   5.0895s (initrd) +  10.9272s (userspace) =  18.5652s

[0] https://git.kernel.org/cgit/linux/kernel/git/mcgrof/linux-next.git/log/?h=20170206-driver-data-try2

Luis R. Rodriguez (5):
  iwlwifi: fix drv cleanup on opmode registration failure
  iwlwifi: fix request_module() use
  iwlwifi: share opmode start work code
  iwlwifi: move opmode loading to shared routine
  iwlwifi: convert final opmode work into a workqueue

 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 140 +++++++++++++++++++--------
 1 file changed, 100 insertions(+), 40 deletions(-)

-- 
2.11.0
