Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:45171 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753131AbeGEJ03 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Jul 2018 05:26:29 -0400
Received: by mail-io0-f194.google.com with SMTP id l25-v6so7120199ioh.12
        for <linux-wireless@vger.kernel.org>; Thu, 05 Jul 2018 02:26:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1530776154.4156.12.camel@realtek.com>
References: <CAPpJ_ed1oFQW_xmBtetP-ztoL7Z14T6akOSgKJ_8jxogdf3FWg@mail.gmail.com>
 <f3bf0687-76fb-9411-6fa2-e8ef312efb58@lwfinger.net> <20180704140933.3dk2ylbntltz6jqd@mwanda>
 <7e95bd6a-97bc-b030-26ce-83da66e5f279@lwfinger.net> <CAD8Lp44EG73XQ9omQhH6XiHfm2rMypmndSFyffnf_PVMueTvEA@mail.gmail.com>
 <1530776154.4156.12.camel@realtek.com>
From: Jian-Hong Pan <jian-hong@endlessm.com>
Date: Thu, 5 Jul 2018 17:26:28 +0800
Message-ID: <CAPpJ_ecCzhxEu8gMBFRsCerpeu_Z8TR=Rw5BiFhzVYP6WK-wAw@mail.gmail.com> (sfid-20180705_112700_713940_FFDDE3FC)
Subject: Re: [BUG] staging: r8822be: RTL8822be can't find any wireless AP
To: Pkshih <pkshih@realtek.com>
Cc: "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "drake@endlessm.com" <drake@endlessm.com>,
        Shaofu <shaofu@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>,
        "colin.king@canonical.com" <colin.king@canonical.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Birming Chiu <birming@realtek.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "frank@generalsoftwareinc.com" <frank@generalsoftwareinc.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux@endlessm.com" <linux@endlessm.com>,
        Steven Ting <steventing@realtek.com>,
        Tony Chuang <yhchuang@realtek.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "sgruszka@redhat.com" <sgruszka@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2018-07-05 15:36 GMT+08:00 Pkshih <pkshih@realtek.com>:
> On Wed, 2018-07-04 at 10:33 -0500, Daniel Drake wrote:
>> On Wed, Jul 4, 2018 at 10:13 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>> > We will have to agree to disagree.
>> >
>> > I have no idea what the vendors are doing that cause some motherboards to
>> > need a different aspm value. What I do know is that we have had to live with
>> > the idiocy of some vendors saving a few pennies by only including a single
>> > antenna, rather than two, and then making a problem by miscoding the EFUSE
>> > bit that indicates which connector is actually in use. As we have no means
>> > that I know about to detect which boxes have the problem, a module parameter
>> > was created, just as in this case.
>> >
>> > I agree that drivers should work "out of the box", but finite resources and
>> > lack of vendor cooperation make this a goal that may not be attainable.
>>
>> As you touched on, the ideal situation is that Realtek solve the
>> issue. Ping-Ke Shih is on CC and I am adding a few more contacts from
>> the commit log. The context is that the r8822 driver fails on several
>> platforms unless setting aspm=0 (the default is 1).
>
> It's hard to have all laptop or motherboards and all rtl8822be modules in my side,
> so what I can do is to analyze the issue when user encountered.
>
>>
>> https://gist.github.com/dsd/20c05f0c6d66ee2ef9bfbb17f93f18ba
>> https://bugzilla.kernel.org/show_bug.cgi?id=199651
>>
>>
>> If we don't get a timely fix from Realtek though, I think there is a
>> key difference between the antenna selection headache and this one. In
>> the antenna case, there isn't a good value that you can set that will
>> work on all systems. If you change the default behaviour you will
>> solve the issue for some users while simultanously introducing the
>> problem on other systems that were previously fine.
>>
>> However in this case, it's highly likely that setting aspm=0 (off) by
>> default would work for everyone. It has the disadvantage of using a
>> bit more power, but especially with the indications that this issue
>> affects a significant number of systems, I think that having the
>> driver working out of the box everywhere is more important. The module
>> parameter can be left in place so that unaffected users that want to
>> save power can set aspm=1.
>>
>
> I think this issue may be due to L1 latency, so below patch would be
> helpful but not sure because I don't have the same laptop.
> Is there anyone can help to test?

I do not know why I cannot apply this patch directly.  So, I apply
each line manually.

However, here is a good news.  I tested this fix, and it works
correctly on ASUS X530UN.  System can scan and get the access points
list.  Finally, it also connects to the access point.
Maybe, you can have a formal patch for this.

Thanks,
Jian-Hong Pan

>
> diff --git a/drivers/staging/rtlwifi/rtl8822be/hw.c b/drivers/staging/rtlwifi/rtl8822be/hw.c
> index 7947edb239a1..88ba5b2fea6a 100644
> --- a/drivers/staging/rtlwifi/rtl8822be/hw.c
> +++ b/drivers/staging/rtlwifi/rtl8822be/hw.c
> @@ -803,7 +803,7 @@ static void _rtl8822be_enable_aspm_back_door(struct ieee80211_hw *hw)
>                 return;
>
>         pci_read_config_byte(rtlpci->pdev, 0x70f, &tmp);
> -       pci_write_config_byte(rtlpci->pdev, 0x70f, tmp | BIT(7));
> +       pci_write_config_byte(rtlpci->pdev, 0x70f, tmp | ASPM_L1_LATENCY << 3);
>
>         pci_read_config_byte(rtlpci->pdev, 0x719, &tmp);
>         pci_write_config_byte(rtlpci->pdev, 0x719, tmp | BIT(3) | BIT(4));
> diff --git a/drivers/staging/rtlwifi/wifi.h b/drivers/staging/rtlwifi/wifi.h
> index 012fb618840b..a45f0eb69d3f 100644
> --- a/drivers/staging/rtlwifi/wifi.h
> +++ b/drivers/staging/rtlwifi/wifi.h
> @@ -88,6 +88,7 @@
>  #define RTL_USB_MAX_RX_COUNT                   100
>  #define QBSS_LOAD_SIZE                         5
>  #define MAX_WMMELE_LENGTH                      64
> +#define ASPM_L1_LATENCY                                7
>
>  #define TOTAL_CAM_ENTRY                                32
>
>
> ---
> PK
>
