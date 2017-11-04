Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eggs.gnu.org ([208.118.235.92]:56093 "EHLO eggs.gnu.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751612AbdKDX2M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 4 Nov 2017 19:28:12 -0400
Received: from Debian-exim by eggs.gnu.org with spam-scanned (Exim 4.71)
        (envelope-from <nikolas@gnu.org>)
        id 1eB7rH-0003I3-8u
        for linux-wireless@vger.kernel.org; Sat, 04 Nov 2017 19:28:12 -0400
To: linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry.Finger@lwfinger.net
From: Nik Nyby <nikolas@gnu.org>
Subject: rtl8821ae dbi read question
Message-ID: <d46763ef-14d1-a6fa-fb33-a0bd676ef056@gnu.org> (sfid-20171105_002815_907786_38010B28)
Date: Sat, 4 Nov 2017 19:27:52 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c, we have this 
function:

  static u8 _rtl8821ae_dbi_read(struct rtl_priv *rtlpriv, u16 addr)
  {
      u16 read_addr = addr & 0xfffc;
      u8 tmp = 0, count = 0, ret = 0;

      rtl_write_word(rtlpriv, REG_DBI_ADDR, read_addr);
      rtl_write_byte(rtlpriv, REG_DBI_FLAG, 0x2);
      tmp = rtl_read_byte(rtlpriv, REG_DBI_FLAG);
      count = 0;
      while (tmp && count < 20) {
          udelay(10);
          tmp = rtl_read_byte(rtlpriv, REG_DBI_FLAG);
          count++;
      }
      if (0 == tmp) {
          read_addr = REG_DBI_RDATA + addr % 4;
          ret = rtl_read_word(rtlpriv, read_addr);
      }
      return ret;
  }

Near the end of the function, in this line:

   ret = rtl_read_word(rtlpriv, read_addr);

rtl_read_word() returns a u16, but "ret" is declared as a u8. Is that a 
problem, or is this code correct?

What's prompting this question is that I'm getting frequent disconnects 
from my access point with my rtl8821ae device. I've experienced this 
behavior both before and after the recent change to this function in 
commit b8b8b16352cd90c6083033fd4487f04fae935c18.
