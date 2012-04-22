Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47324 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab2DVNBA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Apr 2012 09:01:00 -0400
Received: by bkcik5 with SMTP id ik5so8005847bkc.19
        for <linux-wireless@vger.kernel.org>; Sun, 22 Apr 2012 06:00:59 -0700 (PDT)
Subject: Re: wlan0 not present
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=US-ASCII
From: Dominik Feser <dominik.feser@googlemail.com>
In-Reply-To: <CANUX_P2t86v0L=DDaaBdW-6Yb5ffSscv2aSy+jQ5dFc0TqWB_Q@mail.gmail.com>
Date: Sun, 22 Apr 2012 15:00:54 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Message-Id: <CBC6370A-C51D-4CF6-99CE-AE8C35C467FB@gmail.com> (sfid-20120422_150105_525756_388A622E)
References: <2F08FF0B-5C29-4827-AA5F-B0F3847D0B83@gmail.com> <FC927BD3-30FD-4DF2-A65C-5BE785FB72BC@gmail.com> <CANUX_P0dR93vJicsrnpxPmOZvaxBvaONHQiFXOTcaP1Ax0LAnQ@mail.gmail.com> <816C5F70-E340-46F9-8206-2B230A27F3AD@gmail.com> <CANUX_P3=ttVKdLYBfAdGRhmfDRbPruogw8Eo_d09on0ajdTqUw@mail.gmail.com> <5714877C-2465-4FD5-94A0-9D0806A803C4@gmail.com> <CANUX_P27GoLY2q9jmsWw9Rzn9posf3mCjDa98+q4JP=83wYthg@mail.gmail.com> <8FBCAE90-FAE9-430D-888E-F055091E6683@gmail.com> <CANUX_P1OxH7rmYWxizEaf2DnPSTK0npNtZ2Q9Rm5dksnmFKD8g@mail.gmail.com> <9D52D4AD-58DC-4896-97FC-7248E1FD2614@gmail.com> <CANUX_P1ZX_e+0qs4sa7vdAqHvOQjO6+9PiFhDbW8ybE4ax80gQ@mail.gmail.com> <8EE08C44-8618-45EC-B890-B5B12B661FB6@gmail.com> <CANUX_P0O0-6sOaN59V_RxLj_DbiTdNdwq0zze6B6vMe1hfQuqA@mail.gmail.com> <37926591-261D-4C3E-A1D9-4A8AB3364F5D@gmail.com> <4F901224.1040508@sipsolutions.net> <EA757D90-2CCE-48A1-AF35-7F65EB45F7EE@gmail.com> <4F901F16.6080007@sipsolutions.net> <CAC79F14-24F2-4F90-8A47-B9B2744F5AE3@gmail.com> <CANUX_P2t86v0L=DDaaBdW-6Yb5ffSscv2aSy+jQ5dFc0TqWB_Q@mail.gmail.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

THX a lot! Here is the dmesg output:

Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:d
Copyright(c) 2003-2012 Intel Corporation
iwlwifi 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
iwlwifi 0000:02:00.0: setting latency timer to 64
iwlwifi 0000:02:00.0: pci_resource_len = 0x00002000
iwlwifi 0000:02:00.0: pci_resource_base = f4498000
iwlwifi 0000:02:00.0: HW Revision ID = 0x34
iwlwifi 0000:02:00.0: irq 1277 (277) for MSI/MSI-X
iwlwifi 0000:02:00.0: U iwl_request_firmware eebd9d74
iwlwifi 0000:02:00.0: U iwl_request_firmware c8ee1dd8
iwlwifi 0000:02:00.0: U iwl_request_firmware ed655dd8
iwlwifi 0000:02:00.0: d21d7e18
iwlwifi 0000:02:00.0: U iwl_request_firmware d21d7dd8
iwlwifi 0000:02:00.0: eda37e18
iwlwifi 0000:02:00.0: eda37de0
iwlwifi 0000:02:00.0: U iwl_trans_pcie_rx_free eda37d80
iwlwifi 0000:02:00.0: PCI INT A disabled




Am 19.04.2012 um 18:19 schrieb Emmanuel Grumbach:

> On Thu, Apr 19, 2012 at 18:08, Dominik Feser
> <dominik.feser@googlemail.com> wrote:
>> May it be that the fact that Centos 5 doesnt have hotplug causes the issue?
>> 
> 
> Don't think so.
> Can it be a problem in the backport of request_firwamre_no_wait ?
> Did I see somewhere that you run 2.6.38 ?
> Can you check again after having applied the patch attached ?
> 
> from the main dir of compat:
> patch -p1 < print.patch
> 
> Thanks
> 
>> Am 19.04.2012 um 16:20 schrieb Johannes Berg:
>> 
>>> On 4/19/2012 7:09 AM, Dominik Feser wrote:
>>>> Finally, here is the output of dmesg after recompiling:
>>>> 
>>>> iwlwifi 0000:02:00.0: edd19e18
>>>> iwlwifi 0000:02:00.0: d55c1e18
>>>> iwlwifi 0000:02:00.0: d55c1ddc
>>>> iwlwifi 0000:02:00.0: PCI INT A disabled
>>>> Intel(R) Wireless WiFi Link AGN driver for Linux, in-tree:d
>>>> Copyright(c) 2003-2012 Intel Corporation
>>>> iwlwifi 0000:02:00.0: PCI INT A ->  GSI 17 (level, low) ->  IRQ 17
>>>> iwlwifi 0000:02:00.0: setting latency timer to 64
>>>> iwlwifi 0000:02:00.0: pci_resource_len = 0x00002000
>>>> iwlwifi 0000:02:00.0: pci_resource_base = f447c000
>>>> iwlwifi 0000:02:00.0: HW Revision ID = 0x34
>>>> iwlwifi 0000:02:00.0: irq 1277 (277) for MSI/MSI-X
>>>> iwlwifi 0000:02:00.0: U iwl_request_firmware d5b37d70
>>>> iwlwifi 0000:02:00.0: U iwl_request_firmware e09ebdd4
>>>> iwlwifi 0000:02:00.0: ee2afe18
>>>> iwlwifi 0000:02:00.0: U iwl_request_firmware ee2afdd4
>>>> iwlwifi 0000:02:00.0: cc93fe18
>>>> iwlwifi 0000:02:00.0: cc93fddc
>>> 
>>> Still pretty useless since you get %pV printed as a pointer rather than a message. Does anyone know how to fix that in compat? But the iwl_request_firmware 3 times probably means it failed?
>>> 
>>> johannes
>> 
> <print.patch>

