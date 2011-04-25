Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp208.alice.it ([82.57.200.104]:32835 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758808Ab1DYSrD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2011 14:47:03 -0400
Subject: Re: ath9k stopped queue bug
From: Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	ath9k-devel <ath9k-devel@lists.ath9k.org>
In-Reply-To: <AANLkTink_44QnwzQE2gZXsV3QVi5-KW_oAkYozjyhQhr@mail.gmail.com>
References: <1298390485.2575.6.camel@gnutoo-laptop>
	 <AANLkTin0ixVQJA6B6Et1AUqdkhu1b+hv6Gxu_SQWEMzD@mail.gmail.com>
	 <1300647934.31197.0.camel@gnutoo-laptop>
	 <AANLkTink_44QnwzQE2gZXsV3QVi5-KW_oAkYozjyhQhr@mail.gmail.com>
Content-Type: multipart/mixed; boundary="=-q8exWmuJznXoErxvaKM9"
Date: Mon, 25 Apr 2011 20:46:57 +0200
Message-ID: <1303757217.1538.2.camel@gnutoo-laptop> (sfid-20110425_204707_996221_2D6F8330)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-q8exWmuJznXoErxvaKM9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Mon, 2011-03-21 at 20:41 +0530, Mohammed Shafi wrote:
> On Mon, Mar 21, 2011 at 12:35 AM, Denis 'GNUtoo' Carikli
> <GNUtoo@no-log.org> wrote:
> > On Wed, 2011-02-23 at 11:04 +0530, Mohammed Shafi wrote:
> >> please try with debug messages enabled sudo modprobe ath9k debug=0x2
> >> (or)
> >> sudo modprobe debug=0x82 (this produces lots of log)
> > # cat /sys/kernel/debug/ieee80211/phy*/queues
> > 00: 0x00000000/0
> > 01: 0x00000000/0
> > 02: 0x00000001/965
> > 03: 0x00000000/0
> > # uname -a
> > Linux gnutoo-laptop 2.6.38-gnutoo-0001 #2 SMP Sat Mar 19 19:07:58 CET
> > 2011 x86_64 GNU/Linux
> >
> > The problem persist and dmesg still doesn't have the debug infos...
> 
> 
> regarding the debug info you need to be enable following in config.mk or .config
> CONFIG_ATH_DEBUG=y
> CONFIG_ATH9K_DEBUGFS=y
Here's 0x2:
[...]
[ 8022.507095] ath: qnum: 0, txq depth: 0
[ 8022.507101] ath: Enable TXE on queue: 0
[ 8022.507142] ath: tx queue 0 (37838880), link ffff880037838880
[ 8022.507295] ath: tx queue 0 (37838880), link ffff880037838880
[ 8022.601383] ath: qnum: 0, txq depth: 0
[ 8022.601390] ath: Enable TXE on queue: 0
[ 8022.601444] ath: tx queue 0 (378388e8), link ffff8800378388e8
[ 8022.601564] ath: tx queue 0 (378388e8), link ffff8800378388e8
[ 8022.845845] scsi host1: rpm_resume flags 0x4
[ 8022.845851] scsi host1: rpm_resume returns 1
[ 8023.844839] scsi host1: rpm_resume flags 0x4
[ 8023.844845] scsi host1: rpm_resume returns 1
[ 8023.846386] scsi host1: rpm_resume flags 0x4
[ 8023.846393] scsi host1: rpm_resume returns 1
[ 8024.246146] ath: qnum: 0, txq depth: 0
[ 8024.246153] ath: Enable TXE on queue: 0
[ 8024.246194] ath: tx queue 0 (37838950), link ffff880037838950
[ 8024.246272] ath: tx queue 0 (37838950), link ffff880037838950
[ 8024.339867] ath: qnum: 0, txq depth: 0
[ 8024.339874] ath: Enable TXE on queue: 0
[ 8024.339917] ath: tx queue 0 (378389b8), link ffff8800378389b8
[ 8024.339990] ath: tx queue 0 (378389b8), link ffff8800378389b8
[ 8024.844097] scsi host1: rpm_resume flags 0x4
[ 8024.844104] scsi host1: rpm_resume returns 1
[ 8025.842473] scsi host1: rpm_resume flags 0x4
[ 8025.842480] scsi host1: rpm_resume returns 1
[ 8025.843829] scsi host1: rpm_resume flags 0x4
[ 8025.843833] scsi host1: rpm_resume returns 1
[ 8026.292195] ath: qnum: 0, txq depth: 0
[ 8026.292202] ath: Enable TXE on queue: 0
[ 8026.292242] ath: tx queue 0 (37838a20), link ffff880037838a20
[ 8026.292323] ath: tx queue 0 (37838a20), link ffff880037838a20
[ 8026.387914] ath: qnum: 0, txq depth: 0
[ 8026.387923] ath: Enable TXE on queue: 0
[ 8026.388040] ath: tx queue 0 (37838a88), link ffff880037838a88
[ 8026.841295] scsi host1: rpm_resume flags 0x4
[ 8026.841301] scsi host1: rpm_resume returns 1
[ 8027.315285] ath: qnum: 0, txq depth: 0
[ 8027.315292] ath: Enable TXE on queue: 0
[ 8027.315337] ath: tx queue 0 (37838af0), link ffff880037838af0
[ 8027.315410] ath: tx queue 0 (37838af0), link ffff880037838af0
[ 8027.406817] ath: qnum: 0, txq depth: 0
[ 8027.406824] ath: Enable TXE on queue: 0
[ 8027.406875] ath: tx queue 0 (37838b58), link ffff880037838b58
[ 8027.406991] ath: tx queue 0 (37838b58), link ffff880037838b58
[ 8027.841126] scsi host1: rpm_resume flags 0x4
[ 8027.841133] scsi host1: rpm_resume returns 1
[ 8027.842780] scsi host1: rpm_resume flags 0x4
[ 8027.842787] scsi host1: rpm_resume returns 1
[ 8028.338233] ath: qnum: 0, txq depth: 0
[ 8028.338240] ath: Enable TXE on queue: 0
[ 8028.338280] ath: tx queue 0 (37838bc0), link ffff880037838bc0
[ 8028.338358] ath: tx queue 0 (37838bc0), link ffff880037838bc0
[ 8028.435895] ath: qnum: 0, txq depth: 0
[ 8028.435901] ath: Enable TXE on queue: 0
[ 8028.435947] ath: tx queue 0 (37838c28), link ffff880037838c28
[ 8028.436019] ath: tx queue 0 (37838c28), link ffff880037838c28
[ 8028.840280] scsi host1: rpm_resume flags 0x4
[ 8028.840287] scsi host1: rpm_resume returns 1
[ 8029.839181] scsi host1: rpm_resume flags 0x4
[ 8029.839191] scsi host1: rpm_resume returns 1
[ 8029.840671] scsi host1: rpm_resume flags 0x4
[ 8029.840677] scsi host1: rpm_resume returns 1
[ 8030.838370] scsi host1: rpm_resume flags 0x4
[...] (nothing but power management debug stuff)

I also attached a more complete bziped log.

Sorry for the delay.

Denis.


--=-q8exWmuJznXoErxvaKM9
Content-Type: application/x-bzip; name="ath9k_trace.txt.bz2"
Content-Disposition: attachment; filename="ath9k_trace.txt.bz2"
Content-Transfer-Encoding: base64

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
foXckU4UJBeBLl3A


--=-q8exWmuJznXoErxvaKM9--

