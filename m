Return-Path: <SRS0=8fZi=PT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72B4FC43387
	for <linux-wireless@archiver.kernel.org>; Fri, 11 Jan 2019 11:51:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 434B22064C
	for <linux-wireless@archiver.kernel.org>; Fri, 11 Jan 2019 11:51:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="fGvYWVn+";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="dorsoiaA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729884AbfAKLvy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 11 Jan 2019 06:51:54 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:37770 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728488AbfAKLvy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 Jan 2019 06:51:54 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6351660A72; Fri, 11 Jan 2019 11:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547207512;
        bh=mw9RZ2ur1/2dBHon5bWF7MAr5QKceWwhoPlxvuaWF90=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=fGvYWVn+I3bA62EwJGiSI0yk52ibkf4ouGESO1iY1GXcRZRIyLt0S9o67vvhY0h/p
         8oC3FBDccFgcZf7BtIsgSNwjYhsfsOHrotYRBXl07FMswFJRf/eesfrqCts844D5uY
         X7P1AhLxiOHoyr+1doPGB3F09vMI+0I4wmx9Pjwo=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id F0020608CB;
        Fri, 11 Jan 2019 11:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547207511;
        bh=mw9RZ2ur1/2dBHon5bWF7MAr5QKceWwhoPlxvuaWF90=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=dorsoiaAh/aGRGp7yhr9F+cJZjRPoVdWMo7d9/WYBOHqUtgH2SYcl6hezjTixUYzm
         VU3IeFAiDLWNVYbZnM8UGsBviNW3p+eL9lA9PF67Sr9sYjQEzMJmgho4YRqLw7xd6l
         ZE02fT4NfeIhFsETt2N9i9g84TEtWwix8Z9Zis9g=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org F0020608CB
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linuxwifi <linuxwifi@intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: Re: linux-next: Tree for Jan 10 (iwlwifi)
References: <20190110151409.7d0916c8@canb.auug.org.au>
        <2069197c-c758-6c4e-d30c-3f6baa10b841@infradead.org>
Date:   Fri, 11 Jan 2019 13:51:47 +0200
In-Reply-To: <2069197c-c758-6c4e-d30c-3f6baa10b841@infradead.org> (Randy
        Dunlap's message of "Thu, 10 Jan 2019 13:41:33 -0800")
Message-ID: <87pnt35s4s.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Randy Dunlap <rdunlap@infradead.org> writes:

> On 1/9/19 8:14 PM, Stephen Rothwell wrote:
>> Hi all,
>> 
>> Changes since 20190109:
>> 
>
> on x86_64:
>
> WARNING: unmet direct dependencies detected for MAC80211_LEDS
>   Depends on [n]: NET [=y] && WIRELESS [=y] && MAC80211 [=n] && LEDS_CLASS [=y]
>   Selected by [y]:
>   - IWLWIFI_LEDS [=y] && NETDEVICES [=y] && WLAN [=y] && WLAN_VENDOR_INTEL [=y] && IWLWIFI [=y] && (LEDS_CLASS [=y]=y || LEDS_CLASS [=y]=IWLWIFI [=y])
>
> and then
>
> ld: drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.o: in function `iwl_parse_eeprom_data':
> iwl-eeprom-parse.c:(.text+0x7c4): undefined reference to `ieee80211_channel_to_frequency'
> ld: drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.o: in function `iwl_init_sbands':
> iwl-nvm-parse.c:(.text+0x37f): undefined reference to `ieee80211_channel_to_frequency'
> ld: drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.o: in function `iwl_parse_nvm_mcc_info':
> iwl-nvm-parse.c:(.text+0xce9): undefined reference to `ieee80211_channel_to_frequency'
> ld: iwl-nvm-parse.c:(.text+0xe9b): undefined reference to `reg_query_regdb_wmm'
> ld: drivers/net/wireless/intel/iwlwifi/pcie/tx.o: in function `iwl_trans_pcie_tx':
> tx.c:(.text+0x344d): undefined reference to `ieee80211_hdrlen'
> ld: drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.o: in function `iwl_trans_pcie_gen2_tx':
> tx-gen2.c:(.text+0xd93): undefined reference to `ieee80211_hdrlen'
> ld: drivers/net/wireless/intel/iwlwifi/iwl-devtrace.o: in function `iwl_rx_trace_len':
> iwl-devtrace.c:(.text+0x974): undefined reference to `ieee80211_hdrlen'

Kbuild bot also reported this and Luca (CCed) is working on a fix.
Thanks for the report.

-- 
Kalle Valo
