Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:26278 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbZCZET3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2009 00:19:29 -0400
Received: by wf-out-1314.google.com with SMTP id 29so443383wff.4
        for <linux-wireless@vger.kernel.org>; Wed, 25 Mar 2009 21:19:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <e13a36b30903252008i72caad77y32e31f625b7cb842@mail.gmail.com>
References: <43e72e890903250009hbe7bcfal546dddf731820b8e@mail.gmail.com>
	<200903260337.37783.kel@otaku42.de> <43e72e890903251041r657a5217q9af7b5eb34f2f824@mail.gmail.com>
	<200903260442.36251.kel@otaku42.de> <e13a36b30903251203v7c53fb20g64bf61e4e433377@mail.gmail.com>
	<e13a36b30903252008i72caad77y32e31f625b7cb842@mail.gmail.com>
Date: Wed, 25 Mar 2009 21:19:12 -0700
Message-ID: <43e72e890903252119r56043c93h954ad1cdcc69ad33@mail.gmail.com> (sfid-20090326_051932_841615_F97C3F3E)
Subject: Re: [renamed] Debian crda?
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: debian-devel@lists.debian.org,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 25, 2009 at 8:08 PM, Paul Wise <pabs@debian.org> wrote:
> On Thu, Mar 26, 2009 at 4:03 AM, Paul Wise <pabs@debian.org> wrote:
>
>> When we do, just adding a second public key to the CRDA =C2=A0pubkey=
s dir
>> and using the corresponding private key (from outside the package)
>> during the build process of wireless-regdb would be just fine. This
>> would mean the maintainer of crda would also have to be the
>> wireless-regdb maintainer. I assume the wireless-regdb is
>> architecture-independent so this would work because the buildds do n=
ot
>> build such packages.
>
> Brainwave: no need to add a second public key to CRDA itself, the
> wireless-regdb could install the public key corresponding to the
> private key it was built with.

Can you elaborate on what you mean? Do you mean for wireless-regdb to
put the actual pubkey into the users' system somewhere? Otherwise not
sure what you mean.

>> It is possible for users to add more public keys to the CRDA =C2=A0p=
ubkeys
>> dir and build their own wireless-regdb using their own private key.
>
> The above simplification makes this much easier.

Not sure what you mean, but the idea with the pubkeys directory when
building CRDA is it lets you add more keys to CRDA so it can use
regulatory.bin from multiple trusted parties. A small example is a
distribution can decide to use their own pubkey and also leave John's
in the pubkeys/ directory. This allow the user to then install and
actually use the distribution's release of wireless-regdb while also
enabling the users to upgrade to John's latest regulatory.bin
themselves whenever they feel like it either manually or using the
upstream package. Of course if the distribution keeps up with these
then there is no need for the user to be doing any of this.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
