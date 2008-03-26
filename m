Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:53115 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754171AbYCZRjC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Mar 2008 13:39:02 -0400
Subject: Re: [PATCH] libertas: don't depend on IEEE80211
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200803261735.59235.hs4233@mail.mn-solutions.de>
References: <200803261324.21938.hs4233@mail.mn-solutions.de>
	 <200803261735.59235.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Wed, 26 Mar 2008 13:37:54 -0400
Message-Id: <1206553074.31383.104.camel@localhost.localdomain> (sfid-20080326_173907_217001_7AB5671D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-03-26 at 17:35 +0100, Holger Schurig wrote:
> John, please wait with applying this. I just saw that 
> escape_essid is also used in debugfs.c, even when 
> CONFIG_LIBERTAS_DEBUG is off.

Yeah, but from lbs_getscantable() which is utterly pointless since the
only thing it provides beyond 'iwlist eth1 scan' is CAP_SPECTRUM_MGMT,
which if people really care, we can shove out in custom WEXT scan result
tags.   I'd just kill lbs_getscantable() completely.

Dan

