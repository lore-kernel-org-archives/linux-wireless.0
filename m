Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f175.google.com ([209.85.210.175]:49795 "EHLO
	mail-yx0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbZGaTEZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 15:04:25 -0400
Received: by yxe5 with SMTP id 5so307231yxe.33
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2009 12:04:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1249066564.20276.3.camel@mj>
References: <4A720FE4.4020301@gmx.de> <1248990136.10154.10.camel@mj>
	<4A733CDE.4060801@gmx.de> <1249066564.20276.3.camel@mj>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 31 Jul 2009 12:04:04 -0700
Message-ID: <43e72e890907311204h5f79075m4506a89dca640fd1@mail.gmail.com>
Subject: Re: [PATCH] compat-2.6: Makefile: fixed test expressions for target
	install
To: Pavel Roskin <proski@gnu.org>
Cc: Joerg Albert <jal2@gmx.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 31, 2009 at 11:56 AM, Pavel Roskin<proski@gnu.org> wrote:
> On Fri, 2009-07-31 at 20:50 +0200, Joerg Albert wrote:
>
>> joerg@thinkpad:~$ echo $BASH_VERSION
>> 3.2.39(1)-release
>> joerg@thinkpad:~$ if [ -z "" && -z "" ]; then echo "both empty"; fi
>> bash: [: missing `]'
>> joerg@thinkpad:~$ if [ -z "" -a -z "" ]; then echo "both empty"; fi
>> both empty
>> joerg@thinkpad:~$ if [[ -z "" && -z "" ]]; then echo "both empty"; fi
>> both empty
>> joerg@thinkpad:~$
>
> No, I didn't mean that.  I meant:
>
> if [ -z "" ] && [ -z "" ]; then echo "both empty"; fi
>
>> If the link for the man page of bash v1 on http://wwwbs.informatik.htw-dresden.de/fbs/bash/old.bash.html is correct,
>> that version supported -a in test.
>> Unfortunately [[ ... ]] was introduced after bash v1 (2.02 AFAIR).
>
> We should not rely on any bash features as /bin/sh may not be bash at
> all.

compat-wireless depends on bash, hence /bin/bash at the top.

  Luis
