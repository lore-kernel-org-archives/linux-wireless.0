Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:45545 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752110AbeBBU12 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Feb 2018 15:27:28 -0500
Received: by mail-ot0-f195.google.com with SMTP id 73so12339679oti.12
        for <linux-wireless@vger.kernel.org>; Fri, 02 Feb 2018 12:27:28 -0800 (PST)
Subject: Re: rtl8821ae keep alive not set, connection lost
To: Pkshih <pkshih@realtek.com>, James Cameron <quozl@laptop.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <20170912220916.GB32211@us.netrek.org>
 <a9a1ff03-d12f-7437-e7bc-5f01b195f753@lwfinger.net>
 <20180201062202.GH917@us.netrek.org>
 <5B2DA6FDDF928F4E855344EE0A5C39D13BE7A25E@RTITMBSV07.realtek.com.tw>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <28da1b31-1f4e-cd16-e121-0fbf4bb0fe71@lwfinger.net> (sfid-20180202_212732_999106_225EA43C)
Date: Fri, 2 Feb 2018 14:27:23 -0600
MIME-Version: 1.0
In-Reply-To: <5B2DA6FDDF928F4E855344EE0A5C39D13BE7A25E@RTITMBSV07.realtek.com.tw>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/02/2018 01:50 AM, Pkshih wrote:
> 
> Hi James,
> 
> In my experiment, unaligned-word-access may get wrong values that
> are different from the value by byte-access. Actually, it can simply
> verified by using 'lspci' to check PCI configuration space.
> 
> DBI read 0x70f:
> _rtl8821ae_dbi_read:1127 r8 0x34f = 0x0017
> _rtl8821ae_dbi_read:1131 r8 0x350 = 0x000c
> _rtl8821ae_dbi_read:1136 r16 0x350 = 0xffff
> 
> DBI read 0x719:
> _rtl8821ae_dbi_read:1127 r8 0x34d = 0x0000
> _rtl8821ae_dbi_read:1131 r8 0x34e = 0x0002
> _rtl8821ae_dbi_read:1136 r16 0x34e = 0x0200
> 
> 
> According to the wrong and original value of 0x70f is 0xff, I think
> larger L1 latency 0x70f[5:3] may be helpful. Please help to try
> below patch. If it works, quirk table won't be necessary.
> 
> PK
> 
> 
> diff --git a/rtl8821ae/hw.c b/rtl8821ae/hw.c
> index 7d43ba002..e53af06ed 100644
> --- a/rtl8821ae/hw.c
> +++ b/rtl8821ae/hw.c
> @@ -1123,7 +1123,8 @@ static u8 _rtl8821ae_dbi_read(struct rtl_priv *rtlpriv, u16 addr)
>   	}
>   	if (0 == tmp) {
>   		read_addr = REG_DBI_RDATA + addr % 4;
> -		ret = rtl_read_word(rtlpriv, read_addr);
> +
> +		ret = rtl_read_byte(rtlpriv, read_addr);
>   	}
>   	return ret;
>   }
> @@ -1165,7 +1166,7 @@ static void _rtl8821ae_enable_aspm_back_door(struct ieee80211_hw *hw)
>   	}
>   
>   	tmp = _rtl8821ae_dbi_read(rtlpriv, 0x70f);
> -	_rtl8821ae_dbi_write(rtlpriv, 0x70f, tmp | BIT(7));
> +	_rtl8821ae_dbi_write(rtlpriv, 0x70f, tmp | BIT(7) | 0x38);
>   
>   	tmp = _rtl8821ae_dbi_read(rtlpriv, 0x719);
>   	_rtl8821ae_dbi_write(rtlpriv, 0x719, tmp | BIT(3) | BIT(4));
PK,

One more question: Will we need to make the same change to rtl8723be and rtl8723de?

Larry
