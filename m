Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:33816 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbZINEJm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 00:09:42 -0400
Received: by iwn8 with SMTP id 8so1179863iwn.4
        for <linux-wireless@vger.kernel.org>; Sun, 13 Sep 2009 21:09:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3ace41890909132041w2d3f10b7r72e0eb855f1ab2a5@mail.gmail.com>
References: <4A9BFCCB.6040808@ufra.edu.br> <3ace41890908311025r3ce83c12gd6aeace4833609b1@mail.gmail.com>
	<4A9C0ADC.6050607@ufra.edu.br> <3ace41890908311126m5212926cl27172ae775fc92f2@mail.gmail.com>
	<4A9D7DC0.6050701@ufra.edu.br> <4AAC240E.20104@ufra.edu.br>
	<3ace41890909130313y474074ecnc5e720f780a4bd8f@mail.gmail.com>
	<3ace41890909132041w2d3f10b7r72e0eb855f1ab2a5@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Sun, 13 Sep 2009 21:09:25 -0700
Message-ID: <43e72e890909132109l4b47431cw85cfba21ec1fb42c@mail.gmail.com>
Subject: Re: zd1211rw on ppc (iBook G4) -- Solved, somewhat)
To: Hin-Tak Leung <hintak.leung@gmail.com>
Cc: "Leonardo H. Souza Hamada" <leonardo.hamada@ufra.edu.br>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 13, 2009 at 8:41 PM, Hin-Tak Leung <hintak.leung@gmail.com> wrote:
> On Sun, Sep 13, 2009 at 11:13 AM, Hin-Tak Leung <hintak.leung@gmail.com> wrote:
>> On Sat, Sep 12, 2009 at 11:43 PM, Leonardo H. Souza Hamada
>> <leonardo.hamada@ufra.edu.br> wrote:
>>> Hi all,
>>>
>>> At this moment, after tweaking the zd1211rw code in kernel
>>> 2.6.31-gentoo, finally I am able to use the WLI-U2-KG54L wireless usb
>>> dongle on this old ibook.
>>>
>>> Browsing the source with a cross referencing tool
>>> (http://lxr.free-electrons.com) and making additional checking points, I
>>> could trace the issue as follow.
>>>
>>> The problem is that this device returns a regulatory region of 0x49,
>>> which is not defined in the zd1211rw tables. So the call
>>>
>>> r <http://lxr.free-electrons.com/ident?i=r> = zd_reg2alpha2 <http://lxr.free-electrons.com/ident?i=zd_reg2alpha2>(mac <http://lxr.free-electrons.com/ident?i=mac>->regdomain, alpha2);
>>>
>>> will fail the initialization process.
>>>
>>>
>>> Workaround:
>>>
>>> ----snip----
>>> int zd_mac_init_hw(struct ieee80211_hw *hw)
>>> {
>>> ...
>>>        r = zd_read_regdomain(chip, &default_regdomain);
>>>        /* A unknown regulatory of 0x49 will be set default to
>>> ZD_REGDOMAIN_FCC. */
>>>        if (0x49 == default_regdomain)
>>>                default_regdomain = ZD_REGDOMAIN_FCC;
>>> ...
>>> ----snip----
>>>
>>> The above code will force the default regulatry to be FCC code for this
>>> case. I think that this was the case in previous zd1211rw driver. What
>>> is the country code for 0x49 region? There is a better way?
>>>
>>>
>>> Thanks all,
>>>
>>> Phew!! Leonardo
>>
>> The vendor driver has quite a lot more regdomain code defined, and
>> 0x49 is apparently
>>
>> ZD_Region_Japan_3           = 0x49,//G channel->ch1-13; A channel->8~16,34~46;
>>
>> the rw driver code probably should set it to most restrictive than let
>> it fail...
>>
>
> Can you give this patch a try against a recent
> wireless-testing/compat-wireless? I think this is the correct way to
> do things.
>
> Here is the content of the patch for others who doesn't like
> attachments - it just sets 0x49 as Japan.
> ==============================
> diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c
> b/drivers/net/wireless/zd1211rw/zd_mac.c
> index 6d66635..b0d32c4 100644
> --- a/drivers/net/wireless/zd1211rw/zd_mac.c
> +++ b/drivers/net/wireless/zd1211rw/zd_mac.c
> @@ -42,6 +42,7 @@ static struct zd_reg_alpha2_map reg_alpha2_map[] = {
>        { ZD_REGDOMAIN_ETSI, "DE" }, /* Generic ETSI, use most restrictive */
>        { ZD_REGDOMAIN_JAPAN, "JP" },
>        { ZD_REGDOMAIN_JAPAN_ADD, "JP" },
> +       { ZD_REGDOMAIN_JAPAN_3, "JP" },
>        { ZD_REGDOMAIN_SPAIN, "ES" },
>        { ZD_REGDOMAIN_FRANCE, "FR" },
>  };
> diff --git a/drivers/net/wireless/zd1211rw/zd_mac.h
> b/drivers/net/wireless/zd1211rw/zd_mac.h
> index 7c27591..9701935 100644
> --- a/drivers/net/wireless/zd1211rw/zd_mac.h
> +++ b/drivers/net/wireless/zd1211rw/zd_mac.h
> @@ -193,6 +193,7 @@ struct zd_mac {
>  #define ZD_REGDOMAIN_FRANCE    0x32
>  #define ZD_REGDOMAIN_JAPAN_ADD 0x40
>  #define ZD_REGDOMAIN_JAPAN     0x41
> +#define ZD_REGDOMAIN_JAPAN_3   0x49

FWIW, this does seem right.

  Luis
