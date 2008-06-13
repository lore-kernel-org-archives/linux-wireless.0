Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:8550 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189AbYFMUVt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2008 16:21:49 -0400
Received: from poczta.interia.pl (mi02.poczta.interia.pl [10.217.12.2])
	by smtp239.poczta.interia.pl (INTERIA.PL) with ESMTP id D8AD131B033
	for <linux-wireless@vger.kernel.org>; Fri, 13 Jun 2008 22:21:47 +0200 (CEST)
Received: from [192.168.1.7] (d90-129-241-239.cust.tele2.pl [90.129.241.239])
	by poczta.interia.pl (INTERIA.PL) with ESMTP id A57ED2BC11A
	for <linux-wireless@vger.kernel.org>; Fri, 13 Jun 2008 22:21:44 +0200 (CEST)
Message-ID: <4852D6EB.3020304@interia.pl> (sfid-20080613_222154_625180_796235E6)
Date: Fri, 13 Jun 2008 22:22:03 +0200
From: Maciek Kaliszewski <mkalkal@interia.pl>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: iwl3945 and WPA
References: <4852658A.4040402@interia.pl>	 <20080613132317.GB5333@tuxdriver.com>	 <1ba2fa240806130637u1f4b485dked28ce04ff52a9b5@mail.gmail.com>	 <48527D72.4070509@interia.pl> <1213375014.29669.36.camel@dv>
In-Reply-To: <1213375014.29669.36.camel@dv>
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin wrote:
> On Fri, 2008-06-13 at 16:00 +0200, Maciek Kaliszewski wrote:
>
>  =20
>> debian:/home/u# dpkg -l |grep wpa
>> ii  wpasupplicant                        0.6.3-1
>> Client support for WPA and WPA2 (IEEE 802.11
>>
>> It is standard debian/lenny package .
>> Should I compile wpa_supplicant from source ?
>>
>> On other computer debian/lenny also ,and p54pci.ko driver everything
>> works ok.
>>    =20
>
> =EF=BB=BFMake sure you don't have any obsolete version of wpa_supplic=
ant in
> PATH.
>  =20
I've checked and 0.6.3 is latest development version of wpa_supplicant.
> Try removing "scan_ssid=3D1".   Also try ESSID scanning in iwlist:
> iwlist wlan0_rename scanning essid APTEKA
>  =20
 Removing scan_ssid doesn't help .

iwlist wlan0_rename scanning essid APTEKA

gives the same results like

iwlist wlan0_rename scanning
and
iwlist wlan0_rename scanning essid AAAA
so driver ignores essid parameter


> If the recompiled wpa_supplicant fails, try asking in
> hostap@lists.shmoo.com (the list for wpa_supplicant and hostapd)
>
>  =20

It looks like driver issue (driver is returning bogus data)

Selecting BSS from priority group 0
Try to find WPA-enabled AP
0: 00:00:01:00:00:1d ssid=3D'' wpa_ie_len=3D0 rsn_ie_len=3D0 caps=3D0x1=
0
  skip - no WPA/RSN IE
Try to find non-WPA AP
0: 00:00:01:00:00:1d ssid=3D'' wpa_ie_len=3D0 rsn_ie_len=3D0 caps=3D0x1=
0
  skip - SSID mismatch
No suitable AP found

there is no AP with BSSID 00:00:01:00:00:1d and hidden SSID in vicinity=
=20
=2E There is only one (my) AP in the range .
Moreover p54pci.ko driver  (from the  same family  )  works  just fine=20
with  this  version  of  wpa_supplicant .
Command line and config file I run wpa_supplicant with  is the same.

Regards
Maciek Kaliszewski

--


----------------------------------------------------------------------
Tania telefonia internetowa!
Sprawdz >>>  http://link.interia.pl/f1e2e

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
