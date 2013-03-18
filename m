Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ironport2-out.teksavvy.com ([206.248.154.182]:13036 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752781Ab3CRQt5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Mar 2013 12:49:57 -0400
Message-ID: <a10f9fe2e0e48f8b7378bb655d673151.squirrel@www.infidigm.net> (sfid-20130318_175003_208382_E9F4844E)
Date: Mon, 18 Mar 2013 13:53:04 -0400
Subject: AR9374 v1.3 (Ath6kl - 6004) in sdio mode
From: drwho@infidigm.net
To: linux-wireless@vger.kernel.org
Cc: ath6kl-devel@qca.qualcomm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Can anyone confirm if they have had an AR9374 v1.3 (=AR6004) working in
sdio mode in compat v3.8?  I have three AR9374s working just fine in USB
mode with compat v3.8.  I have an AR6103 (=AR6003), sdio, working on the
same host as I'm trying the AR9374 on.  The AR9374 only gets as far as
registering as mmc1.  The vendor and device IDs are correct.  When I try
to load ath6kl_sdio, I get....

ath6kl: 8f69fe04
ath6kl: 8f69fe34
ath6kl: 8f69fe7c
ath6kl_sdio: probe of mmc1:0001:1 failed with error -110

loading ath6kl_core.ko debug_mask=0xffffffff doesn't give much more. 
compat is build with
export CONFIG_ATH_DEBUG=y
export CONFIG_ATH6KL_DEBUG=y
and I'm getting tones on debug when booting the AR6103.

My hardware settings for usb or sdio mode on the AR9374....

USB mode
sdio_cmd = 10k pull down

SDIO mode
sdio_cmd = 10k pull up to 3.3v
sdio_D1 = 10k pull up to 3.3v

I've tried dropping my sdio clock from 50Mhz to 10Mhz,  no go either.

Jon

