Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33109 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568Ab1GEOrP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 10:47:15 -0400
Received: by wyg8 with SMTP id 8so4043006wyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jul 2011 07:47:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110705143029.GA28091@alittletooquiet.net>
References: <20110701133553.GA7125@alittletooquiet.net>
	<BANLkTikByepHZoEE2b65CrgUmpBmcxiTgw@mail.gmail.com>
	<BANLkTimUs65_Sw=pwF-J8gPjyrNcs2qnOw@mail.gmail.com>
	<20110701173237.GC7125@alittletooquiet.net>
	<20110704052410.GA1364@vmraj-lnx.users.atheros.com>
	<20110704095341.GA1380@vmraj-lnx.users.atheros.com>
	<20110705124914.GC26882@alittletooquiet.net>
	<CAD2nsn0-FQuo7bT3nb3jJLDe1XwbMw4J-Gr8qFkY5zzY1O-vxg@mail.gmail.com>
	<20110705143029.GA28091@alittletooquiet.net>
Date: Tue, 5 Jul 2011 20:17:13 +0530
Message-ID: <CAD2nsn1r7cW7KZ2W_z+SURHRpaTvuC_bd42yN9S+y9JrYMkS4w@mail.gmail.com> (sfid-20110705_165624_609276_6A9898E0)
Subject: Re: ath9k_htc fails to initialize TL-WN721N with compat-wireless 3.0-rc4-1
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Forest Bond <forest@alittletooquiet.net>
Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 5, 2011 at 8:00 PM, Forest Bond <forest@alittletooquiet.net> wrote:
> Hi,
>
> On Tue, Jul 05, 2011 at 06:59:27PM +0530, Mohammed Shafi wrote:
>> >> > Please share your PID/VID.
>> >
>> > 0cf3:9271
>> >
>> >> And also for compat-wireless-v3.0-rc4-1, FW version should be 1.3 and fw size
>> >> should be 51272. But in your case size is 51288 which is 1.2. Please upgrade fw
>> >> to 1.3 and test again.
>> >>
>> >> http://wireless.kernel.org/download/htc_fw/1.3/htc_9271.fw
>> >
>> > Okay.  I had tried both versions previously; neither seems to work any better
>> > than the other.  Here is dmesg using firmware version 1.3:
>> >
>> > [  102.984766] Compat-wireless backport release: compat-wireless-v3.0-rc4-1
>> > [  102.984775] Backport based on linux-2.6-allstable.git v3.0-rc4
>> > [  103.213468] Calling CRDA to update world regulatory domain
>> > [  103.798281] usbcore: registered new interface driver ath9k_htc
>> > [  108.482070] usb 5-7: new high speed USB device using ehci_hcd and address 5
>> > [  108.643105] usb 5-7: configuration #1 chosen from 1 choice
>> > [  108.996663] usb 5-7: ath9k_htc: Transferred FW: htc_9271.fw, size: 51272
>> > [  109.135499] ath9k_htc 5-7:1.0: ath9k_htc: HTC initialized with 33 credits
>> > [  109.140526] ath: UNDEFINED -> AWAKE
>> > [  109.141769] ath: serialize_regmode is 0
>> > [  109.383151] ath: Timeout waiting for WMI command: WMI_REG_WRITE_CMDID
>> > [  109.383168] ath: REGISTER WRITE FAILED, multi len: 9
>> > [  109.609805] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
>> > [  109.609822] ath: REGISTER READ FAILED: (0x9c00, -110)
>> > [  109.609835] ath: Reading from EEPROM, not flash
>> > [  109.824058] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
>> > [  109.824079] ath: Multiple REGISTER READ FAILED (count: 8)
>> > [  110.042132] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
>> > [  110.042148] ath: Multiple REGISTER READ FAILED (count: 8)
>> > [  110.260786] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
>> > [  110.260802] ath: Multiple REGISTER READ FAILED (count: 8)
>> > [  110.482613] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
>> > [  110.482629] ath: Multiple REGISTER READ FAILED (count: 8)
>> > [  110.719736] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
>> > [  110.719753] ath: Multiple REGISTER READ FAILED (count: 8)
>> > [  110.953628] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
>> > [  110.953645] ath: Multiple REGISTER READ FAILED (count: 8)
>> > [  111.195035] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
>> > [  111.195057] ath: Multiple REGISTER READ FAILED (count: 8)
>> > [  111.432953] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
>> > [  111.432975] ath: Multiple REGISTER READ FAILED (count: 8)
>> > [  111.668211] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
>> > [  111.668227] ath: Multiple REGISTER READ FAILED (count: 8)
>> > [  111.903626] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
>> > [  111.903642] ath: Multiple REGISTER READ FAILED (count: 8)
>> > [  112.135695] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
>> > [  112.135711] ath: Multiple REGISTER READ FAILED (count: 8)
>> > [  112.370919] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
>> > [  112.370936] ath: Multiple REGISTER READ FAILED (count: 8)
>> > [  112.603491] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
>> > [  112.603508] ath: Multiple REGISTER READ FAILED (count: 8)
>> > [  112.841972] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
>> > [  112.841988] ath: Multiple REGISTER READ FAILED (count: 8)
>> > [  113.065412] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
>> > [  113.065428] ath: Multiple REGISTER READ FAILED (count: 8)
>> > [  113.300441] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
>> > [  113.300458] ath: Multiple REGISTER READ FAILED (count: 8)
>> > [  113.536889] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
>> > [  113.536906] ath: Multiple REGISTER READ FAILED (count: 8)
>> > [  113.774809] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
>> > [  113.774826] ath: Multiple REGISTER READ FAILED (count: 8)
>> > [  114.012001] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
>> > [  114.012018] ath: Multiple REGISTER READ FAILED (count: 8)
>> > [  114.245297] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
>> > [  114.245314] ath: Multiple REGISTER READ FAILED (count: 8)
>> > [  114.476929] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
>> > [  114.476946] ath: Multiple REGISTER READ FAILED (count: 8)
>> > [  114.753310] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
>> > [  114.753327] ath: Multiple REGISTER READ FAILED (count: 8)
>> > [  114.966595] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
>> > [  114.966611] ath: Multiple REGISTER READ FAILED (count: 8)
>> > [  115.193618] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
>> > [  115.193634] ath: Multiple REGISTER READ FAILED (count: 4)
>> > [  115.462402] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
>> > [  115.462419] ath: REGISTER READ FAILED: (0x2000, -110)
>> > [  115.685667] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
>> > [  115.685684] ath: REGISTER READ FAILED: (0x407c, -110)
>> > [  115.918681] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
>> > [  115.918703] ath: REGISTER READ FAILED: (0x407c, -110)
>> > [  116.152756] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
>> > [  116.152773] ath: REGISTER READ FAILED: (0x407c, -110)
>> > [  116.391881] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
>> > [  116.391898] ath: REGISTER READ FAILED: (0x407c, -110)
>> > [  116.629244] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
>> > [  116.629265] ath: REGISTER READ FAILED: (0x407c, -110)
>> > [  116.860197] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
>> > [  116.860214] ath: REGISTER READ FAILED: (0x407c, -110)
>> > [  117.094108] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
>> > [  117.094124] ath: REGISTER READ FAILED: (0x407c, -110)
>> > [  117.325535] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
>> > [  117.325551] ath: REGISTER READ FAILED: (0x407c, -110)
>> > [  117.578615] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
>> > [  117.578632] ath: REGISTER READ FAILED: (0x407c, -110)
>> > [  117.819951] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
>> > [  117.819968] ath: REGISTER READ FAILED: (0x407c, -110)
>> > [  118.055933] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
>> > [  118.055950] ath: REGISTER READ FAILED: (0x407c, -110)
>> > [  118.329876] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
>> > [  118.329893] ath: REGISTER READ FAILED: (0x407c, -110)
>> > [  118.563992] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
>> > [  118.564009] ath: REGISTER READ FAILED: (0x407c, -110)
>> > [  118.803279] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
>> > [  118.803296] ath: REGISTER READ FAILED: (0x407c, -110)
>> > [  119.045193] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
>> > [  119.045209] ath: REGISTER READ FAILED: (0x407c, -110)
>> > [  119.294820] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
>> > [  119.294832] ath: REGISTER READ FAILED: (0x407c, -110)
>> > [  119.536403] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
>> > [  119.536421] ath: REGISTER READ FAILED: (0x407c, -110)
>> > [  119.764358] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
>> > [  119.764375] ath: REGISTER READ FAILED: (0x407c, -110)
>> > [  120.002647] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
>> > [  120.002664] ath: REGISTER READ FAILED: (0x407c, -110)
>> > [  120.223089] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
>> > [  120.223107] ath: REGISTER READ FAILED: (0x407c, -110)
>> > [  120.450418] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
>> > [  120.450435] ath: REGISTER READ FAILED: (0x407c, -110)
>> > [  120.701625] ath: Timeout waiting for WMI command: WMI_REG_READ_CMDID
>> > [  120.701638] ath: REGISTER READ FAILED: (0x407c, -110)
>>
>> please try to apply the attached reverting patch, if it works it may
>> help us to narrow down the issue.
>
> This does not seem to make a difference.

sorry  i found it late and Raj pointed out register write itself is
failing and I doubt multiple register write is failing for you.
just thinking about these two commits ... and may be try reverting the
second one

commit 4a22fe108e62367c10c3abeb469d6972ba3299f5
commit 7d0d0df0eca695c83a08dc386824a9d1d7c526a4


-- 
shafi
