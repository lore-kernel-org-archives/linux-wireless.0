Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54200 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551AbbFYOd0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Jun 2015 10:33:26 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: David Decotigny <ddecotig@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
	Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH v2 0/2] staging: rtl8723au: core: endianness issues
References: <1433724182-657-1-git-send-email-ddecotig@gmail.com>
Date: Thu, 25 Jun 2015 10:33:23 -0400
In-Reply-To: <1433724182-657-1-git-send-email-ddecotig@gmail.com> (David
	Decotigny's message of "Sun, 7 Jun 2015 17:43:00 -0700")
Message-ID: <wrfj4mlvoo24.fsf@redhat.com> (sfid-20150625_163330_468754_D9597813)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Decotigny <ddecotig@gmail.com> writes:
> The code shows a couple inconsistencies (described in commit
> descriptions) which would not be an issue on little-endian cpus, but
> could cause breakage on non-LE cpus. Note: I could not test on real
> hardware, these patches created based on sparse reports.
>
> Hostory:
>   - resending the same patches to correct recipients, only changed
>     commit descriptions (credits to Dan Carpenter)
>
> ############################################
> # Patch Set Summary:
>
> David Decotigny (2):
>   staging: rtl8723au: core: avoid bitwise arithmetic with forced
>     endianness
>   staging: rtl8723au: core: remove redundant endianness conversion
>
>  drivers/staging/rtl8723au/core/rtw_mlme_ext.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)

Looks fine to me, however if you fiddle with this same value twice,
wouldn't it be better to do it in one patch?

Cheers,
Jes
