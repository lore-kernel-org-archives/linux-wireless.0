Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:36555 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751076AbdFANyc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Jun 2017 09:54:32 -0400
Received: by mail-qk0-f196.google.com with SMTP id y201so1361329qka.3
        for <linux-wireless@vger.kernel.org>; Thu, 01 Jun 2017 06:54:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1495560381.22203.29.camel@synopsys.com>
References: <1495008675.2606.72.camel@synopsys.com> <CAEhWJFkVe1C9jtxH9zeeMeJiAs86sJGOKSoqMku0qRqNAQujxg@mail.gmail.com>
 <1495560381.22203.29.camel@synopsys.com>
From: amit karwar <amitkarwar@gmail.com>
Date: Thu, 1 Jun 2017 19:24:30 +0530
Message-ID: <CAEhWJFkqCWE1QLJCRvkQEo0YokfzcW1sVFitwY_Q+OUcMBYSGg@mail.gmail.com> (sfid-20170601_155436_739037_1690982B)
Subject: Re: git repo with Redpine changes
To: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Cc: "amit.karwar@redpinesignals.com" <amit.karwar@redpinesignals.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "prameela.j04cs@gmail.com" <prameela.j04cs@gmail.com>,
        "linux-snps-arc@lists.infradead.org"
        <linux-snps-arc@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 23, 2017 at 10:56 PM, Alexey Brodkin
<Alexey.Brodkin@synopsys.com> wrote:
> Hi Amit!
>
> On Tue, 2017-05-23 at 17:00 +0530, amit karwar wrote:
>> On Wed, May 17, 2017 at 1:41 PM, Alexey Brodkin
>> <Alexey.Brodkin@synopsys.com> wrote:
>> >
>> > Hello Amitkumar, Prameela,
>> >
>> > I was lucky enough to get hold of RS9113 Evaluation Kit and now I'm trying
>> > to get it working with my board via USB and SDIO interfaces but seeing issues here and there:
>> >  1) In case of SDIO I see this on interface up with vanilla 4.11.1 kernel:
>> > ----------------------->8--------------------
>> > # ifconfig wlan0 up
>> > rsi_91x: Sending RX filter frame
>> > rsi_91x: rsi_core_qos_processor: Queue number = 4
>> > rsi_91x: rsi_sdio_host_intf_write_pkt: Successfully written onto card
>> > rsi_91x: rsi_set_vap_capabilities: Sending VAP capabilities frame
>> > rsi_91x: rsi_mac80211_conf_tx: Conf queue 0, aifs: 2, cwmin: 15 cwmax: 1023, txop: 0
>> > rsi_91x: rsi_mac80211_conf_tx: Conf queue 1, aifs: 2, cwmin: 15 cwmax: 1023, txop: 0
>> > rsi_91x: rsi_mac80211_conf_tx: Conf queue 2, aifs: 2, cwmin: 15 cwmax: 1023, txop: 0
>> > # rsi_91x: rsi_mac80211_conf_tx: Conf queue 3, aifs: 2, cwmin: 15 cwmax: 1023, txop: 0
>> > rsi_91x: rsi_channel_change: Set channel: 2412 MHz type: 416 channel_no 1
>> > rsi_91x: rsi_set_channel: Sending scan req frame
>> > rsi_91x: rsi_mac80211_config: Configuring Power
>> > rsi_91x: rsi_config_power: Set tx power: 20 dBM
>> > rsi_91x: rsi_send_radio_params_update: Sending Radio Params update frame
>> > rsi_91x: rsi_core_qos_processor: Queue number = 4
>> > rsi_91x: rsi_interrupt_handler: Intr_status = 8 8 4
>> > rsi_91x: Pkt pending interrupt
>> > rsi_91x: rsi_mgmt_pkt_recv: Msg Len: 0, Msg Type:    1
>> > rsi_91x: rsi_handle_ta_confirm_type: Invalid TA confirm pkt received
>> > rsi_91x: rsi_sdio_host_intf_write_pkt: Successfully written onto card
>> > rsi_91x: rsi_core_qos_processor: Queue number = 4
>> > rsi_91x: rsi_sdio_host_intf_write_pkt: Successfully written onto card
>> > rsi_91x: rsi_core_qos_processor: Queue number = 4
>> > rsi_91x: rsi_interrupt_handler: Intr_status = 8 8 4
>> > rsi_91x: Pkt pending interrupt
>> > rsi_91x: rsi_mgmt_pkt_recv: Msg Len: 0, Msg Type:    1
>> > rsi_91x: rsi_handle_ta_confirm_type: Invalid TA confirm pkt received
>> > rsi_91x: rsi_interrupt_handler: Intr_status = 8 8 4
>> > rsi_91x: Pkt pending interrupt
>> > rsi_91x: rsi_mgmt_pkt_recv: Msg Len: 321, Msg Type:    2
>> > rsi_91x: rsi_sdio_host_intf_write_pkt: Successfully written onto card
>> > rsi_91x: rsi_core_qos_processor: Queue number = 255
>> > rsi_91x: rsi_core_qos_processor: No More Pkt
>> > rsi_91x: rsi_interrupt_handler: Intr_status = c 8 4
>> > rsi_91x: Pkt pending interrupt
>> > rsi_91x: rsi_mgmt_pkt_recv: Msg Len: 299, Msg Type:    2
>> > rsi_91x: rsi_interrupt_handler: ==> FIRMWARE Assert <==
>
> Any hint on what's wrong here?
>
> Note firmware was successfully loaded on probe a bit earlier.
> And here I used a firmware blob from linux-firmware git repo,
> https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/rsi_91x.fw
>
>> > rsi_91x: rsi_interrupt_handler: Firmware Status is 0x65
>> > rsi_91x: rsi_core_qos_processor: Queue number = 255
>> > rsi_91x: rsi_core_qos_processor: No More Pkt
>> > ----------------------->8--------------------
>> >
>> > and you recent patch series for nwe firmware loading I see something a bit
>> > different:
>> > ----------------------->8--------------------
>> > mmc_host mmc0: Bus speed (slot 0) = 50000000Hz (slot req 25000000Hz, actual 25000000HZ div = 1)
>> > mmc0: new SDIO card at address fffd
>> > rsi_91x: rsi_probe: Init function called
>> > rsi_91x: rsi_init_sdio_interface: Enabled the interface
>> > mmc_host mmc0: Bus speed (slot 0) = 50000000Hz (slot req 50000000Hz, actual 50000000HZ div = 0)
>> > rsi_91x: rsi_setblocklength: Setting the block length
>> > rsi_91x: rsi_setblocklength: Operational blk length is 256
>> > rsi_91x: rsi_init_sdio_interface: Setup card succesfully
>> > rsi_91x: rsi_init_sdio_slave_regs: Initialzing SDIO read start level
>> > rsi_91x: rsi_init_sdio_slave_regs: Initialzing FIFO ctrl registers
>> > rsi_91x: rsi_sdio_master_access_msword: MASTER_ACCESS_MSBYTE:0x5
>> > rsi_91x: rsi_sdio_master_access_msword:MASTER_ACCESS_LSBYTE:0x41
>> > rsi_91x: rsi_sdio_read_register_multiple: Synch Cmd53 read failed
>>
>> Looks like sdio_readsb() failed for some reason on your platform.
>> We expect firmware loading to be successful with recent patch series.
>
> Hm, that's interesting why stuff used to work before that patch series.
> At least as you might see from above I got much further with vanilla 4.11 kernel.
>
> BTW where may I find new firmware blob which is mentioned in on of the patches ("rs9113_wlan_qspi.rps")?

I have posted a firmware image for new firmware loading mechanism to
community. There are some patches for SDIO specific driver
enhancements and fixes. I am sending them in couple of days. With
those patches you will be able to see wireless interface bring up,
connection in open network and data path working.

>
>> > rsi_91x: rsi_sdio_master_reg_read: AHB register read failed
>> > rsi_91x: rsi_load_firmware: REGOUT read failed
>> > rsi_91x: rsi_hal_device_init: Failed to load TA instructions
>> > rsi_91x: rsi_probe: Failed in device init
>> > rsi_91x: rsi_91x_deinit: Performing deinit os ops
>> > rsi_91x: rsi_core_qos_processor: Queue number = 255
>> > rsi_91x: rsi_core_qos_processor: No More Pkt
>> > rsi_91x: rsi_probe: Failed in probe...Exiting
>> > RSI-SDIO WLAN: probe of mmc0:fffd:1 failed with error 1
>> > ----------------------->8--------------------
>> >
>> >  2) In case of USB I just see:
>> > ----------------------->8--------------------
>> > usb 1-1: new high-speed USB device number 6 using ehci-platform
>> > usb 1-1: config 1 interface 0 altsetting 0 endpoint 0x83 has an invalid bInterval 255, changing to 11
>> > usb 1-1: New USB device found, idVendor=1618, idProduct=9113
>> > usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
>> > usb 1-1: Product: Wireless USB-CDC Network Module
>> > usb 1-1: Manufacturer: Redpine Signals, Inc.
>> > cdc_acm 1-1:1.0: ttyACM0: USB ACM device
>> > ----------------------->8--------------------
>> >
>> > I noticed that there're quite some patches floating on linux-wireless mailing list which
>> > were not yet merged in upstream kernel (even in linux-next or wireless-testing).
>> >
>> > So at this point I'm not really sure what could be a safe baseline for my experiments:
>> >  - if existing vanilla say 4.11 kernel is good enough and things that doesn't work are caused
>> >    by other problems not related to Redpine module (that would be strange because both USB abd SD-card
>> >    slot are proven to work pretty well with other devices)
>> >  - if I need an arbitrary set of patches to get things up and running etc
>> >
>> > That said if there's a public git repo which contains everything required for Redpine module to
>> > work [preferably based on the latest kernel sources] I'd like to get a reference to it.
>> >
>> > Any hints here are much appreciated.
>>
>> We don't have a public git repo maintained. We have 2 patchsets ready
>> for submission. We are working on code cleanup for other pending
>> changes. I would suggest you to wait till these patches are posted.
>
> Ok, will do. But please add me in Cc list in your upcoming patches as I'm very interested
> in getting Redpine module working on our new board and will be happy to review them as well as test on
> my platform.
>

Sure. I will add you in CC for those patches.

Regards,
Amitkumar Karwar
