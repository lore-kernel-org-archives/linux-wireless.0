Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:41284 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbYJANCx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Oct 2008 09:02:53 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [RFC, PATCH v2] libertas: unify request_firmware failure
Date: Wed, 1 Oct 2008 15:02:32 +0200
Cc: Marc Pignat <marc.pignat@hevs.ch>, Dan Williams <dcbw@redhat.com>,
	libertas-dev@lists.infradead.org
References: <200809301625.40554.marc.pignat@hevs.ch> <1222792480.27374.25.camel@localhost.localdomain> <200810011043.34229.marc.pignat@hevs.ch>
In-Reply-To: <200810011043.34229.marc.pignat@hevs.ch>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200810011502.32427.hs4233@mail.mn-solutions.de> (sfid-20081001_150257_515835_F04D1065)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> -		lbs_pr_err("can't load helper firmware\n");
> +		lbs_pr_err("request_firmware() failed with %d\n", ret);
> +		lbs_pr_err("helper firmware libertas_cs_helper.fw not found\n"); ret = -ENODEV;

While I don't have a problem with the idea per
se, I don't like it outputting two error lines now.

So for if_cs.c, I like the original code better.

I don't care to emit the error number, won't be usable to most
people anyway. And I don't care about outputting the filename,
because udev will already show you the filename if it doesn't
find what was requested.
