Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:56611 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbaHQDRj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Aug 2014 23:17:39 -0400
Received: by mail-la0-f51.google.com with SMTP id pn19so3432793lab.38
        for <linux-wireless@vger.kernel.org>; Sat, 16 Aug 2014 20:17:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140816221505.5420b21e@neptune.home>
References: <20140816221505.5420b21e@neptune.home>
Date: Sat, 16 Aug 2014 23:17:37 -0400
Message-ID: <CANUX_P3vPfOov++XAEdb67J-vrWY+FCLhGVwJ3sWt98avDcm5g@mail.gmail.com> (sfid-20140817_051742_679425_7D4E8E54)
Subject: Re: iwlwifi: fix Kconfig issues breaks CONFIG_MODULES=n
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: =?UTF-8?Q?Bruno_Pr=C3=A9mont?= <bonbons@linux-vserver.org>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 16, 2014 at 4:15 PM, Bruno Prémont
<bonbons@linux-vserver.org> wrote:
> Hi,
>
> The commit ae7486a2b734ee03 (iwlwifi: fix Kconfig issues) in 3.17-rc1
> breaks iwlwifi for kernels built without support for modules
> (CONFIG_MODULES=n).
>
> It changes the dependencies of IWLDVM and IWLMVM from
>   depends on IWLWIFI
> to
>   depends on m
> (while enclosing the whole set of options in 'if IWLWIFI').
>
>
> Why that dependency on 'm' for apparently mandatory feature of the driver
> (without DVM and MVM, Kconfig comment says
>   "WARNING: iwlwifi is useless without IWLDVM or IWLMVM"
>
>
> Up until 3.16 it was very well possible to operate iwlwifi built-in
> in a kernel without support for modules, either by building firmware
> into the kernel, or as needed re-binding the driver to the PCI device
> once filesystems were mounted.
>
> Removing those two 'depend on m' iwlwifi works fine for a 7260
> wireless card.
>

I know - you are not the first to report that - I have already 2
versions of the exact same patch fixing this.
But I am currently travelling and I'll handle later.
