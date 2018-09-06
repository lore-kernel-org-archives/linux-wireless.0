Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:52651 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbeIFVuW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 17:50:22 -0400
Received: by mail-it0-f45.google.com with SMTP id h3-v6so16182239ita.2
        for <linux-wireless@vger.kernel.org>; Thu, 06 Sep 2018 10:13:55 -0700 (PDT)
MIME-Version: 1.0
References: <CAM0KTbBJuhuEyuZB_z_BcDSeXa-CJ+NwupssS2jLx0pJ0KXQGQ@mail.gmail.com>
 <CAJ0CqmWAqdB8Og7fabLDeZnzFO5Aw5Qd0cYGaLrs7Ls-zM_yQw@mail.gmail.com>
 <CAM0KTbAbjDYNOzivxMdLmYrV9QHgwkLp7zXpdCvn1Kf1uEcQTQ@mail.gmail.com>
 <20180906093213.GB16539@redhat.com> <CAM0KTbAPh5J+cguhE0Qh9c8n_UVK9UyqsHtWUydrXzLTz9sXgQ@mail.gmail.com>
In-Reply-To: <CAM0KTbAPh5J+cguhE0Qh9c8n_UVK9UyqsHtWUydrXzLTz9sXgQ@mail.gmail.com>
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date: Thu, 6 Sep 2018 19:13:44 +0200
Message-ID: <CAJ0CqmU0TBc42k=RX3T1DJd2dfGFHu4WuhbATYoe-7poUk3Ekw@mail.gmail.com> (sfid-20180906_191358_831562_D6E47588)
Subject: Re: mt76x0 bug report
To: Zero Chaos <sidhayn@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Thu, Sep 6, 2018 at 5:32 AM Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> >
> > On Wed, Sep 05, 2018 at 08:52:18PM +0000, Sid Hayn wrote:
> > > On Tue, Sep 4, 2018 at 5:11 PM Lorenzo Bianconi
> > > <lorenzo.bianconi@redhat.com> wrote:
> > > >
> > > > >
> > > > > I have one mt76x2u (Alfa AWUS036ACM) and a few mt76x0.
> > > > >
> > > > > I've noticed two additional issues in my testing.
> > > > >
> > > > > First issue, is that it appears the mt76x0 devices don't work properly
> > > > > in monitor mode.  Sometimes they seem to monitor one channel properly,
> > > > > but nothing else.  The mt76x2u works great, channel control, lots of
> > > > > packets, etc.
> > > >
> > > > Could you elaborate a little bit please? how can you reproduce the issue?
> > > > just add an interface in monitor mode and run a scan?
> > >
> > > Correct, standard stuff, use iw to create a monitor mode interface,
> > > use iw to remove managed mode interface, run some tool such as kismet
> > > or airodump-ng or even wireshark.
> >
> > But what exactly are the syptomps, I don't understand what you mean by
> > "mt76x0 devices don't work properly in monitor mode" ?
> >
> > > > I guess it depends on eeprom values. Could you please enable debug
> > > > messages a paste
> > > > syslog output?
> > >
> > > I don't see a mediatek specific debug near the driver selection in
> > > menuconfig, what debug messages do you want me to enable and how?
> >
> > You need to uncomment this line:
> >
> > # ccflags-y := -DDEBUG
> >
> > in drivers/net/wireless/mediatek/mt76/mt76x0/Makefile
>
> I have done this change, rebooted, and plugged in the TP-Link t1u
> dongle which is 5GHz only.  This is dmesg:
> [   30.058587] usb 2-2: new high-speed USB device number 3 using xhci_hcd
> [   30.200008] usb 2-2: New USB device found, idVendor=2357,
> idProduct=0105, bcdDevice= 1.00
> [   30.200010] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [   30.200012] usb 2-2: Product: WiFi
> [   30.200013] usb 2-2: Manufacturer: MediaTek
> [   30.200015] usb 2-2: SerialNumber: 1.0
> [   30.332895] usb 2-2: reset high-speed USB device number 3 using xhci_hcd
> [   30.466124] mt76x0 2-2:1.0: ASIC revision: 76100002 MAC revision: 76502000
> [   30.467534] mt76x0 2-2:1.0: Firmware Version: 0.1.00 Build: 7640
> Build time: 201308221655____
> [   30.789455] mt76x0 2-2:1.0: loading FW - ILM 68716 + IVB 64
> [   30.844588] mt76x0 2-2:1.0: loading FW - DLM 11476
> [   31.172677] mt76x0 2-2:1.0: Firmware running!
> [   31.378879] mt76x0 2-2:1.0: MCU not ready
> [   31.393770] BBP version f000f200
> [   31.410935] mt76x0 2-2:1.0: EEPROM ver:02 fae:01
> [   31.411086] mt76x0 2-2:1.0: NIC_CONF0: fd11 NIC_CONF1: 3084
> [   31.411088] mt76x0 2-2:1.0: Has 2GHZ 1 5GHZ 1

as you can see the eeprom reports both bands. I will review mt76x0
eeprom layout later today

Regards,
Lorenzo

> [   31.411089] mt76x0 2-2:1.0: PA Type 1
> [   31.411090] mt76x0 2-2:1.0: REG 2GHZ 0 REG 5GHZ 9
> [   31.411092] mt76x0 2-2:1.0: EEPROM country region 00 (channels 1-11)
> [   31.416308] ieee80211 phy1: Selected rate control algorithm 'minstrel_ht'
> [   31.417285] usbcore: registered new interface driver mt76x0
>
> What would you like next?
>
> -Zero
> >
> > Thanks
> > Stanislaw
> >
