Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54393 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235Ab2BXOJE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Feb 2012 09:09:04 -0500
Subject: Re: [RFC] carl9170: Fix memory accounting when sta is in
 power-save mode.
From: Johannes Berg <johannes@sipsolutions.net>
To: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
In-Reply-To: <4F479847.10906@lri.fr>
References: <1330012414-26559-1-git-send-email-cavallar@lri.fr>
	 <201202231752.44125.chunkeey@googlemail.com> <4F46771F.9000200@lri.fr>
	 <201202231908.16364.chunkeey@googlemail.com> <4F468AC1.1050100@lri.fr>
	 <4F4791FC.9080707@lri.fr>
	 (sfid-20120224_143533_449788_ED2A82B4) <1330090741.3426.16.camel@jlt3.sipsolutions.net>
	 <4F479847.10906@lri.fr>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Feb 2012 15:09:02 +0100
Message-ID: <1330092542.3426.17.camel@jlt3.sipsolutions.net> (sfid-20120224_150908_401829_53EE941D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-02-24 at 15:01 +0100, Nicolas Cavallari wrote:

> >> Shouldn't mac80211 transition the sta to "awake" when receiving
> >> auth/assoc frames ?
> > 
> > I don't think so, that would make us send frames to the station it no
> > longer deserves to have. Hostapd should instead delete & re-create the
> > station entry, I think?

> 
> Hostapd already does that¹ ... after the association response is acked.

Ok maybe then we should send out assoc resp etc. frames and not subject
them to PS queueing? Jouni?

johannes

