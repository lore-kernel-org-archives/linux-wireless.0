Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f182.google.com ([209.85.223.182]:36129 "EHLO
	mail-iw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab0C2UOM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 16:14:12 -0400
Received: by iwn12 with SMTP id 12so943053iwn.21
        for <linux-wireless@vger.kernel.org>; Mon, 29 Mar 2010 13:14:11 -0700 (PDT)
Message-ID: <4BB10A0F.1030608@lwfinger.net>
Date: Mon, 29 Mar 2010 15:14:07 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: =?UTF-8?B?UmVuw6kgQm9sbGRvcmY=?= <xsecute@googlemail.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: [BUG] No SPROM available!
References: <4BB0FD96.5020402@lwfinger.net> <4BB10110.9090202@googlemail.com> <20100329194745.GH4984@tuxdriver.com>
In-Reply-To: <20100329194745.GH4984@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/29/2010 02:47 PM, John W. Linville wrote:
> On Mon, Mar 29, 2010 at 09:35:44PM +0200, René Bolldorf wrote:
>> On 03/29/10 21:20, Larry Finger wrote:
>>> Ren�,
>>>
>>> When you have a wireless problem, please post it to
>>> linux-wireless@vger.kernel.org. The Linux Kernel Mailing List may or may not be
>>> appropriate.
>>>
>>> To help in diagnosing your problem, please apply this patch and post the output
>>> line that it produces. On my system, it shows
>>>
>>> ssb: chip_id 0x4312, status 0x10
>>>
>> and on my: ssb: chip_id 0x4312, status 0x12
>>> Please also post the output of 'lspci -nnv | grep 14e4'.
>> Yep:
>> 01:00.0 Network controller [0280]: Broadcom Corporation BCM4312  
>> 802.11b/g [14e4:4315] (rev 01)
> 
> OK, I'm new to the thread -- what exactly is the issue?  Was your
> device working previously?

Yes. He originally posted only to LKML
(http://marc.info/?l=linux-kernel&m=126988911025280&w=2), where he posted

=========================
since commit fcb54b0bf7d3fe730c2b72e224bc616e358f24cb, my b43 (4312)
device doesn't work.

But the device have a sprom. Maybe the chip-status register check is wrong?

+/** Macros to determine SPROM presence based on Chip-Status register. */
+#define SSB_CHIPCO_CHST_4312_SPROM_PRESENT(status) \
+       ((status & SSB_CHIPCO_CHST_4325_SPROM_OTP_SEL) != \
+               SSB_CHIPCO_CHST_4325_OTP_SEL)
=======================================

I just happened to do one of my infrequent scans of LKML, and happened to see
it. In a follow-up, he proposes a patch that would fail on your system and leave
it locked up..

I rechecked the Broadcom driver, and stick by my specs that you used for your patch.

Could you please apply my little test patch and send me the contents of the
chipcommon status register in your netbook?

Thanks,

Larry
