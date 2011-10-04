Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:35807 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756986Ab1JDNW3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 09:22:29 -0400
Received: by pzk1 with SMTP id 1so1292994pzk.1
        for <linux-wireless@vger.kernel.org>; Tue, 04 Oct 2011 06:22:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADPsn1Zi20JHmc7EOFCvjDmKWKtHnBCcyxTxWwBK8_vLps_u_w@mail.gmail.com>
References: <CADPsn1bsUJqcuwZrW+e92aGms+t+TKRasnGb=ujzzgvz+S1Maw@mail.gmail.com>
	<4E68ECE2.7060504@qca.qualcomm.com>
	<CADPsn1Yvdw58AYXFNPc4L1M1tyJ7K6kEA2j85gRCq+vqAYQu_w@mail.gmail.com>
	<CADPsn1Zi20JHmc7EOFCvjDmKWKtHnBCcyxTxWwBK8_vLps_u_w@mail.gmail.com>
Date: Tue, 4 Oct 2011 14:22:28 +0100
Message-ID: <CADPsn1ZB_Po5TumMA5r5WewUHC=M+3JUpzt0SyRdc+RG5WeU+g@mail.gmail.com> (sfid-20111004_152232_338889_A41232C9)
Subject: Re: Question: ath6kl (driver/net/wireless/ath/ath6kl) with debug_mask value
From: Sangwook Lee <sangwook.lee@linaro.org>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle

I used  git://github.com/kvalo/ath6kl.git for-linville (Sat Oct 1
09:43:09 2011 +0300)
to run AR6003 HW2.0 (hw 2.0 fw 3.1.1.149) in my ARM board.

But I faced booting problem as like the following:
Is there any changes for AR6003 HW2.0 with the latest ath6kl git ?
-----------------------------------------------------------------------
mmc2: queuing unknown CIS tuple 0x01 (3 bytes)
mmc2: queuing unknown CIS tuple 0x1a (5 bytes)
mmc2: queuing unknown CIS tuple 0x1b (8 bytes)
mmc2: queuing unknown CIS tuple 0x14 (0 bytes)
mmc2: queuing unknown CIS tuple 0x80 (1 bytes)
mmc2: queuing unknown CIS tuple 0x81 (1 bytes)
mmc2: queuing unknown CIS tuple 0x82 (1 bytes)
mmc2: new high speed SDIO card at address 0001
ath6kl: target_ver 0x30000384 target_type 0x3 dataset_patch 0x57e884
app_load_addr 0x543180
ath6kl: app_start_override_addr 0x0 board_ext_data_addr 0x57e500
reserved_ram_size 0x1b00
ath6kl: using fw api 1
ath6kl: temporary war to avoid sdio crc error
ath6kl: writing extended board data to 0x57e500 (768 B)
ath6kl: writing board file to 0x541800 (1024 B)
ath6kl: writing otp to 0x543180 (3689 B)
ath6kl: app_start_override_addr 0x0
ath6kl: executing OTP at 0x0
ath6kl: bmi_recv_buf FIFO empty
ath6kl: Unable to read from the device: -22
ath6kl: writing firmware to 0x543180 (100694 B)
ath6kl: bmi communication timeout
ath6kl: Unable to write to the device: -110
ath6kl: Failed to write firmware: -110
ath6kl: Failed to init ath6kl core
ath6kl_sdio: probe of mmc2:0001:1 failed with error -110

--------------------------------------------------------------------------------

Thanks
Sangwook



On 9 September 2011 09:54, Sangwook Lee <sangwook.lee@linaro.org> wrote:
>
> Hi Kalle
>
> On 8 September 2011 17:27, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> > Hi Sangwook,
> >
> > On 09/07/2011 04:32 PM, Sangwook Lee wrote:
> >> I am running ath6kl-cleanup git.
> >
> > BTW, ath6kl-cleanup.git is not updated anymore. Instead there's now
> > ath6kl.git which follows wireless-testing. You can find it from
> > git.kernel.org (when it's up again) or from github.
> >
> Thanks for this info, I will use new git.
>
> >> If I add debug_mask values with ath6kl.ko as like followings, I get
> >> the success full results,

[snip]

> >> $ insmod ath6kl.ko
> >> $ ifconfig wlan0 up
> >> $ iwlist wlan0 scan
> >> With this case, there is no coming event "WMI_SCAN_COMPLETE_EVENTID".
> >> After receiving  "ath6kl: WMI_EXTENSION_EVENTID"
> >> iwlist shows error message:
> >>       wlan0     Failed to read scan data : Resource temporarily unavailable
> >
[snip]
