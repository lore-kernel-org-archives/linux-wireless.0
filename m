Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53796 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755504Ab0EQSBj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 May 2010 14:01:39 -0400
Received: by pwi5 with SMTP id 5so581248pwi.19
        for <linux-wireless@vger.kernel.org>; Mon, 17 May 2010 11:01:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <z2o43e72e891005041451qa4ea338bu5a20171a82f13471@mail.gmail.com>
References: <x2q43e72e891005041344gb9945d73p3d97e648fd13aa85@mail.gmail.com>
	<1273007509.12618.1.camel@mj> <z2o43e72e891005041451qa4ea338bu5a20171a82f13471@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 17 May 2010 10:54:26 -0700
Message-ID: <AANLkTilrjw-Jq4MEQPT35fHTTqsaSdU5Jc7lt_2lUH2V@mail.gmail.com>
Subject: Re: A file to print the release of loaded compat-wireless stuff
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 4, 2010 at 2:51 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Tue, May 4, 2010 at 2:11 PM, Pavel Roskin <proski@gnu.org> wrote:
>> On Tue, 2010-05-04 at 13:44 -0700, Luis R. Rodriguez wrote:
>>> It seems there is a reasonable need to find out what version of
>>> compat-wireless you have running. This will be a dated thing when
>>> based on linux-next but more importantly it will contain the 2.6.3x.y
>>> release the release was based on for the stable releases. Any ideas of
>>> what filesystem API to use for this, I was thinking maybe a simple
>>> sysfs entry for the compat module. Thoughts, preferences?
>>
>> We could use a read-only parameter of the compat module.  Then the
>> version would be in /sys/module/compat/parameters/version
>>
>> Module parameters are visible in sysfs even if the code is compiled into
>> the kernel.
>
> Neat trick thanks for the tip, will give that a shot.

Oh wow, and look at that, even if you enable the module as built-in to
the kernel you still get the module parameter sysfs file for it. For
example I just built-in cfg80211 on my kernel and I still see the
ieee80211_regdom module parameter:

mcgrof@tux ~ $ lsmod | grep cfg
mcgrof@tux ~ $ cat /sys/module/cfg80211/parameters/ieee80211_regdom
00

This is important as some distributions [1] might built-in some stable
compat-wireless releases into their older kernel releases.

  Luis

[1] http://src.chromium.org/cgi-bin/gitweb.cgi?p=kernel.git;a=commit;h=73ec6aa6d7ed254d235939bf00ea49cbb6526e6f
