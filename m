Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:52867 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750812AbdJUEmv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 21 Oct 2017 00:42:51 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Jasmine Strong <jas@eero.com>
CC: Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        ath10k <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: rebuild crypto header in RX data frames
Date: Sat, 21 Oct 2017 04:42:44 +0000
Message-ID: <877evpdscc.fsf@kamboji.qca.qualcomm.com> (sfid-20171021_064305_072339_E3BCF979)
References: <150851690590.5158.11970481736247725763.stgit@potku.adurom.net>
        <c9bdd915-0667-eee0-3b52-1fdf15abf249@dd-wrt.com>
        <CAGyitvP0wquoo_8_ma3rcj+riJ5Wgfo7+pmbUOx9pQRwFcQHYA@mail.gmail.com>
In-Reply-To: <CAGyitvP0wquoo_8_ma3rcj+riJ5Wgfo7+pmbUOx9pQRwFcQHYA@mail.gmail.com>       (Jasmine
 Strong's message of "Fri, 20 Oct 2017 17:34:09 -0700")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jasmine Strong <jas@eero.com> writes:

> When we tried this patch, it completely broke all wpa2-ccmp-aes
> traffic.

Which patch, Vasanth's or Sebastian's? I even tested myself, with both
CCMP and TKIP on both AP and client modes, and didn't see see any
problems. What kind of setup you have?

I tested on a x86 laptop and current ath.git master branch:

ath10k_pci 0000:02:00.0: pci irq msi oper_irq_mode 2 irq_mode 0 reset_mode =
0
ath10k_pci 0000:02:00.0: qca988x hw2.0 target 0x4100016c chip_id 0x043202ff=
 sub 0000:0000
ath10k_pci 0000:02:00.0: kconfig debug 1 debugfs 1 tracing 1 dfs 1 testmode=
 1
ath10k_pci 0000:02:00.0: firmware ver 10.2.4.70.66 api 5 features no-p2p,ra=
w-mode,mfp,allows-mesh-bcast crc32 c2dd2ad5
ath10k_pci 0000:02:00.0: board_file api 1 bmi_id N/A crc32 bebc7c08

And my hostapd.conf:

driver=3Dnl80211
hw_mode=3Da
channel=3D36
ieee80211n=3D1
interface=3Dwlan0
ctrl_interface=3D/var/run/hostapd
ctrl_interface_group=3Dadm
ssid=3Dtest-psk
wpa=3D2
wpa_key_mgmt=3DWPA-PSK
wpa_pairwise=3DCCMP
wpa_passphrase=3D12345678


--=20
Kalle Valo=
