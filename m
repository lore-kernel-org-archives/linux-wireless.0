Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:34183 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbbJSS0r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2015 14:26:47 -0400
Received: by lbbwb3 with SMTP id wb3so90060576lbb.1
        for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2015 11:26:46 -0700 (PDT)
References: <20151019151045.GA12293@mwanda>
From: Jakub Sitnicki <jsitnicki@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Larry.Finger@lwfinger.net, linux-wireless@vger.kernel.org
Subject: Re: rtlwifi: rtl8723be: Add new driver
In-reply-to: <20151019151045.GA12293@mwanda>
Date: Mon, 19 Oct 2015 20:26:44 +0200
Message-ID: <87eggqemu3.fsf@frog.home> (sfid-20151019_202650_987142_C0FC5093)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

On Mon, Oct 19, 2015 at 05:10 PM CEST, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> The patch a619d1abe20c: "rtlwifi: rtl8723be: Add new driver" from Feb
> 28, 2014, leads to the following static checker warning:
>
> 	drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c:1802 _rtl8723be_read_power_value_fromprom()
> 	warn: why is the last element skipped?
>
> drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c

[snip]

>   1794          for (path = 0; path < MAX_RF_PATH; path++) {
>   1795                  /*2.4G default value*/
>   1796                  for (group = 0; group < MAX_CHNL_GROUP_24G; group++) {
>                                         ^^^^^^^^^^^^^^^^^^^^^^^^^^
> Here we go to the end.
>
>   1797                          pw2g->index_cck_base[path][group] = hwinfo[addr++];
>   1798                          if (pw2g->index_cck_base[path][group] == 0xFF)
>   1799                                  pw2g->index_cck_base[path][group] = 0x2D;
>   1800  
>   1801                  }
>   1802                  for (group = 0; group < MAX_CHNL_GROUP_24G - 1; group++) {
>                                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> Here we skip the last element.  So far as I can see this looks like a
> mistake but I don't know the code well.
>
>   1803                          pw2g->index_bw40_base[path][group] = hwinfo[addr++];
>   1804                          if (pw2g->index_bw40_base[path][group] == 0xFF)
>   1805                                  pw2g->index_bw40_base[path][group] = 0x2D;
>   1806                  }

I have seen the same thing in rtlwifi/rtl8188ee and staging/rtl8188eu
drivers (see read_power_value_fromprom() and
Hal_ReadPowerValueFromPROM_8188E(), respectively), and I've asked myself
exactly the same question before so I'll share my thoughts.

Please take it all with a grain of salt, I'm new at this.

The rtl8188e[eu] drivers divide 2.4 GHz channels into six sets
(MAX_CHNL_GROUP_24G == 6) as far as the TX power goes (see
_rtl88e_get_chnl_group(), Hal_GetChnlGroup88E()):

group 0: 1-2
group 1: 3-5
group 2: 6-8
group 3: 9-11
group 4: 12-13
group 5: 14

As you see the last group is special, it's only channel 14, which
applies only to 802.11b in Japan, AFAIK.  The loop in question
initializes the index_bw40_base[] array, which name suggests that it is
related to 40 MHz channel bandwidth - 802.11n only then.  That would
explain the `MAX_CHNL_GROUP_24G - 1' expression.

This is the case for rtl8188e[eu].  However, rtl8723be driver divides
2.4 GHz channels into just three groups - 0: 1-3, 1: 4-9, and 2: 10-14
(_rtl8723be_get_chnl_group()).  In that regard it is similar to
rtlwifi/rtl8192cu and staging/rtl8723au (rtl92c_get_chnl_group(),
Hal_GetChnlGroup()).

That would mean that the index_bw40_base[3..5] range in this
one-size-fits all array is never accessed by the rtl8723be driver.

That's all I know, beyond that point I tell myself that it's a driver
for a chip with no datasheet so questions without answers are part of
the deal ;-)

Cheers,
Jakub
