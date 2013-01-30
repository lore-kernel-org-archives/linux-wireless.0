Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f47.google.com ([209.85.219.47]:42802 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481Ab3A3Uay (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2013 15:30:54 -0500
Received: by mail-oa0-f47.google.com with SMTP id o17so579788oag.34
        for <linux-wireless@vger.kernel.org>; Wed, 30 Jan 2013 12:30:54 -0800 (PST)
Message-ID: <510982FA.3010401@lwfinger.net> (sfid-20130130_213100_786482_4934022A)
Date: Wed, 30 Jan 2013 14:30:50 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Dylan <dylandonkersgoed@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: rtl8723ae Weak Signal Problems
References: <51072B15.2030805@gmail.com> <51072B95.10101@gmail.com> <51080904.5000103@lwfinger.net> <51095E55.3020106@gmail.com>
In-Reply-To: <51095E55.3020106@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/30/2013 11:54 AM, Dylan wrote:

Please do not drop the Cc to wireless.

> I apologize for the late response and limited information.
>
> The patch doesn't work for me - same problems as before, i.e. the patch doesn't
> seem to have changed anything. I attached a log. I expect you can make more
> sense of it than I.
>
> I can give you the model number of only one of the router/access points - the
> Cisco DPC3825 which I have. Unfortunately I can't offer much analysis of it as
> it's in modem only mode now and it's not very practical to reactivate it as an
> access point at this time. I could try to find out what my school is using as well.
>
> I've noticed that with the compat wireless drivers I'm ALSO experiencing similar
> problems with an RTL8188CU card. I expect that's relevant. Funnily enough I have
> three wireless cards on hand and all of them are some form of Realtek card.

The vendor driver you are using, 
/rtl_92ce_92se_92de_8723ae_linux_mac80211_0006.0514.2012/, is relatively old. My 
patches were for rtl_92ce_92se_92de_8723ae_88ee_linux_mac80211_0010.0109.2013, 
however, since I wrote earlier, I found 
rtl_92ce_92se_92de_8723ae_88ee_linux_mac80211_0011.0128.2013, which you will 
find on the Realtek web site under the RTL8188CE listing for Linux. That one 
includes my feedback to Realtek about the 01092013 version, and it should build 
on mainline kernels through 3.8, but not the current wireless-testing, but I 
doubt that you are using that tree. With that driver, my RTL8723AE got 
throughput of 60-70 Mbps for both RX and TX. I did have an unexplained kernel 
panic while running that driver, thus there might be a severe bug in it. I don't 
know if it is rtl8723e, but that is the only panic that I have had with 3.8-rc4.

The driver for the RTL8188CU/RTL8192CU is a mess. Unfortunately, I am not 
getting musch help from Realtek. For that reason, I am concentrating on the CE 
models. Their PCIe group is more responsive.

Larry

