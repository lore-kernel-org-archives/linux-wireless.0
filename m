Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39666 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198Ab1LUTig (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 14:38:36 -0500
Received: by ggdk6 with SMTP id k6so5789751ggd.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Dec 2011 11:38:36 -0800 (PST)
Message-ID: <4EF235B9.3020805@lwfinger.net> (sfid-20111221_203840_297428_6B82949B)
Date: Wed, 21 Dec 2011 13:38:33 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Darshan Kumar NANDANWAR <Darshan.KN@st.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: insmod RTL8192CE OOPS on 2.6.32.16
References: <D6068D304DED1F4FBFC1F56ECFA211D85A1EA7BBF0@EAPEX1MAIL1.st.com> <4EF1F32F.8070704@lwfinger.net> <20111221151605.GA11842@tuxdriver.com>
In-Reply-To: <20111221151605.GA11842@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/21/2011 09:16 AM, John W. Linville wrote:

> No, sorry -- I have no idea what that bug was.  I don't even think
> I have the device in question, so I don't know how I could even have
> produced a bug report!

I found a reference at https://lkml.org/lkml/2011/7/28/42. The bug at b.k.o was 
just for tracking.

The fix came with commit b6b67df3f24c45af0012ee, which is dated Jul 29.

This bug is likely not the one causing your problem as the fix should be in 
whatever version you are running. In addition, the oops traceback in that 
instance came back to _rtl_pci_find_adapter(). Yours fails in rtl_pci_probe(). 
Any chance of telling me what statement is at rtl_pci_probe+0x652/0x1660? The 
source file is drivers/net/wireless/rtlwifi/pci.c.

Larry




