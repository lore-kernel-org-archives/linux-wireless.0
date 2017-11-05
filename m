Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f181.google.com ([74.125.82.181]:45662 "EHLO
        mail-ot0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750748AbdKEQuI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 5 Nov 2017 11:50:08 -0500
Received: by mail-ot0-f181.google.com with SMTP id q99so6471477ota.2
        for <linux-wireless@vger.kernel.org>; Sun, 05 Nov 2017 08:50:08 -0800 (PST)
Subject: Re: rtl8821ae dbi read question
To: Nik Nyby <nikolas@gnu.org>, linux-wireless@vger.kernel.org,
        pkshih@realtek.com
References: <d46763ef-14d1-a6fa-fb33-a0bd676ef056@gnu.org>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <695fe947-7b0d-ef4b-5e90-ff503df6a08b@lwfinger.net> (sfid-20171105_175013_554323_DD749AD1)
Date: Sun, 5 Nov 2017 10:50:06 -0600
MIME-Version: 1.0
In-Reply-To: <d46763ef-14d1-a6fa-fb33-a0bd676ef056@gnu.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/04/2017 06:27 PM, Nik Nyby wrote:
> In drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c, we have this function:
> 
>   static u8 _rtl8821ae_dbi_read(struct rtl_priv *rtlpriv, u16 addr)
>   {
>       u16 read_addr = addr & 0xfffc;
>       u8 tmp = 0, count = 0, ret = 0;
> 
>       rtl_write_word(rtlpriv, REG_DBI_ADDR, read_addr);
>       rtl_write_byte(rtlpriv, REG_DBI_FLAG, 0x2);
>       tmp = rtl_read_byte(rtlpriv, REG_DBI_FLAG);
>       count = 0;
>       while (tmp && count < 20) {
>           udelay(10);
>           tmp = rtl_read_byte(rtlpriv, REG_DBI_FLAG);
>           count++;
>       }
>       if (0 == tmp) {
>           read_addr = REG_DBI_RDATA + addr % 4;
>           ret = rtl_read_word(rtlpriv, read_addr);
>       }
>       return ret;
>   }
> 
> Near the end of the function, in this line:
> 
>    ret = rtl_read_word(rtlpriv, read_addr);
> 
> rtl_read_word() returns a u16, but "ret" is declared as a u8. Is that a problem, 
> or is this code correct?
> 
> What's prompting this question is that I'm getting frequent disconnects from my 
> access point with my rtl8821ae device. I've experienced this behavior both 
> before and after the recent change to this function in commit 
> b8b8b16352cd90c6083033fd4487f04fae935c18.

If you read the commit message for commit b8b8b16352cd, you will find that we do 
not understand why using a byte read causes failure, but reverting the change so 
that it is a word read made it function again. The "fix" was found by a user 
doing bisection, and verified on my system, where the RTL8821AE has stable 
connections. The transfer rates take wild swings, but the connection is not dropped.

If you NIC behaves differently, then you will need to help us debug the problem. 
If you had a kernel that worked, then you might try bisection. If that is not 
possible, you might try various combinations of module parameters aspm, 
int_clear, and msi. Those parameters default to 1, so setting one or more of 
them to zero is the test. Note, however, that changing any of these might cause 
the system to fail, thus I recommend that you test changes dynamically with 
modprobe, and not create a file in /etc/modprobe.d/ until you have verified that 
changing one or more of these parameters actually helps. That will keep from 
making your system unbootable.

Larry
