Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f66.google.com ([209.85.213.66]:33984 "EHLO
        mail-vk0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751225AbdF1EMf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 00:12:35 -0400
Received: by mail-vk0-f66.google.com with SMTP id 191so2999846vko.1
        for <linux-wireless@vger.kernel.org>; Tue, 27 Jun 2017 21:12:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <353a53a0-4d7c-84c4-a2f3-7b2848c983fc@lwfinger.net>
References: <20170622132329.GA4825@symbol-HP-ZBook-15> <CAFqt6zadBtGgagJ0B1RYR6Ny7izTqfuQS5aGQsPqw4k5vQJRaA@mail.gmail.com>
 <353a53a0-4d7c-84c4-a2f3-7b2848c983fc@lwfinger.net>
From: Souptick Joarder <jrdr.linux@gmail.com>
Date: Wed, 28 Jun 2017 09:42:33 +0530
Message-ID: <CAFqt6zYEnx2Yi7+M6HXgDH+tpOno=bZAbP5gENMuwd5Nsm1eBQ@mail.gmail.com> (sfid-20170628_061239_257139_755833D6)
Subject: Re: [PATCH v2] rtlwifi: Remove unnecessary conditions
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
        Julian Calaby <julian.calaby@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry,


On Tue, Jun 27, 2017 at 7:21 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 06/26/2017 09:41 PM, Souptick Joarder wrote:
>>
>> Any further comment on this patch ?
>>
>> On 22-Jun-2017 6:53 PM, "Souptick Joarder" <jrdr.linux@gmail.com
>> <mailto:jrdr.linux@gmail.com>> wrote:
>>  >
>>  > As wmm_enable is initialized to false, hence the else condition never
>>  > execute and boundary is assigned with TX_PAGE_BOUNDARY. So the if-else
>>  > condition can be removed and boundary will be assigned with
>>  > TX_PAGE_BOUNDARY.
>>  >
>>  > Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com
>> <mailto:jrdr.linux@gmail.com>>
>>
>>  > ---
>>  > Changes in v2:
>>  >   - Correcting the indent and moving up the change where
>>  >     boundary is defined.
>>  >
>>  >  drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c | 9 +--------
>>  >  1 file changed, 1 insertion(+), 8 deletions(-)
>>  >
>>  > diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
>> b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
>>  > index f95a645..107c34e 100644
>>  > --- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
>>  > +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
>>  > @@ -835,7 +835,7 @@ static int _rtl92cu_init_mac(struct ieee80211_hw
>> *hw)
>>  >         struct rtl_usb_priv *usb_priv = rtl_usbpriv(hw);
>>  >         struct rtl_usb *rtlusb = rtl_usbdev(usb_priv);
>>  >         int err = 0;
>>  > -       u32     boundary = 0;
>>  > +       u32     boundary = TX_PAGE_BOUNDARY;
>>  >         u8 wmm_enable = false; /* TODO */
>>  >         u8 out_ep_nums = rtlusb->out_ep_nums;
>>  >         u8 queue_sel = rtlusb->out_queue_sel;
>>  > @@ -845,13 +845,6 @@ static int _rtl92cu_init_mac(struct ieee80211_hw
>> *hw)
>>  >                 pr_err("Failed to init power on!\n");
>>  >                 return err;
>>  >         }
>>  > -       if (!wmm_enable) {
>>  > -               boundary = TX_PAGE_BOUNDARY;
>>  > -       } else { /* for WMM */
>>  > -               boundary = (IS_NORMAL_CHIP(rtlhal->version))
>>  > -                                       ? WMM_CHIP_B_TX_PAGE_BOUNDARY
>>  > -                                       : WMM_CHIP_A_TX_PAGE_BOUNDARY;
>>  > -       }
>>  >         if (false == rtl92c_init_llt_table(hw, boundary)) {
>>  >                 pr_err("Failed to init LLT Table!\n");
>>  >                 return -EINVAL;
>
>
> This patch troubles me. I have no idea why the original author placed a TODO
> on the assignent of wmm_enable. You, however, have left the TODO in place
> but removed the actual place where it would make a difference. As a result,
> it would become impossible to reconstruct that author's intentions. For that
> reason
>
> NACK.
>
> Note that these changes make no difference in the object code and the
> optimizer will remove that code anyway.

Thanks for your feedback.
>
> Larry
>

Souptick
