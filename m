Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37251 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363AbcDZMhT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2016 08:37:19 -0400
Date: Tue, 26 Apr 2016 14:37:07 +0200
From: Jan Kara <jack@suse.cz>
To: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc: Jan Kara <jack@suse.cz>, netdev@vger.kernel.org,
	davem@davemloft.net, sd@queasysnail.net, johannes@sipsolutions.net,
	kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
	jack@suse.com, linux-kernel@vger.kernel.org, pshelar@nicira.com,
	dev@openvswitch.org, jhs@mojatatu.com, philipp.reisner@linbit.com,
	lars.ellenberg@linbit.com, drbd-dev@lists.linbit.com
Subject: Re: [PATCH net-next 3/8] fs/quota: use nla_put_u64_64bit()
Message-ID: <20160426123707.GE27612@quack2.suse.cz> (sfid-20160426_143755_944674_9DC031B6)
References: <1461657978-13360-1-git-send-email-nicolas.dichtel@6wind.com>
 <1461657978-13360-4-git-send-email-nicolas.dichtel@6wind.com>
 <20160426110848.GD27612@quack2.suse.cz>
 <571F5FBE.8050900@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <571F5FBE.8050900@6wind.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue 26-04-16 14:31:58, Nicolas Dichtel wrote:
> Le 26/04/2016 13:08, Jan Kara a écrit :
> > On Tue 26-04-16 10:06:13, Nicolas Dichtel wrote:
> >> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> > 
> > OK, so I somewhat miss a description of what will this do to the netlink
> > message so that I can judge whether the change is fine for the userspace
> > counterpart parsing these messages. AFAIU this changes the message format
> > by adding a QUOTA_NL_A_PAD field before each 64-bit field which needs an
> > alignment, am I guessing right? Thus when the userspace counterpart uses
> > genlmsg_parse() it should just silently ignore these attributes if I read
> > the documentation right. Did I understand this correctly?
> Yes, that's it.

OK, then feel free to add:

Acked-by: Jan Kara <jack@suse.cz>

to the quota patch.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
