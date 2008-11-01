Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web28511.mail.ukl.yahoo.com ([87.248.110.190]:23182 "HELO
	web28511.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751101AbYKAWAn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Nov 2008 18:00:43 -0400
Date: Sat, 1 Nov 2008 22:00:41 +0000 (GMT)
From: Julien HENRY <henryju@yahoo.fr>
Subject: Re : Re : Not associated with Intel 4965
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-ID: <564175.76346.qm@web28511.mail.ukl.yahoo.com> (sfid-20081101_230053_844398_DF60368B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

OK, now I can load the module... but nothing better concerning associat=
ion.

Nov  1 22:39:24 Capgemini kernel: cfg80211: Using static regulatory dom=
ain info
Nov  1 22:39:24 Capgemini kernel: cfg80211: Regulatory domain: JP
Nov  1 22:39:24 Capgemini kernel:     (start_freq - end_freq @ bandwidt=
h), (max_antenna_gain, max_eirp)
Nov  1 22:39:24 Capgemini kernel:     (2402000 KHz - 2494000 KHz @ 4000=
0 KHz), (600 mBi, 2000 mBm)
Nov  1 22:39:24 Capgemini kernel:     (5160000 KHz - 5250000 KHz @ 4000=
0 KHz), (600 mBi, 2000 mBm)
Nov  1 22:39:24 Capgemini kernel:     (5250000 KHz - 5330000 KHz @ 4000=
0 KHz), (600 mBi, 2000 mBm)
Nov  1 22:39:24 Capgemini kernel: cfg80211: Calling CRDA for country: J=
P
Nov  1 22:39:24 Capgemini kernel: iwlagn: Intel(R) Wireless WiFi Link A=
GN driver for Linux, 1.3.27ks
Nov  1 22:39:24 Capgemini kernel: iwlagn: Copyright(c) 2003-2008 Intel =
Corporation
Nov  1 22:39:24 Capgemini kernel: iwlagn 0000:03:00.0: PCI INT A -> GSI=
 17 (level, low) -> IRQ 17
Nov  1 22:39:24 Capgemini kernel: iwlagn: Detected Intel Wireless WiFi =
Link 4965AGN REV=3D0x4
Nov  1 22:39:24 Capgemini kernel: iwlagn: Tunable channels: 13 802.11bg=
, 19 802.11a channels
=2E..
Nov  1 22:39:41 Capgemini kernel: iwlagn 0000:03:00.0: PCI INT A -> GSI=
 17 (level, low) -> IRQ 17
Nov  1 22:39:41 Capgemini kernel: firmware: requesting iwlwifi-4965-2.u=
code
Nov  1 22:39:41 Capgemini kernel: Registered led device: iwl-phy0:radio
Nov  1 22:39:41 Capgemini kernel: Registered led device: iwl-phy0:assoc
Nov  1 22:39:41 Capgemini kernel: Registered led device: iwl-phy0:RX
Nov  1 22:39:41 Capgemini kernel: Registered led device: iwl-phy0:TX
Nov  1 22:39:41 Capgemini kernel: ADDRCONF(NETDEV_UP): wlan0: link is n=
ot ready
Nov  1 22:39:41 Capgemini kernel: iwlagn: TX Power requested while scan=
ning!
Nov  1 22:39:41 Capgemini kernel: iwlagn: Error sending TX power (-11)

=2E..
Nov  1 22:39:47 Capgemini kernel: iwlagn 0000:03:00.0: PCI INT A -> GSI=
 17 (level, low) -> IRQ 17
Nov  1 22:39:47 Capgemini kernel: Registered led device: iwl-phy0:radio
Nov  1 22:39:47 Capgemini kernel: Registered led device: iwl-phy0:assoc
Nov  1 22:39:47 Capgemini kernel: Registered led device: iwl-phy0:RX
Nov  1 22:39:47 Capgemini kernel: Registered led device: iwl-phy0:TX
Nov  1 22:39:47 Capgemini kernel: ADDRCONF(NETDEV_UP): wlan0: link is n=
ot ready

Anything I can try?

Thanks,

Julien



----- Message d'origine ----
De : Luis R. Rodriguez <mcgrof@gmail.com>
=C0 : Julien HENRY <henryju@yahoo.fr>
Cc : linux-wireless@vger.kernel.org
Envoy=E9 le : Samedi, 1 Novembre 2008, 22h31mn 07s
Objet : Re: Re : Not associated with Intel 4965

On Sat, Nov 1, 2008 at 1:48 PM, Julien HENRY <henryju@yahoo.fr> wrote:
>> We no longer have iwl4965, the new name is iwlagn, try that.
>
> Not better (please note that I've upgraded to kernel 2.6.27.4-desktop=
-0.uc1mnb since my last post):
>
> # modprobe iwlagn
> WARNING: Error inserting iwlcore (/lib/modules/2.6.27.4-desktop-0.uc1=
mnb/updates/drivers/net/wireless/iwlwifi/iwlcore.ko): Unknown symbol in=
 module, or unknown parameter (see dmesg)
> FATAL: Error inserting iwlagn (/lib/modules/2.6.27.4-desktop-0.uc1mnb=
/kernel/drivers/net/wireless/iwlwifi/iwlagn.ko.gz): Unknown symbol in m=
odule, or unknown parameter (see dmesg)

I see a discrepancy on the directory where the modules are being
picked up on. The ones that should be used are the ones in updates for
compat-wireless, your kernel drivers are under kernel. Lets try this
to be sure:

cd /lib/modules/2.6.27.4-desktop-0.uc1mnb/kernel/drivers/net/wireless/i=
wlwifi

rename everything there from foo to foo.ignore, for example, then run

sudo depmod -ae

and finally then try unloading all the wireless modules and then try
loading iwlagn.



     =20
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
