Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:5555 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752701AbaBSMSj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 07:18:39 -0500
Date: Wed, 19 Feb 2014 17:34:35 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: Jonas Gorski <jogo@openwrt.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: Re: [PATCH 1/3] mwl8k: Adding support to access BBP registers
Message-ID: <20140219120434.GB2812@markyou.marvell.com> (sfid-20140219_131843_818117_FB46360D)
References: <20140219103717.GA3284@markyou.marvell.com>
 <CAOiHx==5geqrnqQyp6y_GoAZC0adWPzq8vXo1fPVA_t9Uhs-ww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAOiHx==5geqrnqQyp6y_GoAZC0adWPzq8vXo1fPVA_t9Uhs-ww@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jonas,

On Wed, Feb 19, 2014 at 04:12:56AM -0800, Jonas Gorski wrote:
> > +       cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
> > +       if (cmd == NULL)
> > +               return -ENOMEM;
> > +
> > +       cmd->header.code = cpu_to_le16(MWL8K_CMD_BBP_REG_ACCESS);
> > +       cmd->header.length = cpu_to_le16(sizeof(*cmd));
> > +       cmd->action = cpu_to_le16(action);
> > +       cmd->offset = cpu_to_le16(offset);
> > +
> > +       rc = mwl8k_post_cmd(hw, &cmd->header);
> > +
> > +       if (!rc)
> > +               *value = cmd->value;
> > +       else
> > +               *value = 0;
> > +
> > +       return rc;
> 
> You don't free the allocated cmd anywhere, so you are leaking memory
> on every call.

We will fix this in V2.

Thanks
Yogesh

> 
> 
> Regards
> Jonas
