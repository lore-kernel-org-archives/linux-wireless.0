Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46167 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479Ab2ICNx1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Sep 2012 09:53:27 -0400
Received: by obbuo13 with SMTP id uo13so9153805obb.19
        for <linux-wireless@vger.kernel.org>; Mon, 03 Sep 2012 06:53:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120902200102.GA28313@pandem0nium>
References: <20120813165340.GA10044@pandem0nium>
	<20120819220436.GA9899@pandem0nium>
	<CAD2nsn0O+dfJLnKroRUJF6TEVWUmgwvriF7M+Oy4YL2ug0gSNA@mail.gmail.com>
	<CAD2nsn2_V-p+8u0VSnkJnjtFF-+nkT=vOLCBqmK9+H=Sj=uhCA@mail.gmail.com>
	<20120902200102.GA28313@pandem0nium>
Date: Mon, 3 Sep 2012 19:23:26 +0530
Message-ID: <CAD2nsn2wGCsYV2NW9VSVnvmQhnEk0EXW1vn6eaTYg_4-1w8ecQ@mail.gmail.com> (sfid-20120903_155332_331461_15D2D5A1)
Subject: Re: AR9330 hornet board stops beaconing after a few days (0xdeadbeef)
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	openwrt-devel@lists.openwrt.org,
	Marek Lindner <lindner_marek@yahoo.de>, sven@narfation.org,
	Gabor Juhos <juhosg@openwrt.org>,
	Adrian Chadd <adrian.chadd@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 3, 2012 at 1:31 AM, Simon Wunderlich
<simon.wunderlich@s2003.tu-chemnitz.de> wrote:
> Hey guys,
>
> now, finally after approx. 9 days the problem hit us again, this time with debug enabled.
>
> The symptoms are the same as described before. I'm pasting part of the syslog of routers
> 200 and 201 where the calibrating output changes - this is the only thing I could find
> which was really different from before.
>
> Unfortunately I can't take anything useful out of the logs - to me, it looks like the
> 'NF calibrated' output changes out of the blue. I can provide full log files to anyone
> interested.
>
> Debug level was:
>
> # cat /sys/kernel/debug/ieee80211/phy0/ath9k/debug
> 0x000ffe2d
>
> Any ideas? The routers are still on and reachable in this errorneous state, so I can
> check for more things. :)
>
> Thanks,
>         Simon
>
> === router 200 ===
> root@OpenWrt:/sys/kernel/debug/ieee80211/phy0/ath9k# head regdump
> 0x000000 0xdeadbeef
> 0x000004 0xdeadbeef
> 0x000008 0xdeadbeef
> 0x00000c 0xdeadbeef
> 0x000010 0xdeadbeef
> 0x000014 0xdeadbeef
> 0x000018 0xdeadbeef
> 0x00001c 0xdeadbeef
> 0x000020 0xdeadbeef
> 0x000024 0xdeadbeef
>
>
> Aug 31 15:48:56 192.168.10.200 kernel: [706236.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -105
> Aug 31 15:49:01 192.168.10.200 kernel: [706236.110000] ath: phy0: NF calibrated [ext] [chain 0] is -104
> Aug 31 15:49:25 192.168.10.200 kernel: [706266.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -105
> Aug 31 15:49:31 192.168.10.200 kernel: [706266.110000] ath: phy0: NF calibrated [ext] [chain 0] is -104
> Aug 31 15:49:55 192.168.10.200 kernel: [706296.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -105
> Aug 31 15:50:01 192.168.10.200 kernel: [706296.110000] ath: phy0: NF calibrated [ext] [chain 0] is -104
> Aug 31 15:51:22 192.168.10.200 kernel: [706309.810000] ath: phy0: Resetting Cal 1 state for channel 2462
> Aug 31 15:51:27 192.168.10.200 kernel: [706309.910000] ath: phy0: starting IQ Mismatch Calibration
> Aug 31 15:51:32 192.168.10.200 kernel: [706326.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -105
> Aug 31 15:51:37 192.168.10.200 kernel: [706326.110000] ath: phy0: NF calibrated [ext] [chain 0] is -104
> Aug 31 15:51:42 192.168.10.200 kernel: [706327.810000] ath: phy0: 0: Chn 0 pmi=0x0389beb7;pmq=0x03853165;iqcm=0x0015ca84;
> Aug 31 15:51:47 192.168.10.200 kernel: [706327.810000] ath: phy0: Starting IQ Cal and Correction for Chain 0
> Aug 31 15:51:52 192.168.10.200 kernel: [706327.810000] ath: phy0: Original: Chn 0 iq_corr_meas = 0x0015ca84
> Aug 31 15:51:57 192.168.10.200 kernel: [706327.810000] ath: phy0: Chn 0 pwr_meas_i = 0x0389beb7
> Aug 31 15:52:02 192.168.10.200 kernel: [706327.810000] ath: phy0: Chn 0 pwr_meas_q = 0x03853165
> Aug 31 15:52:07 192.168.10.200 kernel: [706327.810000] ath: phy0: iqCorrNeg is 0x00000000
> Aug 31 15:52:12 192.168.10.200 kernel: [706327.810000] ath: phy0: Chn 0 iCoff = 0x00000006
> Aug 31 15:52:17 192.168.10.200 kernel: [706327.810000] ath: phy0: Chn 0 qCoff = 0x00000000
> Aug 31 15:52:22 192.168.10.200 kernel: [706327.810000] ath: phy0: Chn 0 : iCoff = 0x7a  qCoff = 0x0
> Aug 31 15:52:28 192.168.10.200 kernel: [706327.810000] ath: phy0: Register offset (0x98dc) before update = 0x20007e01
> Aug 31 15:52:33 192.168.10.200 kernel: [706327.810000] ath: phy0: Register offset (0x98dc) QI COFF (bitfields 0x00003f80) after update = 0x20007d00
> Aug 31 15:52:48 192.168.10.200 kernel: [706356.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -105
> Aug 31 15:52:53 192.168.10.200 kernel: [706356.110000] ath: phy0: NF calibrated [ext] [chain 0] is -104
> Aug 31 15:53:08 192.168.10.200 kernel: [706386.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -105
> Aug 31 15:53:13 192.168.10.200 kernel: [706386.110000] ath: phy0: NF calibrated [ext] [chain 0] is -105
> Aug 31 15:53:28 192.168.10.200 kernel: [706416.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -104
> Aug 31 15:53:33 192.168.10.200 kernel: [706416.110000] ath: phy0: NF calibrated [ext] [chain 0] is -105
> Aug 31 15:53:49 192.168.10.200 kernel: [706446.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -105
> Aug 31 15:53:54 192.168.10.200 kernel: [706446.110000] ath: phy0: NF calibrated [ext] [chain 0] is -105
> Aug 31 15:54:09 192.168.10.200 kernel: [706476.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -105
> Aug 31 15:54:14 192.168.10.200 kernel: [706476.110000] ath: phy0: NF calibrated [ext] [chain 0] is -105
> Aug 31 15:54:29 192.168.10.200 kernel: [706506.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -105
> Aug 31 15:54:34 192.168.10.200 kernel: [706506.110000] ath: phy0: NF calibrated [ext] [chain 0] is -104
> Aug 31 15:54:50 192.168.10.200 kernel: [706536.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -105
> Aug 31 15:54:55 192.168.10.200 kernel: [706536.110000] ath: phy0: NF calibrated [ext] [chain 0] is -105
> Aug 31 15:55:10 192.168.10.200 kernel: [706566.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -105
> Aug 31 15:55:15 192.168.10.200 kernel: [706566.110000] ath: phy0: NF calibrated [ext] [chain 0] is -105
> Aug 31 15:55:30 192.168.10.200 kernel: [706596.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -104
> Aug 31 15:55:35 192.168.10.200 kernel: [706596.110000] ath: phy0: NF calibrated [ext] [chain 0] is -105
> Aug 31 15:55:50 192.168.10.200 kernel: [706626.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -105
> Aug 31 15:55:55 192.168.10.200 kernel: [706626.110000] ath: phy0: NF calibrated [ext] [chain 0] is -104
> Aug 31 15:56:11 192.168.10.200 kernel: [706656.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -105
> Aug 31 15:56:16 192.168.10.200 kernel: [706656.110000] ath: phy0: NF calibrated [ext] [chain 0] is -105
> Aug 31 15:56:31 192.168.10.200 kernel: [706686.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -105
> Aug 31 15:56:36 192.168.10.200 kernel: [706686.110000] ath: phy0: NF calibrated [ext] [chain 0] is -105
> Aug 31 15:56:56 192.168.10.200 kernel: [706716.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -104
> Aug 31 15:57:01 192.168.10.200 kernel: [706716.110000] ath: phy0: NF calibrated [ext] [chain 0] is -105
> Aug 31 15:57:26 192.168.10.200 kernel: [706746.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -104
> Aug 31 15:57:31 192.168.10.200 kernel: [706746.110000] ath: phy0: NF calibrated [ext] [chain 0] is -104
> Aug 31 15:57:56 192.168.10.200 kernel: [706776.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -104
> Aug 31 15:58:01 192.168.10.200 kernel: [706776.110000] ath: phy0: NF calibrated [ext] [chain 0] is -104
> Aug 31 15:58:26 192.168.10.200 kernel: [706806.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -105
> Aug 31 15:58:31 192.168.10.200 kernel: [706806.110000] ath: phy0: NF calibrated [ext] [chain 0] is -105
> Aug 31 15:58:46 192.168.10.200 kernel: [706824.240000] ath: phy0: Set HW Key
> Aug 31 15:58:51 192.168.10.200 kernel: [706824.240000] ath: phy0: Set HW Key
> Aug 31 15:58:56 192.168.10.200 kernel: [706836.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -104
> Aug 31 15:59:01 192.168.10.200 kernel: [706836.110000] ath: phy0: NF calibrated [ext] [chain 0] is -105
> Aug 31 15:59:26 192.168.10.200 kernel: [706866.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -105
> Aug 31 15:59:31 192.168.10.200 kernel: [706866.110000] ath: phy0: NF calibrated [ext] [chain 0] is -105
> Aug 31 15:59:46 192.168.10.200 kernel: [706884.160000] ath: phy0: missed 1 consecutive beacons
> Aug 31 15:59:51 192.168.10.200 kernel: [706884.250000] ath: phy0: resume beacon xmit after 1 misses
> Aug 31 15:59:56 192.168.10.200 kernel: [706896.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -105
> Aug 31 16:00:01 192.168.10.200 kernel: [706896.110000] ath: phy0: NF calibrated [ext] [chain 0] is -104
> Aug 31 16:00:20 192.168.10.200 kernel: [706920.710000] ath: phy0: missed 1 consecutive beacons
> Aug 31 16:00:25 192.168.10.200 kernel: [706920.800000] ath: phy0: resume beacon xmit after 1 misses
> Aug 31 16:00:30 192.168.10.200 kernel: [706926.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -105
> Aug 31 16:00:36 192.168.10.200 kernel: [706926.110000] ath: phy0: NF calibrated [ext] [chain 0] is -105
> Aug 31 16:00:56 192.168.10.200 kernel: [706956.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -105
> Aug 31 16:01:01 192.168.10.200 kernel: [706956.110000] ath: phy0: NF calibrated [ext] [chain 0] is -104
> Aug 31 16:01:26 192.168.10.200 kernel: [706986.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -104
> Aug 31 16:01:31 192.168.10.200 kernel: [706986.110000] ath: phy0: NF calibrated [ext] [chain 0] is -104
> Aug 31 16:01:55 192.168.10.200 kernel: [707015.330000] ath: phy0: missed 1 consecutive beacons
> Aug 31 16:02:00 192.168.10.200 kernel: [707015.420000] ath: phy0: resume beacon xmit after 1 misses
> Aug 31 16:02:05 192.168.10.200 kernel: [707016.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -104
> Aug 31 16:02:10 192.168.10.200 kernel: [707016.110000] ath: phy0: NF calibrated [ext] [chain 0] is -104
> Aug 31 16:02:35 192.168.10.200 kernel: [707046.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -104
> Aug 31 16:02:41 192.168.10.200 kernel: [707046.110000] ath: phy0: NF calibrated [ext] [chain 0] is -104
> Aug 31 16:02:56 192.168.10.200 kernel: [707076.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -105
> Aug 31 16:03:01 192.168.10.200 kernel: [707076.110000] ath: phy0: NF calibrated [ext] [chain 0] is -105
> Aug 31 16:03:26 192.168.10.200 kernel: [707106.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -105
> Aug 31 16:03:31 192.168.10.200 kernel: [707106.110000] ath: phy0: NF calibrated [ext] [chain 0] is -105
> Aug 31 16:03:56 192.168.10.200 kernel: [707136.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -104
> Aug 31 16:04:01 192.168.10.200 kernel: [707136.110000] ath: phy0: NF calibrated [ext] [chain 0] is -104
> Aug 31 16:04:26 192.168.10.200 kernel: [707166.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -105
> Aug 31 16:04:31 192.168.10.200 kernel: [707166.110000] ath: phy0: NF calibrated [ext] [chain 0] is -105
> Aug 31 16:04:56 192.168.10.200 kernel: [707196.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -105
> Aug 31 16:05:01 192.168.10.200 kernel: [707196.110000] ath: phy0: NF calibrated [ext] [chain 0] is -105
> Aug 31 16:05:26 192.168.10.200 kernel: [707226.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -104
> Aug 31 16:05:31 192.168.10.200 kernel: [707226.110000] ath: phy0: NF calibrated [ext] [chain 0] is -104
> Aug 31 16:05:56 192.168.10.200 kernel: [707256.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -105
> Aug 31 16:06:01 192.168.10.200 kernel: [707256.110000] ath: phy0: NF calibrated [ext] [chain 0] is -104
> Aug 31 16:06:26 192.168.10.200 kernel: [707286.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -105
> Aug 31 16:06:31 192.168.10.200 kernel: [707286.110000] ath: phy0: NF calibrated [ext] [chain 0] is -104
> Aug 31 16:06:56 192.168.10.200 kernel: [707316.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -105
> Aug 31 16:07:01 192.168.10.200 kernel: [707316.110000] ath: phy0: NF calibrated [ext] [chain 0] is -104
> Aug 31 16:07:26 192.168.10.200 kernel: [707346.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -104
> Aug 31 16:07:31 192.168.10.200 kernel: [707346.110000] ath: phy0: NF calibrated [ext] [chain 0] is -104
> Aug 31 16:07:56 192.168.10.200 kernel: [707376.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -105
> Aug 31 16:08:01 192.168.10.200 kernel: [707376.110000] ath: phy0: NF calibrated [ext] [chain 0] is -105
> Aug 31 16:08:26 192.168.10.200 kernel: [707406.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -105
> Aug 31 16:08:31 192.168.10.200 kernel: [707406.110000] ath: phy0: NF calibrated [ext] [chain 0] is -105
> Aug 31 16:08:57 192.168.10.200 kernel: [707424.240000] ath: phy0: Set HW Key
> Aug 31 16:09:02 192.168.10.200 kernel: [707424.240000] ath: phy0: Set HW Key
> Aug 31 16:09:07 192.168.10.200 kernel: [707436.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> Aug 31 16:09:12 192.168.10.200 kernel: [707436.110000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:09:17 192.168.10.200 kernel: [707436.110000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> Aug 31 16:09:22 192.168.10.200 kernel: [707436.110000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:09:37 192.168.10.200 kernel: [707466.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> Aug 31 16:09:42 192.168.10.200 kernel: [707466.110000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:09:47 192.168.10.200 kernel: [707466.110000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> Aug 31 16:09:52 192.168.10.200 kernel: [707466.110000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:10:08 192.168.10.200 kernel: [707496.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> Aug 31 16:10:13 192.168.10.200 kernel: [707496.110000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:10:18 192.168.10.200 kernel: [707496.110000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> Aug 31 16:10:23 192.168.10.200 kernel: [707496.110000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:10:48 192.168.10.200 kernel: [707526.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> Aug 31 16:10:53 192.168.10.200 kernel: [707526.110000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:10:58 192.168.10.200 kernel: [707526.110000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> Aug 31 16:11:03 192.168.10.200 kernel: [707526.110000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:11:08 192.168.10.200 kernel: [707527.810000] ath: phy0: Resetting Cal 1 state for channel 2462
> Aug 31 16:11:13 192.168.10.200 kernel: [707527.910000] ath: phy0: starting IQ Mismatch Calibration
> Aug 31 16:11:19 192.168.10.200 kernel: [707528.010000] ath: phy0: 0: Chn 0 pmi=0x00000000;pmq=0x00000000;iqcm=0x00000000;
> Aug 31 16:11:24 192.168.10.200 kernel: [707528.010000] ath: phy0: Starting IQ Cal and Correction for Chain 0
> Aug 31 16:11:29 192.168.10.200 kernel: [707528.010000] ath: phy0: Original: Chn 0 iq_corr_meas = 0x00000000
> Aug 31 16:11:34 192.168.10.200 kernel: [707528.010000] ath: phy0: Chn 0 pwr_meas_i = 0x00000000
> Aug 31 16:11:39 192.168.10.200 kernel: [707528.010000] ath: phy0: Chn 0 pwr_meas_q = 0x00000000
> Aug 31 16:11:44 192.168.10.200 kernel: [707528.010000] ath: phy0: iqCorrNeg is 0x00000000
> Aug 31 16:11:49 192.168.10.200 kernel: [707528.010000] ath: phy0: IQ Cal and Correction (offset 0x98dc) enabled (bit position 0x00004000). New Value 0x20007d00
> Aug 31 16:13:00 192.168.10.200 kernel: [707556.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> Aug 31 16:13:05 192.168.10.200 kernel: [707556.110000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:13:10 192.168.10.200 kernel: [707556.110000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> Aug 31 16:13:15 192.168.10.200 kernel: [707556.110000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:13:30 192.168.10.200 kernel: [707586.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> Aug 31 16:13:35 192.168.10.200 kernel: [707586.110000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:13:40 192.168.10.200 kernel: [707586.110000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> Aug 31 16:13:46 192.168.10.200 kernel: [707586.110000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:14:01 192.168.10.200 kernel: [707616.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> Aug 31 16:14:06 192.168.10.200 kernel: [707616.110000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:14:11 192.168.10.200 kernel: [707616.110000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> Aug 31 16:14:16 192.168.10.200 kernel: [707616.110000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:14:31 192.168.10.200 kernel: [707646.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> Aug 31 16:14:36 192.168.10.200 kernel: [707646.110000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:14:41 192.168.10.200 kernel: [707646.110000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> Aug 31 16:14:46 192.168.10.200 kernel: [707646.110000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:15:02 192.168.10.200 kernel: [707676.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> Aug 31 16:15:07 192.168.10.200 kernel: [707676.110000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:15:12 192.168.10.200 kernel: [707676.110000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> Aug 31 16:15:17 192.168.10.200 kernel: [707676.110000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:15:32 192.168.10.200 kernel: [707706.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> Aug 31 16:15:37 192.168.10.200 kernel: [707706.110000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:15:42 192.168.10.200 kernel: [707706.110000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> Aug 31 16:15:47 192.168.10.200 kernel: [707706.110000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:16:02 192.168.10.200 kernel: [707736.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> Aug 31 16:16:07 192.168.10.200 kernel: [707736.110000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:16:13 192.168.10.200 kernel: [707736.110000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> Aug 31 16:16:18 192.168.10.200 kernel: [707736.110000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:16:33 192.168.10.200 kernel: [707766.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> Aug 31 16:16:38 192.168.10.200 kernel: [707766.110000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:16:43 192.168.10.200 kernel: [707766.110000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> Aug 31 16:16:48 192.168.10.200 kernel: [707766.110000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:17:03 192.168.10.200 kernel: [707796.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> Aug 31 16:17:08 192.168.10.200 kernel: [707796.110000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:17:13 192.168.10.200 kernel: [707796.110000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> Aug 31 16:17:18 192.168.10.200 kernel: [707796.110000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:17:34 192.168.10.200 kernel: [707826.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> Aug 31 16:17:39 192.168.10.200 kernel: [707826.110000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:17:44 192.168.10.200 kernel: [707826.110000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> Aug 31 16:17:49 192.168.10.200 kernel: [707826.110000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:18:04 192.168.10.200 kernel: [707856.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> Aug 31 16:18:09 192.168.10.200 kernel: [707856.110000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:18:14 192.168.10.200 kernel: [707856.110000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> Aug 31 16:18:19 192.168.10.200 kernel: [707856.110000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:18:34 192.168.10.200 kernel: [707886.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> Aug 31 16:18:39 192.168.10.200 kernel: [707886.110000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:18:45 192.168.10.200 kernel: [707886.110000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> Aug 31 16:18:50 192.168.10.200 kernel: [707886.110000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:19:05 192.168.10.200 kernel: [707916.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> Aug 31 16:19:10 192.168.10.200 kernel: [707916.110000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:19:15 192.168.10.200 kernel: [707916.110000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> Aug 31 16:19:20 192.168.10.200 kernel: [707916.110000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:19:45 192.168.10.200 kernel: [707946.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> Aug 31 16:19:50 192.168.10.200 kernel: [707946.110000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:19:55 192.168.10.200 kernel: [707946.110000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> Aug 31 16:20:01 192.168.10.200 kernel: [707946.110000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:20:26 192.168.10.200 kernel: [707976.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> Aug 31 16:20:31 192.168.10.200 kernel: [707976.110000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:20:36 192.168.10.200 kernel: [707976.110000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> Aug 31 16:20:41 192.168.10.200 kernel: [707976.110000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:20:56 192.168.10.200 kernel: [708006.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> Aug 31 16:21:01 192.168.10.200 kernel: [708006.110000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:21:06 192.168.10.200 kernel: [708006.110000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> Aug 31 16:21:11 192.168.10.200 kernel: [708006.110000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:21:27 192.168.10.200 kernel: [708024.250000] ath: phy0: Set HW Key
> Aug 31 16:21:32 192.168.10.200 kernel: [708024.250000] ath: phy0: Set HW Key
> Aug 31 16:21:37 192.168.10.200 kernel: [708036.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> Aug 31 16:21:42 192.168.10.200 kernel: [708036.110000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:21:47 192.168.10.200 kernel: [708036.110000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> Aug 31 16:21:52 192.168.10.200 kernel: [708036.110000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:22:17 192.168.10.200 kernel: [708066.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> Aug 31 16:22:22 192.168.10.200 kernel: [708066.110000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:22:27 192.168.10.200 kernel: [708066.110000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> Aug 31 16:22:33 192.168.10.200 kernel: [708066.110000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:22:58 192.168.10.200 kernel: [708096.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> Aug 31 16:23:03 192.168.10.200 kernel: [708096.110000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:23:08 192.168.10.200 kernel: [708096.110000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> Aug 31 16:23:13 192.168.10.200 kernel: [708096.110000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:23:28 192.168.10.200 kernel: [708126.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> Aug 31 16:23:33 192.168.10.200 kernel: [708126.110000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:23:38 192.168.10.200 kernel: [708126.110000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> Aug 31 16:23:43 192.168.10.200 kernel: [708126.110000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:23:59 192.168.10.200 kernel: [708156.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> Aug 31 16:24:04 192.168.10.200 kernel: [708156.110000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:24:09 192.168.10.200 kernel: [708156.110000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> Aug 31 16:24:14 192.168.10.200 kernel: [708156.110000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:24:29 192.168.10.200 kernel: [708186.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> Aug 31 16:24:34 192.168.10.200 kernel: [708186.110000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:24:39 192.168.10.200 kernel: [708186.110000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> Aug 31 16:24:44 192.168.10.200 kernel: [708186.110000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:24:59 192.168.10.200 kernel: [708216.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> Aug 31 16:25:05 192.168.10.200 kernel: [708216.110000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:25:10 192.168.10.200 kernel: [708216.110000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> Aug 31 16:25:15 192.168.10.200 kernel: [708216.110000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:25:30 192.168.10.200 kernel: [708246.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> Aug 31 16:25:35 192.168.10.200 kernel: [708246.110000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:25:40 192.168.10.200 kernel: [708246.110000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> Aug 31 16:25:45 192.168.10.200 kernel: [708246.110000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:26:00 192.168.10.200 kernel: [708276.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> Aug 31 16:26:05 192.168.10.200 kernel: [708276.110000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:26:10 192.168.10.200 kernel: [708276.110000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> Aug 31 16:26:16 192.168.10.200 kernel: [708276.110000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:26:31 192.168.10.200 kernel: [708306.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> Aug 31 16:26:36 192.168.10.200 kernel: [708306.110000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:26:41 192.168.10.200 kernel: [708306.110000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> Aug 31 16:26:46 192.168.10.200 kernel: [708306.110000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:27:01 192.168.10.200 kernel: [708336.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> Aug 31 16:27:06 192.168.10.200 kernel: [708336.110000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:27:11 192.168.10.200 kernel: [708336.110000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> Aug 31 16:27:16 192.168.10.200 kernel: [708336.110000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:27:31 192.168.10.200 kernel: [708366.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> Aug 31 16:27:37 192.168.10.200 kernel: [708366.110000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:27:42 192.168.10.200 kernel: [708366.110000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> Aug 31 16:27:47 192.168.10.200 kernel: [708366.110000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:28:02 192.168.10.200 kernel: [708396.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> Aug 31 16:28:07 192.168.10.200 kernel: [708396.110000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:28:12 192.168.10.200 kernel: [708396.110000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> Aug 31 16:28:17 192.168.10.200 kernel: [708396.110000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:28:32 192.168.10.200 kernel: [708426.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> Aug 31 16:28:37 192.168.10.200 kernel: [708426.110000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:28:42 192.168.10.200 kernel: [708426.110000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> Aug 31 16:28:47 192.168.10.200 kernel: [708426.110000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:29:03 192.168.10.200 kernel: [708456.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> Aug 31 16:29:08 192.168.10.200 kernel: [708456.110000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:29:13 192.168.10.200 kernel: [708456.110000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> Aug 31 16:29:18 192.168.10.200 kernel: [708456.110000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:29:33 192.168.10.200 kernel: [708486.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> Aug 31 16:29:38 192.168.10.200 kernel: [708486.110000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:29:43 192.168.10.200 kernel: [708486.110000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> Aug 31 16:29:48 192.168.10.200 kernel: [708486.110000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:30:03 192.168.10.200 kernel: [708516.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> Aug 31 16:30:09 192.168.10.200 kernel: [708516.110000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:30:14 192.168.10.200 kernel: [708516.110000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> Aug 31 16:30:19 192.168.10.200 kernel: [708516.110000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:30:44 192.168.10.200 kernel: [708546.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> Aug 31 16:30:49 192.168.10.200 kernel: [708546.110000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:30:54 192.168.10.200 kernel: [708546.110000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> Aug 31 16:30:59 192.168.10.200 kernel: [708546.110000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:31:14 192.168.10.200 kernel: [708576.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> Aug 31 16:31:19 192.168.10.200 kernel: [708576.110000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:31:25 192.168.10.200 kernel: [708576.110000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> Aug 31 16:31:30 192.168.10.200 kernel: [708576.110000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:31:45 192.168.10.200 kernel: [708606.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> Aug 31 16:31:50 192.168.10.200 kernel: [708606.110000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:31:55 192.168.10.200 kernel: [708606.110000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> Aug 31 16:32:00 192.168.10.200 kernel: [708606.110000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:32:15 192.168.10.200 kernel: [708624.250000] ath: phy0: Set HW Key
> Aug 31 16:32:20 192.168.10.200 kernel: [708624.250000] ath: phy0: Set HW Key
> Aug 31 16:32:25 192.168.10.200 kernel: [708636.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> Aug 31 16:32:30 192.168.10.200 kernel: [708636.110000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:32:35 192.168.10.200 kernel: [708636.110000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> Aug 31 16:32:41 192.168.10.200 kernel: [708636.110000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:32:56 192.168.10.200 kernel: [708666.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> Aug 31 16:33:01 192.168.10.200 kernel: [708666.110000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:33:06 192.168.10.200 kernel: [708666.110000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> Aug 31 16:33:11 192.168.10.200 kernel: [708666.110000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:33:26 192.168.10.200 kernel: [708696.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> Aug 31 16:33:31 192.168.10.200 kernel: [708696.110000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:33:36 192.168.10.200 kernel: [708696.110000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> Aug 31 16:33:41 192.168.10.200 kernel: [708696.110000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:33:57 192.168.10.200 kernel: [708726.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> Aug 31 16:34:02 192.168.10.200 kernel: [708726.110000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:34:07 192.168.10.200 kernel: [708726.110000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> Aug 31 16:34:12 192.168.10.200 kernel: [708726.110000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> Aug 31 16:34:17 192.168.10.200 kernel: [708728.010000] ath: phy0: Resetting Cal 1 state for channel 2462
> Aug 31 16:34:22 192.168.10.200 kernel: [708728.110000] ath: phy0: starting IQ Mismatch Calibration
> Aug 31 16:34:27 192.168.10.200 kernel: [708728.210000] ath: phy0: 0: Chn 0 pmi=0x00000000;pmq=0x00000000;iqcm=0x00000000;
> Aug 31 16:34:32 192.168.10.200 kernel: [708728.210000] ath: phy0: Starting IQ Cal and Correction for Chain 0
> Aug 31 16:34:37 192.168.10.200 kernel: [708728.210000] ath: phy0: Original: Chn 0 iq_corr_meas = 0x00000000
> Aug 31 16:34:42 192.168.10.200 kernel: [708728.210000] ath: phy0: Chn 0 pwr_meas_i = 0x00000000
> Aug 31 16:34:47 192.168.10.200 kernel: [708728.210000] ath: phy0: Chn 0 pwr_meas_q = 0x00000000
> Aug 31 16:34:52 192.168.10.200 kernel: [708728.210000] ath: phy0: iqCorrNeg is 0x00000000
> Aug 31 16:34:57 192.168.10.200 kernel: [708728.210000] ath: phy0: IQ Cal and Correction (offset 0x98dc) enabled (bit position 0x00004000). New Value 0x20007d00
> [...]
> Sep  2 21:52:46 192.168.10.200 kernel: [899346.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> Sep  2 21:52:51 192.168.10.200 kernel: [899346.110000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> Sep  2 21:53:06 192.168.10.200 kernel: [899376.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> Sep  2 21:53:11 192.168.10.200 kernel: [899376.110000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> Sep  2 21:53:16 192.168.10.200 kernel: [899376.110000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> Sep  2 21:53:21 192.168.10.200 kernel: [899376.110000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> Sep  2 21:53:37 192.168.10.200 kernel: [899406.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> Sep  2 21:53:42 192.168.10.200 kernel: [899406.110000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> Sep  2 21:53:47 192.168.10.200 kernel: [899406.110000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> Sep  2 21:53:52 192.168.10.200 kernel: [899406.110000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> Sep  2 21:53:57 192.168.10.200 kernel: [899426.250000] ath: phy0: Set HW Key
> Sep  2 21:54:02 192.168.10.200 kernel: [899426.260000] ath: phy0: Set HW Key
> Sep  2 21:54:17 192.168.10.200 kernel: [899436.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> Sep  2 21:54:22 192.168.10.200 kernel: [899436.110000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> Sep  2 21:54:37 192.168.10.200 kernel: [899466.110000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> Sep  2 21:54:43 192.168.10.200 kernel: [899466.110000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> Sep  2 21:54:48 192.168.10.200 kernel: [899466.110000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> Sep  2 21:54:53 192.168.10.200 kernel: [899466.110000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
>
>
> === router 201 ===
> root@OpenWrt:/sys/kernel/debug/ieee80211/phy0/ath9k# head regdump
> 0x000000 0xdeadbeef
> 0x000004 0xdeadbeef
> 0x000008 0xdeadbeef
> 0x00000c 0xdeadbeef
> 0x000010 0xdeadbeef
> 0x000014 0xdeadbeef
> 0x000018 0xdeadbeef
> 0x00001c 0xdeadbeef
> 0x000020 0xdeadbeef
> 0x000024 0xdeadbeef
>
> root@OpenWrt:/sys/kernel/debug/ieee80211/phy0/ath9k# uptime
>  10:20:54 up 10 days, 10:20,  load average: 0.18, 0.19, 0.21
>
> # dmesg
> [...]
> [900132.160000] ath: phy0: NF calibrated [ext] [chain 0] is -104
> [900162.160000] ath: phy0: NF calibrated [ctl] [chain 0] is -104
> [900162.160000] ath: phy0: NF calibrated [ext] [chain 0] is -104
> [900192.160000] ath: phy0: NF calibrated [ctl] [chain 0] is -104
> [900192.160000] ath: phy0: NF calibrated [ext] [chain 0] is -104
> [900197.470000] ath: phy0: missed 1 consecutive beacons
> [900197.560000] ath: phy0: resume beacon xmit after 1 misses
> [900222.160000] ath: phy0: NF calibrated [ctl] [chain 0] is -104
> [900222.160000] ath: phy0: NF calibrated [ext] [chain 0] is -104
> [900252.160000] ath: phy0: NF calibrated [ctl] [chain 0] is -104
> [900252.160000] ath: phy0: NF calibrated [ext] [chain 0] is -104
> [900275.910000] ath: phy0: missed 1 consecutive beacons

seems we are getting beacon stuck, though its not sufficient for triggering
chip reset (or) atleast start noise floor calibration. Is this is in a congested
environment ? we can dump cycle counters . I think we need to have a
WAR of chip reset if the cycle counters (busy is too high) inspite the MAC hang
signature . let me try too to figure out that WAR is already available (or)
we got to enable it.

> [900276.000000] ath: phy0: resume beacon xmit after 1 misses
> [900282.160000] ath: phy0: NF calibrated [ctl] [chain 0] is -104
> [900282.160000] ath: phy0: NF calibrated [ext] [chain 0] is -104
> [900303.560000] ath: phy0: missed 1 consecutive beacons
> [900303.650000] ath: phy0: resume beacon xmit after 1 misses
> [900312.160000] ath: phy0: NF calibrated [ctl] [chain 0] is -104
> [900312.160000] ath: phy0: NF calibrated [ext] [chain 0] is -104
> [900342.160000] ath: phy0: NF calibrated [ctl] [chain 0] is -104
> [900342.160000] ath: phy0: NF calibrated [ext] [chain 0] is -104
> [900372.160000] ath: phy0: NF calibrated [ctl] [chain 0] is -104
> [900372.160000] ath: phy0: NF calibrated [ext] [chain 0] is -104
> [900402.160000] ath: phy0: NF calibrated [ctl] [chain 0] is -104
> [900402.160000] ath: phy0: NF calibrated [ext] [chain 0] is -104
> [900432.160000] ath: phy0: NF calibrated [ctl] [chain 0] is -104
> [900432.160000] ath: phy0: NF calibrated [ext] [chain 0] is -104
> [900462.160000] ath: phy0: NF calibrated [ctl] [chain 0] is -104
> [900462.160000] ath: phy0: NF calibrated [ext] [chain 0] is -104
> [900492.160000] ath: phy0: NF calibrated [ctl] [chain 0] is -104
> [900492.160000] ath: phy0: NF calibrated [ext] [chain 0] is -104
> [900522.160000] ath: phy0: NF calibrated [ctl] [chain 0] is -104
> [900522.160000] ath: phy0: NF calibrated [ext] [chain 0] is -104
> [900552.160000] ath: phy0: NF calibrated [ctl] [chain 0] is -103
> [900552.160000] ath: phy0: NF calibrated [ext] [chain 0] is -104
> [900582.160000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> [900582.160000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> [900582.160000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> [900582.160000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> [900612.160000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> [900612.160000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> [900612.160000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> [900612.160000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> [900625.220000] ath: phy0: Set HW Key
> [900625.220000] ath: phy0: Set HW Key
> [900642.160000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> [900642.160000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> [900642.160000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> [900642.160000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> [900672.160000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> [900672.160000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> [900672.160000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> [900672.160000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> [900702.160000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> [900702.160000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> [900702.160000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> [900702.160000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> [900732.160000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> [900732.160000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> [900732.160000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> [900732.160000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> [900762.160000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> [900762.160000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> [900762.160000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> [900762.160000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> [900792.160000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> [900792.160000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> [900792.160000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> [900792.160000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> [900822.160000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> [900822.160000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> [900822.160000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> [900822.160000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> [900852.160000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> [900852.160000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> [900852.160000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> [900852.160000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> [900882.160000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> [900882.160000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> [900882.160000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> [900882.160000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> [900912.160000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> [900912.160000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> [900912.160000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> [900912.160000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> [900942.160000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> [900942.160000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> [900942.160000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> [900942.160000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> [900969.460000] ath: phy0: Resetting Cal 1 state for channel 2462
> [900969.560000] ath: phy0: starting IQ Mismatch Calibration
> [900969.660000] ath: phy0: 0: Chn 0 pmi=0x00000000;pmq=0x00000000;iqcm=0x00000000;
> [900969.660000] ath: phy0: Starting IQ Cal and Correction for Chain 0
> [900969.660000] ath: phy0: Original: Chn 0 iq_corr_meas = 0x00000000
> [900969.660000] ath: phy0: Chn 0 pwr_meas_i = 0x00000000
> [900969.660000] ath: phy0: Chn 0 pwr_meas_q = 0x00000000
> [900969.660000] ath: phy0: iqCorrNeg is 0x00000000
> [900969.660000] ath: phy0: IQ Cal and Correction (offset 0x98dc) enabled (bit position 0x00004000). New Value 0x20007f7b
> [900972.160000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> [900972.160000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> [900972.160000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> [900972.160000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> [901002.160000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> [901002.160000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> [901002.160000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> [901002.160000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> [901032.160000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> [901032.160000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> [901032.160000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> [901032.160000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> [901062.160000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> [901062.160000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> [901062.160000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> [901062.160000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> [901092.160000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> [901092.160000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> [901092.160000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> [901092.160000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> [901122.160000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> [901122.160000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> [901122.160000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> [901122.160000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
> [901152.160000] ath: phy0: NF calibrated [ctl] [chain 0] is -45
> [901152.160000] ath: phy0: NF[0] (-45) > MAX (-95), correcting to MAX
> [901152.160000] ath: phy0: NF calibrated [ext] [chain 0] is -45
> [901152.160000] ath: phy0: NF[3] (-45) > MAX (-95), correcting to MAX
>
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.10 (GNU/Linux)
>
> iEYEARECAAYFAlBDuv4ACgkQrzg/fFk7axZH5wCcCPfepF11qXP0ELPLnf+R1L57
> v0AAoJ2xlpt6vKhbWO7hbHWzkMiJR8W6
> =DRhA
> -----END PGP SIGNATURE-----
>



-- 
thanks,
shafi
