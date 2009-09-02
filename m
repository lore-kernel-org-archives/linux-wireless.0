Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:11055 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbZIBWA1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Sep 2009 18:00:27 -0400
Received: by ey-out-2122.google.com with SMTP id 25so279725eya.19
        for <linux-wireless@vger.kernel.org>; Wed, 02 Sep 2009 15:00:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890909021425s13784658r342e52eefb7b582d@mail.gmail.com>
References: <95408c820909021353i5b2d0e5dpeddefcdb5065d724@mail.gmail.com>
	 <43e72e890909021425s13784658r342e52eefb7b582d@mail.gmail.com>
Date: Wed, 2 Sep 2009 22:00:29 +0000
Message-ID: <95408c820909021500t19208ea2sad78a0d0470a8d71@mail.gmail.com>
Subject: Re: building compat-wireless for other than running kernels
From: Natanael Copa <natanael.copa@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 2, 2009 at 9:25 PM, Luis R. Rodriguez<mcgrof@gmail.com> wrote:
> On Wed, Sep 2, 2009 at 1:53 PM, Natanael Copa<natanael.copa@gmail.com> wrote:
>> Hi,
>> I'm trying to create a compat-wireless package for Alpine Linux. I get
>> errors like this:
>> FATAL: Could not load
>> /lib/modules/2.6.29.4-vs2.3.0.36.14-ARCH/modules.dep: No such file or
>> directory
>> This comes from the fact that the package is not for the current running kernel.
...
>> Alternatively you could define a DEPMOD=/sbin/depmod in the Makefile
>> so its possible to override it with: make DEPMOD=: ...
>
> Patches are welcomed. I considered just now added the depmod stuff you
> mentioned but remembered that there are also scripts which may use
> this on compat-wireless. We could just export it though and then all
> the scripts would have access to it -- but note that it means then
> that you'd need the Makefile to run certain scripts -- and if you
> don't you have to define your own depmod. Because of this I welcome
> your patches on this if you test it.

That explains why I saw the error message even with my patch. For my
use the scripts are not critical as they don't exit with error and
make just continues. I do have an idea how to fix that too though.

I also have some simple fix to split the install so you can easily
have multiple binary packages for different kernel flavors but still
share the userspace scripts.

Thanks!

-- 
Natanael Copa
