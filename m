Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43486 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752417Ab0GWCCw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 22:02:52 -0400
Received: by fxm14 with SMTP id 14so4726516fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Jul 2010 19:02:51 -0700 (PDT)
Message-ID: <4C48F84C.8020201@gmail.com>
Date: Fri, 23 Jul 2010 04:02:52 +0200
From: Daniel Golle <daniel.golle@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Subject: Re: [RFC] refactor ath9k_platform to sound sane for use in both ath9k
 and ath5k
References: <4C1F51A3.5000407@gmail.com> <AANLkTim7zJFbV0N0yoV--F3-8_fuv3jWFilozC9wmuP-@mail.gmail.com>
In-Reply-To: <AANLkTim7zJFbV0N0yoV--F3-8_fuv3jWFilozC9wmuP-@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!
In order to support the Senao EAP7660D board, I now added 
ath5k_platform.h and patched ath5k (and madwifi).
In this way, the infrastructure for ath9k and ath5k remains separate, as 
discussed in
https://lists.openwrt.org/pipermail/openwrt-devel/2010-July/007506.html

Is there any chance to have the patches added in
https://dev.openwrt.org/changeset/22188
included to linux-wireless?

Thank you!

Daniel

On 06/21/2010 08:02 PM, Luis R. Rodriguez wrote:
> On Mon, Jun 21, 2010 at 4:48 AM, Daniel Golle<daniel.golle@gmail.com>  wrote:
>    
>> I'm developing on OpenWrt to work with EEPROM-less ath5k mini-pci devices.
>> This is needed to support the ar71xx-based Senao EAP7660D board which got
>> two AR5413 modules soldered into its mini-pci slots. In the original
>> Firmware, MAC addresses as well as calibration-data seems to be part of the
>> firmware blob stored on the board flash.
>> See https://lists.openwrt.org/pipermail/openwrt-devel/2010-June/007366.html
>> for the corresponding discussion on OpenWrt-devel.
>>      
> I don't see much "discussion" there.
>
>    
>> Similarly to the way this happens for ath9k, I managed to get ath5k to use
>> the MAC address and eeprom-data supplied by ath9k_platform_data.
>> Including ath9k_platform.h in ath5k-sources looks confusing as the name
>> ath9k_platform suggests that the supplied ath9k_platform_info struct is
>> specific to ath9k devices.
>> Consequently, I believe ath9k_platform.h should be renamed into
>> ath_platform.h, the macro ATH9K_PLAT_EEP_MAX_WORDS into
>> ATH_PLAT_EEP_MAX_WORDS and struct ath9k_platform_data should be refactored
>> to be struct ath_platform_data.
>> Please let me know if you agree with this in theory; if yes, I'll start
>> posting the patches to OpenWrt.
>>      
> You can stuff any general stuff into the ath module which is shared by both.
>
>    Luis
>    

