Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47090 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab0J0FOs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Oct 2010 01:14:48 -0400
Subject: Re: [PATCH v2] iw: Add ibss join parameter for beacon interval
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20101027030756.29191.4213.stgit@localhost6.localdomain6>
References: <20101027030756.29191.4213.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Oct 2010 07:14:43 +0200
Message-ID: <1288156483.3803.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-10-27 at 12:07 +0900, Bruno Randolf wrote:

> +	if (argc > 1 && strcmp(argv[0], "beacon-interval") == 0) {
> +		argv++;
> +		argc--;
> +		bintval = strtoul(argv[0], &end, 10);

error checking would be nice, this will accept "beacon-interval 50ms"
which may not be what we want ;)

johannes

