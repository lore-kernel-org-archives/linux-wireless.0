Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:50430 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab1GTLyb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jul 2011 07:54:31 -0400
Received: by qwk3 with SMTP id 3so69361qwk.19
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jul 2011 04:54:30 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUXFwP7QM2JY8HzCjNEAbyVhr6K1K_AMDMKE2x+5wwWvuA@mail.gmail.com>
References: <20110715002155.14332.3527.stgit@mj.roinet.com>
	<CAFtRNNy3SvLXUJ8uaOibGfnynS7gwCOMW2x=cLhfPDf9aNw4vQ@mail.gmail.com>
	<CA+icZUXFwP7QM2JY8HzCjNEAbyVhr6K1K_AMDMKE2x+5wwWvuA@mail.gmail.com>
Date: Wed, 20 Jul 2011 13:54:29 +0200
Message-ID: <CA+icZUUJrCWqtQhtzhzniLan23poA_KuaLXK9QUTidkOO1nErA@mail.gmail.com> (sfid-20110720_135434_675810_FAF22AF9)
Subject: Re: [PATCH v2] ath5k: merge ath5k_hw and ath5k_softc
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Pavel Roskin <proski@gnu.org>,
	Nick Kossifidis <mickflemm@gmail.com>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: multipart/mixed; boundary=90e6ba30943417488e04a87ee5be
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--90e6ba30943417488e04a87ee5be
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 20, 2011 at 12:19 PM, Sedat Dilek
<sedat.dilek@googlemail.com> wrote:
> On Wed, Jul 20, 2011 at 3:39 AM, Nick Kossifidis <mickflemm@gmail.com> wr=
ote:
>> 2011/7/15 Pavel Roskin <proski@gnu.org>:
>>> Both ath5k_hw and ath5k_softc represent one instance of the hardware.
>>> This duplication is historical and is not needed anymore.
>>>
>>> Keep the name "ath5k_hw" for the merged structure and "ah" for the
>>> variable pointing to it. =C2=A0"ath5k_hw" is shorter than "ath5k_softc"=
, more
>>> descriptive and more widely used.
>>>
>>> Put the combined structure to ath5k.h where the old ath5k_softc used to
>>> be. Move some code from base.h to ath5k.h as needed.
>>>
>>> Remove memory allocation for struct ath5k_hw and the corresponding erro=
r
>>> handling. =C2=A0Merge iobase and ah_iobase fields.
>>>
>>> Signed-off-by: Pavel Roskin <proski@gnu.org>
>>
>> Thanks a lot Pavel ;-)
>>
>> Acked-by: Nick Kossifidis <mickflemm@gmail.com>
>>
>> --
>> GPG ID: 0xD21DB2DB
>> As you read this post global entropy rises. Have Fun ;-)
>> Nick
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.html
>>
>
> Hi,
>
> I have tested this patch on top of linux-next (next-20110720) and it fail=
s:
>
> In file included from
> /mnt/sdb3/linux-kernel/linux-3.0-rc7/debian/build/source_i386_none/driver=
s/net/wireless/ath/ath5k/caps.c:24:0:
> /mnt/sdb3/linux-kernel/linux-3.0-rc7/debian/build/source_i386_none/driver=
s/net/wireless/ath/ath5k/ath5k.h:1072:24:
> error: field 'toggleq' has incomplete type
> /mnt/sdb3/linux-kernel/linux-3.0-rc7/debian/build/source_i386_none/driver=
s/net/wireless/ath/ath5k/ath5k.h:1191:24:
> error: field 'rxtq' has incomplete type
> /mnt/sdb3/linux-kernel/linux-3.0-rc7/debian/build/source_i386_none/driver=
s/net/wireless/ath/ath5k/ath5k.h:1198:24:
> error: field 'txtq' has incomplete type
> /mnt/sdb3/linux-kernel/linux-3.0-rc7/debian/build/source_i386_none/driver=
s/net/wireless/ath/ath5k/ath5k.h:1203:24:
> error: field 'calib' has incomplete type
> /mnt/sdb3/linux-kernel/linux-3.0-rc7/debian/build/source_i386_none/driver=
s/net/wireless/ath/ath5k/ath5k.h:1206:24:
> error: field 'beacontq' has incomplete type
> /mnt/sdb3/linux-kernel/linux-3.0-rc7/debian/build/source_i386_none/driver=
s/net/wireless/ath/ath5k/ath5k.h:1225:24:
> error: field 'ani_tasklet' has incomplete type
> make[9]: *** [drivers/net/wireless/ath/ath5k/caps.o] Error 1
> make[8]: *** [drivers/net/wireless/ath/ath5k] Error 2
> make[7]: *** [drivers/net/wireless/ath] Error 2
> make[6]: *** [drivers/net/wireless] Error 2
> make[5]: *** [drivers/net] Error 2
> make[5]: *** Waiting for unfinished jobs....
>
> Just wanna let you know.
>
> Please, let me know if I should test on top of other trees like
> wireless-testing GIT or I am missing something in my kernel-config
> file.
> Thanks.
>
> Regards,
> - Sedat -
>

Attached patch fixes the build-breakage here.

- Sedat -

--90e6ba30943417488e04a87ee5be
Content-Type: plain/text; name="ath5k-Add-missing-include-to-ath5k.h.patch"
Content-Disposition: attachment;
	filename="ath5k-Add-missing-include-to-ath5k.h.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gqc8ic8n1

LS0tIGxpbnV4LW5leHQtMjAxMTA3MjAub3JpZy9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRo
NWsvYXRoNWsuaAorKysgbGludXgtbmV4dC0yMDExMDcyMC9kcml2ZXJzL25ldC93aXJlbGVzcy9h
dGgvYXRoNWsvYXRoNWsuaApAQCAtMjQsNiArMjQsNyBAQAogI2RlZmluZSBDSEFOX0RFQlVHCTAK
IAogI2luY2x1ZGUgPGxpbnV4L2lvLmg+CisjaW5jbHVkZSA8bGludXgvaW50ZXJydXB0Lmg+CiAj
aW5jbHVkZSA8bGludXgvdHlwZXMuaD4KICNpbmNsdWRlIDxsaW51eC9hdmVyYWdlLmg+CiAjaW5j
bHVkZSA8bGludXgvbGVkcy5oPgo=
--90e6ba30943417488e04a87ee5be--
