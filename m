Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:9658 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648AbYLWGUV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2008 01:20:21 -0500
Message-ID: <20081223012037.otw1xe4tc084coc8-cebfxv@webmail.spamcop.net> (sfid-20081223_072033_345576_AF58A0A0)
Date: Tue, 23 Dec 2008 01:20:37 -0500
From: Pavel Roskin <proski@gnu.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>
Subject: Re: [PATCH] crda: use strerror() to report error code verbosely
References: <20081223050006.3710.98311.stgit@ct.roinet.com>
	<43e72e890812222127k60ade0f1u21263800f9374f52@mail.gmail.com>
	<20081223004945.3437vudqtc0ogcsk-cebfxv@webmail.spamcop.net>
	<43e72e890812222157s5d410d39ye9ac0840eef5331a@mail.gmail.com>
In-Reply-To: <43e72e890812222157s5d410d39ye9ac0840eef5331a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting "Luis R. Rodriguez" <mcgrof@gmail.com>:

> You don't need to build this unless you want to define your own rules.

I see.

> And if you do and want to use the signature stuff you need to copy the
> RSA public key into pubkeys/ directory of CRDA. Did you try that?

No, I just wanted to install the most current regulatory database.   
Perhaps the error message should be more clear.

With both CONFIG_CFG80211_REG_DEBUG, CONFIG_WIRELESS_OLD_REGULATORY  
enabled and modular mac80211 and cfg80211, regdomain is set correctly  
from udev:

[    7.642548] cfg80211: Using static regulatory domain info
[    7.642551] cfg80211: Regulatory domain: US
[    8.697261] cfg80211: Regulatory domain changed to country: US

However, changing it to anything doesn't work:

[root@ct proski]# COUNTRY=00 crda
Failed to set regulatory domain: -22
[root@ct proski]# COUNTRY=US crda
Failed to set regulatory domain: -22
[root@ct proski]# COUNTRY=DE crda
Failed to set regulatory domain: -22
[root@ct proski]#

Maybe it can only be set once?  But then -EBUSY would be more reasonable.

-- 
Regards,
Pavel Roskin
