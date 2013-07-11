Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:51346 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756034Ab3GKPRh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jul 2013 11:17:37 -0400
Message-ID: <1373555849.8201.13.camel@jlt4.sipsolutions.net> (sfid-20130711_171741_374392_3851A154)
Subject: Re: [WT PATCH 6/6] mac80211: Tell user why beacons fail to parse.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 11 Jul 2013 17:17:29 +0200
In-Reply-To: <51DECAFD.8070608@candelatech.com>
References: <1372546738-25827-1-git-send-email-greearb@candelatech.com>
	  <1372546738-25827-6-git-send-email-greearb@candelatech.com>
	  (sfid-20130630_005952_096446_C7F6AD26) <1373533184.8201.8.camel@jlt4.sipsolutions.net>
	 <51DECAFD.8070608@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-07-11 at 08:10 -0700, Ben Greear wrote:

> >>   	/* Keep track of what bits of information we have valid info for. */
> >>   	u8 valid_data;
> >> +	char corrupt_elems_msg[80];
> >
> > you should store a "what's bad" type field and the broken IE number or
> > so, to reduce memory usage
> 
> I thought of this, but the problem is then you cannot tell the details
> (for instance the actual lengths when length is bad, the ID that is duplicated, etc).
> I figure if we are going to provide the info to the user, we might as well
> be specific about it.

It doesn't seem so difficult?

enum ies_parse_error {
	NO_ERROR,
	BAD_IE_LEN, // uses eid+len
	DUPLICATE_IE, // uses eid
	...
} parse_error;
int parse_error_eid, parse_error_len;

> >> +				snprintf(elems->parse_err_msg,
> >> +					 sizeof(elems->parse_err_msg),
> >> +					 "seen id: %i already", id);
> >
> > Your snprintf() usage is also unsafe.
> 
> What is unsafe about it?

using printk("%s", result) is unsafe due to potentially missing
NUL-termination.

johannes

