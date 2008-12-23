Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f13.google.com ([209.85.217.13]:40961 "EHLO
	mail-gx0-f13.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbYLWO5t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2008 09:57:49 -0500
Received: by gxk6 with SMTP id 6so2204170gxk.13
        for <linux-wireless@vger.kernel.org>; Tue, 23 Dec 2008 06:57:48 -0800 (PST)
Message-ID: <43e72e890812230657w58dd2f9an5d1bf7e7a824ff57@mail.gmail.com> (sfid-20081223_155754_043094_26FB22FA)
Date: Tue, 23 Dec 2008 06:57:47 -0800
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Pavel Roskin" <proski@gnu.org>
Subject: Re: [PATCH] crda: use strerror() to report error code verbosely
Cc: "Davide Pesavento" <davidepesa@gmail.com>,
	linux-wireless@vger.kernel.org,
	"John W Linville" <linville@tuxdriver.com>
In-Reply-To: <20081223094138.jlokt6sr40w448o0-cebfxv@webmail.spamcop.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20081223050006.3710.98311.stgit@ct.roinet.com>
	 <43e72e890812222127k60ade0f1u21263800f9374f52@mail.gmail.com>
	 <20081223004945.3437vudqtc0ogcsk-cebfxv@webmail.spamcop.net>
	 <43e72e890812222157s5d410d39ye9ac0840eef5331a@mail.gmail.com>
	 <20081223012037.otw1xe4tc084coc8-cebfxv@webmail.spamcop.net>
	 <2da21fe50812230041q1d844215o589c79c351966e50@mail.gmail.com>
	 <20081223094138.jlokt6sr40w448o0-cebfxv@webmail.spamcop.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 23, 2008 at 6:41 AM, Pavel Roskin <proski@gnu.org> wrote:
> Quoting Davide Pesavento <davidepesa@gmail.com>:
>
>>> [root@ct proski]# COUNTRY=00 crda
>>> Failed to set regulatory domain: -22
>>> [root@ct proski]# COUNTRY=US crda
>>> Failed to set regulatory domain: -22
>>> [root@ct proski]# COUNTRY=DE crda
>>> Failed to set regulatory domain: -22
>>> [root@ct proski]#
>>>
>>> Maybe it can only be set once?  But then -EBUSY would be more reasonable.
>>>
>>
>> AFAIK, you have to use `iw reg set <country>` to manually change it.
>
> That works.  As I understand now, crda should never be run manually.

That is correct.

>  It
> should only run by the kernel through udev.  If that is correct, it should
> be written clearly in the crda README.

Apologies if it is not clear. How's this:

---
 CALLING CRDA -- UDEV
======================

Distributions can set up a udev rule to allow the kernel's regulatory
domain change request to be reviewed by CRDA so CRDA can pass an
appropriate regulatory domain. An example regulatory rule is provided
with this package as regulatory.rules
---

Or the giant diagram here:

http://wireless.kernel.org/en/developers/Regulatory

This also mentions:

---
CRDA

CRDA is our userspace agent which uploads regulatory domains into the
kernel, it acts as a udev helper.
---

Then the CRDA section on the CRDA page has a section:

http://wireless.kernel.org/en/developers/Regulatory/CRDA#LettingthekernelcallCRDA

We also have iw's documentation:

http://wireless.kernel.org/en/users/Documentation/iw#Updatingyourregulatorydomain

The wiki is editable by everyone so feel free to update that, and also
feel free to send patches to the README as you see fit.

  Luis
