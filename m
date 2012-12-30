Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f171.google.com ([209.85.223.171]:42201 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083Ab2L3Om4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Dec 2012 09:42:56 -0500
Received: by mail-ie0-f171.google.com with SMTP id 17so14493636iea.30
        for <linux-wireless@vger.kernel.org>; Sun, 30 Dec 2012 06:42:56 -0800 (PST)
MIME-Version: 1.0
From: HariHara Sudhan <hari@emo2.com>
Date: Sun, 30 Dec 2012 06:42:56 -0800
Message-ID: <-1211637985816790459@unknownmsgid> (sfid-20121230_154300_945464_7552B0A8)
Subject: RE: ar3012 bluetooth nor working
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Solved the problem by enabling wext_priv . Since kernel 3.5.4 doesn't
have direct option to enable wext_priv. I had to enable IEEE 802.11
host ap to enable wext_priv.

Sent from my Windows Phone
From: Mohammed Shafi
Sent: 12/30/2012 7:51 PM
To: HariHara Sudhan
Cc: linux-wireless@vger.kernel.org; Mohammed Shafi Shajakhan
Subject: Re: ar3012 bluetooth nor working
On Sat, Dec 8, 2012 at 4:17 PM, HariHara Sudhan <hari@emo2.com> wrote:
> I've a ar9485 +ar3012 combo card and using .
>  Wifi is working fine with ath9k drivers.
> But for bluetooth i've enabled BT_ATH3k use in kernel. And it loaded btusb ,
> bnep, rfcomm modules. ath3k wasn't comming up, and hcitool scan
> results gave me nothing.
> rfkill shows both wwifi and bluetooth devices are not blocked.
>
> so it is told in ath3k drivers guide from your website . i've added
> the id's in ath3k support list and btusb blacklist.
> Now ath3k is loaded when i checked lsmod, and btusb is also loaded .
> But now rfkill is not showing bluetooth device and hcitool scan says
> "Device Not abailable".
> What could be the reason.
> BTW blacklist driverinfo i gave was "BTUSB_IGNORE
>
> --
> Regards
>
> HariHaraSudhan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

you can give us the vid, PID. we can come up with a patch and see if
works for you.


-- 
thanks,
shafi
