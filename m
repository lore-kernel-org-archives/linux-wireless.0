Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58871 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab3HBNBP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Aug 2013 09:01:15 -0400
Message-ID: <1375448470.18144.10.camel@jlt4.sipsolutions.net> (sfid-20130802_150119_005536_B75704E3)
Subject: Re: [RFC 1/3] nl/cfg80211: add chan_time for scan request
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Date: Fri, 02 Aug 2013 15:01:10 +0200
In-Reply-To: <CA+BoTQ=XNeYL1KLGQ4gRCZ03a9XsAWde4O7_T-dqKndLLKeX_g@mail.gmail.com> (sfid-20130802_135231_798451_6ACEA72F)
References: <1375087158-22077-1-git-send-email-michal.kazior@tieto.com>
	 <1375087158-22077-2-git-send-email-michal.kazior@tieto.com>
	 <1375342845.8608.8.camel@jlt4.sipsolutions.net>
	 <CA+BoTQm+rWRRpp6XQ_-YHMBfH0Q4ecZ3z-6TV3cvFZ=8uXWsQA@mail.gmail.com>
	 <1375442751.18144.7.camel@jlt4.sipsolutions.net>
	 <CA+BoTQ=XNeYL1KLGQ4gRCZ03a9XsAWde4O7_T-dqKndLLKeX_g@mail.gmail.com>
	 (sfid-20130802_135231_798451_6ACEA72F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > That's what I'm worried about - the implicit semantic change here.
> 
> I think I understand your point now.
> 
> I'm thinking of using series of passive scans for ACS now, so perhaps
> the whole chan_time stuff is unnecessary. What are your thoughts about
> it?

Well, still then you're relying on the fact that passive channels scans
will stick to each channel for ~110ms or so. This is true today, but
it's not really specified.

I don't think that using the scan command would be a big deal, but maybe
this 'measurement' behaviour should be explicitly enabled? Maybe other
devices even have to do something special to collect the data.

johannes

