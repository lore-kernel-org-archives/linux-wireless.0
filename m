Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:60127 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845AbZGaS4G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 14:56:06 -0400
Subject: Re: [PATCH] compat-2.6:  Makefile: fixed test expressions for
 target install
From: Pavel Roskin <proski@gnu.org>
To: Joerg Albert <jal2@gmx.de>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <4A733CDE.4060801@gmx.de>
References: <4A720FE4.4020301@gmx.de> <1248990136.10154.10.camel@mj>
	 <4A733CDE.4060801@gmx.de>
Content-Type: text/plain
Date: Fri, 31 Jul 2009 14:56:04 -0400
Message-Id: <1249066564.20276.3.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-07-31 at 20:50 +0200, Joerg Albert wrote:

> joerg@thinkpad:~$ echo $BASH_VERSION
> 3.2.39(1)-release
> joerg@thinkpad:~$ if [ -z "" && -z "" ]; then echo "both empty"; fi
> bash: [: missing `]'
> joerg@thinkpad:~$ if [ -z "" -a -z "" ]; then echo "both empty"; fi
> both empty
> joerg@thinkpad:~$ if [[ -z "" && -z "" ]]; then echo "both empty"; fi
> both empty
> joerg@thinkpad:~$

No, I didn't mean that.  I meant:

if [ -z "" ] && [ -z "" ]; then echo "both empty"; fi

> If the link for the man page of bash v1 on http://wwwbs.informatik.htw-dresden.de/fbs/bash/old.bash.html is correct,
> that version supported -a in test.
> Unfortunately [[ ... ]] was introduced after bash v1 (2.02 AFAIR).

We should not rely on any bash features as /bin/sh may not be bash at
all.

-- 
Regards,
Pavel Roskin
