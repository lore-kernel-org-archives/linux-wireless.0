Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:53782 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1762714AbdJQOGD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Oct 2017 10:06:03 -0400
Message-ID: <1508249157.5497.103.camel@coelho.fi> (sfid-20171017_160615_039955_D48C2D0A)
From: Luca Coelho <luca@coelho.fi>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-wireless@vger.kernel.org, linuxwifi@intel.com
Date: Tue, 17 Oct 2017 17:05:57 +0300
In-Reply-To: <20171017094440.25tpkoeyfm6q2lqw@merlins.org>
References: <20170526024826.3qjx7pe3kz44klk3@merlins.org>
         <1496396575.9478.54.camel@coelho.fi> <20170603165950.GC29546@merlins.org>
         <20170816233844.qtigfurckdr44awa@merlins.org>
         <20171017094440.25tpkoeyfm6q2lqw@merlins.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: After upgrading to 4.11.1, wifi driver refuses to load after
 being unloaded once.
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Tue, 2017-10-17 at 02:44 -0700, Marc MERLIN wrote:
> Was broken in 4.11, still broken in 4.12. This is crippling, I'm not
> running linux so that I have to reboot it to reload an intel wireless
> driver :-/

Can you report a bug in https://bugzilla.kernel.org so it's easier to
track this?

The problem seems to be that the rootport is not leaving D3 for some
reason when the driver is loaded again.  Do you have
CONFIG_IWLWIFI_PCIE_RTPM enabled in your .config? (you shouldn't)

In any case, better continue tracking this in bugzilla, so please
report it there and include the full dmesg output so we can better
understand what is going on.

--
Cheers,
Luca.
