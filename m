Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f54.google.com ([209.85.214.54]:36570 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758939Ab3DBRln (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Apr 2013 13:41:43 -0400
Received: by mail-bk0-f54.google.com with SMTP id q16so347488bkw.41
        for <linux-wireless@vger.kernel.org>; Tue, 02 Apr 2013 10:41:42 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Juan Carlos Garza Fernandez <juancarlosgarza@gmail.com>
Subject: Re: Status of the RTL8712 staging driver
Date: Tue, 2 Apr 2013 19:41:36 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
References: <CAMEN=G4gwKC5oTbJyDfU4QcnO+EAff+nGsj+++AH0ip4eVV3MA@mail.gmail.com>
In-Reply-To: <CAMEN=G4gwKC5oTbJyDfU4QcnO+EAff+nGsj+++AH0ip4eVV3MA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201304021941.37133.chunkeey@googlemail.com> (sfid-20130402_194147_578594_CBCA98B1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, April 02, 2013 02:51:19 PM Juan Carlos Garza Fernandez wrote:
> Now I have another question regarding the 8712 driver which has been
> in staging forever.
> 
> In your opinion, are there any chances that it will be improved to
> reach the mainline level?
Hopefully yes. You can download a git-repository with the latest driver
from: <https://github.com/chunkeey/rtl8192su>

The latest incarnation "r92su" is currently the best bet on getting a
proper driver into the mainline. Unlike its predecessor rtl8192su it
uses cfg80211 directly (yes, unfortunately. it is a stand-alone driver
with no dependencies on rtlwifi).

what works with r92su:
	Station Mode & passive monitor
	802.11b/g/n (yes, HT is working - in both directions)
	WEP40/104,TKIP and CCMP (WPA and WPA2 works)
	Defragmentation
	QoS/WMM
	ERP

What isn't:
	AD-Hoc
	Fragmentation (also broken in r8712u... It would work, if the fw
	wouldn't override the sequence counter on out-going frames)
	SDIO transport
 
> If so, would it be possible to use it as an access point with HostAPD,
> or is it limited by the firmware?
Apparently there is a AP firmware. But you have to ask Realtek for the
right firmware.

Regards,
	Christian
