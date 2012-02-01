Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:37186 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787Ab2BALOJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Feb 2012 06:14:09 -0500
Received: by vcge1 with SMTP id e1so876125vcg.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 Feb 2012 03:14:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAD2nsn2RTzkx_1ApoyPixfim6j5sY7kscW4QAzoVu49HyTNJjA@mail.gmail.com>
References: <CAAJ3AHeF5-yD_+a6HiA3Ty-yjizM4hOqS+nnZimbJULuX0s--A@mail.gmail.com>
	<CAD2nsn2RTzkx_1ApoyPixfim6j5sY7kscW4QAzoVu49HyTNJjA@mail.gmail.com>
Date: Wed, 1 Feb 2012 16:44:08 +0530
Message-ID: <CAD2nsn0c=cUdD8kQWNprGr7GJ6t1Y+c=LA2KZ+sSVgrsb3oedQ@mail.gmail.com> (sfid-20120201_121413_421233_0E509085)
Subject: Re:
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Laurent Bonnans <bonnans.l@gmail.com>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 31, 2012 at 11:28 AM, Mohammed Shafi
<shafi.wireless@gmail.com> wrote:
> On Tue, Jan 31, 2012 at 1:13 AM, Laurent Bonnans <bonnans.l@gmail.com> wrote:
>> Since the update from linux 3.2.1 to 3.2.2, dhcp stopped working on
>> some APs on my laptop with an AR9285 Wireless card.
>>
>> dhcp works fine on an open wifi network but receives no response on a
>> wep network I use. I haven't been able to test it on a third network
>> for now.
>
>  reverting  "ath9k_hw: fix interpretation of the rx KeyMiss flag" does
> helps.  i  need to analyze
> if it exposes some real issue which need to be fixed.
>

this seems to be a problem in WEP alone, where the key miss is always
set for this case and RX_FLAG_DECRYPTED is not set. mac80211 trys to
decrypt,  but fails due to ICV mismatch.

-- 
shafi
