Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:33225 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbcDZMcM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2016 08:32:12 -0400
Received: by mail-wm0-f53.google.com with SMTP id g17so1573282wme.0
        for <linux-wireless@vger.kernel.org>; Tue, 26 Apr 2016 05:32:12 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net-next 3/8] fs/quota: use nla_put_u64_64bit()
References: <1461657978-13360-1-git-send-email-nicolas.dichtel@6wind.com>
 <1461657978-13360-4-git-send-email-nicolas.dichtel@6wind.com>
 <20160426110848.GD27612@quack2.suse.cz>
To: Jan Kara <jack@suse.cz>
Cc: netdev@vger.kernel.org, davem@davemloft.net, sd@queasysnail.net,
	johannes@sipsolutions.net, kvalo@codeaurora.org,
	linux-wireless@vger.kernel.org, jack@suse.com,
	linux-kernel@vger.kernel.org, pshelar@nicira.com,
	dev@openvswitch.org, jhs@mojatatu.com, philipp.reisner@linbit.com,
	lars.ellenberg@linbit.com, drbd-dev@lists.linbit.com
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Message-ID: <571F5FBE.8050900@6wind.com> (sfid-20160426_143243_818846_7E558881)
Date: Tue, 26 Apr 2016 14:31:58 +0200
MIME-Version: 1.0
In-Reply-To: <20160426110848.GD27612@quack2.suse.cz>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le 26/04/2016 13:08, Jan Kara a écrit :
> On Tue 26-04-16 10:06:13, Nicolas Dichtel wrote:
>> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> 
> OK, so I somewhat miss a description of what will this do to the netlink
> message so that I can judge whether the change is fine for the userspace
> counterpart parsing these messages. AFAIU this changes the message format
> by adding a QUOTA_NL_A_PAD field before each 64-bit field which needs an
> alignment, am I guessing right? Thus when the userspace counterpart uses
> genlmsg_parse() it should just silently ignore these attributes if I read
> the documentation right. Did I understand this correctly?
Yes, that's it.


Regards,
Nicolas
