Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57640 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757441Ab0LBMRn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 07:17:43 -0500
Received: by qwb7 with SMTP id 7so8301088qwb.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Dec 2010 04:17:43 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <AANLkTi=_F0orXPY79ojoPKEqn4ohQjV5Rj5Qb3H7CR8f@mail.gmail.com>
References: <AANLkTi=_F0orXPY79ojoPKEqn4ohQjV5Rj5Qb3H7CR8f@mail.gmail.com>
Date: Thu, 2 Dec 2010 13:17:42 +0100
Message-ID: <AANLkTin5nSy4uopY8z2ncKgwpPUYV+YG1V7aJLKnFQGg@mail.gmail.com>
Subject: Re: [linux-next] next-20101201: ath5k permanently disconnecting
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: wireless <linux-wireless@vger.kernel.org>
Cc: John Linville <linville@tuxdriver.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Bruno Randolf <br1@einfach.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 1, 2010 at 11:09 AM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
> Hi,
>
> I have built today a linux-next (next-20101201) kernel which includes
> wireless-next-2.6 up to master-2010-11-30.
>
[...]
> Unfortunately, my wlan network connection is totally unstable.
[...]
> My wlan device is an ath5k:
>
> $ lspci -nnvv | grep "Ethernet controller" | grep -i ath
> 02:02.0 Ethernet controller [0200]: Atheros Communications Inc. AR5212
> 802.11abg NIC [168c:1014] (rev 01)
>
> Any idea what's wrong? (Just speculating on the last patch-set from Nick...)

So it is definitely not Nick's patchset causing the troubles here.
I have built compat-wireless-2010-11-30 which does not contain this
ath5 patchset.

$ grep ath5k compat-wireless-2010-11-29_compat-wireless-2010-11-30.diff

$ grep ath5k compat-wireless-2010-11-30_compat-wireless-2010-12-01.diff | wc -l
1229

# modinfo ath5k | grep filename
filename:
/lib/modules/2.6.37-rc4-686/updates/drivers/net/wireless/ath/ath5k/ath5k.ko

So I try backwards the c-w-2.6 tarballs and report again.

- Sedat -
