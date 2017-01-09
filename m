Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:34140 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S934450AbdAIW0P (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jan 2017 17:26:15 -0500
Message-ID: <1484000770.5227.35.camel@coelho.fi> (sfid-20170109_232640_028595_1306F87E)
From: Luca Coelho <luca@coelho.fi>
To: Alexander Morozov <alexandr.morozov@docker.com>,
        Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Cc: Fabio Coatti <fabio.coatti@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        linuxwifi <linuxwifi@intel.com>
Date: Tue, 10 Jan 2017 00:26:10 +0200
In-Reply-To: <CA+EAOG50cJM_Sg5Q+G+LCfCgUwZ92BH5mcctUvFeWeT9aPAS7Q@mail.gmail.com>
References: <2029482.jt8IarKZJs@calvin>
         <942b4775-6027-2b99-84c7-37b7cde124b9@au1.ibm.com>
         <CA+EAOG50cJM_Sg5Q+G+LCfCgUwZ92BH5mcctUvFeWeT9aPAS7Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: kernel 4.9 iwlwifi startup error
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-01-03 at 07:41 -0800, Alexander Morozov wrote:
> I have a similar problem on Gentoo. But in my case, it just can't load
> firmware: "no suitable firmware found". I've tried to reinstall
> firmware with no luck. Everything is ok with 4.8.6.

This is a completely different issue.  This means that you don't have
the correct firmware installed for this kernel version.  We do support
several versions back from the latest, but we can't support older
firmwares forever, so if you're using a recent kernel you must upgrade
the firmwares too.

Let me know which device you have, so I can tell you which firmware you
need to use.  But as a general rule, if you clone the linux-firmware
repository[1] and install all the iwlwifi*.ucode files in /lib/firmware
(or wherever gentoo looks for the firmware in your filesystem), you will
surely get the latest version of the firmware that works with your
kernel.

[1] http://git.kernel.org/cgit/linux/kernel/git/firmware/linux-firmware.git

--
Cheers,
Luca.
