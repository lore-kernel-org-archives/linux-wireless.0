Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.230]:17929 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbZC0EAh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 00:00:37 -0400
Received: by rv-out-0506.google.com with SMTP id f9so1022656rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 26 Mar 2009 21:00:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <e13a36b30903252159r1dc5cdc7p244f39e75816f04@mail.gmail.com>
References: <43e72e890903250009hbe7bcfal546dddf731820b8e@mail.gmail.com>
	<200903260337.37783.kel@otaku42.de> <43e72e890903251041r657a5217q9af7b5eb34f2f824@mail.gmail.com>
	<200903260442.36251.kel@otaku42.de> <e13a36b30903251203v7c53fb20g64bf61e4e433377@mail.gmail.com>
	<e13a36b30903252008i72caad77y32e31f625b7cb842@mail.gmail.com>
	<43e72e890903252119r56043c93h954ad1cdcc69ad33@mail.gmail.com>
	<e13a36b30903252159r1dc5cdc7p244f39e75816f04@mail.gmail.com>
Date: Thu, 26 Mar 2009 21:00:20 -0700
Message-ID: <43e72e890903262100p57802b9fuc5bb75a23599fbbd@mail.gmail.com> (sfid-20090327_050042_174669_1AE9E1BB)
Subject: Re: [renamed] Debian crda?
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: debian-devel@lists.debian.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 25, 2009 at 9:59 PM, Paul Wise <pabs@debian.org> wrote:
> On Thu, Mar 26, 2009 at 1:19 PM, Luis R. Rodriguez <mcgrof@gmail.com>=
 wrote:
>
>>> Brainwave: no need to add a second public key to CRDA itself, the
>>> wireless-regdb could install the public key corresponding to the
>>> private key it was built with.
>>
>> Can you elaborate on what you mean? Do you mean for wireless-regdb t=
o
>> put the actual pubkey into the users' system somewhere? Otherwise no=
t
>> sure what you mean.
>
> The crda package would contain the default upstream public key.
>
> The wireless-regdb would ship the Debian maintainer's pubkey as
> debian/pubkeys/debian.pem in the source package and
> /lib/crda/pubkeys/debian.pub.pem (or similar) in the binary package.
>
> Ubuntu would add their pubkey in a similar way.
>
> When wireless-regdb is built, it would:
>
> check the sha1sum/sha256sum of db.txt (alternatively upstream could
> add a detached signature if possible to the tarball/git repo)
>
> if the db.txt is identical to the upstream one (or signed by
> upstream), ship the upstream regulatory.bin file
>
> if the db.txt has been modified:
>
> if no private key is available, generate one automatically
>
> rebuild the regulatory.bin file using the private key
>
> create the corresponding public key and install it in the package as
> /lib/crda/pubkeys/custom.pub.pem when it is not the same public key a=
s
> one of the ones in debian/pubkeys/*.pem (avoids shipping two copies o=
f
> the Debian pubkey)
>
> this scheme requires standard locations for the private key. I would
> suggest either ~/.debian-wireless-regdb.priv.pem or
> debian-wireless-regdb.priv.pem in the package build directory.
>
>>>> It is possible for users to add more public keys to the CRDA =C2=A0=
pubkeys
>>>> dir and build their own wireless-regdb using their own private key=
=2E
>>>
>>> The above simplification makes this much easier.
>>
>> Not sure what you mean, but the idea with the pubkeys directory
>
> The above scheme would allow users who apt-get source wireless-regdb,
> edit db.txt, debuild, debi to automatically trust their own key, as
> well as trusting Debian's key and the upstream key.
>
> I wonder if any of this would be even remotely acceptable to
> regulatory authorities.

Thanks for the ideas, will post patches for this.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
