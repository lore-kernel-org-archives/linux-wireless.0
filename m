Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39507 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752353AbbDBKSE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2015 06:18:04 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Piotr Witoslawski <pwitos@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Yannis Damigos <giannis.damigos@gmail.com>,
	linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] drivers: staging: rtl8723au: fix "warning: cast to restricted __le16"
References: <20150402093748.GA24455@pwitoslawski.warsaw.osa>
	<20150402100756.GH10964@mwanda>
Date: Thu, 02 Apr 2015 06:17:48 -0400
In-Reply-To: <20150402100756.GH10964@mwanda> (Dan Carpenter's message of "Thu,
	2 Apr 2015 13:07:56 +0300")
Message-ID: <wrfja8yqbzqr.fsf@redhat.com> (sfid-20150402_121823_103250_999E0B6D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter <dan.carpenter@oracle.com> writes:
> This doesn't look right and it doesn't have a changelog explainly the
> weirdness.
>

... and the fix is as ugly as it gets!

If something like this is needed, creating a __le16 *ptr at the
beginnging of the function would be a lot better.

Jes
