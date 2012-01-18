Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nautica.notk.org ([91.121.71.147]:42260 "EHLO nautica.notk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757719Ab2ARPTA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jan 2012 10:19:00 -0500
Date: Wed, 18 Jan 2012 16:18:43 +0100
From: Dominique Martinet <asmadeus@codewreck.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@frijolero.org>,
	linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-kbuild@vger.kernel.org
Subject: Re: [PATCH v2] compat-wireless: build: Throw error if space in path
Message-ID: <20120118151843.GA23506@nautica> (sfid-20120118_161906_831914_0B10CA05)
References: <CAB=NE6WAhddiUuf4yOfNAgqMF7GxM--ksDwEmvwdJdFYSjLGzA@mail.gmail.com>
 <1326758892-32135-1-git-send-email-asmadeus@codewreck.org>
 <1326786261.3342.0.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1326786261.3342.0.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

(I added linux-kbuild@ in Cc because it also concerns them. The idea is
to fail cleanly if there is a space in the path to the directory from
which we want to build some modules. We can't detect some from kbuild
itself given how params are given, so it started as a patch for the
modules' Makefile instead)


Johannes Berg wrote on Tue, Jan 17, 2012 :
> I think it also fails if there's a colon in the path -- does anyone know
> what the "forbidden" characters would be?

I can confirm that it fails with a colon in path, although it's not
documented anywhere in Documentation/kbuild/.. (I guess I've just
volunteered to fix that, too :))

I didn't find a proper list, but what I've seen fail is:
 - space " "
 - colon ":"
 - semicolon ";"
 - antislash "\"
 - dollar "$"
 - sharp "#" (although it fails later than the others)
 - ampersand "&"
 - parenthesis "(" and ")" - these fail somewhere else as well (even
 after fixing compat-wireless' Makefile with minor quoting)
 - backtick "`"
 - double quotes """ 
 - single quotes "'"

what does work that's not necessarily obvious:
 - comma, brakets [], brakets {}


... There might be many more I didn't come up with, but that does look
like a fair start!
Does anyone know of a more complete list?

Regards,
-- 
Dominique Martinet | Asmadeus
