Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:58401
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757665AbXHWVCs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2007 17:02:48 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC 06/11] mac80211: remove HW_KEY_IDX_INVALID
Date: Thu, 23 Aug 2007 23:01:17 +0200
Cc: linux-wireless@vger.kernel.org
References: <20070823164500.998912000@sipsolutions.net> <20070823164523.418272000@sipsolutions.net>
In-Reply-To: <20070823164523.418272000@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200708232301.17562.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 23 August 2007 18:45:07 Johannes Berg wrote:
> longer relies on HW_KEY_IDX_INVALID either this removes it, changes
> the key index to be an integer in all places and makes the full
> range of the value available to drivers.

Why's that needed? It increases the tx control struct size,
which is created and destroyed with every packet.
Isn't 127 keys enough? If not, probably do a s16. But I think
an int if overkill.

-- 
Greetings Michael.
