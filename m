Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:46550 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbaDJGNl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2014 02:13:41 -0400
Received: by mail-pa0-f42.google.com with SMTP id fb1so3552408pad.29
        for <linux-wireless@vger.kernel.org>; Wed, 09 Apr 2014 23:13:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1397071009.4964.18.camel@jlt4.sipsolutions.net>
References: <1393376982-28276-1-git-send-email-mcgrof@do-not-panic.com>
 <1393376982-28276-3-git-send-email-mcgrof@do-not-panic.com>
 <1393852248.10039.5.camel@jlt4.sipsolutions.net> <CANrMYP6Rvv4EBjY9-78bdm70G_3YGZFrJH9tFz5XVsbSSi-m=Q@mail.gmail.com>
 <CAB=NE6X02Apk8XFt7yomQKwNoENvKAy1QbGBknQUGJ2ZDs73Gw@mail.gmail.com>
 <CANrMYP4GhDZZzYkyyVCHKpb7YvJzNbFZn77hZH9T+y7HTQ4R=w@mail.gmail.com>
 <CAB=NE6UHKptAvbt1OM4O_cRiCj2wyEKGF2fFPsO_rQ0EUZQahA@mail.gmail.com>
 <CAFED-j=OAMJzFkjgCDx8YMHpEWfpZ6h4UQSRK7DQigrNuaOSig@mail.gmail.com>
 <CAB=NE6UGWfZxU6zi=XzLKWeN+1aFgxTVUpr349FVHBsRgSGo+A@mail.gmail.com>
 <CANrMYP7Meef9rt4aX_EeREq0z7uRtT6oSB6pjE3AqeHMx1GwJw@mail.gmail.com>
 <CA+XVXffzFWsJOU+PLWkeoce1+dDvrqruyi3_GG7V-6dfWpK7gA@mail.gmail.com> <1397071009.4964.18.camel@jlt4.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Thu, 10 Apr 2014 09:13:26 +0300
Message-ID: <CA+XVXfdekoT_jhVL_vpjJSPPD5hAjyprUB+g4kAN2Nssv=9-Ng@mail.gmail.com> (sfid-20140410_081345_481120_6ECC1FF0)
Subject: Re: [PATCH 2/3] cfg80211: fix processing world regdomain when non modular
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Colleen T <colleen@cozybit.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Janusz Dziedzic <janusz.dziedzic@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Sander Eikelenboom <linux@eikelenboom.it>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 9, 2014 at 10:16 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> +static void reg_free_last_request(struct regulatory_request *lr)
>
> Isn't it odd to pass the last request to a function called
> reg_free_last_request()?
>

It makes sense to me. Non-last requests are freed using kfree. The
last request needs RCU.

Arik
