Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:34487 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755548Ab3J1JX0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Oct 2013 05:23:26 -0400
Received: by mail-wi0-f182.google.com with SMTP id ez12so3616888wid.15
        for <linux-wireless@vger.kernel.org>; Mon, 28 Oct 2013 02:23:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <526E20EA.9090203@rempel-privat.de>
References: <CAMP44s1XJRHV8bAX=_-TkSKMkY8Nw1=eHorqTCZ2QmtR5m8uJA@mail.gmail.com>
 <526E20EA.9090203@rempel-privat.de>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Mon, 28 Oct 2013 14:53:05 +0530
Message-ID: <CABPxzYJ8HpdwOYZ4hA40m3MOo_r7CwktzzpM9g6SLdPf6Rkqjg@mail.gmail.com> (sfid-20131028_102337_256223_03040333)
Subject: Re: I always need a miracle to connect with iwlwifi
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
	linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
	ilw@linux.intel.com,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 28, 2013 at 2:01 PM, Oleksij Rempel <linux@rempel-privat.de> wrote:
>> I logged a session [2] where I waited 30 minutes for the link to come
>> up, but it never did. You can see the same thing happening over and
>> over:
>>
>> 1382936199.582861: nl80211: Association request send successfully
>> 1382936199.797063: nl80211: Event message available
>> 1382936199.797097: nl80211: Delete station e0:1d:3b:46:82:a0
>> 1382936199.797881: nl80211: Event message available
>> 1382936199.797905: nl80211: MLME event 38; timeout with e0:1d:3b:46:82:a0
>> 1382936199.797915: wlan0: Event ASSOC_TIMED_OUT (15) received
>> 1382936199.797920: wlan0: SME: Association timed out
>> 1382936199.797924: Added BSSID e0:1d:3b:46:82:a0 into blacklist
>>
>> If I reboot the router, it works immediately, another thing that works
>> is connecting with ad-hoc mode (mode=1), and then back to normal mode
>> (mode=0).
>>
Looks like there is "maximum clients" feature is enabled in the AP, most AP's
send deauth for Auth/Assoc Request but some AP's silently discard the
Assoc Request.

That explains why it works after reboot/adhoc mode. Try increasing the
number if thats the case.
