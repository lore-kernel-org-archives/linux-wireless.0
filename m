Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:34438 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751878AbYLWGW2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2008 01:22:28 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 22 Dec 2008 22:22:28 -0800
Date: Mon, 22 Dec 2008 22:22:19 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Pavel Roskin <proski@gnu.org>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	John W Linville <linville@tuxdriver.com>
Subject: Re: [PATCH] crda: use strerror() to report error code verbosely
Message-ID: <20081223062219.GT10807@tesla> (sfid-20081223_072232_833096_80F89542)
References: <20081223050006.3710.98311.stgit@ct.roinet.com> <43e72e890812222127k60ade0f1u21263800f9374f52@mail.gmail.com> <20081223004945.3437vudqtc0ogcsk-cebfxv@webmail.spamcop.net> <43e72e890812222157s5d410d39ye9ac0840eef5331a@mail.gmail.com> <20081223012037.otw1xe4tc084coc8-cebfxv@webmail.spamcop.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20081223012037.otw1xe4tc084coc8-cebfxv@webmail.spamcop.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 22, 2008 at 10:20:37PM -0800, Pavel Roskin wrote:
> Quoting "Luis R. Rodriguez" <mcgrof@gmail.com>:
> 
> > You don't need to build this unless you want to define your own rules.
> 
> I see.
> 
> > And if you do and want to use the signature stuff you need to copy the
> > RSA public key into pubkeys/ directory of CRDA. Did you try that?
> 
> No, I just wanted to install the most current regulatory database.
> Perhaps the error message should be more clear.
> 
> With both CONFIG_CFG80211_REG_DEBUG, CONFIG_WIRELESS_OLD_REGULATORY
> enabled and modular mac80211 and cfg80211, regdomain is set correctly
> from udev:
> 
> [    7.642548] cfg80211: Using static regulatory domain info
> [    7.642551] cfg80211: Regulatory domain: US
> [    8.697261] cfg80211: Regulatory domain changed to country: US
> 
> However, changing it to anything doesn't work:
> 
> [root@ct proski]# COUNTRY=00 crda
> Failed to set regulatory domain: -22
> [root@ct proski]# COUNTRY=US crda
> Failed to set regulatory domain: -22
> [root@ct proski]# COUNTRY=DE crda
> Failed to set regulatory domain: -22
> [root@ct proski]#
> 
> Maybe it can only be set once?  But then -EBUSY would be more reasonable.

rm -rf on your wireless-regdb git tree and then git checkout -f. Then cp that regulatory.bin
to the REG_BIN location and try to build that CRDA. Then try that CRDA.

  Luis
