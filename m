Return-Path: <SRS0=ogP8=PS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3B7FC43387
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 01:29:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F15C214DA
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 01:29:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B8sDaeKK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbfAJB3s (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 9 Jan 2019 20:29:48 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:44116 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726590AbfAJB3s (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Jan 2019 20:29:48 -0500
Received: by mail-oi1-f194.google.com with SMTP id m6so7972863oig.11;
        Wed, 09 Jan 2019 17:29:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XwHAkJ9fISo/ig1npHSkgm+SYvr8cIIkKan1oY0IZZk=;
        b=B8sDaeKKSJHzmLwzyl2Cc6//+Vwfw0Kf8yjszSuzeM96L/Al7o7VJFAZBQkghIX1jP
         gZQrP2/i/ORcXWV3Op1LS9sEejxroVqc6IcxrQa7OdOfwQ8UiQF973xsMru2SuccNdOQ
         HhJm3e/O1FDbGQdPRju58/gps2b+0CpasuQoDvuYBVHQhmBDFLPx7LmLE4Yu6emv8v+A
         IhuhnIfVHCwo7/wQ4MA6iJItoxd85iYHPhqVhgZZjIkgPDHHRNExLVV04PPfsVg28BZw
         ffnFT20KE8K9SMeeKAPTTxu24xcPOOgobPdIRGeRH6oabXzLHCMNBBgUhinBQORBGml4
         vrpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XwHAkJ9fISo/ig1npHSkgm+SYvr8cIIkKan1oY0IZZk=;
        b=iz9rmVKNoaGGTNWabYHr0FPocjSSVwp2Yi74hYu1kzgRTh27PsNI9Yzb74usrb+ZM0
         mjbb8n9ITbVuEdOUK+Yj4AyhQRz2yHkB2KkdnBH+hc+fyBkIuAiryd+Q9xDyf6tH0WdJ
         Qt50FLhUZ/pRqnI07iROl9/AyjOq2/LnA/YTMYRIE9+2ykSEzbh7KqmAWRD3ZQZ679va
         w4Lch8EJ+do4lFvntcPkkae51juNxQhrZ3MUcBOyk0gQDJStjQm/w9DpY1+vBRRUS9oK
         vRm1Xh5UZ8TieAcqVCCKsYTbCzl2WsQyPdQOEFFz/sFAxQeDHYcJi1yyOjeSXL1rCNgz
         ioaQ==
X-Gm-Message-State: AJcUukeM9e0XjsVXOpewI5a/gpPdrC7ueUoLMl58gj9aG5ESjG+5q8kO
        2q7MEjl7yYKe8kWcCi7Dya439/TvJdJFEu7cezg=
X-Google-Smtp-Source: ALg8bN4XTyYbBWXJjy1g+hE59QJ78sNMG3Qlkrht3KS42cgdCuiHnO3xkp6vWn65bHTSjbgVkDGT8+tYdf6JsQwGUUo=
X-Received: by 2002:aca:38c2:: with SMTP id f185mr5598507oia.26.1547083786537;
 Wed, 09 Jan 2019 17:29:46 -0800 (PST)
MIME-Version: 1.0
References: <20181109000800.15431-1-jprvita@gmail.com> <83CA40B2-1AF3-49FA-9F94-C84A3C916583@holtmann.org>
 <CA+A7VXXfdyLWMpNaEzUzDe6PiktOKb5oJrufYrGeTyXyXChQfw@mail.gmail.com>
 <CA+A7VXX2fA5gC1_-nwFDswvB+we3R69ZTNiGDmrO+sftRdxxpg@mail.gmail.com>
 <CA+A7VXXarPAb+vFNTqZDhpng_niLjSCxqEQdLLV9eGAn+PPUXQ@mail.gmail.com> <CANUX_P27VP_Vy+omnO2CAGvntZNF6vowrFEHrAfeSgPrFJFdsg@mail.gmail.com>
In-Reply-To: <CANUX_P27VP_Vy+omnO2CAGvntZNF6vowrFEHrAfeSgPrFJFdsg@mail.gmail.com>
From:   =?UTF-8?Q?Jo=C3=A3o_Paulo_Rechi_Vita?= <jprvita@gmail.com>
Date:   Wed, 9 Jan 2019 17:29:10 -0800
Message-ID: <CA+A7VXU6kwrjezwdgZnOMZi58i80nja553ZZ3VL5n_hqSeSwKA@mail.gmail.com>
Subject: Re: [PATCH 3/3] iwlwifi: Load firmware exclusively for Intel WiFi
To:     Emmanuel Grumbach <egrumbach@gmail.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Upstreaming Team <linux@endlessm.com>,
        =?UTF-8?Q?Jo=C3=A3o_Paulo_Rechi_Vita?= <jprvita@endlessm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Jan 9, 2019 at 10:39 AM Emmanuel Grumbach <egrumbach@gmail.com> wro=
te:
>
> Hello,
>
> > > > >
> > > > > our hardware teams from the Bluetooth and WiFi side really need t=
o look at this.
> > >
> > > Were you able to get attention from the hardware teams with the logs
> > > I've provided? Are there any news or an idea of when / if we can
> > > expect this to be fixed in firmware? If not, do you have suggestions
> > > for an alternative solution?
> > >
> >
> > Sorry to bother you again with this, but I'd really like to figure out
> > some way forward here. Did you get any feedback from the hardware
> > teams? Otherwise, I understand having an inter-dependency between the
> > wifi and bt kernel modules is not desirable, so do you have any
> > suggestion on how to solve this without adding this dependency?
> >
>
> Have you tried the update the BT firmware with what is now available in
> mainline linux-firmware.git?
> I heard that this problem has now been resolved. After you update the
> BT firmware, you need a full power cycle.

Thanks for the reply. The latest firmware files I see upstream are
from commit c34a52ab7d, which are the same I had tested with
previously. I'm still able to hit the problem, but after the firmware
failed to load the Bluetooth adapter got disconnected from the USB bus
and then re-connected. Since the iwlwifi firmware loading routine had
already finished at this point, the Bluetooth firmware loaded
successfully. I had seen this behavior a few times in my previous
test, but not always (for example that behavior did not trigger on the
test I had previously shared logs for). So, maybe that is the fix that
has been implemented in the firmware? And perhaps some other changes
in the kernel where preventing that behavior from triggering all the
time? I'm pasting logs bellow where both modules where blacklisted and
manually loaded with "modprobe iwlwifi & modprobe btusb":

Jan 09 16:54:24 endless kernel: Bluetooth: Core ver 2.22
Jan 09 16:54:24 endless kernel: NET: Registered protocol family 31
Jan 09 16:54:24 endless kernel: Bluetooth: HCI device and connection
manager initialized
Jan 09 16:54:24 endless kernel: Bluetooth: HCI socket layer initialized
Jan 09 16:54:24 endless kernel: Bluetooth: L2CAP socket layer initialized
Jan 09 16:54:24 endless kernel: Bluetooth: SCO socket layer initialized
Jan 09 16:54:24 endless kernel: cfg80211: Loading compiled-in X.509
certificates for regulatory database
Jan 09 16:54:24 endless kernel: cfg80211: Loaded X.509 cert 'sforshee:
00b28ddf47aef9cea7'
Jan 09 16:54:24 endless kernel: platform regulatory.0: Direct firmware
load for regulatory.db failed with error -2
Jan 09 16:54:24 endless kernel: cfg80211: failed to load regulatory.db
Jan 09 16:54:24 endless kernel: usbcore: registered new interface driver bt=
usb
Jan 09 16:54:24 endless kernel: Bluetooth: hci0: Bootloader revision
0.0 build 2 week 52 2014
Jan 09 16:54:24 endless kernel: Bluetooth: hci0: Device revision is 5
Jan 09 16:54:24 endless kernel: Bluetooth: hci0: Secure boot is enabled
Jan 09 16:54:24 endless kernel: Bluetooth: hci0: OTP lock is enabled
Jan 09 16:54:24 endless kernel: Bluetooth: hci0: API lock is enabled
Jan 09 16:54:24 endless kernel: Bluetooth: hci0: Debug lock is disabled
Jan 09 16:54:24 endless kernel: Bluetooth: hci0: Minimum firmware
build 1 week 10 2014
Jan 09 16:54:24 endless kernel: Intel(R) Wireless WiFi driver for Linux
Jan 09 16:54:24 endless kernel: Copyright(c) 2003- 2015 Intel Corporation
Jan 09 16:54:24 endless kernel: Bluetooth: hci0: Found device
firmware: intel/ibt-11-5.sfi
Jan 09 16:54:25 endless kernel: iwlwifi 0000:01:00.0: loaded firmware
version 36.7596afd4.0 op_mode iwlmvm
Jan 09 16:54:25 endless kernel: iwlwifi 0000:01:00.0: Detected
Intel(R) Dual Band Wireless AC 8260, REV=3D0x208
Jan 09 16:54:25 endless kernel: Bluetooth: BNEP (Ethernet Emulation) ver 1.=
3
Jan 09 16:54:25 endless kernel: Bluetooth: BNEP filters: protocol multicast
Jan 09 16:54:25 endless kernel: Bluetooth: BNEP socket layer initialized
Jan 09 16:54:25 endless kernel: Bluetooth: hci0: Failed to send
firmware data (-38)
Jan 09 16:54:25 endless kernel: iwlwifi 0000:01:00.0: base HW address:
a4:34:d9:81:bf:a5
Jan 09 16:54:25 endless kernel: ieee80211 phy0: Selected rate control
algorithm 'iwl-mvm-rs'
Jan 09 16:54:25 endless kernel: thermal thermal_zone6: failed to read
out thermal zone (-61)
Jan 09 16:54:25 endless kernel: iwlwifi 0000:01:00.0 wlp1s0: renamed from w=
lan0
Jan 09 16:54:25 endless kernel: IPv6: ADDRCONF(NETDEV_UP): wlp1s0:
link is not ready
Jan 09 16:54:25 endless kernel: IPv6: ADDRCONF(NETDEV_UP): wlp1s0:
link is not ready
Jan 09 16:54:25 endless kernel: IPv6: ADDRCONF(NETDEV_UP): wlp1s0:
link is not ready
Jan 09 16:54:31 endless kernel: usb 1-7: USB disconnect, device number 3
Jan 09 16:54:32 endless kernel: usb 1-7: new full-speed USB device
number 7 using xhci_hcd
Jan 09 16:54:32 endless kernel: usb 1-7: New USB device found,
idVendor=3D8087, idProduct=3D0a2b, bcdDevice=3D 0.01
Jan 09 16:54:32 endless kernel: usb 1-7: New USB device strings:
Mfr=3D0, Product=3D0, SerialNumber=3D0
Jan 09 16:54:32 endless kernel: Bluetooth: hci0: Bootloader revision
0.0 build 2 week 52 2014
Jan 09 16:54:32 endless kernel: Bluetooth: hci0: Device revision is 5
Jan 09 16:54:32 endless kernel: Bluetooth: hci0: Secure boot is enabled
Jan 09 16:54:32 endless kernel: Bluetooth: hci0: OTP lock is enabled
Jan 09 16:54:32 endless kernel: Bluetooth: hci0: API lock is enabled
Jan 09 16:54:32 endless kernel: Bluetooth: hci0: Debug lock is disabled
Jan 09 16:54:32 endless kernel: Bluetooth: hci0: Minimum firmware
build 1 week 10 2014
Jan 09 16:54:32 endless kernel: Bluetooth: hci0: Found device
firmware: intel/ibt-11-5.sfi
Jan 09 16:54:34 endless kernel: Bluetooth: hci0: Waiting for firmware
download to complete
Jan 09 16:54:34 endless kernel: Bluetooth: hci0: Firmware loaded in
1820173 usecs
Jan 09 16:54:34 endless kernel: Bluetooth: hci0: Waiting for device to boot
Jan 09 16:54:34 endless kernel: Bluetooth: hci0: Device booted in 11761 use=
cs
Jan 09 16:54:34 endless kernel: Bluetooth: hci0: Found Intel DDC
parameters: intel/ibt-11-5.ddc
Jan 09 16:54:34 endless kernel: Bluetooth: hci0: Applying Intel DDC
parameters completed
Jan 09 16:54:34 endless kernel: Bluetooth: RFCOMM TTY layer initialized
Jan 09 16:54:34 endless kernel: Bluetooth: RFCOMM socket layer initialized
Jan 09 16:54:34 endless kernel: Bluetooth: RFCOMM ver 1.11

--
Jo=C3=A3o Paulo Rechi Vita
http://about.me/jprvita
