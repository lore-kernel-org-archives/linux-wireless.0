Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f45.google.com ([209.85.219.45]:59232 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191Ab3KOTHh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Nov 2013 14:07:37 -0500
Received: by mail-oa0-f45.google.com with SMTP id m1so4437061oag.32
        for <linux-wireless@vger.kernel.org>; Fri, 15 Nov 2013 11:07:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131115184510.GA911@redhat.com>
References: <cover.1384160397.git.dborkman@redhat.com>
	<2ea03f60bb65429cbe5d74a6d356fde3eefcf06c.1384160397.git.dborkman@redhat.com>
	<20131111134357.GC10104@thunk.org>
	<20131112000307.GB14929@order.stressinduktion.org>
	<20131112115350.GA14077@thunk.org>
	<20131112131627.GD14929@order.stressinduktion.org>
	<20131112134603.GE14929@order.stressinduktion.org>
	<20131114025448.GB31602@thunk.org>
	<CAGXu5j+ySEdQBXKkspYC=svfekBja2Z_2tcWSAOEbvyiMLf=aA@mail.gmail.com>
	<20131115184510.GA911@redhat.com>
Date: Fri, 15 Nov 2013 11:07:35 -0800
Message-ID: <CAGXu5j+emFS+Y-=SOE4SM_gAXfR_NWHRXwv8c6CeB7SgGZgKNw@mail.gmail.com> (sfid-20131115_200843_083620_CFBF166E)
Subject: Re: [PATCH] random: seed random_int_secret at least poorly at
 core_initcall time
From: Kees Cook <keescook@chromium.org>
To: Dave Jones <davej@redhat.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Daniel Borkmann <dborkman@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Florian Weimer <fweimer@redhat.com>, netdev@vger.kernel.org,
	Eric Dumazet <eric.dumazet@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 15, 2013 at 10:45 AM, Dave Jones <davej@redhat.com> wrote:
> On Fri, Nov 15, 2013 at 10:33:04AM -0800, Kees Cook wrote:
>
>  > Ingo wanted even more
>  > unpredictability, in the face of total failure from these more dynamic
>  > sources, so x86 also "seeds" itself with the build string and the
>  > boot_params. These last two are hardly high entropy, but they should
>  > at least make 2 different systems not have _identical_ entropy at the
>  > start. It's far from cryptographically secure, but it's something, I
>  > hope.
>
> Those are both likely to be the same on some configurations.
> On x86, we could maybe hash the dmi tables ? Vendor stupidity aside,
> things like serial numbers in those tables _should_ be different.

Yeah, DMI tables were suggested as well. (Hopefully people will start
using -uuid with KVM!) How hard would that be to hook up to the
pre-random-init code?

-Kees

-- 
Kees Cook
Chrome OS Security
