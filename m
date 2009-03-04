Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.228]:50350 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755318AbZCDSxG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Mar 2009 13:53:06 -0500
Received: by rv-out-0506.google.com with SMTP id g37so3442320rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 04 Mar 2009 10:53:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <43e72e890903031852u755677a9se177f6177ef13633@mail.gmail.com>
References: <49ADEB0D.6070100@impulze.org>
	 <43e72e890903031852u755677a9se177f6177ef13633@mail.gmail.com>
Date: Wed, 4 Mar 2009 10:53:04 -0800
Message-ID: <43e72e890903041053m3a8f2de4hf4b04ab08f665d77@mail.gmail.com> (sfid-20090304_195316_108975_616B1B9D)
Subject: Re: CRDA_PATH fixes for wireless-regdb.git
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Daniel Mierswa <impulze@impulze.org>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 3, 2009 at 6:52 PM, Luis R. Rodriguez <mcgrof@gmail.com> wr=
ote:
> On Tue, Mar 3, 2009 at 6:44 PM, Daniel Mierswa <impulze@impulze.org> =
wrote:
>> Heya, i just found that there was a typo in your Makefile and
>> debian-examples dir.
>> I fixed those plus also give the user the chance to override CRDA_PA=
TH
>> (I use /lib64 since I like the idea of having all necessary stuff to=
 get
>> wireless connected in superuser reach). :)
>> Feedback welcomed.
>>
>> --
>> Mierswa, Daniel
>>
>> If you still don't like it, that's ok: that's why I'm boss. I simply
>> know better than you do.
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 --- Linus Torvalds,=
 comp.os.linux.advocacy, 1996/07/22
>>
>>
>>
>> From 14a0da690de4e8803809f5da970b42c953990f03 Mon Sep 17 00:00:00 20=
01
>> From: Daniel Mierswa <impulze@impulze.org>
>> Date: Thu, 5 Feb 2009 02:11:41 +0100
>> Subject: [PATCH] CDRA_PATH typo, also let user override CRDA_PATH
>>
>> ---
>> =C2=A0Makefile =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 | =C2=A0 =C2=
=A06 +++---
>> =C2=A0debian-example/rules | =C2=A0 =C2=A06 +++---
>> =C2=A02 files changed, 6 insertions(+), 6 deletions(-)
>>
>> diff --git a/Makefile b/Makefile
>> index a719f59..32626a1 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -1,6 +1,6 @@
>> =C2=A0# Install prefix
>> =C2=A0PREFIX =3D /usr
>> -CDRA_PATH =3D $(PREFIX)/lib/crda
>> +CRDA_PATH ?=3D $(PREFIX)/lib/crda
>>
>> =C2=A0MANDIR ?=3D $(PREFIX)/share/man/
>>
>> @@ -32,7 +32,7 @@ key.priv.pem:
>> =C2=A0# Distributions wishing to just use John's database
>> =C2=A0# can just call make install.
>> =C2=A0install: regulatory.bin.5.gz
>> - =C2=A0 =C2=A0 =C2=A0 install -o 0 -g 0 -m 755 -d $(DESTDIR)/$(CDRA=
_PATH)
>> - =C2=A0 =C2=A0 =C2=A0 install -o 0 -g 0 -m 644 regulatory.bin $(DES=
TDIR)/$(CDRA_PATH)/regulatory.bin
>> + =C2=A0 =C2=A0 =C2=A0 install -o 0 -g 0 -m 755 -d $(DESTDIR)/$(CRDA=
_PATH)
>> + =C2=A0 =C2=A0 =C2=A0 install -o 0 -g 0 -m 644 regulatory.bin $(DES=
TDIR)/$(CRDA_PATH)/regulatory.bin
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0mkdir -p $(DESTDIR)/$(MANDIR)/man5/
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0install -m 644 -t $(DESTDIR)/$(MANDIR)/ma=
n5/ regulatory.bin.5.gz
>> diff --git a/debian-example/rules b/debian-example/rules
>> index dab9255..34a08a5 100755
>> --- a/debian-example/rules
>> +++ b/debian-example/rules
>> @@ -3,8 +3,8 @@
>> =C2=A0include /usr/share/cdbs/1/rules/debhelper.mk
>>
>> =C2=A0PREFIX =3D /usr
>> -CDRA_LIB =3D $(PREFIX)/lib/crda
>> +CRDA_LIB ?=3D $(PREFIX)/lib/crda
>>
>> =C2=A0install/wireless-regdb::
>> - =C2=A0 =C2=A0 =C2=A0 install -o 0 -g 0 -m 755 -d debian/$(cdbs_cur=
pkg)/$(CDRA_LIB)
>> - =C2=A0 =C2=A0 =C2=A0 install -o 0 -g 0 -m 644 regulatory.bin debia=
n/$(cdbs_curpkg)/$(CDRA_LIB)/regulatory.bin
>> + =C2=A0 =C2=A0 =C2=A0 install -o 0 -g 0 -m 755 -d debian/$(cdbs_cur=
pkg)/$(CRDA_LIB)
>> + =C2=A0 =C2=A0 =C2=A0 install -o 0 -g 0 -m 644 regulatory.bin debia=
n/$(cdbs_curpkg)/$(CRDA_LIB)/regulatory.bin
>> --
>
> Patch doesn't apply.
>
> mcgrof@tesla ~/devel/crda (git::master)$ git describe
> v1.0.1-10-g479ca1d
>
> mcgrof@tesla ~/devel/crda (git::master)$ patch -p1 <
> ../../patches/crda-fix-path.patch
> patching file Makefile
> Hunk #1 FAILED at 1.
> Hunk #2 FAILED at 32.
> 2 out of 2 hunks FAILED -- saving rejects to file Makefile.rej
> patching file debian-example/rules
> Hunk #1 FAILED at 3.
> 1 out of 1 hunk FAILED -- saving rejects to file debian-example/rules=
=2Erej

This patch is for John, not me.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
