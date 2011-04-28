Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61180 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623Ab1D1Exu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2011 00:53:50 -0400
Received: by wya21 with SMTP id 21so1778560wya.19
        for <linux-wireless@vger.kernel.org>; Wed, 27 Apr 2011 21:53:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1303757217.1538.2.camel@gnutoo-laptop>
References: <1298390485.2575.6.camel@gnutoo-laptop>
	<AANLkTin0ixVQJA6B6Et1AUqdkhu1b+hv6Gxu_SQWEMzD@mail.gmail.com>
	<1300647934.31197.0.camel@gnutoo-laptop>
	<AANLkTink_44QnwzQE2gZXsV3QVi5-KW_oAkYozjyhQhr@mail.gmail.com>
	<1303757217.1538.2.camel@gnutoo-laptop>
Date: Thu, 28 Apr 2011 10:23:48 +0530
Message-ID: <BANLkTikn+4Unz_-v-yOCLKSUXhBpfOCZ3w@mail.gmail.com> (sfid-20110428_065353_812025_16597008)
Subject: Re: ath9k stopped queue bug
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: "Denis 'GNUtoo' Carikli" <GNUtoo@no-log.org>
Cc: linux-wireless@vger.kernel.org,
	ath9k-devel <ath9k-devel@lists.ath9k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 26, 2011 at 12:16 AM, Denis 'GNUtoo' Carikli
<GNUtoo@no-log.org> wrote:
> On Mon, 2011-03-21 at 20:41 +0530, Mohammed Shafi wrote:
>> On Mon, Mar 21, 2011 at 12:35 AM, Denis 'GNUtoo' Carikli
>> <GNUtoo@no-log.org> wrote:
>> > On Wed, 2011-02-23 at 11:04 +0530, Mohammed Shafi wrote:
>> >> please try with debug messages enabled sudo modprobe ath9k debug=0x2
>> >> (or)
>> >> sudo modprobe debug=0x82 (this produces lots of log)
>> > # cat /sys/kernel/debug/ieee80211/phy*/queues
>> > 00: 0x00000000/0
>> > 01: 0x00000000/0
>> > 02: 0x00000001/965
>> > 03: 0x00000000/0
>> > # uname -a
>> > Linux gnutoo-laptop 2.6.38-gnutoo-0001 #2 SMP Sat Mar 19 19:07:58 CET
>> > 2011 x86_64 GNU/Linux
>> >
>> > The problem persist and dmesg still doesn't have the debug infos...
>>
>>
>> regarding the debug info you need to be enable following in config.mk or .config
>> CONFIG_ATH_DEBUG=y
>> CONFIG_ATH9K_DEBUGFS=y
> Here's 0x2:
> [...]
> [ 8022.507095] ath: qnum: 0, txq depth: 0
> [ 8022.507101] ath: Enable TXE on queue: 0
> [ 8022.507142] ath: tx queue 0 (37838880), link ffff880037838880
> [ 8022.507295] ath: tx queue 0 (37838880), link ffff880037838880
> [ 8022.601383] ath: qnum: 0, txq depth: 0
> [ 8022.601390] ath: Enable TXE on queue: 0
> [ 8022.601444] ath: tx queue 0 (378388e8), link ffff8800378388e8
> [ 8022.601564] ath: tx queue 0 (378388e8), link ffff8800378388e8
> [ 8022.845845] scsi host1: rpm_resume flags 0x4
> [ 8022.845851] scsi host1: rpm_resume returns 1
> [ 8023.844839] scsi host1: rpm_resume flags 0x4
> [ 8023.844845] scsi host1: rpm_resume returns 1
> [ 8023.846386] scsi host1: rpm_resume flags 0x4
> [ 8023.846393] scsi host1: rpm_resume returns 1
> [ 8024.246146] ath: qnum: 0, txq depth: 0
> [ 8024.246153] ath: Enable TXE on queue: 0
> [ 8024.246194] ath: tx queue 0 (37838950), link ffff880037838950
> [ 8024.246272] ath: tx queue 0 (37838950), link ffff880037838950
> [ 8024.339867] ath: qnum: 0, txq depth: 0
> [ 8024.339874] ath: Enable TXE on queue: 0
> [ 8024.339917] ath: tx queue 0 (378389b8), link ffff8800378389b8
> [ 8024.339990] ath: tx queue 0 (378389b8), link ffff8800378389b8
> [ 8024.844097] scsi host1: rpm_resume flags 0x4
> [ 8024.844104] scsi host1: rpm_resume returns 1
> [ 8025.842473] scsi host1: rpm_resume flags 0x4
> [ 8025.842480] scsi host1: rpm_resume returns 1
> [ 8025.843829] scsi host1: rpm_resume flags 0x4
> [ 8025.843833] scsi host1: rpm_resume returns 1
> [ 8026.292195] ath: qnum: 0, txq depth: 0
> [ 8026.292202] ath: Enable TXE on queue: 0
> [ 8026.292242] ath: tx queue 0 (37838a20), link ffff880037838a20
> [ 8026.292323] ath: tx queue 0 (37838a20), link ffff880037838a20
> [ 8026.387914] ath: qnum: 0, txq depth: 0
> [ 8026.387923] ath: Enable TXE on queue: 0
> [ 8026.388040] ath: tx queue 0 (37838a88), link ffff880037838a88
> [ 8026.841295] scsi host1: rpm_resume flags 0x4
> [ 8026.841301] scsi host1: rpm_resume returns 1
> [ 8027.315285] ath: qnum: 0, txq depth: 0
> [ 8027.315292] ath: Enable TXE on queue: 0
> [ 8027.315337] ath: tx queue 0 (37838af0), link ffff880037838af0
> [ 8027.315410] ath: tx queue 0 (37838af0), link ffff880037838af0
> [ 8027.406817] ath: qnum: 0, txq depth: 0
> [ 8027.406824] ath: Enable TXE on queue: 0
> [ 8027.406875] ath: tx queue 0 (37838b58), link ffff880037838b58
> [ 8027.406991] ath: tx queue 0 (37838b58), link ffff880037838b58
> [ 8027.841126] scsi host1: rpm_resume flags 0x4
> [ 8027.841133] scsi host1: rpm_resume returns 1
> [ 8027.842780] scsi host1: rpm_resume flags 0x4
> [ 8027.842787] scsi host1: rpm_resume returns 1
> [ 8028.338233] ath: qnum: 0, txq depth: 0
> [ 8028.338240] ath: Enable TXE on queue: 0
> [ 8028.338280] ath: tx queue 0 (37838bc0), link ffff880037838bc0
> [ 8028.338358] ath: tx queue 0 (37838bc0), link ffff880037838bc0
> [ 8028.435895] ath: qnum: 0, txq depth: 0
> [ 8028.435901] ath: Enable TXE on queue: 0
> [ 8028.435947] ath: tx queue 0 (37838c28), link ffff880037838c28
> [ 8028.436019] ath: tx queue 0 (37838c28), link ffff880037838c28
> [ 8028.840280] scsi host1: rpm_resume flags 0x4
> [ 8028.840287] scsi host1: rpm_resume returns 1
> [ 8029.839181] scsi host1: rpm_resume flags 0x4
> [ 8029.839191] scsi host1: rpm_resume returns 1
> [ 8029.840671] scsi host1: rpm_resume flags 0x4
> [ 8029.840677] scsi host1: rpm_resume returns 1
> [ 8030.838370] scsi host1: rpm_resume flags 0x4
> [...] (nothing but power management debug stuff)
>
> I also attached a more complete bziped log.
>
> Sorry for the delay.

Hi Denis,
             please try with the backported fix Senthil had provided
for your kernel. from the debug messages I could see that the
txq-depth has reached the 'maximum' of 123 for some reason and this
might stop the queue.

Also you mentioned about power management debug stuff, if the tx is
going we should hardly get it(unless the traffic stalls). if you want
all the latest fixes you can try with latest wireless-testing  or
compat-wireless
http://linuxwireless.org/en/developers/Documentation/git-guide
http://wireless.kernel.org/en/users/Download

>
> Denis.
>
>
