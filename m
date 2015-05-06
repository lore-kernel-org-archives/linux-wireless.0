Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50953 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219AbbEFLkH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 May 2015 07:40:07 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1YpxgL-0002ei-96
	for linux-wireless@vger.kernel.org; Wed, 06 May 2015 13:40:05 +0200
Received: from static-67-98-228-77.ipcom.comunitel.net ([static-67-98-228-77.ipcom.comunitel.net])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 06 May 2015 13:40:05 +0200
Received: from sgala by static-67-98-228-77.ipcom.comunitel.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 06 May 2015 13:40:05 +0200
To: linux-wireless@vger.kernel.org
From: Santiago Gala <sgala@apache.org>
Subject: Re: [PATCH 20/49] iwlwifi: bump API to 13 for devices that use iwlmvm
Date: Wed, 6 May 2015 09:14:21 +0000 (UTC)
Message-ID: <loom.20150506T111003-95@post.gmane.org> (sfid-20150506_134322_550835_E2F59E04)
References: <1426164431.19690.4.camel@egrumbacBox> <1426165474-25586-20-git-send-email-emmanuel.grumbach@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Emmanuel Grumbach <emmanuel.grumbach@...> writes:

> 
> This new firmware will come out soon.

I wonder where it is. My hardware does not work with 3.19 or 4.0 kernels and
firmware API 10 or 12, which means I have to remove them from /lib/firmware
or else no working wifi. I guess it must be related

$ sudo lshw -C network
(...)
  *-network
       description: Wireless interface
       product: Wireless 3160
       vendor: Intel Corporation
       physical id: 0
       bus info: pci@0000:02:00.0
       logical name: wlan0
       version: 83
       serial: 34:de:1a:57:ad:7d
       width: 64 bits
       clock: 33MHz
       capabilities: pm msi pciexpress bus_master cap_list ethernet physical
wireless
       configuration: broadcast=yes driver=iwlwifi
driverversion=4.0.1-040001-generic firmware=25.228.9.0 ip=192.168.0.193
latency=0 link=yes multicast=yes wireless=IEEE 802.11abgn
       resources: irq:45 memory:f0400000-f0401fff

It times out authorization with the 10 or 12 firmwares in linuxwireless.org.
I wonder where to report the bug.

Regards
Santiago

> 
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@...>
> ---
>  drivers/net/wireless/iwlwifi/iwl-7000.c | 8 ++++----
>  drivers/net/wireless/iwlwifi/iwl-8000.c | 4 ++--
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-7000.c
b/drivers/net/wireless/iwlwifi/iwl-7000.c
> index 0597a9c..36e786f 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-7000.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-7000.c
>  <at>  <at>  -69,12 +69,12  <at>  <at> 
>  #include "iwl-agn-hw.h"
> 
>  /* Highest firmware API version supported */
> -#define IWL7260_UCODE_API_MAX	12
> -#define IWL3160_UCODE_API_MAX	12
> +#define IWL7260_UCODE_API_MAX	13
> +#define IWL3160_UCODE_API_MAX	13
> 
>  /* Oldest version we won't warn about */
> -#define IWL7260_UCODE_API_OK	10
> -#define IWL3160_UCODE_API_OK	10
> +#define IWL7260_UCODE_API_OK	12
> +#define IWL3160_UCODE_API_OK	12
> 
>  /* Lowest firmware API version supported */
>  #define IWL7260_UCODE_API_MIN	10
> diff --git a/drivers/net/wireless/iwlwifi/iwl-8000.c
b/drivers/net/wireless/iwlwifi/iwl-8000.c
> index d8dfa6d..9c396a4 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-8000.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-8000.c
>  <at>  <at>  -69,10 +69,10  <at>  <at> 
>  #include "iwl-agn-hw.h"
> 
>  /* Highest firmware API version supported */
> -#define IWL8000_UCODE_API_MAX	12
> +#define IWL8000_UCODE_API_MAX	13
> 
>  /* Oldest version we won't warn about */
> -#define IWL8000_UCODE_API_OK	10
> +#define IWL8000_UCODE_API_OK	12
> 
>  /* Lowest firmware API version supported */
>  #define IWL8000_UCODE_API_MIN	10




