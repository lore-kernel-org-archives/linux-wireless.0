Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:8944 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758596AbYJJQtT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 12:49:19 -0400
Received: by yx-out-2324.google.com with SMTP id 8so220405yxm.1
        for <linux-wireless@vger.kernel.org>; Fri, 10 Oct 2008 09:49:18 -0700 (PDT)
Message-ID: <43e72e890810100949i78c1d813x1b66c6bc0239ef28@mail.gmail.com> (sfid-20081010_184923_238362_AD8B60BA)
Date: Fri, 10 Oct 2008 09:49:18 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Zhu Yi" <yi.zhu@intel.com>
Subject: Re: New Regulatory Domain Api.
Cc: "Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"lrodrigues@atheros.com" <lrodrigues@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1223608949.2510.1061.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <B27EBC40D200ED48A3F4CC2EBEABAE0B16C892F2@orsmsx501.amr.corp.intel.com>
	 <20081009154547.GB13349@tesla>
	 <1223608949.2510.1061.camel@debian.sh.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 9, 2008 at 8:22 PM, Zhu Yi <yi.zhu@intel.com> wrote:
> Does below scenario an expected behaviour?
>
> 0. A system with iwl3945 BG card and iwl4965 AGN card.
> 1. insmod iwl3945 -> regulatory_hint(, 99, rd) return 0;
> 2. insmod iwl4965 -> regulatory_hint(, 99, rd2) return -EALREADY;
> 3. iwl4965 has no A band support!

Yeap. We're going with the regulatory domain the first card specified,
which we believe would be the built in card. The reason we follow this
logic right now is you cannot really be in two different places at the
same time. The real correct behavior here, as the comment also
indicates, is we should be doing an intersection between the two
regulatory domains and I sent a RFC on a some initial code I had to
support such intersection. Until that is not merged we just respect
first regulatory request.

Additionally since each device can still support more channels and
since the driver itself may know better than what the wireless core
provides you can override information using reg_notifier() (part of
the wiphy) and you can be picky so that you can try to respect the
user's request REGDOM_SET_BY_USER so that when they want to be *more*
compliant you let them. For this reason I advise that if you add a
reg_notifier() you only override the information if initiator is not
REGDOM_SET_BY_USER but its up to you of course. This is essentially
why this regulatory infrastructure allows users to be more compliant.

Alternatively you can live with what you have and just let the user
change the regulatory domain (iw reg set US) and this can enable more
channels should your driver support these channels on the device
(registered channels).

So you have a few options here, just keep in mind here the goal is to
allow the user to help the core be more compliant. By overriding a
disable of a channel (if you re-enable it) you are not helping the
user do this.

  Luis
