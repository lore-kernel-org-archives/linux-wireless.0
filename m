Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:57930 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbZG3SrW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 14:47:22 -0400
Received: by ewy10 with SMTP id 10so989394ewy.37
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2009 11:47:22 -0700 (PDT)
Message-ID: <4A71EAAF.1050706@gmail.com>
Date: Thu, 30 Jul 2009 19:47:11 +0100
From: Dave <kilroyd@googlemail.com>
MIME-Version: 1.0
To: Holger Schurig <hs4233@mail.mn-solutions.de>
CC: linux-wireless@vger.kernel.org, Pavel Roskin <proski@gnu.org>,
	orinoco-devel@lists.sourceforge.net,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] orinoco: enable cfg80211 "set_channel" operation
References: <200907281634.26104.hs4233@mail.mn-solutions.de> <4A6F270A.7030002@gmail.com> <200907290916.31603.hs4233@mail.mn-solutions.de>
In-Reply-To: <200907290916.31603.hs4233@mail.mn-solutions.de>
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Holger Schurig wrote:
> On Tuesday 28 July 2009 18:27:54 Dave wrote:
>> You can also eliminate orinoco_ioctl_setfreq from wext.c with
>> this change.
> 
> You mean this ?!?

Yes, except:

> @@ -1481,7 +1432,6 @@
>  static const iw_handler	orinoco_handler[] = {
>  	STD_IW_HANDLER(SIOCSIWCOMMIT,	orinoco_ioctl_commit),
>  	STD_IW_HANDLER(SIOCGIWNAME,	cfg80211_wext_giwname),
> -	STD_IW_HANDLER(SIOCSIWFREQ,	orinoco_ioctl_setfreq),
+	STD_IW_HANDLER(SIOCSIWFREQ,	cfg80211_wext_setfreq ish),

>  	STD_IW_HANDLER(SIOCGIWFREQ,	orinoco_ioctl_getfreq),
>  	STD_IW_HANDLER(SIOCSIWMODE,	cfg80211_wext_siwmode),
>  	STD_IW_HANDLER(SIOCGIWMODE,	cfg80211_wext_giwmode),
> 
> I tried, but with then an "iwconfig eth1 channel 1" gave me an 
> error. I did not investigate this further.

And as Johannes pointed out, we need to have the non-cfg80211 version so
adhoc connections can still be made via wext.

So the original patch is fine as is. Ack from me.


Dave.
