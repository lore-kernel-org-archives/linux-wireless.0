Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53142 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761286Ab2BNWEe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Feb 2012 17:04:34 -0500
Received: by iacb35 with SMTP id b35so478717iac.19
        for <linux-wireless@vger.kernel.org>; Tue, 14 Feb 2012 14:04:33 -0800 (PST)
Message-ID: <4F3ADA6E.4050301@lwfinger.net> (sfid-20120214_230447_465417_2482A8D5)
Date: Tue, 14 Feb 2012 16:04:30 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Hauke Mehrtens <hauke@hauke-m.de>
CC: "Saul St. John" <saul.stjohn@gmail.com>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2s=?= =?UTF-8?B?aQ==?=
	<zajec5@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: [RFC] use alternate SPROM offset for 43224
References: <20120214040120.GA2077@eris.garyseven.net> <CACna6rwXEjsJEPK4EZ9pbh2sGJgvt05JRfo2HkeDKpT26YORwg@mail.gmail.com> <CAG=dh1pTDSkkhgXGOv=n8uferq61-Db0EFGexO=ZZ+oN6w8_hQ@mail.gmail.com> <CACna6rw=ZJe28ahRQFU-_9+BD8+L5SNV_xdwxLxUdNk-b3HHxg@mail.gmail.com> <20120214185202.GA5339@eris.garyseven.net> <4F3ABFB0.3020502@lwfinger.net> <4F3AC20E.8080502@hauke-m.de>
In-Reply-To: <4F3AC20E.8080502@hauke-m.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/14/2012 02:20 PM, Hauke Mehrtens wrote:
>> >  I think it is more complicated than the above. On my 43224, I get the
>> >  message "No SPROM available", which arises because bcma_sprom_get() is
>> >  returning -ENOENT. The reason is that the value tested in "if
>> >  (!(sromctrl&  BCMA_CC_SROM_CONTROL_PRESENT))" is zero. The contents of
>> >  sromctl are 0x12, and the mask is 1.
> This check is the main part of ai_is_sprom_available() in brcmsmac. If
> this check fails, like in your case, brcmsmac tries otp_read_pci() to
> read out the sprom, which is not implemented in bcma.

I will try implementing a similar routine in bcma.

>> >  I am still investigating. When I comment out the test of sromctl, then
>> >  the driver seems to find the SPROM at offset 0x830, but neither b43 nor
>> >  brcmsmac works.
> Where did you get the 0x830 from and for which devices do you get a
> correct sprom at that position?

I don't know that I found a correct SPROM at that location. As I said, the 
device does not work. All I know is that the following fragment did not report 
an error. When the offset is 0x800, err is -71.

         /* Try to get SPROM */
         err = bcma_sprom_get(bus);
         if (err == -ENOENT) {
                 pr_err("No SPROM available\n");
         } else if (err)
                 pr_err("Failed to get SPROM: %d\n", err);

The chip is reported by lspci as "Network controller [0280]: Broadcom 
Corporation BCM43224 802.11a/b/g/n [14e4:4353] (rev 01)"

>From bcma, the core info is

bcma: Found chip with id 0xA8D8, rev 0x01 and package 0x08
bcma: Core 0 found: ChipCommon (manuf 0x4BF, id 0x800, rev 0x22, class 0x0)
bcma: Core 1 found: IEEE 802.11 (manuf 0x4BF, id 0x812, rev 0x17, class 0x0)
bcma: Core 2 found: PCIe (manuf 0x4BF, id 0x820, rev 0x0F, class 0x0)
bcma: Found rev 6 PMU (capabilities 0x108C2606)
bcma: bus->drv_cc.capabilities 0x58500000
bcma: sromctrl 0x12
bcma: SPROM offset 0x830

That offset comes from

         offset = bus->chipinfo.id == (0x4331 || bus->chipinfo.id == 43224) ?
                         BCMA_CC_SPROM : BCMA_CC_SPROM_PCIE6;

which includes the trial patch from the initial posting in this thread.


