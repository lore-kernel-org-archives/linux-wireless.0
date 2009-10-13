Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:40836 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934207AbZJMVMx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2009 17:12:53 -0400
Message-ID: <4AD4ED23.7010200@hauke-m.de>
Date: Tue, 13 Oct 2009 23:12:03 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Hin-Tak Leung <hintak.leung@gmail.com>
CC: lrodriguez@atheros.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/9] [compat-2.6 and compat-stable] Remove unused code
References: <1255382358-20760-1-git-send-email-hauke@hauke-m.de>	 <1255382358-20760-4-git-send-email-hauke@hauke-m.de> <3ace41890910121932r6f832fe8of70d9b2bdd3d2635@mail.gmail.com>
In-Reply-To: <3ace41890910121932r6f832fe8of70d9b2bdd3d2635@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig69412EFE6AE82EB68D252D0D"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig69412EFE6AE82EB68D252D0D
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hin-Tak Leung wrote:
> On Mon, Oct 12, 2009 at 10:19 PM, Hauke Mehrtens <hauke@hauke-m.de> wro=
te:
>> LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,28) can not be true in
>> compat-2.6.28.h. The definitions are not needed in compat-wireless any=

>> more. Removing this does not break compiling with mainline kernel 2.6.=
25
>> to 2.6.32
>=20
> Hmm, I am not questioning your decision for removing unused code, but
> if they are genuinely unused, why were they introduced in the first
> place?

I have added them in edcf845e4bd65d00132f02237bee3fd3daca318f but I can
not find any references to them in compat-wireless. For me it looks like
it was a mistake to introduce them. The commit comment does not say
anything about it (my bad) and I forgot why I added it.

> As a side comment, while it is unusual (compared to the usual <
> version_X), it is a possible scenario for compat-X.h to have codes
> that conditions on LINUX_VERSION_CODE >=3D version_X - and if memory
> serves the bits you are removing were added only recently; and they
> looks like what they are (i.e. public kernel symbols became
> private-static during 2.6.27<->2.6.28 or the other way round).

The condition #if (LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,28)) was
added recently because without it openSuse with kernel 2.6.27 will not
compile. OpenSuse backports the tracepoint part into their 2.6.27 kernel.=


> I guess I am looking for a reason why they were added in the first
> place, if they serve no purpose.
>
>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>> ---
>>  compat/compat-2.6.28.h |   24 ------------------------
>>  1 files changed, 0 insertions(+), 24 deletions(-)
>>
>> diff --git a/compat/compat-2.6.28.h b/compat/compat-2.6.28.h
>> index 90d080c..dd223c6 100644
>> --- a/compat/compat-2.6.28.h
>> +++ b/compat/compat-2.6.28.h
>> @@ -146,22 +146,6 @@ static inline void skb_queue_splice_tail_init(str=
uct sk_buff_head *list,
>>        }
>>  } /* From include/linux/skbuff.h */
>>
>> -struct module;
>> -struct tracepoint;
>> -
>> -#if (LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,28))
>> -struct tracepoint {
>> -       const char *name;               /* Tracepoint name */
>> -       int state;                      /* State. */
>> -       void **funcs;
>> -} __attribute__((aligned(32)));                /*
>> -                                        * Aligned on 32 bytes because=
 it is
>> -                                        * globally visible and gcc ha=
ppily
>> -                                        * align these on the structur=
e size.
>> -                                        * Keep in sync with vmlinux.l=
ds.h.
>> -                                        */
>> -#endif
>> -
>>  #ifndef DECLARE_TRACE
>>
>>  #define TP_PROTO(args...)      args
>> @@ -181,17 +165,9 @@ struct tracepoint {
>>                return -ENOSYS;                                        =
 \
>>        }
>>
>> -#if (LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,28))
>> -#define DEFINE_TRACE(name)
>> -#endif
>>  #define EXPORT_TRACEPOINT_SYMBOL_GPL(name)
>>  #define EXPORT_TRACEPOINT_SYMBOL(name)
>>
>> -#if (LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,28))
>> -static inline void tracepoint_update_probe_range(struct tracepoint *b=
egin,
>> -       struct tracepoint *end)
>> -{ }
>> -#endif
>>
>>  #endif
>>
>> --
>> 1.6.2.1



--------------enig69412EFE6AE82EB68D252D0D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQIcBAEBAgAGBQJK1O0nAAoJEIZ0px9YPRMytykP/1qDIhWtinNWT3RdwVWuXM3/
Y0zgNbpwYH+2vgK4Y7JRZktNFFNexSCNULMSNh6waVsoB11R/8m+IfF8BWcyzeZD
r3kBHlI9UKRSlxjjmp1AtiDFHk/rR9zdtMHEHkvl9dRBZZtbpD0uzDYDGET1Cqtm
HETzFGLR5/d0+l0bZ+tB9hIeXLR3gR/iTsX4Hk2Bsawq5SQZc4fbuykql779D03s
w5CT1kL3+BLsiCEAox8+yY8l6J5ZQRC3Ft8A0YFKLoDLEuk+cKGAch1wanVLSTfC
z9RRavgjeAwxj+0ZIUhLZGvTEaK/BiZeRRnmnP00jwS9zR9/zNsPl9myVBvTilb8
oBZKg7DJiNATduvIR8UGPslyh/dmfdi4WJTJ5dE/1Ed7zEFoPQXi6QlysafokKHE
xla6M5Oaa/FmDXsWLggzrdTjcnN8buy6/2wFx0fo7BuoqLtf3wzZHjfjXVwARabc
0Cg68QHdJ+5+t9NbG6kLXN1TXHo94LkzmsUk7aGmqHWBVC9Rkdeo7AFvwKLLc2Jb
VBNt2IlFXT3xG4ARetQyxvj/T9xZOAvWl7gsEnEhubLR0KLkU6SiCI9QN94gdXXX
C/u4phslyyrhPGaysBQjxaU/OuxZEYqmQh27ZHkKAgLLcAZVUptDUXH7ryAjfPqD
m9Kf8cLlggGpHJjq+ja8
=mRtk
-----END PGP SIGNATURE-----

--------------enig69412EFE6AE82EB68D252D0D--
