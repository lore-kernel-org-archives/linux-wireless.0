Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:39350 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751538AbdJUH6K (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 21 Oct 2017 03:58:10 -0400
Subject: Re: [PATCH] ath10k: rebuild crypto header in RX data frames
To: Kalle Valo <kvalo@qca.qualcomm.com>, Jasmine Strong <jas@eero.com>
Cc: ath10k <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <150851690590.5158.11970481736247725763.stgit@potku.adurom.net>
 <c9bdd915-0667-eee0-3b52-1fdf15abf249@dd-wrt.com>
 <CAGyitvP0wquoo_8_ma3rcj+riJ5Wgfo7+pmbUOx9pQRwFcQHYA@mail.gmail.com>
 <877evpdscc.fsf@kamboji.qca.qualcomm.com>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <1564413e-41d7-1ad9-261e-38515382b059@dd-wrt.com> (sfid-20171021_095840_143151_89C5AE40)
Date: Sat, 21 Oct 2017 09:58:04 +0200
MIME-Version: 1.0
In-Reply-To: <877evpdscc.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

even if he used my patch. my patch should have no influence to wpa2 
ccmp. it just adds the new ccmp 256 + gcmp modes

Am 21.10.2017 um 06:42 schrieb Kalle Valo:
> Jasmine Strong <jas@eero.com> writes:
>
>> When we tried this patch, it completely broke all wpa2-ccmp-aes
>> traffic.
> Which patch, Vasanth's or Sebastian's? I even tested myself, with both
> CCMP and TKIP on both AP and client modes, and didn't see see any
> problems. What kind of setup you have?
>
> I tested on a x86 laptop and current ath.git master branch:
>
> ath10k_pci 0000:02:00.0: pci irq msi oper_irq_mode 2 irq_mode 0 reset_mode 0
> ath10k_pci 0000:02:00.0: qca988x hw2.0 target 0x4100016c chip_id 0x043202ff sub 0000:0000
> ath10k_pci 0000:02:00.0: kconfig debug 1 debugfs 1 tracing 1 dfs 1 testmode 1
> ath10k_pci 0000:02:00.0: firmware ver 10.2.4.70.66 api 5 features no-p2p,raw-mode,mfp,allows-mesh-bcast crc32 c2dd2ad5
> ath10k_pci 0000:02:00.0: board_file api 1 bmi_id N/A crc32 bebc7c08
>
> And my hostapd.conf:
>
> driver=nl80211
> hw_mode=a
> channel=36
> ieee80211n=1
> interface=wlan0
> ctrl_interface=/var/run/hostapd
> ctrl_interface_group=adm
> ssid=test-psk
> wpa=2
> wpa_key_mgmt=WPA-PSK
> wpa_pairwise=CCMP
> wpa_passphrase=12345678
>
>

-- 
Mit freundlichen Grüssen / Regards

Sebastian Gottschall / CTO

NewMedia-NET GmbH - DD-WRT
Firmensitz:  Stubenwaldallee 21a, 64625 Bensheim
Registergericht: Amtsgericht Darmstadt, HRB 25473
Geschäftsführer: Peter Steinhäuser, Christian Scheele
http://www.dd-wrt.com
email: s.gottschall@dd-wrt.com
Tel.: +496251-582650 / Fax: +496251-5826565
