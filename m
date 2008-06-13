Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:23963 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbYFMRhW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2008 13:37:22 -0400
Received: by fg-out-1718.google.com with SMTP id 19so2826230fgg.17
        for <linux-wireless@vger.kernel.org>; Fri, 13 Jun 2008 10:37:20 -0700 (PDT)
To: Zhu Yi <yi.zhu@intel.com>
Subject: Re: [2.6.26-rc5] iwlwifi 4965 not working - last on 2.6.23
Date: Fri, 13 Jun 2008 19:37:03 +0200
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
References: <200806060039.48488.m1k0@wp.pl> <20080606034738.9835782d.akpm@linux-foundation.org> <1213151464.7814.630.camel@debian.sh.intel.com>
In-Reply-To: <1213151464.7814.630.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200806131937.03680.Michal.Kudla@gmail.com> (sfid-20080613_193727_640255_4CD2F243)
From: =?utf-8?q?Micha=C5=82_Kud=C5=82a?= <michal.kudla@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

laptok ~ # modprobe -rv iwl4965
laptok ~ # modprobe -v iwl4965 debug=3D0x20002
laptok ~ # dmesg >dmesg-`uname -r`_`date +%F`.txt
laptok iwlwifi # ls -1
dmesg-2.6.23-gentoo-r2_2008-06-13.txt
dmesg-2.6.24.7_2008-06-13.txt
dmesg-2.6.25-gentoo-r4_2008-06-13.txt
dmesg-2.6.26-rc5_2008-06-13.txt

results:
http://michal.kudla.googlepages.com/dmesg-debug0x20002.tar.gz

W li=C5=9Bcie datowanym na =C5=9Broda, 11 czerwca 2008, Zhu Yi pisze:
>ZY On Fri, 2008-06-06 at 03:47 -0700, Andrew Morton wrote:
>ZY > > ADDRCONF(NETDEV_UP): wlan0: link is not ready
>ZY > > iwl4965: Error sending REPLY_WEPKEY: enqueue_hcmd failed: -5
>ZY > > mac80211-phy0: failed to remove key (0, ff:ff:ff:ff:ff:ff) from
>ZY > hardware (-5)
>ZY > > iwl4965: Error sending REPLY_TX_PWR_TABLE_CMD: enqueue_hcmd fai=
led:
>ZY > -5
>ZY > > iwl4965: WARNING: Requesting MAC access during RFKILL wakes up =
NIC
>ZY > > iwl4965: WARNING: Requesting MAC access during RFKILL wakes up =
NIC
>ZY
>ZY Looks like a rfkill related problem. Can you please try this patch?
>ZY http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=3D1673
>ZY
>ZY Thanks,
>ZY -yi
>ZY
>ZY


--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
