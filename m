Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eggs.gnu.org ([208.118.235.92]:38141 "EHLO eggs.gnu.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750750AbdKEVP7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 5 Nov 2017 16:15:59 -0500
Received: from Debian-exim by eggs.gnu.org with spam-scanned (Exim 4.71)
        (envelope-from <nikolas@gnu.org>)
        id 1eBSGn-0003T4-K5
        for linux-wireless@vger.kernel.org; Sun, 05 Nov 2017 16:15:58 -0500
Subject: Re: rtl8821ae dbi read question
To: Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org, pkshih@realtek.com
References: <d46763ef-14d1-a6fa-fb33-a0bd676ef056@gnu.org>
 <695fe947-7b0d-ef4b-5e90-ff503df6a08b@lwfinger.net>
From: Nik Nyby <nikolas@gnu.org>
Message-ID: <6912fa90-4b21-c325-993b-27fed3c75293@gnu.org> (sfid-20171105_221602_655276_509255BE)
Date: Sun, 5 Nov 2017 16:15:36 -0500
MIME-Version: 1.0
In-Reply-To: <695fe947-7b0d-ef4b-5e90-ff503df6a08b@lwfinger.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I also want to note that adding rtl8821ae.aspm=0 to my grub kernel boot 
command doesn't fix my problem. (I'm building this driver into the 
kernel, not as a module). My connection dropping problem is fixed only 
if I comment out the aspm init code in the driver, per this patch:
   https://patchwork.kernel.org/patch/9951511/
