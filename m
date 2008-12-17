Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46427 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbYLQLvC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2008 06:51:02 -0500
Subject: Re: [PATCH] ath9k: Fix a NULL pointer dereference in ath_rate_get
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni.malinen@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20081217113031.GA18060@jm.kir.nu> (sfid-20081217_123042_383830_2EACC437)
References: <20081217113031.GA18060@jm.kir.nu>
	 (sfid-20081217_123042_383830_2EACC437)
Content-Type: text/plain
Date: Wed, 17 Dec 2008 12:30:56 +0100
Message-Id: <1229513456.4566.2.camel@localhost> (sfid-20081217_125108_224566_4D06A690)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-12-17 at 13:30 +0200, Jouni Malinen wrote:
> It looks like mac80211 may try to send unicast frames to a STA that
> does not have a STA entry. We need to make sure that that is caught in
> the rate control code before dereferencing STA data.

This should only happen for injected packets, can you verify? OTOH, AP
mode obviously has injected packets (auth response, ...)

johannes

