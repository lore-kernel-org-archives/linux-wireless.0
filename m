Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:58601 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756067AbaIZX0O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2014 19:26:14 -0400
Received: by mail-pa0-f45.google.com with SMTP id rd3so4400715pab.32
        for <linux-wireless@vger.kernel.org>; Fri, 26 Sep 2014 16:26:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGG-pUQiiQYEire+Q8B=XVB4u6=JdCsvGyBKD8=W=83q=K7o9Q@mail.gmail.com>
References: <CA+MoWDqGZoStq1cEM8Woe-yxQObGF0W+mzb5vNMjztz_Gz_TxQ@mail.gmail.com>
 <CAB=NE6XeXmZWRXL=hXyPzoWF-3aZBdOqEUGdMErQp_syN23d0g@mail.gmail.com>
 <CAGG-pUTQtORfEiDB3mNO=fccQkj6h1NULTXW4QoWY36NzuXCBA@mail.gmail.com>
 <CAB=NE6X-CSWtvKxFR+DHXg1b0cWJ9K0Tb2eTD5P0=jPHLFkxGQ@mail.gmail.com>
 <CAGG-pURp9exrFcieP=0xiJZD-NmQqn0c7Ty_E-brM7GnVX63Ww@mail.gmail.com>
 <CAGG-pUQMG+XxGss7BT_Gjo2u9y=6uLwXE+q18JewDCVKh4Q8vg@mail.gmail.com> <CAGG-pUQiiQYEire+Q8B=XVB4u6=JdCsvGyBKD8=W=83q=K7o9Q@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 26 Sep 2014 16:25:53 -0700
Message-ID: <CAB=NE6X2xcJe9BnyaXmgK2jOXLMPpO2r+HSXX88VpKgKK8xKiQ@mail.gmail.com> (sfid-20140927_012617_769369_800D564F)
Subject: Re: ar9271 wifi usb
To: =?UTF-8?Q?Geyslan_Greg=C3=B3rio_Bem?= <geyslan@gmail.com>
Cc: Peter Senna Tschudin <peter.senna@gmail.com>,
	John Linville <linville@tuxdriver.com>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 12, 2014 at 6:00 PM, Geyslan Gregório Bem <geyslan@gmail.com> wrote:
> Hi John and Sujith,
>
> Peter and Luis are CC.
>
> I'm having issues with my ath9k as you can see below. My card is constantly
> connecting and disconnecting from my SSID before it could get some IP
> (DHCP).
>
> I saw that you have patched something in the next tree. These recent patches
> are correlated with the looping in the my card connection?
>
> http://git.kernel.org/cgit/linux/kernel/git/linville/wireless-next.git/log/

you landed on a merge commit, surprised that git won't unfold that for
you for a bisect.. Anyway so next step is to bisect on the merge
commit. To do that I'm sure there are several ways. I've Cc'd the
ath9k-devel team which from what I hear is back together.

Here's one way to unfold your merge commit:

git checkout -b merge-commit 88daf80dcca19ff995cc263592426f734a9702f3

If you do git log you will see commit
010d3c3989706d800ae72253773fa6537cc9f74c is right before it. To unfold
I do:

git rebase -i 010d3c3989706d800ae72253773fa6537cc9f74c

Then just exit without changes (on vi, :wq)

If you do git log you will see tons of patches have now been folded
in. Since you know 010d3c3989706d800ae72253773fa6537cc9f74c was the
last commit before the merge of the wireless stuff you can use it as
the last good commit and use something other than the merge commit for
the bad commit, for instance try
b9f381791cb486cd927177d8157ded63c0829e04.

>From now on please engage with the public mailing list and ath9k-devel folks.

  Luis

> 2014-09-01 17:39 GMT-03:00 Geyslan Gregório Bem <geyslan@gmail.com>:
>>
>> Hi guys,
>>
>> I finally did the git bisect procedure. Tell me the next step.
>>
>> uzumaki@hb ~/linux $ git bisect bad
>> 88daf80dcca19ff995cc263592426f734a9702f3 is the first bad commit
>>
>> uzumaki@hb ~/linux $ git bisect log
>> git bisect start
>> # good: [455c6fdbd219161bd09b1165f11699d6d73de11c] Linux 3.14
>> git bisect good 455c6fdbd219161bd09b1165f11699d6d73de11c
>> # bad: [1860e379875dfe7271c649058aeddffe5afd9d0d] Linux 3.15
>> git bisect bad 1860e379875dfe7271c649058aeddffe5afd9d0d
>> # bad: [74a475acea49459721ae4b062d3da68c74259009] SubmittingPatches: add
>> style recommendation to use imperative descriptions
>> git bisect bad 74a475acea49459721ae4b062d3da68c74259009
>> # good: [c12e69c6aaf785fd307d05cb6f36ca0e7577ead7] Merge tag
>> 'staging-3.15-rc1' of
>> git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging
>> git bisect good c12e69c6aaf785fd307d05cb6f36ca0e7577ead7
>> # bad: [0fc31966035d7a540c011b6c967ce8eae1db121b] Merge branch 'for-davem'
>> of git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next
>> git bisect bad 0fc31966035d7a540c011b6c967ce8eae1db121b
>> # good: [67b3bd4e65f0854aca70e0134d59b1daede49504] brcmfmac: fallback to
>> mimo_bw_cap for older firmwares
>> git bisect good 67b3bd4e65f0854aca70e0134d59b1daede49504
>> # bad: [389400428953bb002b173fa07d16d7a6f120843f] Merge tag
>> 'rxrpc-devel-20140304' of
>> git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs
>> git bisect bad 389400428953bb002b173fa07d16d7a6f120843f
>> # good: [3b7d636b50fb38e4e0f1113ba7bff8dcd19d140f] bonding: remove
>> bond->lock from bond_arp_rcv
>> git bisect good 3b7d636b50fb38e4e0f1113ba7bff8dcd19d140f
>> # bad: [ca324099fb2feff62cd0d3e8ef007e2c2dc8b6a7] ixgbe: don't use magic
>> size number to assign ptp_caps.name
>> git bisect bad ca324099fb2feff62cd0d3e8ef007e2c2dc8b6a7
>> # bad: [1f5a7407e4307bfaa465fbaece985a72e4bc4752] Merge branch 'master' of
>> git://git.kernel.org/pub/scm/linux/kernel/git/klassert/ipsec-next
>> git bisect bad 1f5a7407e4307bfaa465fbaece985a72e4bc4752
>> # good: [86c1a045640d3f34ca1ab2f3e8b102670d21f93a] tcp: use zero-window
>> when free_space is low
>> git bisect good 86c1a045640d3f34ca1ab2f3e8b102670d21f93a
>> # bad: [6c5ef6209d28bd2e75484e5cad070c898a7f5154] i40e: tighten up ring
>> enable/disable flow
>> git bisect bad 6c5ef6209d28bd2e75484e5cad070c898a7f5154
>> # bad: [dbbd81119b7ac7bb383413c9e955f21abd15bf2b] i40evf: get rid of
>> pci_using_dac
>> git bisect bad dbbd81119b7ac7bb383413c9e955f21abd15bf2b
>> # bad: [61cc776fc1f51616ab22a898a2ea01e2cf0be567] Merge branch 'for-davem'
>> of git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next
>> git bisect bad 61cc776fc1f51616ab22a898a2ea01e2cf0be567
>> # good: [010d3c3989706d800ae72253773fa6537cc9f74c] bonding: fix
>> bond_arp_rcv() race of curr_active_slave
>> git bisect good 010d3c3989706d800ae72253773fa6537cc9f74c
>> # bad: [88daf80dcca19ff995cc263592426f734a9702f3] Merge branch 'master' of
>> git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next into
>> for-davem
>> git bisect bad 88daf80dcca19ff995cc263592426f734a9702f3
>> # first bad commit: [88daf80dcca19ff995cc263592426f734a9702f3] Merge
>> branch 'master' of
>> git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next into
>> for-davem
>>
