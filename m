Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:62760 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876AbYFBQTS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jun 2008 12:19:18 -0400
Received: by fg-out-1718.google.com with SMTP id 19so772606fgg.17
        for <linux-wireless@vger.kernel.org>; Mon, 02 Jun 2008 09:19:16 -0700 (PDT)
Date: Mon, 02 Jun 2008 18:19:10 +0200
To: "Emmanuel Grumbach" <egrumbach@gmail.com>
Subject: Re: iwlwifi: Bug - can't connect to WPA PSK access point any more
From: Barteq <barteqpl@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=utf-8;
	format=flowed	delsp=yes
MIME-Version: 1.0
References: <op.ub3jirfui79708@thinkpad> <8704f27d0806020801g1785d067j9c28832a7e5c39e3@mail.gmail.com>
Message-ID: <op.ub4p98zui79708@thinkpad> (sfid-20080602_181922_230311_728B5642)
In-Reply-To: <8704f27d0806020801g1785d067j9c28832a7e5c39e3@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dnia 02-06-2008 o 17:01:29 Emmanuel Grumbach <egrumbach@gmail.com> =20
napisa=C5=82(a):

> can you please check that you have this one ?
>
> 1b7a0e7709ba92423894c612c4dca88bec315a75
> http://git.kernel.org/?p=3Dlinux/kernel/git/linville/wireless-testing=
=2Egit;a=3Dcommit;h=3D1b7a0e7709ba92423894c612c4dca88bec315a75
>
As I see this commit is connected with WEP keys only, but yes - it's =20
already included in my driver version.

> Well, in the meantime, you can load the module with swcrypto=3D1, thi=
s
> will make things work

Sadly not. Same thing with sw and hw crypto.

>> Even today was using wpa-psk network.. based on some newer wrt54gl =20
>> linksys
>> AP - without any serious issues.
>
> This might be because your AP does group key rekeying. I just checked
> with a 1250 Cisco AP, group key rekeying works (I configured the AP t=
o
> do rekeying every 15 seconds...) This might also be because the AP
> implements the rekeying in a funny way (in terms of key indeces), tha=
t
> iwlwifi doesn't know how to deal with (just thinking aloud).
>
> Please send your wpa_supp conf file over.
> Please try to disable the group key rekeying just to see what happens=
=2E...
>

AP wireless security tab

	Security Mode:	 	WPA Pre-shared key=09
  	WPA Algorithms: 	TKIP (only tkip available)
  	WPA Shared Key:	 	*******
  	Group Key Renewal:      3600 seconds

So there is no option to disable group rekeying.. I can only change it'=
s =20
time - 3600 s is default, and maximum value, 600 is minimum.

--8<------
wpa_supplicant.conf:

ctrl_interface=3D/var/run/wpa_supplicant
ctrl_interface_group=3Dadm

ap_scan=3D1
#fast_reauth=3D1
#eapol_version=3D1



network=3D{
#	bssid=3D00:13:10:4a:c6:88
#	scan_ssid=3D1
#	proto=3DWPA
#	key_mgmt=3DWPA-PSK
#	pairwise=3DTKIP
#	group=3DTKIP

	ssid=3D"kretyn.com"
	priority=3D60
	psk=3D0000000_made_wtih_wpa_passphrase_and_my_SSID_0000000000
}

--8<------

With uncommented proto, group and pairwase effect is still the same - n=
o =20
connection.

Regards,
Bartek
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
