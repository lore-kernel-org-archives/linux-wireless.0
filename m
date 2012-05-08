Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39248 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754991Ab2EHO73 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 10:59:29 -0400
Received: by yhmm54 with SMTP id m54so5401420yhm.19
        for <linux-wireless@vger.kernel.org>; Tue, 08 May 2012 07:59:29 -0700 (PDT)
Message-ID: <4FA9352F.6070405@gmail.com> (sfid-20120508_165933_908708_81002855)
Date: Tue, 08 May 2012 11:01:03 -0400
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
CC: Bob Copeland <me@bobcopeland.com>, Vadim <Vadims.Kurmis@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Adding custom channels to ath5k for researching purposes
References: <loom.20101104T140201-178@post.gmane.org> <AANLkTinMSH2Vr=iUTD0Pc_OdaM_LFETDEjsOJn+2ZzVD@mail.gmail.com> <CAB=NE6X=iD7Hh7-wFx8-ZudNWUKKJw1Mg5MC_G3z4knu7bNTqg@mail.gmail.com>
In-Reply-To: <CAB=NE6X=iD7Hh7-wFx8-ZudNWUKKJw1Mg5MC_G3z4knu7bNTqg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 05/08/12 10:50, Luis R. Rodriguez wrote:
> On Thu, Nov 4, 2010 at 7:47 AM, Bob Copeland <me@bobcopeland.com> wrote:
>> On Thu, Nov 4, 2010 at 9:03 AM, Vadim <Vadims.Kurmis@gmail.com> wrote:
>>> I need to enable 802.11p standard frequencies. How can I accomplish this? I
>>> found that CRDA is responsible for allowed channels.
>>
>> Partially -- the channel list is exported by the driver but CRDA
>> adds additional regulatory restrictions.  The driver also imposes
>> certain regulatory restrictions based on the EEPROM data.
>>
>>> So, where can I get binary
>>> frequency/channel database to use my hardware for researching purposes ?
>>
>> You can create your own database, but you may need to modify the driver to
>> disregard the EEPROM settings, with the usual disclaimers: we won't support
>> it and if it breaks you get to keep both pieces.
>>
>> Also note that ath5k only advertises a partial channel list; you can
>> get more via all_channels=1 modparam.  We don't do this by default
>> because they make scanning take forever and exceed channel list limits
>> in netlink.
> 
> I'm thinking it may make sense to add CONFIG_WIRELESS_EXPERT where we
> can stuff some of this stuff under. It may be useful for other
> regulatory testing / certification stuff.

+1

In my personal opinion an option like that which enables ONLY crda (or
obviously firmware for those intel guys) to enforce regulatory
compliance it would then be trivial for people who needed other
frequencies to modify their own personal wireless regdb.  Also this
keeps some manner of sanity as with an unmodified wireless regdb nothing
bad happens.

Anyway, my 0.02$

Thanks,
Rick

> 
>   Luis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPqTUvAAoJEKXdFCfdEflKMAAP/ReW3KZEv+ABsWmf2E+iLSex
E10zB2Nmr7lE7I9duECYfWxe9ahm6DFwp6FMD9AJkuxPa8n0K96fKe9PrfRJWi/R
40A78VsW4zTUSfM07IHdTk7ACjrP3G0z+9Wfyd8QcWesHfAhqWzyr3lh9XV0g3hk
LOQcFIwEU8vSTki9QiyVLqltBgtPkPfwQ6KsYdqb9TK2SmSjisKHS63myNHEPTQH
3Y7FO6drRsbCLsNXmMcSZITmFRSXHtYunH9gXwKtQEYH0coS7bdBAETeFHOo9xcO
7xG66ftILniMQ1fAUpASHATP1uT+qQaSX7eTNlerVTBNmF5zLJq+8obrYipvL4gn
0uy3ZOgeG1tUidYTLBUeCbozkkPYrnH6338WQyjHA145Jv9pjkv+TWG9DTwjIVXE
UNjZPG3GbQLx5rGFlFKKumxqHDM3RgwhfEwjIyHX0mJr/Ae9oypwR5TjFbGFazMN
vQBSZE60OcnoPKV2EqpCP5/IINGUjtNWCxeLSefHaO1nDzComH5wR2cbbBGWTJ8P
6v7N7unfexhybGQifWHDWgXrwvh+RQNDo+zaXmWU1Yys34ByhVShU2j5YmzbARav
9byhrxgY/ABIFOc/r86tDwRqZJpVpFKpP1/uUbAQYkMpYfsUajIJFq/piigCYNKs
X9pGsDRw9vpH//uGpCzT
=bfUG
-----END PGP SIGNATURE-----
