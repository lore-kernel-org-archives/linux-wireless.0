Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37778 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757782Ab0LBXcL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 18:32:11 -0500
Received: by gyb11 with SMTP id 11so4474432gyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Dec 2010 15:32:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4CF7AC31.2020206@gmx.net>
References: <4CF66912.8050302@gmx.net>
	<4CF7AC31.2020206@gmx.net>
Date: Fri, 3 Dec 2010 01:32:08 +0200
Message-ID: <AANLkTi=z9uhX-ZU-gn3X_3UKhPb4KRaia-TzHiXF4fOe@mail.gmail.com>
Subject: Re: EAP Identity Response dropped on 5GHz
From: Eliad Peller <eliad@wizery.com>
To: Wolfgang Breyha <wbreyha@gmx.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi Wolfgang,

On Thu, Dec 2, 2010 at 4:24 PM, Wolfgang Breyha <wbreyha@gmx.net> wrote:
> But introducing a usleep(100000) in
> wpa_supplicant/src/eap_peer/eap.c:136, or in other words....
>> wpa_supplicant logs:
>>
>>> 1291215721.998646: Process pending EAPOL frame that was received just before association notification
>>> 1291215721.998677: RX EAPOL from 00:26:cb:xx:xx:xx
>>> 1291215721.998713: Setting authentication timeout: 70 sec 0 usec
>>> 1291215721.998747: EAPOL: Received EAP-Packet frame
>>> 1291215721.998778: EAPOL: SUPP_PAE entering state RESTART
>>> 1291215721.998806: EAP: EAP entering state INITIALIZE
> ............ HERE ................
>>> 1291215721.998835: EAP: EAP entering state IDLE
>>> 1291215721.998865: EAPOL: SUPP_PAE entering state AUTHENTICATING
>>> 1291215721.998895: EAPOL: SUPP_BE entering state REQUEST
>>> 1291215721.998924: EAPOL: getSuppRsp
>>> 1291215721.998952: EAP: EAP entering state RECEIVED

>
> I haven't found the source of this race condition which causes this. The
> reason why it only happens on 5GHz channels is unknown as well.
>

sounds a bit similar to another case i've encountered:
http://lists.shmoo.com/pipermail/hostap/2010-November/021940.html

Eliad.
