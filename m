Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:62639 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaBPG3G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Feb 2014 01:29:06 -0500
Received: by mail-lb0-f172.google.com with SMTP id c11so10397562lbj.17
        for <linux-wireless@vger.kernel.org>; Sat, 15 Feb 2014 22:29:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52FFDC10.5020702@mageia.org>
References: <52FFDC10.5020702@mageia.org>
Date: Sun, 16 Feb 2014 08:29:02 +0200
Message-ID: <CANUX_P26bMLiPjjor6q960VC9RxhCagS7Je8S7hpzte1R52swA@mail.gmail.com> (sfid-20140216_072926_688696_56FF8B3E)
Subject: Re: Intel Wireless 7260 AC firnware SW error
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Thomas Backlund <tmb@mageia.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

>
> Is this known ?

No it is not.

> dmesg showing firmware revision:
>
> [   13.290105] Intel(R) Wireless WiFi driver for Linux, in-tree:d
> [   13.290108] Copyright(c) 2003-2013 Intel Corporation
> [   13.290347] iwlwifi 0000:03:00.0: irq 49 for MSI/MSI-X
> [   13.299469] iwlwifi 0000:03:00.0: loaded firmware version 22.15.8.0
> op_mode iwlmvm

This is the latest firmware - good.

> [  226.928710] iwlwifi 0000:03:00.0: Start IWL Error Log Dump:
> [  226.928716] iwlwifi 0000:03:00.0: Status: 0x00000000, count: 6
> [  226.928722] iwlwifi 0000:03:00.0: 0x00002B03 | ADVANCED_SYSASSERT
> [  226.928726] iwlwifi 0000:03:00.0: 0x002002A0 | uPc
> [  226.928730] iwlwifi 0000:03:00.0: 0x00000000 | branchlink1
> [  226.928734] iwlwifi 0000:03:00.0: 0x00000C2A | branchlink2
> [  226.928738] iwlwifi 0000:03:00.0: 0x00015ADC | interruptlink1
> [  226.928742] iwlwifi 0000:03:00.0: 0x0099FB23 | interruptlink2
> [  226.928747] iwlwifi 0000:03:00.0: 0x00000000 | data1
> [  226.928751] iwlwifi 0000:03:00.0: 0xDEADBEEF | data2
> [  226.928755] iwlwifi 0000:03:00.0: 0xDEADBEEF | data3
> [  226.928759] iwlwifi 0000:03:00.0: 0xAC40CA17 | beacon time
> [  226.928763] iwlwifi 0000:03:00.0: 0xB42716FE | tsf low
> [  226.928768] iwlwifi 0000:03:00.0: 0x0000000C | tsf hi
> [  226.928772] iwlwifi 0000:03:00.0: 0x00000000 | time gp1
> [  226.928776] iwlwifi 0000:03:00.0: 0x0C746956 | time gp2
> [  226.928780] iwlwifi 0000:03:00.0: 0x00000000 | time gp3
> [  226.928783] iwlwifi 0000:03:00.0: 0x0004160F | uCode version
> [  226.928788] iwlwifi 0000:03:00.0: 0x00000144 | hw version
> [  226.928792] iwlwifi 0000:03:00.0: 0x00489204 | board version
> [  226.928797] iwlwifi 0000:03:00.0: 0x09970051 | hcmd
> [  226.928801] iwlwifi 0000:03:00.0: 0x00022000 | isr0
> [  226.928805] iwlwifi 0000:03:00.0: 0x00000000 | isr1
> [  226.928809] iwlwifi 0000:03:00.0: 0x0000000A | isr2
> [  226.928813] iwlwifi 0000:03:00.0: 0x4041F8C0 | isr3
> [  226.928817] iwlwifi 0000:03:00.0: 0x00000001 | isr4
> [  226.928820] iwlwifi 0000:03:00.0: 0x00800110 | isr_pref
> [  226.928824] iwlwifi 0000:03:00.0: 0x00000000 | wait_event
> [  226.928828] iwlwifi 0000:03:00.0: 0x00000080 | l2p_control
> [  226.928832] iwlwifi 0000:03:00.0: 0x00018000 | l2p_duration
> [  226.928836] iwlwifi 0000:03:00.0: 0x0000003F | l2p_mhvalid
> [  226.928839] iwlwifi 0000:03:00.0: 0x00000080 | l2p_addr_match
> [  226.928843] iwlwifi 0000:03:00.0: 0x00000005 | lmpm_pmg_sel
> [  226.928846] iwlwifi 0000:03:00.0: 0x22121614 | timestamp
> [  226.928850] iwlwifi 0000:03:00.0: 0x00000008 | flow_handler
> [  226.928857] ieee80211 phy0: Hardware restart was requested
>

Can you please record tracing?

trace-cmd record -e iwlwifi -e mac80211

and try to reproduce?

It may be a driver or a firmware issue, I can't really know with the
current data.
Thanks for reporting!
