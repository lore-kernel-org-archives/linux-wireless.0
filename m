Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:48015 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072Ab1LWQW5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Dec 2011 11:22:57 -0500
Received: by ggdk6 with SMTP id k6so6901524ggd.19
        for <linux-wireless@vger.kernel.org>; Fri, 23 Dec 2011 08:22:56 -0800 (PST)
Message-ID: <4EF4AADC.8090204@lwfinger.net> (sfid-20111223_172300_016086_BD28CD74)
Date: Fri, 23 Dec 2011 10:22:52 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Darshan Kumar NANDANWAR <Darshan.KN@st.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>,
	Srikrishna Pramoda ATIKUKKE <srikrishna.pramodaatikukke@st.com>,
	Darshan Nandanwar <dk.manit@gmail.com>
Subject: Re: insmod RTL8192CE OOPS on 2.6.32.16
References: <D6068D304DED1F4FBFC1F56ECFA211D85A1EA7BBF0@EAPEX1MAIL1.st.com> <4EF1F32F.8070704@lwfinger.net> <20111221151605.GA11842@tuxdriver.com> <4EF235B9.3020805@lwfinger.net> <D6068D304DED1F4FBFC1F56ECFA211D85A1EA7BE7A@EAPEX1MAIL1.st.com> <4EF3559C.9060500@lwfinger.net> <D6068D304DED1F4FBFC1F56ECFA211D85A1EA7C089@EAPEX1MAIL1.st.com>
In-Reply-To: <D6068D304DED1F4FBFC1F56ECFA211D85A1EA7C089@EAPEX1MAIL1.st.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/23/2011 03:02 AM, Darshan Kumar NANDANWAR wrote:
> Larry ,
> Many thanks .Your patch helped me get over that issue.. But now  I am getting following error which is may be because of firmware is not responding:
>
> PCI: Enabling device 0000:00:01.0 (0000 ->  0003)
> rtl8192ce 0000:00:01.0: enabling bus mastering
> PCI: Setting latency timer of device 0000:00:01.0 to 64
> rtl8192ce:rtl92ce_read_eeprom_info():<0-0>  Autoload ERR!!
> rtl8192ce:rtl92c_init_sw_vars():<0-0>  Failed to request firmware!
> rtlwifi:rtl_pci_probe():<0-0>  Can't init_sw_vars.
>
> I have pulled up latest branch  of linux-firmware.git and using firmware rtlwifi/rtl8192cfw.bin located in /lib/firmware .. Please give me some pointers so that I can get over this now...

Please grab the latest version of the compat-wireless sources. That way we will 
not be chasing bugs that are already fixed.

After you get that package implemented, then use "modprobe rtl8192ce debug=4" 
when you load the module, and send me that dmesg output.

Larry


