Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:53131 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602Ab2JRIbf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Oct 2012 04:31:35 -0400
From: Sujith Manoharan <c_manoha@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20607.48733.682547.956926@gargle.gargle.HOWL> (sfid-20121018_103139_887122_F3ADDE0A)
Date: Thu, 18 Oct 2012 14:01:25 +0530
To: Johannes Berg <johannes@sipsolutions.net>
CC: Sujith Manoharan <c_manoha@qti.qualcomm.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] cfg80211: Disallow HT/WEP in IBSS mode
In-Reply-To: <1350545240.10638.0.camel@jlt4.sipsolutions.net>
References: <20607.35416.907913.623637@gargle.gargle.HOWL>
	<1350545240.10638.0.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Thu, 2012-10-18 at 10:19 +0530, Sujith Manoharan wrote:
> > Currently, a user is allowed to choose a HT operating channel
> > with WEP when creating an IBSS network. WEP is not allowed
> > in HT configuration - this patch ensures that such requests
> > are denied.
> 
> Applied, but
> 
> > @@ -733,6 +733,12 @@ nl80211_parse_connkeys(struct cfg80211_registered_device *rdev,
> >  		result->params[parse.idx].key_len = parse.p.key_len;
> >  		result->params[parse.idx].key = result->data[parse.idx];
> >  		memcpy(result->data[parse.idx], parse.p.key, parse.p.key_len);
> > +
> > +		if (result->params[parse.idx].cipher == WLAN_CIPHER_SUITE_WEP40 ||
> > +		    result->params[parse.idx].cipher == WLAN_CIPHER_SUITE_WEP104) {
> 
> I changed this to be "parse.p.cipher == " to make the lines shorter.

Thanks. :)

Sujith
