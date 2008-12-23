Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:13574 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751050AbYLWOlU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2008 09:41:20 -0500
Message-ID: <20081223094138.jlokt6sr40w448o0-cebfxv@webmail.spamcop.net> (sfid-20081223_154125_334719_45E901D0)
Date: Tue, 23 Dec 2008 09:41:38 -0500
From: Pavel Roskin <proski@gnu.org>
To: Davide Pesavento <davidepesa@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>
Subject: Re: [PATCH] crda: use strerror() to report error code verbosely
References: <20081223050006.3710.98311.stgit@ct.roinet.com>
	<43e72e890812222127k60ade0f1u21263800f9374f52@mail.gmail.com>
	<20081223004945.3437vudqtc0ogcsk-cebfxv@webmail.spamcop.net>
	<43e72e890812222157s5d410d39ye9ac0840eef5331a@mail.gmail.com>
	<20081223012037.otw1xe4tc084coc8-cebfxv@webmail.spamcop.net>
	<2da21fe50812230041q1d844215o589c79c351966e50@mail.gmail.com>
In-Reply-To: <2da21fe50812230041q1d844215o589c79c351966e50@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Davide Pesavento <davidepesa@gmail.com>:

>> [root@ct proski]# COUNTRY=00 crda
>> Failed to set regulatory domain: -22
>> [root@ct proski]# COUNTRY=US crda
>> Failed to set regulatory domain: -22
>> [root@ct proski]# COUNTRY=DE crda
>> Failed to set regulatory domain: -22
>> [root@ct proski]#
>>
>> Maybe it can only be set once?  But then -EBUSY would be more reasonable.
>>
>
> AFAIK, you have to use `iw reg set <country>` to manually change it.

That works.  As I understand now, crda should never be run manually.   
It should only run by the kernel through udev.  If that is correct, it  
should be written clearly in the crda README.

-- 
Regards,
Pavel Roskin
