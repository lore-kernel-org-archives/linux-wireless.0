Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:54189 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753274AbaIVKpp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2014 06:45:45 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Liad Kaufman <liad.kaufman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: Re: [PATCH 13/17] iwlwifi: 8000: fix fw name to account for revision
References: <541F23D2.90600@gmail.com>
	<1411327338-23099-13-git-send-email-egrumbach@gmail.com>
Date: Mon, 22 Sep 2014 12:45:35 +0200
In-Reply-To: <1411327338-23099-13-git-send-email-egrumbach@gmail.com>
	(Emmanuel Grumbach's message of "Sun, 21 Sep 2014 22:22:14 +0300")
Message-ID: <87ppeoc4s0.fsf@nemi.mork.no> (sfid-20140922_124549_432125_F4EE642E)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Emmanuel Grumbach <egrumbach@gmail.com> writes:

> diff --git a/drivers/net/wireless/iwlwifi/iwl-8000.c b/drivers/net/wireless/iwlwifi/iwl-8000.c
> index 4ae8ba6..e435148 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-8000.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-8000.c
> @@ -81,7 +81,7 @@
>  #define IWL8000_NVM_VERSION		0x0a1d
>  #define IWL8000_TX_POWER_VERSION	0xffff /* meaningless */
>  
> -#define IWL8000_FW_PRE "iwlwifi-8000-"
> +#define IWL8000_FW_PRE "iwlwifi-8000"
>  #define IWL8000_MODULE_FIRMWARE(api) IWL8000_FW_PRE __stringify(api) ".ucode"

Isn't this going to create a misleading MODULE_FIRMWARE entry, matching
neither of the firmware variants?


Bjørn
