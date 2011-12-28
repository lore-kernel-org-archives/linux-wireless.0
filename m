Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout4.freenet.de ([195.4.92.94]:39172 "EHLO mout4.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754614Ab1L1WDf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Dec 2011 17:03:35 -0500
Received: from [195.4.92.141] (helo=mjail1.freenet.de)
	by mout4.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.76 #1)
	id 1Rg1aw-0005lf-2t
	for linux-wireless@vger.kernel.org; Wed, 28 Dec 2011 23:03:34 +0100
Received: from localhost ([::1]:57688 helo=mjail1.freenet.de)
	by mjail1.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1Rg1av-00061G-VN
	for linux-wireless@vger.kernel.org; Wed, 28 Dec 2011 23:03:34 +0100
Received: from [195.4.92.28] (port=57892 helo=18.mx.freenet.de)
	by mjail1.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1Rg1Yt-0005Ug-LY
	for linux-wireless@vger.kernel.org; Wed, 28 Dec 2011 23:01:27 +0100
Received: from p4fde0638.dip0.t-ipconnect.de ([79.222.6.56]:42059 helo=mail.maya.org)
	by 18.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.76 #1)
	id 1Rg1Yt-0001FC-9Y
	for linux-wireless@vger.kernel.org; Wed, 28 Dec 2011 23:01:27 +0100
Message-ID: <4EFB91B0.2070800@01019freenet.de> (sfid-20111228_230339_321780_5ABF2A0C)
Date: Wed, 28 Dec 2011 23:01:20 +0100
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: Gertjan van Wingerde <gwingerde@gmail.com>
CC: Ivo Van Doorn <ivdoorn@gmail.com>,
	John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	=?ISO-8859-2?Q?Jakub_Kici=F1ski?= <kubakici@wp.pl>
Subject: Re: [PATCH 4/7] rt2800usb: Let rt2x00usb handle USB padding
References: <1325033604-26469-1-git-send-email-gwingerde@gmail.com> <1325033604-26469-2-git-send-email-gwingerde@gmail.com> <1325033604-26469-3-git-send-email-gwingerde@gmail.com> <1325033604-26469-4-git-send-email-gwingerde@gmail.com> <1325033604-26469-5-git-send-email-gwingerde@gmail.com> <CAOZOX0XauBTyaBR9j75de=BeTZ1v_rRfgdJc7BPYDsA9HYi-2w@mail.gmail.com> <4EFB7F6B.8050104@gmail.com>
In-Reply-To: <4EFB7F6B.8050104@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gertjan van Wingerde schrieb:
> On 12/28/11 21:12, Ivo Van Doorn wrote:
>> On Wed, Dec 28, 2011 at 1:53 AM, Gertjan van Wingerde
>> <gwingerde@gmail.com> wrote:
>>> From: Jakub Kiciñski <kubakici@wp.pl>
>>>
>>> Older USB drivers does not append end padding to skb but instead report
>>> it in size of data to be transmitted to HW. rt2800usb should follow that
>>> behaviour. Custom write_tx_data callback which was adding pad to skb
>>> is not be needed any more.
>>>
>>> Thanks to this patch frames handed back from rt2800usb to mac80211 will
>>> no longer contain end padding.
>>
>> What happened to the reports that after this (and the next) patch, the
>> non-2800 USB
>> drivers are failing?
> 
> I have seen only 1 failure report (from Andreas Hartmann), which seemed
> to have been caused by not applying both patches. ISTR that Andreas did
> not see any regression when both patches were applied.

Yes, that's true. The behavior of a rt3572 dongle in my test with both
patches applied was the same as without these both patches.

Please note that the test I did was very short, because the rt2800usb
driver works really bad with this device anyway.



Kind regards,
Andreas Hartmann
