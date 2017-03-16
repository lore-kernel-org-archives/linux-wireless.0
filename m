Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:36554 "EHLO
        mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751954AbdCPVBM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Mar 2017 17:01:12 -0400
Received: by mail-pf0-f178.google.com with SMTP id o126so29747103pfb.3
        for <linux-wireless@vger.kernel.org>; Thu, 16 Mar 2017 14:00:27 -0700 (PDT)
Date: Thu, 16 Mar 2017 13:52:26 -0700
From: Brian Norris <briannorris@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>, rajatja@google.com
Subject: Re: [PATCH v2] mwifiex: fix kernel crash after shutdown command
 timeout
Message-ID: <20170316205224.GA34312@google.com> (sfid-20170316_220200_324278_1EA26105)
References: <1489660132-27352-1-git-send-email-akarwar@marvell.com>
 <20170316183317.GA2935@dtor-ws>
 <20170316184115.GA105900@google.com>
 <20170316193857.GB105900@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170316193857.GB105900@google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 16, 2017 at 12:38:57PM -0700, Brian Norris wrote:
> On Thu, Mar 16, 2017 at 11:41:15AM -0700, Brian Norris wrote:
> > On Thu, Mar 16, 2017 at 11:33:17AM -0700, Dmitry Torokhov wrote:
> > > You need to check this flag before queueing firmware dump work, and
> > > make sure it is not racy with setting this flag in mwifiex_pcie_remove()
> > > (and sdio).
> > 
> > That's another approach that could work, but it's a little more
> > invasive.
> 
> Never mind, that isn't too invasive. There's only one schedule_work() in
> pcie.c and two in sdio.c. We could even factor out a helper, that knows
> how to check the appropriate MWIFIEX_IFACE_* flags, if we really wanted
> to...

OK, so I took a crack at implementing this, and after thinking about it,
the "make sure it is not racy with setting this flag" part is tougher
than it seems. In the end, I think the key is that to eliminate the
race between setting and checking the flag, we just want to halt all
sources of more work -- e.g., commands (which could time out), or
debugfs entries (which could trigger a FW dump manually) -- without
fiddling with extra flags. We do this already in the first half of
mwifiex_remove_card(), when we terminate the main workqueue(s) and
unregister the net and wiphy devices.

IOW, we can move the cancel_work_sync() into the .cleanup_if() callback,
which occurs after the above described teardown, but before the PCIe
driver has actually called things like pci_disable_device() [1]. Then we
don't need any DONT_RUN flag either.

I'll test the above a bit more here, then send a v3 myself, with the
above reasoning captured. I *think* that should eliminate all the races
we've discussed here.

Brian


[1] BTW, I think I previously blamed mwifiex_init_shutdown_fw() for
    racing with the FW dumper; I think that is not actually the smoking
    gun (it was an educated guess). Based on testing, I see aborts if
    we're still accessing the PCIe device (e.g., in the FW dumper) after
    mwifiex_cleanup_pcie() -> pci_disable_device().
