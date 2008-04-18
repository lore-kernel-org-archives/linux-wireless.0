Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.233]:38473 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756402AbYDRRIp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Apr 2008 13:08:45 -0400
Received: by wr-out-0506.google.com with SMTP id c48so431020wra.1
        for <linux-wireless@vger.kernel.org>; Fri, 18 Apr 2008 10:08:44 -0700 (PDT)
Message-ID: <c85cb4470804181008i22b8828euccac6e1652eb1113@mail.gmail.com> (sfid-20080418_180849_589633_0ACD5D80)
Date: Fri, 18 Apr 2008 20:08:43 +0300
From: "Ron Rindjunsky" <ron.rindjunsky@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] mac80211: correct skb allocation
Cc: "Reinette Chatre" <reinette.chatre@intel.com>,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	"Ester Kummer" <ester.kummer@intel.com>,
	"Tomas Winkler" <tomas.winkler@intel.com>
In-Reply-To: <20080418013515.GB3152@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1208473514-16688-1-git-send-email-reinette.chatre@intel.com>
	 <20080418013515.GB3152@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > -     skb = dev_alloc_skb(sizeof(*mgmt) + local->hw.extra_tx_headroom + 1 +
> > -                                     sizeof(mgmt->u.action.u.addba_resp));
> > +     skb = dev_alloc_skb(sizeof(*mgmt) + local->hw.extra_tx_headroom);
> > +
>
> Forgive my ignorant, unresearched question... :-)  What was the "+1"
> and why is it no longer necessary?
>
> John

originaly it was for the category field, but the union covers it as well

ron
