Return-Path: <SRS0=yJNj=RD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0A00C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 07:34:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D467205C9
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 07:34:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=comcastmailservice.net header.i=@comcastmailservice.net header.b="RQDFl8GD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730749AbfB1HeZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Feb 2019 02:34:25 -0500
Received: from resqmta-po-11v.sys.comcast.net ([96.114.154.170]:52112 "EHLO
        resqmta-po-11v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725958AbfB1HeZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Feb 2019 02:34:25 -0500
X-Greylist: delayed 450 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Feb 2019 02:33:47 EST
Received: from resomta-po-16v.sys.comcast.net ([96.114.154.240])
        by resqmta-po-11v.sys.comcast.net with ESMTP
        id zG28g5TZ8gNePzG5Bg8tzx; Thu, 28 Feb 2019 07:26:17 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=comcastmailservice.net; s=20180828_2048; t=1551338777;
        bh=480B1d3tdk/7PDBpVm8LtAFJ2ZDc8QNEvSZvBClwgKg=;
        h=Received:Received:To:From:Subject:Message-ID:Date:MIME-Version:
         Content-Type;
        b=RQDFl8GD0mth9EI0hsV5wLQobXRf8vimAdfC7nh1Ra+2fTt0cIrbCKBeTukCM7Qud
         0QYLI/7fXpzROugJfI+HbbCbuP9N//2yvKo/9myYcy8kTdRQaxuDKAsSr03X7XwTaD
         DE9INJ0ciGaYv1+UUXoiFi4AH3rbhSqfcxW6UjztaGP66xjrU1tXMbs88CseBzNORD
         7m0R3Ak4zRrJdZcEN0TpPAFG2NTBpLy8VJfGFGZkh+0lE2ZxyxO6UeFXV19AnIorS/
         RjULM3b/CLwLnvV43kDrpD7tnDnDKqkxQSueOdadavG+rpgfifijkI1ojGDUnFdFeK
         374ym1DduKHjw==
Received: from touchy.whiterc.com ([73.109.211.103])
        by resomta-po-16v.sys.comcast.net with ESMTPSA
        id zG5AgDuqxKP4pzG5AgYiBl; Thu, 28 Feb 2019 07:26:17 +0000
X-Xfinity-VAAS: gggruggvucftvghtrhhoucdtuddrgedutddrvddvgddutdegucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuvehomhgtrghsthdqtfgvshhipdfqfgfvpdfpqffurfetoffkrfenuceurghilhhouhhtmecufedttdenucenucfjughrpefvhffukffffgggtgfgsehtjeertddtfeejnecuhfhrohhmpeftohgsvghrthcuhghhihhtvgcuoehrfihhihhtvgesphhosghogidrtghomheqnecuffhomhgrihhnpeifhhhithgvrhgtrdgtohhmnecukfhppeejfedruddtledrvdduuddruddtfeenucfrrghrrghmpehhvghlohepthhouhgthhihrdifhhhithgvrhgtrdgtohhmpdhinhgvthepjeefrddutdelrddvuddurddutdefpdhmrghilhhfrhhomheprhifhhhithgvsehpohgsohigrdgtohhmpdhrtghpthhtoheplhhinhhugidqfihirhgvlhgvshhssehvghgvrhdrkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-Xfinity-VMeta: sc=??;st=legit
To:     linux-wireless@vger.kernel.org
From:   Robert White <rwhite@pobox.com>
Subject: long startup delay ath10k_pci known issue?
Message-ID: <76303a09-744e-dbc2-01c2-92b0f2c1a266@pobox.com>
Date:   Thu, 28 Feb 2019 07:26:16 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

I recently switched from an ath9k to an ath10k on my (gentoo based) 
home-build router, and there is about a two minute delay between the 
time of the modprobe of ath10k_pci and the time "iw list" can see the 
wireless endpoint. Then there's maybe another delay before the wlan0 
device appears in the kernel.

This extreme delay is preventing a normal startup because it causes an 
error return in the OpenRC dependency/startup logic.

That dependency tree is it's own problem, of course, but I don't 
understand why the delay is taking place. There are no errors shown in 
the startup and the system runs fine once manually kicked around to get 
it running (e.g. manually modprobing the various devices and then 
waiting and then re-triggering various parts of the startup).

I have to reiterate that the system starts and runs fine as-configured 
if I put the ath9k device back in, so it's not a system-level 
configuration problem.

Is this long delay after module and firmware load some expected effect 
that I need to code around or what?

IF the delay is expected, is there some sort of user-space detectable 
event that I can use to know the de

I built the device by buying a micro PCI card from SparkLan and a 
Chinese PCIexpress adapter card.

The only really weird thing I see is the all-zeros device serial number.


Various Info:

rwhite@lightning ~ $ uname -a
Linux lightning.whiterc.com 4.20.13-gentoo #2 SMP PREEMPT Wed Feb 27 
22:28:03 PST 2019 x86_64 AMD Athlon(tm) II X2 250 Processor AuthenticAMD 
GNU/Linux

[  761.891968] ath10k_pci 0000:03:00.0: limiting irq mode to: 2
[  761.892056] ath10k_pci 0000:03:00.0: pci irq msi oper_irq_mode 2 
irq_mode 2 reset_mode 0
[  947.463173] ath10k_pci 0000:03:00.0: qca988x hw2.0 target 0x4100016c 
chip_id 0x043202ff sub 0000:0000
[  947.463181] ath10k_pci 0000:03:00.0: kconfig debug 0 debugfs 1 
tracing 0 dfs 1 testmode 0
[  947.463787] ath10k_pci 0000:03:00.0: firmware ver 10.2.4-1.0-00043 
api 5 features no-p2p,raw-mode,mfp,allows-mesh-bcast crc32 ed0aafd8
[ 1008.884389] ath10k_pci 0000:03:00.0: board_file api 1 bmi_id N/A 
crc32 bebc7c08
[ 1010.004457] ath10k_pci 0000:03:00.0: unsupported HTC service id: 1536
[ 1010.025717] ath10k_pci 0000:03:00.0: htt-ver 2.1 wmi-op 5 htt-op 2 
cal otp max-sta 128 raw 0 hwcrypto 1
[ 1010.088540] ath: EEPROM regdomain: 0x6a
[ 1010.088545] ath: EEPROM indicates we should expect a direct regpair map
[ 1010.088552] ath: Country alpha2 being used: 00
[ 1010.088554] ath: Regpair used: 0x6a
[ 1070.500586] ath10k_pci 0000:03:00.0: unsupported HTC service id: 1536
[ 1070.521639] ath10k_pci 0000:03:00.0: pdev param 0 not supported by 
firmware

03:00.0 Network controller: Qualcomm Atheros QCA986x/988x 802.11ac 
Wireless Network Adapter
         Flags: bus master, fast devsel, latency 0, IRQ 35, NUMA node 0
         Memory at fe200000 (64-bit, non-prefetchable) [size=2M]
         Expansion ROM at fe400000 [disabled] [size=64K]
         Capabilities: [40] Power Management version 2
         Capabilities: [50] MSI: Enable+ Count=1/8 Maskable+ 64bit-
         Capabilities: [70] Express Endpoint, MSI 00
         Capabilities: [100] Advanced Error Reporting
         Capabilities: [140] Virtual Channel
         Capabilities: [160] Device Serial Number 00-00-00-00-00-00-00-00
         Kernel driver in use: ath10k_pci
         Kernel modules: ath10k_pci

