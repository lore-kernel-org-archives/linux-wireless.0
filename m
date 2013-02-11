Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44594 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932531Ab3BKVWx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 16:22:53 -0500
Message-ID: <1360617742.8738.43.camel@jlt4.sipsolutions.net> (sfid-20130211_222256_489092_5DBCC112)
Subject: Re: [PATCH] rtlwifi: Initialize rate_init member of struct
 rate_control_ops
From: Johannes Berg <johannes@sipsolutions.net>
To: Catalin Iacob <iacobcatalin@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Mon, 11 Feb 2013 22:22:22 +0100
In-Reply-To: <1360617485-6194-1-git-send-email-iacobcatalin@gmail.com> (sfid-20130211_221826_368182_FF033C33)
References: <1360617485-6194-1-git-send-email-iacobcatalin@gmail.com>
	 (sfid-20130211_221826_368182_FF033C33)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-02-11 at 22:18 +0100, Catalin Iacob wrote:
> This partially reverts commit 44ba973699b831414c3f8eef68ee5a7fe1208a05.
> 
> rate_control_rate_init assumes the rate_init member of
> struct rate_control_ops is not NULL therefore not initializing it leads to
> an oops as soon the driver succesfully associates to an AP.
> 
> The removal of rate_update from 44ba973699b831414c3f8eef68ee5a7fe1208a05
> is ok because rate_update is checked for NULL before being
> called.

OTOH, if the driver supports HT then rate_update is critical to its
functioning properly, e.g. for SMPS updates.

johannes

