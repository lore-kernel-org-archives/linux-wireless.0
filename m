Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f195.google.com ([209.85.217.195]:33508 "EHLO
	mail-lb0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbbFKGdr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2015 02:33:47 -0400
Received: by lbio15 with SMTP id o15so7782819lbi.0
        for <linux-wireless@vger.kernel.org>; Wed, 10 Jun 2015 23:33:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4e93e535617121ba802385eef13b9ef7@lanada.kaist.ac.kr>
References: <1433913284-18444-1-git-send-email-janusz.dziedzic@tieto.com>
	<911fece613ad9dd7975e53ac808fd495@lanada.kaist.ac.kr>
	<CALhHN=qf=frYc2iLQWs5AyJncxACa3fuBeXChE7_K+rTS8w7VQ@mail.gmail.com>
	<4e93e535617121ba802385eef13b9ef7@lanada.kaist.ac.kr>
Date: Thu, 11 Jun 2015 08:33:46 +0200
Message-ID: <CAFED-jkdYZaKiEY9RWHTh0+MthbsQri8EhmQZ1j-tjcvzjSVdg@mail.gmail.com> (sfid-20150611_083351_282300_A66853D4)
Subject: Re: [PATCH v2] ath10k: enable VHT for IBSS
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
To: Sangwoo Moon <swmoon@lanada.kaist.ac.kr>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath10k <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2015-06-11 8:32 GMT+02:00 Sangwoo Moon <swmoon@lanada.kaist.ac.kr>:
> Hello,
>
> I have successfully installed the latest version of ath10k driver from
> backports.
>
> However, I have some difficulties on configuring wpa_supplicant for IBSS VHT
> mode.
> Looked at wpa_supplicant configuration file, but I couldn't found any option
> related to explicit setting VHT (though I've found disable_vht instead)
>
> Sorry for annoying questions, but can you help this out?
> At least you could let me know your configuration of wpa_supplicant.
>
supplicant by default setup wildest BW, no special parameter required
for IBSS VHT

network = {
    ssid="ibss"
    mode=1
    key_mgmt=NONE
    frequency=5180
}

Just use latest version of wpa_supplicant.
next check you have 80MHz BW
iw wlan0 info


BR
Janusz
