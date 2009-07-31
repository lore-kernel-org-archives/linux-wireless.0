Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:48179 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752860AbZGaSuI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 14:50:08 -0400
Message-ID: <4A733CDE.4060801@gmx.de>
Date: Fri, 31 Jul 2009 20:50:06 +0200
From: Joerg Albert <jal2@gmx.de>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH] compat-2.6:  Makefile: fixed test expressions for target
 install
References: <4A720FE4.4020301@gmx.de> <1248990136.10154.10.camel@mj>
In-Reply-To: <1248990136.10154.10.camel@mj>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/30/2009 11:42 PM, Pavel Roskin wrote:
> On Thu, 2009-07-30 at 23:25 +0200, Joerg Albert wrote:
>> This removes the two errors of [ with target "install"
>>
>> make[1]: Leaving directory `/home/joerg/src/linux-2.6.30'
>> [: 9: missing ]
>> [: 9: missing ]
>> depmod will prefer updates/ over kernel/ -- OK!
> 
> I believe "-a" in test is not very portable.  I remember getting
> complaints about it.  I believe the built-in test command in bash 1.x
> doesn't have it.  I'd rather stick with && and || written properly.
> 
> "-a" and -o" are currently only used in the clean target and in the
> maintenance scripts, so they probably don't get enough testing on
> systems with old bash.

Bash 3.2.39 seems to have a problem with &&, while [[ ... ]] accept it:

joerg@thinkpad:~$ echo $BASH_VERSION
3.2.39(1)-release
joerg@thinkpad:~$ if [ -z "" && -z "" ]; then echo "both empty"; fi
bash: [: missing `]'
joerg@thinkpad:~$ if [ -z "" -a -z "" ]; then echo "both empty"; fi
both empty
joerg@thinkpad:~$ if [[ -z "" && -z "" ]]; then echo "both empty"; fi
both empty
joerg@thinkpad:~$

If the link for the man page of bash v1 on http://wwwbs.informatik.htw-dresden.de/fbs/bash/old.bash.html is correct,
that version supported -a in test.
Unfortunately [[ ... ]] was introduced after bash v1 (2.02 AFAIR).

Regards,
Joerg.
