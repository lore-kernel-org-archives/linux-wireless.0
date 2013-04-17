Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40852 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754342Ab3DQGQH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Apr 2013 02:16:07 -0400
Date: Wed, 17 Apr 2013 08:17:04 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Jonas Gorski <jogo@openwrt.org>
Cc: Johannes Berg <johannes.berg@intel.com>, ilw@linux.intel.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] iwlwifi: fix freeing uninitialized pointer
Message-ID: <20130417061703.GB1597@redhat.com> (sfid-20130417_081620_029096_8F9A5249)
References: <20130416133828.GA20024@redhat.com>
 <CAOiHx=nY148aJoVON6TK4eygbFn4Moh9JVGZGbNaQsRR=TSo9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAOiHx=nY148aJoVON6TK4eygbFn4Moh9JVGZGbNaQsRR=TSo9A@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 16, 2013 at 08:40:30PM +0200, Jonas Gorski wrote:
> > +       ret = iwl_dump_nic_event_log(priv, true, &buf, true);
> > +       if (ret < 0)
> > +               goto err;
> > +       ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
> > +err:
> 
> Not every error check needs a goto, you can avoid it by inverting the
> condition: ;-)
> 
> 	ret = iwl_dump_nic_event_log(priv, true, &buf, true);
> 	if (ret >= 0) /* or maybe even > 0, because AFAICT 0 => nothing to read */
> 		ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
> 	kfree(buf);

Make sense. Since this is only code cleanup issue and 
simple_read_from_buffer(..., 0) is ok, I'll post incremental
patch which fix this.

Thanks
Stanislaw
