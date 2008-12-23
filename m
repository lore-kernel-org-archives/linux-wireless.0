Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:60616 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213AbYLWIlX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2008 03:41:23 -0500
Received: by fg-out-1718.google.com with SMTP id 19so920338fgg.17
        for <linux-wireless@vger.kernel.org>; Tue, 23 Dec 2008 00:41:21 -0800 (PST)
Message-ID: <2da21fe50812230041q1d844215o589c79c351966e50@mail.gmail.com> (sfid-20081223_094127_616031_372BBAC3)
Date: Tue, 23 Dec 2008 09:41:21 +0100
From: "Davide Pesavento" <davidepesa@gmail.com>
To: "Pavel Roskin" <proski@gnu.org>
Subject: Re: [PATCH] crda: use strerror() to report error code verbosely
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org,
	"John W Linville" <linville@tuxdriver.com>
In-Reply-To: <20081223012037.otw1xe4tc084coc8-cebfxv@webmail.spamcop.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20081223050006.3710.98311.stgit@ct.roinet.com>
	 <43e72e890812222127k60ade0f1u21263800f9374f52@mail.gmail.com>
	 <20081223004945.3437vudqtc0ogcsk-cebfxv@webmail.spamcop.net>
	 <43e72e890812222157s5d410d39ye9ac0840eef5331a@mail.gmail.com>
	 <20081223012037.otw1xe4tc084coc8-cebfxv@webmail.spamcop.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 23, 2008 at 07:20, Pavel Roskin <proski@gnu.org> wrote:
> Quoting "Luis R. Rodriguez" <mcgrof@gmail.com>:
>
>> You don't need to build this unless you want to define your own rules.
>
> I see.
>
>> And if you do and want to use the signature stuff you need to copy the
>> RSA public key into pubkeys/ directory of CRDA. Did you try that?
>
> No, I just wanted to install the most current regulatory database.  Perhaps
> the error message should be more clear.
>
> With both CONFIG_CFG80211_REG_DEBUG, CONFIG_WIRELESS_OLD_REGULATORY enabled
> and modular mac80211 and cfg80211, regdomain is set correctly from udev:
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
>

AFAIK, you have to use `iw reg set <country>` to manually change it.

Regards,
Davide Pesavento

> --
> Regards,
> Pavel Roskin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
