Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from correio.ufra.edu.br ([200.129.150.6]:45312 "EHLO
	correio.ufra.edu.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbZILWnr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Sep 2009 18:43:47 -0400
Received: from localhost (localhost [127.0.0.1])
	by correio.ufra.edu.br (Postfix) with ESMTP id 83EF57A4D2
	for <linux-wireless@vger.kernel.org>; Sat, 12 Sep 2009 19:46:25 -0300 (BRT)
Received: from correio.ufra.edu.br ([127.0.0.1])
	by localhost (correio.ufra.edu.br [127.0.0.1]) (amavisd-new, port 10025)
	with LMTP id vfCM0iuqUfft for <linux-wireless@vger.kernel.org>;
	Sat, 12 Sep 2009 19:46:16 -0300 (BRT)
Received: from [192.168.254.5] (unknown [189.82.217.205])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by correio.ufra.edu.br (Postfix) with ESMTP id D54A97A4B4
	for <linux-wireless@vger.kernel.org>; Sat, 12 Sep 2009 19:46:15 -0300 (BRT)
Message-ID: <4AAC240E.20104@ufra.edu.br>
Date: Sat, 12 Sep 2009 19:43:26 -0300
From: "Leonardo H. Souza Hamada" <leonardo.hamada@ufra.edu.br>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: zd1211rw on ppc (iBook G4) -- Solved, somewhat)
References: <4A9BFCCB.6040808@ufra.edu.br>	 <3ace41890908311025r3ce83c12gd6aeace4833609b1@mail.gmail.com>	 <4A9C0ADC.6050607@ufra.edu.br> <3ace41890908311126m5212926cl27172ae775fc92f2@mail.gmail.com> <4A9D7DC0.6050701@ufra.edu.br>
In-Reply-To: <4A9D7DC0.6050701@ufra.edu.br>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

At this moment, after tweaking the zd1211rw code in kernel
2.6.31-gentoo, finally I am able to use the WLI-U2-KG54L wireless usb
dongle on this old ibook.

Browsing the source with a cross referencing tool
(http://lxr.free-electrons.com) and making additional checking points, I
could trace the issue as follow.

The problem is that this device returns a regulatory region of 0x49,
which is not defined in the zd1211rw tables. So the call

r <http://lxr.free-electrons.com/ident?i=r> = zd_reg2alpha2 <http://lxr.free-electrons.com/ident?i=zd_reg2alpha2>(mac <http://lxr.free-electrons.com/ident?i=mac>->regdomain, alpha2);

will fail the initialization process.


Workaround:

----snip----
int zd_mac_init_hw(struct ieee80211_hw *hw)
{
...
        r = zd_read_regdomain(chip, &default_regdomain);
        /* A unknown regulatory of 0x49 will be set default to
ZD_REGDOMAIN_FCC. */
        if (0x49 == default_regdomain)
                default_regdomain = ZD_REGDOMAIN_FCC;
...
----snip----

The above code will force the default regulatry to be FCC code for this
case. I think that this was the case in previous zd1211rw driver. What
is the country code for 0x49 region? There is a better way?


Thanks all,

Phew!! Leonardo




