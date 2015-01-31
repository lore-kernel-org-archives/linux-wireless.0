Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:44213 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbbAaOQp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Jan 2015 09:16:45 -0500
Received: by mail-ie0-f170.google.com with SMTP id y20so9295780ier.1
        for <linux-wireless@vger.kernel.org>; Sat, 31 Jan 2015 06:16:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1422650111.1919.45.camel@sipsolutions.net>
References: <CAAd0S9BwPQZhOZSzt2NU1SGjzv8i6685Y7Zb6qRQ1BzJ0P92SA@mail.gmail.com>
	<1422650111.1919.45.camel@sipsolutions.net>
Date: Sat, 31 Jan 2015 15:16:45 +0100
Message-ID: <CAAd0S9BRXoymMm=jSPptyYhywyAXVKyoTU_UJDyShDExX5ERRg@mail.gmail.com> (sfid-20150131_151652_631188_9F4B858F)
Subject: Re: [IWLMVM] Firmware restart issue with 3.19-rc6-wl with AC 3160, REV=0x164
From: Christian Lamparter <chunkeey@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On Fri, Jan 30, 2015 at 9:35 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2015-01-30 at 21:23 +0100, Christian Lamparter wrote:
>> [    6.274625] iwlwifi 0000:01:00.0: 0x00000038 | BAD_COMMAND
>> [    6.275034] iwlwifi 0000:01:00.0: FW error in SYNC CMD SCD_QUEUE_CFG
>
> WTF. How did the firmware even announce support for this command??
>
> Perhaps I missed it in the log, but which firmware are you using? Any
> chance you also upgraded that? Because I can't imagine this code is new
> in the tree...
Uhh, good question: I "think" got this firmware from one of Emmanuel's firmware
announcements. (ls says "10 January 2015")

iwlwifi 0000:01:00.0: loaded firmware version 23.11.10.0 op_mode iwlmvm
Loaded firmware version: 23.11.10.0

sha1sum iwl-3160-10.ucode cf1a39c1b30f389e12d17c1379a2ac539491b8e2
md5sum iwl-3160-10.ucode 9f744224cee51dac1d11708cade96641

If you need further infos, let me know!

> Anyway, make this change:
>
> diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
> index 979ac23522f2..5b8c969f457e 100644
> --- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
> +++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
> @@ -874,7 +874,7 @@ static inline bool iwl_mvm_is_d0i3_supported(struct iwl_mvm *mvm)
>
>  static inline bool iwl_mvm_is_scd_cfg_supported(struct iwl_mvm *mvm)
>  {
> -       return mvm->fw->ucode_capa.capa[0] & IWL_UCODE_TLV_API_SCD_CFG;
> +       return false;
>  }
>
>  extern const u8 iwl_mvm_ac_to_tx_fifo[];
>
> I guess Emmanuel will look at it on Sunday :)
Thanks! That did the trick!

Regards,
   Christian
