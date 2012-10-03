Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33075 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756250Ab2JCOv3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Oct 2012 10:51:29 -0400
Received: by padhz1 with SMTP id hz1so6410624pad.19
        for <linux-wireless@vger.kernel.org>; Wed, 03 Oct 2012 07:51:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <506B0628.6070201@openwrt.org>
References: <1348756862-8788-1-git-send-email-sven@narfation.org>
	<20121002133533.GA19403@pandem0nium>
	<CAJ-VmomddCMRxx6Vh_i8AJsqYMUCyguUwFt_PQHpDY7-+Gs88A@mail.gmail.com>
	<7670031.sYFb4t8Iqn@bentobox>
	<506B0628.6070201@openwrt.org>
Date: Wed, 3 Oct 2012 07:51:28 -0700
Message-ID: <CAJ-Vmo=bu=j+=z_TAeE3--Sn5oAEbkEG-HDqK=6okR8xmmWpSQ@mail.gmail.com> (sfid-20121003_165140_374414_D0CBB9B4)
Subject: Re: [ath9k-devel] [PATCHv2] ath9k_hw: Handle AR_INTR_SYNC_HOST1_FATAL
 on AR9003
From: Adrian Chadd <adrian@freebsd.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Sven Eckelmann <sven@narfation.org>,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com, ath9k-devel@lists.ath9k.org,
	lindner_marek@yahoo.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2 October 2012 08:20, Felix Fietkau <nbd@openwrt.org> wrote:

>> This sync cause 0x20 isn't handled anywhere and may be the cause of the
>> hang/crash. At least this is the symptom which can be fixed without crashing
>> the system.
> I checked the AR933x datasheet, and it says that cause 0x20 is tx
> descriptor corruption.

Ah hey, for Hornet they redefined those bits:

5: MAC_TXC_CORRUPTION_FLAG_SYNC (TX descriptor integrity flag)
6: INVALID_ADDRESS_ACCESS (invalid register access)

Good catch. That's definitely something in the right direction.



Adrian
