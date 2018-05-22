Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f46.google.com ([209.85.160.46]:35790 "EHLO
        mail-pl0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751001AbeEVE7J (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 May 2018 00:59:09 -0400
Received: by mail-pl0-f46.google.com with SMTP id i5-v6so10129593plt.2
        for <linux-wireless@vger.kernel.org>; Mon, 21 May 2018 21:59:08 -0700 (PDT)
Date: Mon, 21 May 2018 21:59:06 -0700
From: Eric Biggers <ebiggers3@gmail.com>
To: "Dreyfuss, Haim" <haim.dreyfuss@intel.com>
Cc: linuxwifi <linuxwifi@intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Coelho, Luciano" <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [4.17 iwlwifi regression] NULL pointer dereference in
 reg_query_regdb_wmm()
Message-ID: <20180522045906.GB987@sol.localdomain> (sfid-20180522_065925_529139_2AAC9F3A)
References: <20180519183345.GA701@sol.localdomain>
 <409B2791E285FD41B488E034D9B4719F27E99C58@HASMSX106.ger.corp.intel.com>
 <20180522044712.GA987@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180522044712.GA987@sol.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 21, 2018 at 09:47:12PM -0700, Eric Biggers wrote:
> Hi Haim,
> 
> On Mon, May 21, 2018 at 10:10:09AM +0000, Dreyfuss, Haim wrote:
> > Hello,
> > 
> > Can you provide the following information?
> > 1. The *boot* you mentioned is from clean shutdown or from Sx state?
> > 2. Do you know which MCC the driver is trying to update?
> > I will appreciate if you could reproduce it with trace-cmd  (recording at least iwlwifi , iwlwifi_msg -and iwlwifi_ucode)
> > Or if you can't,  just send dmesg  but make sure to set iwlwifi.debug in the kernel parameters to 0x4000
> > 
> 
> It's a clean boot, from powered off.
> 
> I built an v4.17-rc6 kernel with CONFIG_IWLWIFI_DEBUG=y and booted with
> iwlwifi.debug=0x4000.  I've attached the dmesg output and kernel config.
> 
> The crash happens right away, so there's no time to easily run trace-cmd.
> But if the other stuff still isn't enough, I can try booting with the
> NetworkManager service disabled, then enabling it at runtime.
> 
> - Eric

The crash goes away if I replace iwlwifi-7265D-27.ucode in CONFIG_EXTRA_FIRMWARE
with iwlwifi-7265D-29.ucode.  I don't know how well supported using old iwlwifi
firmware versions is supposed to be, but it shouldn't crash the kernel.

- Eric
