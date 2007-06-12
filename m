Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:56710 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817AbXFLL6D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2007 07:58:03 -0400
Message-ID: <28971.131.234.232.48.1181649480.squirrel@secure.sipsolutions.net>
In-Reply-To: <20070612095551.323709697@warmcat.com>
References: <20070612095551.323709697@warmcat.com>
Date: Tue, 12 Jun 2007 13:58:00 +0200 (CEST)
Subject: Re: [PATCH Try#10 0/4] Radiotap injection for Monitor Mode
From: "Johannes Berg" <johannes@sipsolutions.net>
To: andy@warmcat.com
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I had prepared a longer mail but can't send it right now.

I think the return code for the iterator should be a new type with values
RADIOTAP_PARSER_OK
RADIOTAP_PARSER_DONE
RADIOTAP_PARSER_INVALID
and
RADIOTAP_PARSER_UNHANDLED

instead of error codes for the latter three. Then the mac80211 code would
check for while (... == _OK) and drop the packet on _INVALID.

johannes
