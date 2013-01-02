Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44221 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670Ab3ABM4d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 07:56:33 -0500
Message-ID: <1357131412.9839.17.camel@jlt4.sipsolutions.net> (sfid-20130102_135637_128893_4A1E9540)
Subject: Re: [PATCH V4 2/2] cfg80211/nl80211: Enable drivers to implement
 mac address based ACL
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Wed, 02 Jan 2013 13:56:52 +0100
In-Reply-To: <50E11F43.4010006@qca.qualcomm.com>
References: <1356690070-26612-1-git-send-email-vthiagar@qca.qualcomm.com>
	  <1356690070-26612-2-git-send-email-vthiagar@qca.qualcomm.com>
	  <1356694308.9922.1.camel@jlt4.sipsolutions.net>
	  (sfid-20121228_123135_896103_E2B28BED) <1356699373.9922.2.camel@jlt4.sipsolutions.net>
	 <50E11F43.4010006@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-12-31 at 10:44 +0530, Vasanthakumar Thiagarajan wrote:
> 
> On Friday 28 December 2012 06:26 PM, Johannes Berg wrote:
> > On Fri, 2012-12-28 at 12:31 +0100, Johannes Berg wrote:
> >> On Fri, 2012-12-28 at 15:51 +0530, Vasanthakumar Thiagarajan wrote:
> >>
> >>> V4:
> >>> 	- Change it accordingly so that at any time the driver can
> >>> 	  support either white or black list not both.
> >>
> >> I was under the impression you needed both. Unless I get confirmation
> >> from Kalle and/or Jouni I'll not apply this lest it needs to be changed
> >> in yet again incompatible ways later ...
> >
> > Actually I just talked to Jouni again and it seems that the best way to
> > think of the combined black/whitelist is to treat it as a whitelist +
> > "notification avoidance optimisation list". The key here being
> > optimisation, we don't really have to worry about it in terms of feature
> > advertising etc. since it can be ignored/managed by the driver.
> 
> Sure. Is the assumption here is the stations in optimisation list \
> either be denied or allowed which is specific to driver?.

?
Basically we would have two modes:
 * whitelist
 * blacklist

(each might or might not be supported by the driver)

When a station is on the blacklist it's ignored. When it's on the
whitelist it's allowed. When it's on neither, but a list is configured,
an event might be sent. When there's a black- & whitelist, the blacklist
is this an optimisation to suppress the event, so we don't need a third
mode "black- and whitelist supported".

johannes

