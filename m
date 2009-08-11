Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:39679 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750878AbZHKAph (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2009 20:45:37 -0400
Message-ID: <4A80BF22.9060101@redfish-solutions.com>
Date: Mon, 10 Aug 2009 17:45:22 -0700
From: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
MIME-Version: 1.0
To: Philip Craig <philipc@snapgear.com>
CC: Pavel Roskin <proski@gnu.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Jon Loeliger <jdl@bigfootnetworks.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] CRDA and cross-compilation
References: <4A7A8F7E.6020503@redfish-solutions.com>	 <1249569993.6446.2.camel@jdl-desktop> 	<1249576886.14919.16.camel@mj>	 <43e72e890908060956j3548c23ak4cf98d11c32efec0@mail.gmail.com>	 <1249580707.14919.29.camel@mj>	 <43e72e890908061142w41d3c0e8x1dc81ffd3ac5b8ae@mail.gmail.com>	 <4A7BD15E.1030604@redfish-solutions.com>	 <43e72e890908070905s447a2fc0j2dc086048194db34@mail.gmail.com>	 <4A7CC24D.1000104@redfish-solutions.com> <1249698462.25983.7.camel@mj> <4A809B8D.5000309@redfish-solutions.com> <4A80BE1F.8020708@snapgear.com>
In-Reply-To: <4A80BE1F.8020708@snapgear.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Philip Craig wrote:
> Philip A. Prindeville wrote:
>> * allowing a cross-compilation without contamination by the host's own state via pkg-config bleeding into it.
> 
> Setting PKG_CONFIG_LIBDIR should fix that without any makefile changes.
> I haven't tried with this package, but it works for every other
> cross compilation I've done.

Indeed, and that would work until, as Pavel points out, someone adds something naive and ill-informed like a `uname -r` (or `arch`) into the Makefile.

I'm not just trying to make the current version safe for cross-compilation, but all future versions too so I don't ever have to come back and fix this issue again.

You have no idea how many packages we had to make cross-compilation safe.  Literally dozens.  And some of them continue to have periodic regressions.


