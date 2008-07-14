Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.241]:2850 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757881AbYGNHxV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jul 2008 03:53:21 -0400
Received: by an-out-0708.google.com with SMTP id d40so924678and.103
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jul 2008 00:53:20 -0700 (PDT)
Message-ID: <43e72e890807140053l4acec227ic1a1eca7d8638b51@mail.gmail.com> (sfid-20080714_095355_768440_87CF8727)
Date: Mon, 14 Jul 2008 00:53:20 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Johannes Berg" <johannes@sipsolutions.net>, linville@tuxdriver.com
Subject: Re: [PATCH] Add new regulatory framework for Linux wireless
Cc: linux-wireless@vger.kernel.org,
	"Tomas Winkler" <tomas.winkler@intel.com>,
	"Rindjunsky, Ron" <ron.rindjunsky@intel.com>,
	"Tim Gardner" <tim.gardner@canonical.com>,
	"Jouni Malinen" <j@w1.fi>,
	"Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>,
	"Marcel Holtmann" <marcel@holtmann.org>
In-Reply-To: <20080711123039.GP17936@ruslug.rutgers.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080711123039.GP17936@ruslug.rutgers.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 11, 2008 at 5:30 AM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> Johannes' changes have been taken into consideration for this patch.
> Individual changes can be seen here:
>
> http://www.kernel.org/pub/linux/kernel/people/mcgrof/v3-regdomain-patches/

I added a few more fixes and also support for zd1211rw with the new
regulatory work, the patches are up in the same URL as above. I
havent' tested it though with zd1211rw, I just know it compiles. This
should give you an idea how to add your regulatory_hint() and callback
if needed.

I've also added a freq_reg_info() which other subsystems can make use
of. If other subsystems (bluetooth, wimax) do make use of this then we
have to modify the regulatory chain registration a bit to be wifi
agnostic. In that case we might as well move regulatory stuff some
place non-802.11 specific.

Comments?

  Luis
