Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f181.google.com ([209.85.220.181]:36265 "EHLO
        mail-qk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750717AbdFNORC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Jun 2017 10:17:02 -0400
Received: by mail-qk0-f181.google.com with SMTP id g83so1710017qkb.3
        for <linux-wireless@vger.kernel.org>; Wed, 14 Jun 2017 07:17:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87d1a7os83.fsf@purkki.adurom.net>
References: <1496412785-8720-1-git-send-email-amit.karwar@redpinesignals.com>
 <1496412785-8720-7-git-send-email-amit.karwar@redpinesignals.com> <87d1a7os83.fsf@purkki.adurom.net>
From: Amitkumar Karwar <amitkarwar@gmail.com>
Date: Wed, 14 Jun 2017 19:47:00 +0530
Message-ID: <CAEhWJFnWTeg0__wecBTqsJ7c4wZ1tM+orByrQE+fv54VCkh9Mw@mail.gmail.com> (sfid-20170614_161705_695650_01CBA5E9)
Subject: Re: [PATCH 6/6] rsi: add tx frame for common device configuration
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 14, 2017 at 2:34 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Amitkumar Karwar <amitkarwar@gmail.com> writes:
>
>> From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>>
>> After successful loading of firmware, a CARD READY indication is
>> received by host. Common device configuration parameters are sent
>> to the device after this. It includes information like device
>> operating mode (Wi-Fi alone or BT coex), power save related
>> parameters, GPIO information etc. As device supports BT coex,
>> this frame is send in COEX queue initially. Based on the operating
>> mode, CARD READY indication is received from each protocol module
>> in firmware i.e. WLAN, BT.
>>
>> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
>
> [...]
>
>> +struct rsi_ulp_gpio_vals {
>> +#ifdef __LITTLE_ENDIAN
>> +     u8 motion_sensor_gpio_ulp_wakeup:1;
>> +     u8 sleep_ind_from_device:1;
>> +     u8 ulp_gpio_2:1;
>> +     u8 push_button_ulp_wakeup:1;
>> +     u8 reserved:4;
>> +#else
>> +     u8 reserved:4;
>> +     u8 push_button_ulp_wakeup:1;
>> +     u8 ulp_gpio_2:1;
>> +     u8 sleep_ind_from_device:1;
>> +     u8 motion_sensor_gpio_ulp_wakeup:1;
>> +#endif
>> +} __packed;
>
> This is something I'm not exactly thrilled to see (bitfields are not
> really liked in upstream community) but I'm not going to reject that
> either as we have other offenders, rtl8xxxx being one. But it's much
> better that to __le_to_cpu(), FIELD_GET() & co. That you don't need to
> duplicate the fields and is less error prone.

Got it. I will get rid of bitfields in structure and __LITTLE_ENDIAN
macro usage.

>
>> +struct rsi_config_vals {
>> +#ifdef __LITTLE_ENDIAN
>> +     u16 len:12;
>> +     u16 q_no:4;
>> +#else
>> +     u16 q_no:4;
>> +     u16 len:12;
>> +#endif
>> +     u8 pkt_type;
>> +     u8 misc_flags;
>> +     __le16 reserved1[6];
>> +     u8 lp_ps_handshake;
>> +     u8 ulp_ps_handshake;
>> +     u8 sleep_config_params; /* 0 for no handshake,
>> +                              * 1 for GPIO based handshake,
>> +                              * 2 packet handshake
>> +                              */
>> +     u8 unused_ulp_gpio;
>> +     u32 unused_soc_gpio_bitmap;
>> +     u8 ext_pa_or_bt_coex_en;
>> +     u8 opermode;
>> +     u8 wlan_rf_pwr_mode;
>> +     u8 bt_rf_pwr_mode;
>> +     u8 zigbee_rf_pwr_mode;
>> +     u8 driver_mode;
>> +     u8 region_code;
>> +     u8 antenna_sel_val;
>> +     u8 reserved2[16];
>> +} __packed;
>
> But here you are even mixing use of __LITTLE_ENDIAN and __le16, that's
> just weird. And shouldn't unused_soc_gpio_bitmap be __le32?
>

You are right. unused_soc_gpio_bitmap should have been __le32.
I will correct this and get rid of __LITTLE_ENDIAN in updated version

Regards,
Amitkumar
