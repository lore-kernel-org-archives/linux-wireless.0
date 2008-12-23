Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:34963 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbYLWHji (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2008 02:39:38 -0500
Received: by yx-out-2324.google.com with SMTP id 8so824535yxm.1
        for <linux-wireless@vger.kernel.org>; Mon, 22 Dec 2008 23:39:36 -0800 (PST)
Message-ID: <2d0a357f0812222339h622dbb36k83c312c523819291@mail.gmail.com> (sfid-20081223_083946_112219_0D9E7B24)
Date: Tue, 23 Dec 2008 08:39:36 +0100
From: "Sedat Dilek" <sedat.dilek@googlemail.com>
To: "Zhu Yi" <yi.zhu@intel.com>
Subject: Re: [PATCH 10/10] iwl3945: use rx queue management infrastructure from iwlcore
Cc: "Kalle Valo" <kalle.valo@iki.fi>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Winkler, Tomas" <tomas.winkler@intel.com>
In-Reply-To: <1230001118.2570.35.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1229916683-9772-1-git-send-email-yi.zhu@intel.com>
	 <1229916683-9772-5-git-send-email-yi.zhu@intel.com>
	 <1229916683-9772-6-git-send-email-yi.zhu@intel.com>
	 <1229916683-9772-7-git-send-email-yi.zhu@intel.com>
	 <1229916683-9772-8-git-send-email-yi.zhu@intel.com>
	 <1229916683-9772-9-git-send-email-yi.zhu@intel.com>
	 <1229916683-9772-10-git-send-email-yi.zhu@intel.com>
	 <1229916683-9772-11-git-send-email-yi.zhu@intel.com>
	 <87r640s3ph.fsf@litku.valot.fi>
	 <1230001118.2570.35.camel@debian.sh.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hiho,

No Xmas-bells ringing here.

I applied the patch-series 01/10 till 10/10 and afterwards I reverted
04_10_iwl3945-remove-iwl-3945-led.[ch].patch with Yi's revert-patch.

On the first sight, everything seems OK.
iwlist, wpa_cli gave the expected values back, but there is no DNS
resolved properly, e.g. ping.
This new state is also not usable for me :-).

What does this mean?
[...]
/var/log/syslog:Dec 23 08:18:05 seduxbox kernel: mac80211-phy0: failed
to set key (2, ff:ff:ff:ff:ff:ff) to hardware (-22)
[...]
Do I need any mac80211-patches additionally?

The file exists:
$ ls -l /lib/modules/2.6.28-rc9-git3-wl-gcc44/kernel/drivers/crypto/padlock-aes.ko
-rw-r--r-- 1 root root 11724 2008-12-23 07:46
/lib/modules/2.6.28-rc9-git3-wl-gcc44/kernel/drivers/crypto/padlock-aes.ko

Kind Regards,
Sedat

----- Investigations -----

[...]
/var/log/syslog-Dec 23 08:18:05 seduxbox kernel: EXT4-fs: mounted
filesystem with ordered data mode.
/var/log/syslog-Dec 23 08:18:05 seduxbox kernel: kjournald starting.
Commit interval 5 seconds
/var/log/syslog-Dec 23 08:18:05 seduxbox kernel: EXT3 FS on sda6,
internal journal
/var/log/syslog-Dec 23 08:18:05 seduxbox kernel: EXT3-fs: mounted
filesystem with ordered data mode.
/var/log/syslog-Dec 23 08:18:05 seduxbox kernel: iwl3945 0000:10:00.0:
PCI INT A -> GSI 17 (level, low) -> IRQ 17
/var/log/syslog-Dec 23 08:18:05 seduxbox kernel: iwl3945 0000:10:00.0:
restoring config space at offset 0x1 (was 0x100002, writing 0x100006)
/var/log/syslog-Dec 23 08:18:05 seduxbox kernel: iwl3945 0000:10:00.0:
irq 1274 for MSI/MSI-X
/var/log/syslog-Dec 23 08:18:05 seduxbox kernel: iwl3945 0000:10:00.0:
firmware: requesting iwlwifi-3945-2.ucode
/var/log/syslog-Dec 23 08:18:05 seduxbox kernel: iwl3945 0000:10:00.0:
loaded firmware version 15.28.2.8
/var/log/syslog-Dec 23 08:18:05 seduxbox kernel: Registered led
device: iwl-phy0:radio
/var/log/syslog-Dec 23 08:18:05 seduxbox kernel: Registered led
device: iwl-phy0:assoc
/var/log/syslog-Dec 23 08:18:05 seduxbox kernel: Registered led
device: iwl-phy0:RX
/var/log/syslog-Dec 23 08:18:05 seduxbox kernel: Registered led
device: iwl-phy0:TX
/var/log/syslog-Dec 23 08:18:05 seduxbox kernel: NET: Registered
protocol family 17
/var/log/syslog-Dec 23 08:18:05 seduxbox kernel: NET: Registered
protocol family 10
/var/log/syslog-Dec 23 08:18:05 seduxbox kernel: lo: Disabled Privacy Extensions
/var/log/syslog-Dec 23 08:18:05 seduxbox kernel: ADDRCONF(NETDEV_UP):
wlan0: link is not ready
/var/log/syslog-Dec 23 08:18:05 seduxbox kernel: wlan0: authenticate
with AP 00:1c:4a:41:62:2e
/var/log/syslog-Dec 23 08:18:05 seduxbox kernel: wlan0: authenticated
/var/log/syslog-Dec 23 08:18:05 seduxbox kernel: wlan0: associate with
AP 00:1c:4a:41:62:2e
/var/log/syslog-Dec 23 08:18:05 seduxbox kernel: wlan0: RX AssocResp
from 00:1c:4a:41:62:2e (capab=0x411 status=0 aid=1)
/var/log/syslog-Dec 23 08:18:05 seduxbox kernel: wlan0: associated
/var/log/syslog-Dec 23 08:18:05 seduxbox kernel:
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
/var/log/syslog-Dec 23 08:18:05 seduxbox kernel: padlock: VIA PadLock
not detected.
/var/log/syslog-Dec 23 08:18:05 seduxbox modprobe: WARNING: Error
inserting padlock_aes
(/lib/modules/2.6.28-rc9-git3-wl-gcc44/kernel/drivers/crypto/padlock-aes.ko):
No such device
/var/log/syslog:Dec 23 08:18:05 seduxbox kernel: mac80211-phy0: failed
to set key (2, ff:ff:ff:ff:ff:ff) to hardware (-22)
[...]

On Tue, Dec 23, 2008 at 3:58 AM, Zhu Yi <yi.zhu@intel.com> wrote:
> On Mon, 2008-12-22 at 22:07 +0800, Kalle Valo wrote:
>> Yes, ifconfig up works but now iwlist wlan0 scan crashes. I just
>> tested this once due to lack of time.
>>
>> I hope I get my wifi working before Christmas ;)
>
> http://marc.info/?l=linux-wireless&m=123000088608330&w=2 should fix the
> problem. Thanks a lot for your testing.
>
> Thanks,
> -yi
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
