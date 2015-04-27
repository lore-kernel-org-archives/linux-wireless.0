Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:61566 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932118AbbD0I7K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Apr 2015 04:59:10 -0400
Message-ID: <553DFA5A.3090802@broadcom.com> (sfid-20150427_105932_365799_B453EDDB)
Date: Mon, 27 Apr 2015 10:59:06 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: "Fu, Zhonghui" <zhonghui.fu@linux.intel.com>
CC: "brudley@broadcom.com" <brudley@broadcom.com>,
	Franky Lin <frankyl@broadcom.com>,
	"meuleman@broadcom.com" <meuleman@broadcom.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	"pieterpg@broadcom.com" <pieterpg@broadcom.com>,
	"hdegoede@redhat.com" <hdegoede@redhat.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH 1/2] brcmfmac: prohibit ACPI power management for brcmfmac
 driver
References: <553DC280.6080503@linux.intel.com>
In-Reply-To: <553DC280.6080503@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/27/15 07:00, Fu, Zhonghui wrote:
> ACPI will manage WiFi chip's power state during suspend/resume
> process on some tablet platforms(such as ASUS T100TA). This is
> not supported by brcmfmac driver now, and the context of WiFi
> chip will be damaged after resume. This patch disconnects the
> relationship between WiFi chip and it's ACPI companion, and
> prohibit ACPI PM for it.

Nice. However, ACPI may contain configuration data that brcmfmac needs 
on some platforms and Adrian Hunter is looking into this. So it is 
probably better to do this operation at the end of the probe before 
returning successful.

Regards,
Arend

> Signed-off-by: Zhonghui Fu<zhonghui.fu@linux.intel.com>
> ---
>   drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c |    5 +++++
>   1 files changed, 5 insertions(+), 0 deletions(-)
>
