Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f188.google.com ([209.85.210.188]:61179 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbZGARtb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2009 13:49:31 -0400
Received: by yxe26 with SMTP id 26so1493415yxe.33
        for <linux-wireless@vger.kernel.org>; Wed, 01 Jul 2009 10:49:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1246470361.11632.23.camel@jdl-desktop>
References: <1246460365.11632.4.camel@jdl-desktop> <43e72e890907010959q15bde116ue796802e006e410f@mail.gmail.com>
	<1246468471.15757.12.camel@mj> <1246469405.11632.19.camel@jdl-desktop>
	<43e72e890907011035x77005470u6646d7feb941b9f7@mail.gmail.com>
	<1246470361.11632.23.camel@jdl-desktop>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 1 Jul 2009 10:49:14 -0700
Message-ID: <43e72e890907011049w45508c9fpfabdddf36c28e99c@mail.gmail.com>
Subject: Re: [Fwd: Re: [PATCH 4/5] Introduce separate HOST and TARGET
	compilation steps.]
To: Jon Loeliger <jdl@bigfootnetworks.com>
Cc: Pavel Roskin <proski@gnu.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 1, 2009 at 10:46 AM, Jon Loeliger<jdl@bigfootnetworks.com> wrote:
> On Wed, 2009-07-01 at 10:35 -0700, Luis R. Rodriguez wrote:
>> On Wed, Jul 1, 2009 at 10:30 AM, Jon Loeliger<jdl@bigfootnetworks.com> wrote:
>>
>> > Do you agree or disagree with me when I say that the regdbdump program
>> > might need to be compiled twice -- once for the host and once for the
>> > target?
>>
>> Why?
>
> The existing binary regulatory DB binary is verified on the host
> using these rules.  (This is from my version of the makefile, but
> they are there in the original too.):
>
>    all: host target $(REG_BIN) $(BUILD_ALL) verify
>
>    verify: $(REG_BIN) host/regdbdump
>        $(NQ) '  CHK  $(REG_BIN)'
>        $(Q)./host/regdbdump $(REG_BIN) >/dev/null
>
> That is, as part of the host build process, the regdbdump tool
> is run *on the host*.

This helps to understand a little better some of your intentions, may
be good to mention this as part of your patches. Hm, interesting... I
suppose we don't want to just disable this check then.

> Ultimately, the regdbdump utility may *also* be needed or
> wanted on the target too.

ACK.

  Luis
