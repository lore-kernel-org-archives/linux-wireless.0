Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:43867 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751248AbdJEMYL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Oct 2017 08:24:11 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: Re: [RFC 1/2] fq: support filtering a given tin
In-Reply-To: <20171005113808.3889-1-johannes@sipsolutions.net>
References: <20171005113808.3889-1-johannes@sipsolutions.net>
Date: Thu, 05 Oct 2017 14:24:06 +0200
Message-ID: <87k209sryx.fsf@toke.dk> (sfid-20171005_142415_482642_9A46E1B7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> +static void fq_tin_filter(struct fq *fq,
> +			  struct fq_tin *tin,
> +			  fq_skb_filter_t filter_func,
> +			  void *filter_data,
> +			  fq_skb_free_t free_func)
> +{
> +	struct list_head *head;
> +	struct fq_flow *flow;
> +
> +	lockdep_assert_held(&fq->lock);
> +
> +	for (;;) {
> +		head = &tin->new_flows;
> +		if (list_empty(head)) {
> +			head = &tin->old_flows;
> +			if (list_empty(head))
> +				break;
> +		}
> +
> +		flow = list_first_entry(head, struct fq_flow, flowchain);
> +		fq_flow_filter(fq, flow, filter_func, filter_data, free_func);
> +	}

Isn't this going to loop forever?

-Toke
