Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:37331 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756874Ab3CYTLa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Mar 2013 15:11:30 -0400
Received: by mail-ob0-f176.google.com with SMTP id er7so2776733obc.35
        for <linux-wireless@vger.kernel.org>; Mon, 25 Mar 2013 12:11:29 -0700 (PDT)
Message-ID: <5150A15F.20600@lwfinger.net> (sfid-20130325_201134_175856_AB106A45)
Date: Mon, 25 Mar 2013 14:11:27 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Vincent Brillault <gentoo@lerya.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: Warnings with ASUS PCE-N15 (RTL8188CE)
References: <20130307192920.GB8668@Fea.lerya.net> <20130308215833.GA2829@Fea.lerya.net> <513A960B.2020304@lwfinger.net> <20130309113222.GA3009@Fea.lerya.net> <513B7E58.9000505@lwfinger.net> <20130311183825.GG3009@Fea.lerya.net> <20130313080048.GB3484@Fea.lerya.net> <20130317141201.GA2557@Fea.lerya.net> <20130325182910.GA10274@Fea.lerya.net>
In-Reply-To: <20130325182910.GA10274@Fea.lerya.net>
Content-Type: multipart/mixed;
 boundary="------------020108060701000905000104"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020108060701000905000104
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 03/25/2013 01:29 PM, Vincent Brillault wrote:
> Hi Larry and everyone else on the list,
>
> I've seen your 25 patches and applied them in hope my problems were
> resolved. They are not :'(
>
> I've tried to look further, I think that the root of this problem is in
> core.c, in the rtl_op_bss_info_changed function. This function make a
> call to get_sta on the new bssid. The problem is that at this point, the
> sta is still not inserted, thus cannot be accessed by this method. As
> far as I understand the code, this specific rtl_op_bss_info_changed is
> responsible for setting rtlmac->mode, which explains why this mode is
> never set on my system.

I think the difference in our two systems is in the use of NetworkManager and 
the associated applet. With it, rtl_op_bss_info_changed() does not seem to be 
called before sta is ready.

Attached is a patch that will force mac->mode when sta has not been established. 
Perhaps that will be enough.

It not, I will need to set up your distro and run the wireless exactly the way 
you do to duplicate your results. Please provide the distro name and version, 
the architecture, the sequence of commands, and the contents of any special 
scripts you run.

Larry



--------------020108060701000905000104
Content-Type: text/plain; charset=UTF-8;
 name="rtlwifi_fix_core"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="rtlwifi_fix_core"

Index: wireless-testing-save/drivers/net/wireless/rtlwifi/core.c
===================================================================
--- wireless-testing-save.orig/drivers/net/wireless/rtlwifi/core.c
+++ wireless-testing-save/drivers/net/wireless/rtlwifi/core.c
@@ -832,6 +832,7 @@ static void rtl_op_bss_info_changed(stru
 		rcu_read_lock();
 		sta = get_sta(hw, vif, bss_conf->bssid);
 		if (!sta) {
+			mac->mode = WIRELESS_MODE_G;
 			rcu_read_unlock();
 			goto out;
 		}

--------------020108060701000905000104--
