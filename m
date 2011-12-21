Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59797 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab1LUOyn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 09:54:43 -0500
Received: by iaeh11 with SMTP id h11so11992230iae.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Dec 2011 06:54:42 -0800 (PST)
Message-ID: <4EF1F32F.8070704@lwfinger.net> (sfid-20111221_155446_435803_33E23944)
Date: Wed, 21 Dec 2011 08:54:39 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Darshan Kumar NANDANWAR <Darshan.KN@st.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: insmod RTL8192CE OOPS on 2.6.32.16
References: <D6068D304DED1F4FBFC1F56ECFA211D85A1EA7BBF0@EAPEX1MAIL1.st.com>
In-Reply-To: <D6068D304DED1F4FBFC1F56ECFA211D85A1EA7BBF0@EAPEX1MAIL1.st.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/21/2011 06:06 AM, Darshan Kumar NANDANWAR wrote:
> Larry ,
>
> I am using RTL8192CE driver for 2.6.32.16 for one of the DTV soc(sh4 cpu) ..
> Once I insert it , I get following oops... The same oops is reported by *John
> Linville in https://bugzilla.kernel.org/show_bug.cgi?id=40212 . But
> unfortunately , given link is down ; so I am unable to get into the the
> discussion. Could you please give me the pointers why it’s happening so?*
>
> Lspci is showing me correct vendor and product id which is : *0x10ec 0x8178*

I added the linux-wireless ML to the Cc list so that others will see this thread.

I do not remember the kernel bugzilla. Perhaps John does.

Are you using a recent version of compat-wireless? If not, please do.

I do not know anything about the sh4, but I will try to help.

The only rtl8192ce routine mentioned in the traceback is rtl92ce_module_init. I 
see no indication that it got as far as the .probe routine, which is 
rtl_pci_probe() in drivers/net/wireless/rtlwifi/pci.c. It might be useful to put 
a printk() at the beginning of that routine to see if it is being reached. I 
would also suggest that you modprobe the various components separately. First 
rtlwifi, then rtl8192c_common, and finally rtl8192ce.

Is the sh4 little- or big-endian? Not all the code has been tested on a BE machine.

Larry
