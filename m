Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out6.electric.net ([192.162.217.186]:58831 "EHLO
	smtp-out6.electric.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509AbbBMLfE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2015 06:35:04 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: 'Rasmus Villemoes' <linux@rasmusvillemoes.dk>,
	Mark Rustad <mrustad@gmail.com>
CC: "Rustad, Mark D" <mark.d.rustad@intel.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] iwl4965: Enable checking of format strings
Date: Fri, 13 Feb 2015 11:20:47 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1CAE3325@AcuExch.aculab.com> (sfid-20150213_123508_869498_DE5989A0)
References: <1423695069-23436-1-git-send-email-linux@rasmusvillemoes.dk>
	<60178C37-F104-430E-92EB-B6DDFAEB2F99@intel.com>
	<87vbj7zb0e.fsf@rasmusvillemoes.dk> <54DDAE03.4000502@gmail.com>
 <87y4o2xfgz.fsf@rasmusvillemoes.dk>
In-Reply-To: <87y4o2xfgz.fsf@rasmusvillemoes.dk>
Content-Type: text/plain; charset="Windows-1252"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rasmus Villemoes
> Well, probably the linker is allowed to overlap "anonymous" objects
> (string literals) with whatever const char[] (or indeed any const)
> object it finds containing the appropriate byte sequence. But I think
> language lawyers would insist that for
> 
> const char foo[] = "a string";
> const char bar[] = "a string";

A quick test shows those are separate strings.
But 'const char *foo = "xxx";' will share.
You also need -O1 to get the strings into .rodata.str.n so that the linker
can merge them.

	David

