Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:33126 "EHLO
	mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbcHGEiU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Aug 2016 00:38:20 -0400
Received: by mail-io0-f196.google.com with SMTP id y195so26798668iod.0
        for <linux-wireless@vger.kernel.org>; Sat, 06 Aug 2016 21:38:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1460448559.2630.8.camel@intel.com>
References: <1460448559.2630.8.camel@intel.com>
From: Emmanuel Grumbach <egrumbach@gmail.com>
Date: Sun, 7 Aug 2016 07:38:19 +0300
Message-ID: <CANUX_P27s1jzXfLzBca19db10c9yo1MKQ6T9b=pw-ZQLZ0KKVQ@mail.gmail.com> (sfid-20160807_063826_945508_519DF183)
Subject: Re: pull request: iwlwifi 2016-04-12
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 7, 2016 at 7:35 AM, Grumbach, Emmanuel
<emmanuel.grumbach@intel.com> wrote:
>
> Hi Kalle,
>
> Here is a pull request for 4.6. I have here a patch that was merged to
> -next already, but clearly, it should have been routed through the
> current cycle's trees. Sorry about that.
> The patch is:


Wow.. I knew evolution was sometimes stupid, but this is new to me..
Obviously you should ignore that.
Sorry...

>
> commit cd49727e1a2bccc4ff008dde24c2f8430dd9e368
> Author: Ayala Beker <ayala.beker@intel.com>
> Date:   Wed Feb 3 15:36:52 2016 +0200
>
>     iwlwifi: mvm: avoid to WARN about gscan capabilities
>
>     Gscan capabilities were updated with new capabilities supported
>     by the device. Update GSCAN capabilities TLV and avoid to WARN
>     if the firmware does not have the new capabilities.
>
> It appears in -next as:
>
> commit a0b09f13036cedfd67c9cb4b9d05138e7022723d
> Author: Ayala Beker <ayala.beker@intel.com>
> Date:   Wed Feb 3 15:36:52 2016 +0200
>
>     iwlwifi: mvm: update GSCAN capabilities
>
>     Gscan capabilities were updated with new capabilities supported
>     by the device. Update GSCAN capabilities TLV.
>
> The commit message wasn't good enough for the current cycle, so I
> rewrote it. Besides that one, all is fairly normal.
> Let me know if you have issues!
>
> Thanks.
>
>
> The following changes since commit 7fdf9663261cc77a516396fec82cee8a8ea07e76:
>
>   iwlwifi: mvm: fix memory leak in paging (2016-03-20 23:01:54 +0200)
>
> are available in the git repository at:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git tags/iwlwifi-for-kalle-2016-04-12
>
> for you to fetch changes up to 2d25fb8b3a138706b63bd26ad72a95c58029954a:
>
>   iwlwifi: mvm: fix accessing Null pointer during fw dump collection (2016-04-12 10:03:17 +0300)
>
> ----------------------------------------------------------------
> * add new device IDs for 8265
> * fix a NULL pointer dereference when paging firmware asserts
> * remove a WARNING on gscan capabilities
> * fix MODULE_FIRMWARE for 8260
>
> ----------------------------------------------------------------
> Ayala Beker (1):
>       iwlwifi: mvm: avoid to WARN about gscan capabilities
>
> Matti Gottlieb (1):
>       iwlwifi: mvm: fix accessing Null pointer during fw dump collection
>
> Oren Givon (1):
>       iwlwifi: add device IDs for the 8265 device
>
> Sara Sharon (1):
>       iwlwifi: 8000: fix MODULE_FIRMWARE input
>
>  drivers/net/wireless/intel/iwlwifi/iwl-8000.c   |  2 +-
>  drivers/net/wireless/intel/iwlwifi/iwl-drv.c    | 26 ++++++++++----------------
>  drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c |  6 ++++--
>  drivers/net/wireless/intel/iwlwifi/mvm/fw.c     |  2 ++
>  drivers/net/wireless/intel/iwlwifi/pcie/drv.c   | 10 ++++++++++
>  5 files changed, 27 insertions(+), 19 deletions(-)
