Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:52614 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751415AbdJKHrx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Oct 2017 03:47:53 -0400
Message-ID: <1507708070.908.216.camel@coelho.fi> (sfid-20171011_094811_483286_147897A0)
From: Luca Coelho <luca@coelho.fi>
To: Seraphime Kirkovski <kirkseraph@gmail.com>,
        linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Date: Wed, 11 Oct 2017 10:47:50 +0300
In-Reply-To: <20171010074414.x3uqv27prkqov45v@macchiaveli>
References: <20171010074414.x3uqv27prkqov45v@macchiaveli>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: 4.14.0-rc3 iwlwifi: Hardware became unavailable during restart
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-10-10 at 09:44 +0200, Seraphime Kirkovski wrote:
> Hello,

Hi Seraphime,


> I've got this splat after a couple of suspend-resume cycles on my
> HP-laptop. I haven't had the time to bisect or test other rcs for now.
> Pasting some logs before the actual WARN_ON, as they may be relevant.
> Just after the splat the connection is successfully reestablished.
> 
> [14293.758404] iwlwifi 0000:24:00.0: Error sending REPLY_SCAN_ABORT_CMD: 
> time out after 2000ms.
> [14293.758429] iwlwifi 0000:24:00.0: Current CMD queue read_ptr 67 write_ptr 68
> [14293.758518] iwlwifi 0000:24:00.0: Loaded firmware version: 18.168.6.1

This seems to be a DVM device (iwldvm).  What is the exact device
model? And you have never noticed this problem before?

Unfortunately this is a very old device and we don't support it
actively anymore.  Hopefully this will turn out to be a trivial fix in
the driver side, so we can get it solved for you.

The best way to track this is to report it in
https://bugzilla.kernel.org.

--
Cheers,
Luca.
