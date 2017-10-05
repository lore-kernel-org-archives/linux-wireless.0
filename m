Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:40486 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751280AbdJENNN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Oct 2017 09:13:13 -0400
Message-ID: <1507209191.2387.22.camel@sipsolutions.net> (sfid-20171005_151316_235392_CD33F7A1)
Subject: Re: [RFC 1/2] fq: support filtering a given tin
From: Johannes Berg <johannes@sipsolutions.net>
To: Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Date: Thu, 05 Oct 2017 15:13:11 +0200
In-Reply-To: <87k209sryx.fsf@toke.dk>
References: <20171005113808.3889-1-johannes@sipsolutions.net>
         <87k209sryx.fsf@toke.dk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-10-05 at 14:24 +0200, Toke Høiland-Jørgensen wrote:

> > +	for (;;) {
> > +		head = &tin->new_flows;
> > +		if (list_empty(head)) {
> > +			head = &tin->old_flows;
> > +			if (list_empty(head))
> > +				break;
> > +		}
> > +
> > +		flow = list_first_entry(head, struct fq_flow, flowchain);
> > +		fq_flow_filter(fq, flow, filter_func, filter_data, free_func);
> > +	}
> 
> Isn't this going to loop forever?

Good question, I'll admit that I copied this without understanding it
from fq_tin_reset(), and didn't think about it much.

I think you're right though - I guess this needs to iterate the
new_flows and old_flows.

johannes
